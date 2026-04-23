-- =====================================================================
-- Module 23: Notifications & Communications
-- Covers PRD Step 23
-- =====================================================================

SET search_path = app, core, public;

-- =============== SCHEMA ===============

CREATE TABLE IF NOT EXISTS app.notification_templates (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  code            citext NOT NULL,
  name            text NOT NULL,
  channel         text NOT NULL CHECK (channel IN ('email','sms','in_app','push','whatsapp','slack','teams')),
  locale          char(5) NOT NULL DEFAULT 'en-IN',
  subject         text,
  body            text NOT NULL,
  variables       jsonb NOT NULL DEFAULT '[]'::jsonb,  -- declared variables
  active          boolean NOT NULL DEFAULT true,
  created_at      timestamptz NOT NULL DEFAULT now(),
  updated_at      timestamptz NOT NULL DEFAULT now(),
  created_by      uuid, updated_by uuid, version int NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, code, channel, locale)
);

CREATE TABLE IF NOT EXISTS app.notification_preferences (
  tenant_id       uuid NOT NULL,
  user_id         uuid NOT NULL REFERENCES app.users(id) ON DELETE CASCADE,
  category        text NOT NULL,              -- e.g. 'sales_alerts','approvals'
  channel         text NOT NULL CHECK (channel IN ('email','sms','in_app','push','whatsapp')),
  enabled         boolean NOT NULL DEFAULT true,
  quiet_hours     jsonb,                      -- {"start":"22:00","end":"08:00","tz":"Asia/Kolkata"}
  updated_at      timestamptz NOT NULL DEFAULT now(),
  PRIMARY KEY (user_id, category, channel)
);

-- Queue (outbox) — partitioned by created_at for high-volume tenants
CREATE TABLE IF NOT EXISTS ops.notification_queue (
  id              uuid NOT NULL DEFAULT gen_random_uuid(),
  tenant_id       uuid,
  user_id         uuid,
  channel         text NOT NULL CHECK (channel IN ('email','sms','in_app','push','whatsapp','slack','teams')),
  template_code   text,
  to_address      text NOT NULL,
  subject         text,
  body            text NOT NULL,
  payload         jsonb,
  status          text NOT NULL DEFAULT 'queued'
                  CHECK (status IN ('queued','sending','sent','failed','cancelled')),
  attempts        int NOT NULL DEFAULT 0,
  max_attempts    int NOT NULL DEFAULT 5,
  last_error      text,
  scheduled_at    timestamptz NOT NULL DEFAULT now(),
  sent_at         timestamptz,
  provider        text,
  provider_msg_id text,
  created_at      timestamptz NOT NULL DEFAULT now(),
  PRIMARY KEY (id, created_at)
) PARTITION BY RANGE (created_at);

CREATE TABLE IF NOT EXISTS ops.notification_queue_2026 PARTITION OF ops.notification_queue
  FOR VALUES FROM ('2026-01-01') TO ('2027-01-01');
CREATE TABLE IF NOT EXISTS ops.notification_queue_default PARTITION OF ops.notification_queue DEFAULT;

