-- =====================================================================
-- Module 24: Integration Platform (basic)
-- Covers PRD Step 24 — webhooks, external clients, sync logs
-- =====================================================================

SET search_path = app, core, public;

-- =============== SCHEMA ===============

CREATE TABLE IF NOT EXISTS app.webhooks (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  code            citext NOT NULL,
  url             text NOT NULL,
  secret_ciphertext bytea,
  events          text[] NOT NULL DEFAULT '{}',    -- ['sales_invoice.posted', ...]
  active          boolean NOT NULL DEFAULT true,
  headers         jsonb NOT NULL DEFAULT '{}'::jsonb,
  timeout_ms      int NOT NULL DEFAULT 10000,
  retry_policy    jsonb NOT NULL DEFAULT '{"max":5,"backoff":"exponential"}'::jsonb,
  created_at      timestamptz NOT NULL DEFAULT now(),
  updated_at      timestamptz NOT NULL DEFAULT now(),
  created_by      uuid, updated_by uuid, version int NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, code)
);

CREATE TABLE IF NOT EXISTS ops.webhook_deliveries (
  id              uuid NOT NULL DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  webhook_id      uuid NOT NULL,
  event_type      text NOT NULL,
  payload         jsonb NOT NULL,
  status          text NOT NULL DEFAULT 'pending'
                  CHECK (status IN ('pending','success','failed','retrying','dead')),
  attempts        int NOT NULL DEFAULT 0,
  last_attempt_at timestamptz,
  last_http_code  int,
  last_response   text,
  created_at      timestamptz NOT NULL DEFAULT now(),
  PRIMARY KEY (id, created_at)
) PARTITION BY RANGE (created_at);

CREATE TABLE IF NOT EXISTS ops.webhook_deliveries_2026 PARTITION OF ops.webhook_deliveries
  FOR VALUES FROM ('2026-01-01') TO ('2027-01-01');
CREATE TABLE IF NOT EXISTS ops.webhook_deliveries_default PARTITION OF ops.webhook_deliveries DEFAULT;

CREATE TABLE IF NOT EXISTS app.integrations (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  code            citext NOT NULL,
  provider        text NOT NULL,          -- 'shopify','quickbooks','razorpay','stripe',...
  config          jsonb NOT NULL DEFAULT '{}'::jsonb,
  credentials_ciphertext bytea,
  status          text NOT NULL DEFAULT 'disconnected'
                  CHECK (status IN ('connected','disconnected','error','auth_required')),
  last_sync_at    timestamptz,
  last_error      text,
  created_at      timestamptz NOT NULL DEFAULT now(),
  updated_at      timestamptz NOT NULL DEFAULT now(),
  created_by      uuid, updated_by uuid, version int NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, code)
);

CREATE TABLE IF NOT EXISTS ops.sync_logs (
  id              uuid NOT NULL DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  integration_id  uuid REFERENCES app.integrations(id) ON DELETE SET NULL,
  direction       char(1) NOT NULL CHECK (direction IN ('I','O')),
  entity_type     text NOT NULL,
  external_id     text,
  internal_id     uuid,
  operation       text NOT NULL CHECK (operation IN ('create','update','delete','upsert','skip')),
  status          text NOT NULL CHECK (status IN ('success','failed','skipped')),
  error           text,
  payload         jsonb,
  created_at      timestamptz NOT NULL DEFAULT now(),
  PRIMARY KEY (id, created_at)
) PARTITION BY RANGE (created_at);

CREATE TABLE IF NOT EXISTS ops.sync_logs_2026 PARTITION OF ops.sync_logs
  FOR VALUES FROM ('2026-01-01') TO ('2027-01-01');
CREATE TABLE IF NOT EXISTS ops.sync_logs_default PARTITION OF ops.sync_logs DEFAULT;

CREATE TABLE IF NOT EXISTS app.external_id_map (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  integration_id  uuid NOT NULL REFERENCES app.integrations(id) ON DELETE CASCADE,
  entity_type     text NOT NULL,
  internal_id     uuid NOT NULL,
  external_id     text NOT NULL,
  last_seen_at    timestamptz NOT NULL DEFAULT now(),
  UNIQUE (integration_id, entity_type, external_id),
  UNIQUE (integration_id, entity_type, internal_id)
);

-- =============== INDEXES ===============
CREATE INDEX IF NOT EXISTS idx_webhooks_events_gin ON app.webhooks USING gin (events);
CREATE INDEX IF NOT EXISTS idx_whd_pending         ON ops.webhook_deliveries(webhook_id, status) WHERE status IN ('pending','retrying');
CREATE INDEX IF NOT EXISTS idx_whd_tenant_time     ON ops.webhook_deliveries(tenant_id, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_sync_logs_tenant    ON ops.sync_logs(tenant_id, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_sync_logs_entity    ON ops.sync_logs(entity_type, internal_id);
CREATE INDEX IF NOT EXISTS idx_idmap_int           ON app.external_id_map(integration_id, entity_type);

-- =============== RLS ===============
SELECT core.enable_tenant_rls('app.webhooks');
SELECT core.enable_tenant_rls('app.integrations');
SELECT core.enable_tenant_rls('app.external_id_map');

-- =============== TRIGGERS ===============
SELECT core.attach_standard_triggers('app.webhooks');
SELECT core.attach_standard_triggers('app.integrations');

-- =============== FUNCTIONS ===============

-- Emit event → enqueue webhook deliveries for all subscribed webhooks
CREATE OR REPLACE FUNCTION app.emit_webhook_event(p_event_type text, p_payload jsonb)
RETURNS int
LANGUAGE plpgsql AS $$
DECLARE v_count int;
BEGIN
  INSERT INTO ops.webhook_deliveries(tenant_id, webhook_id, event_type, payload)
  SELECT core.require_tenant(), w.id, p_event_type, p_payload
    FROM app.webhooks w
   WHERE w.tenant_id = core.require_tenant()
     AND w.active AND p_event_type = ANY(w.events);
  GET DIAGNOSTICS v_count = ROW_COUNT;
  RETURN v_count;
END $$;

-- =============== VIEWS ===============
CREATE OR REPLACE VIEW app.v_webhook_health AS
SELECT w.tenant_id, w.id, w.code,
       COUNT(wd.*) FILTER (WHERE wd.created_at >= now() - interval '24 hours') AS deliveries_24h,
       COUNT(wd.*) FILTER (WHERE wd.status='failed'  AND wd.created_at >= now() - interval '24 hours') AS failed_24h,
       MAX(wd.created_at)                                                     AS last_delivery_at
  FROM app.webhooks w
  LEFT JOIN ops.webhook_deliveries wd ON wd.webhook_id = w.id
 GROUP BY w.tenant_id, w.id, w.code;