-- In-app notifications (shown in UI bell)
CREATE TABLE IF NOT EXISTS app.in_app_notifications (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  user_id         uuid NOT NULL REFERENCES app.users(id) ON DELETE CASCADE,
  category        text NOT NULL,
  title           text NOT NULL,
  message         text,
  link_url        text,
  entity_type     text,
  entity_id       uuid,
  read_at         timestamptz,
  created_at      timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS audit.communication_log (
  id              bigserial PRIMARY KEY,
  tenant_id       uuid,
  user_id         uuid,
  channel         text NOT NULL,
  direction       char(1) NOT NULL CHECK (direction IN ('I','O')),
  to_address      text,
  from_address    text,
  subject         text,
  body_preview    text,
  status          text,
  provider        text,
  provider_ref    text,
  occurred_at     timestamptz NOT NULL DEFAULT now()
);

-- =============== INDEXES ===============
CREATE INDEX IF NOT EXISTS idx_ntemplates_code     ON app.notification_templates(tenant_id, code, channel);
CREATE INDEX IF NOT EXISTS idx_nqueue_status       ON ops.notification_queue(status, scheduled_at) WHERE status IN ('queued','sending');
CREATE INDEX IF NOT EXISTS idx_nqueue_tenant_time  ON ops.notification_queue(tenant_id, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_inapp_user_unread   ON app.in_app_notifications(user_id, created_at DESC) WHERE read_at IS NULL;
CREATE INDEX IF NOT EXISTS idx_commlog_tenant_time ON audit.communication_log(tenant_id, occurred_at DESC);

-- =============== RLS ===============
SELECT core.enable_tenant_rls('app.notification_templates');
SELECT core.enable_tenant_rls('app.notification_preferences');
SELECT core.enable_tenant_rls('app.in_app_notifications');

-- =============== TRIGGERS ===============
SELECT core.attach_standard_triggers('app.notification_templates');

-- =============== FUNCTIONS ===============

-- Render template with {{var}} substitution
CREATE OR REPLACE FUNCTION app.render_template(p_body text, p_vars jsonb)
RETURNS text
LANGUAGE plpgsql IMMUTABLE AS $$
DECLARE
  v_out text := p_body;
  k text; v jsonb;
BEGIN
  IF p_vars IS NULL THEN RETURN v_out; END IF;
  FOR k, v IN SELECT * FROM jsonb_each(p_vars) LOOP
    v_out := replace(v_out, '{{'||k||'}}', COALESCE(v#>>'{}',''));
  END LOOP;
  RETURN v_out;
END $$;

-- Enqueue a notification
CREATE OR REPLACE FUNCTION app.enqueue_notification(
  p_user_id      uuid,
  p_channel      text,
  p_template_code text,
  p_to_address   text,
  p_vars         jsonb DEFAULT '{}'::jsonb,
  p_scheduled_at timestamptz DEFAULT now()
) RETURNS uuid
LANGUAGE plpgsql AS $$
DECLARE
  v_id uuid := gen_random_uuid();
  v_tmpl app.notification_templates%ROWTYPE;
  v_tenant uuid := core.require_tenant();
BEGIN
  SELECT * INTO v_tmpl FROM app.notification_templates
   WHERE tenant_id = v_tenant AND code = p_template_code AND channel = p_channel AND active
   ORDER BY locale DESC LIMIT 1;
  IF NOT FOUND THEN RAISE EXCEPTION 'template not found: % / %', p_template_code, p_channel; END IF;

  INSERT INTO ops.notification_queue(id,tenant_id,user_id,channel,template_code,to_address,
         subject,body,payload,scheduled_at)
  VALUES (v_id, v_tenant, p_user_id, p_channel, p_template_code, p_to_address,
          app.render_template(COALESCE(v_tmpl.subject,''), p_vars),
          app.render_template(v_tmpl.body, p_vars),
          p_vars, p_scheduled_at);
  RETURN v_id;
END $$;

-- Mark in-app notification read
CREATE OR REPLACE FUNCTION app.mark_notification_read(p_notification_id uuid)
RETURNS void
LANGUAGE sql AS $$
  UPDATE app.in_app_notifications SET read_at = now()
   WHERE id = p_notification_id AND user_id = core.current_user_id() AND read_at IS NULL;
$$;

-- Retry failed notifications (cron)
CREATE OR REPLACE FUNCTION app.retry_failed_notifications()
RETURNS int
LANGUAGE plpgsql AS $$
DECLARE v_count int;
BEGIN
  UPDATE ops.notification_queue
     SET status='queued', scheduled_at = now() + (attempts * interval '5 min')
   WHERE status = 'failed' AND attempts < max_attempts;
  GET DIAGNOSTICS v_count = ROW_COUNT;
  RETURN v_count;
END $$;

-- =============== VIEWS ===============
CREATE OR REPLACE VIEW app.v_unread_notifications_count AS
SELECT tenant_id, user_id, COUNT(*) AS unread
  FROM app.in_app_notifications
 WHERE read_at IS NULL
 GROUP BY tenant_id, user_id;
