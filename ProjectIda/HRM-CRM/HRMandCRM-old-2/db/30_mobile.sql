-- =====================================================================
-- Module 30: Mobile Strategy
-- App version mgmt, device registry, push tokens, offline sync queue,
-- mobile feature flags, mobile analytics
-- =====================================================================

SET search_path = app, core, ops, public;

-- =============== SCHEMA ===============

CREATE TABLE IF NOT EXISTS app.mobile_apps (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid,                           -- NULL = platform-wide app
  code            citext NOT NULL,                -- 'field_sales','employee','customer'
  name            text NOT NULL,
  platform        text NOT NULL CHECK (platform IN ('ios','android','web','windows','macos')),
  bundle_id       text,                           -- com.acme.fieldsales
  store_url       text,
  active          boolean NOT NULL DEFAULT true,
  created_at      timestamptz NOT NULL DEFAULT now(),
  updated_at      timestamptz NOT NULL DEFAULT now(),
  created_by      uuid, updated_by uuid, version int NOT NULL DEFAULT 1,
  UNIQUE (code, platform)
);

CREATE TABLE IF NOT EXISTS app.mobile_app_versions (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  app_id          uuid NOT NULL REFERENCES app.mobile_apps(id) ON DELETE CASCADE,
  version_string  text NOT NULL,                  -- '1.2.3'
  version_code    int NOT NULL,                   -- 10203
  build_number    text,
  release_notes   text,
  min_supported_version_code int,
  force_update    boolean NOT NULL DEFAULT false,
  rollout_percent smallint NOT NULL DEFAULT 100 CHECK (rollout_percent BETWEEN 0 AND 100),
  released_at     timestamptz,
  deprecated_at   timestamptz,
  sha256          text,
  artifact_url    text,
  status          text NOT NULL DEFAULT 'draft'
                  CHECK (status IN ('draft','internal','beta','staged_rollout','released','deprecated','blocked')),
  created_at      timestamptz NOT NULL DEFAULT now(),
  updated_at      timestamptz NOT NULL DEFAULT now(),
  created_by      uuid, updated_by uuid, version int NOT NULL DEFAULT 1,
  UNIQUE (app_id, version_code)
);

CREATE TABLE IF NOT EXISTS app.mobile_devices (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  user_id         uuid REFERENCES app.users(id) ON DELETE SET NULL,
  app_id          uuid REFERENCES app.mobile_apps(id),
  device_id       text NOT NULL,                  -- OS-provided identifier
  platform        text NOT NULL CHECK (platform IN ('ios','android','web','windows','macos')),
  os_version      text,
  device_model    text,
  manufacturer    text,
  app_version     text,
  locale          text,
  timezone        text,
  is_rooted       boolean,
  last_seen_at    timestamptz NOT NULL DEFAULT now(),
  first_seen_at   timestamptz NOT NULL DEFAULT now(),
  status          text NOT NULL DEFAULT 'active'
                  CHECK (status IN ('active','inactive','blocked','wiped')),
  mdm_enrolled    boolean NOT NULL DEFAULT false,
  metadata        jsonb NOT NULL DEFAULT '{}'::jsonb,
  UNIQUE (tenant_id, device_id)
);

CREATE TABLE IF NOT EXISTS app.push_tokens (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  device_id       uuid NOT NULL REFERENCES app.mobile_devices(id) ON DELETE CASCADE,
  user_id         uuid REFERENCES app.users(id) ON DELETE CASCADE,
  provider        text NOT NULL CHECK (provider IN ('fcm','apns','web_push','onesignal','huawei')),
  token           text NOT NULL,
  voip            boolean NOT NULL DEFAULT false,
  active          boolean NOT NULL DEFAULT true,
  registered_at   timestamptz NOT NULL DEFAULT now(),
  last_used_at    timestamptz,
  failure_count   int NOT NULL DEFAULT 0,
  UNIQUE (provider, token)
);

-- Offline sync queue: mobile app buffers mutations offline, posts on reconnect.
CREATE TABLE IF NOT EXISTS ops.offline_sync_queue (
  id              uuid NOT NULL DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  device_id       uuid NOT NULL,
  user_id         uuid,
  client_mutation_id text NOT NULL,               -- idempotency key from client
  entity_type     text NOT NULL,
  operation       text NOT NULL CHECK (operation IN ('create','update','delete','upsert')),
  payload         jsonb NOT NULL,
  client_timestamp timestamptz NOT NULL,
  received_at     timestamptz NOT NULL DEFAULT now(),
  processed_at    timestamptz,
  status          text NOT NULL DEFAULT 'pending'
                  CHECK (status IN ('pending','processing','applied','conflict','failed','skipped','stale')),
  conflict_resolution text,
  server_entity_id uuid,
  error           text,
  attempts        int NOT NULL DEFAULT 0,
  PRIMARY KEY (id, received_at),
  UNIQUE (device_id, client_mutation_id, received_at)
) PARTITION BY RANGE (received_at);

CREATE TABLE IF NOT EXISTS ops.offline_sync_queue_2026 PARTITION OF ops.offline_sync_queue
  FOR VALUES FROM ('2026-01-01') TO ('2027-01-01');
CREATE TABLE IF NOT EXISTS ops.offline_sync_queue_default PARTITION OF ops.offline_sync_queue DEFAULT;

-- Per-device last-sync watermark per entity (for delta pull)
CREATE TABLE IF NOT EXISTS app.mobile_sync_watermarks (
  tenant_id       uuid NOT NULL,
  device_id       uuid NOT NULL REFERENCES app.mobile_devices(id) ON DELETE CASCADE,
  entity_type     text NOT NULL,
  last_synced_at  timestamptz NOT NULL DEFAULT now(),
  last_cursor     text,
  PRIMARY KEY (device_id, entity_type)
);

-- Mobile-specific feature flags (overrides app.feature_flags per app/version)
CREATE TABLE IF NOT EXISTS app.mobile_feature_flags (
  tenant_id       uuid NOT NULL,
  app_code        citext NOT NULL,
  feature_code    citext NOT NULL,
  min_version_code int,
  platforms       text[] NOT NULL DEFAULT '{}',
  enabled         boolean NOT NULL DEFAULT false,
  rollout_percent smallint NOT NULL DEFAULT 0,
  config          jsonb NOT NULL DEFAULT '{}'::jsonb,
  updated_at      timestamptz NOT NULL DEFAULT now(),
  PRIMARY KEY (tenant_id, app_code, feature_code)
);

-- Mobile analytics events (fire-and-forget from app)
CREATE TABLE IF NOT EXISTS ops.mobile_events (
  id              uuid NOT NULL DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  device_id       uuid,
  user_id         uuid,
  event_name      text NOT NULL,
  event_props     jsonb,
  screen_name     text,
  session_id      text,
  app_version     text,
  platform        text,
  occurred_at     timestamptz NOT NULL,
  received_at     timestamptz NOT NULL DEFAULT now(),
  PRIMARY KEY (id, received_at)
) PARTITION BY RANGE (received_at);

CREATE TABLE IF NOT EXISTS ops.mobile_events_2026 PARTITION OF ops.mobile_events
  FOR VALUES FROM ('2026-01-01') TO ('2027-01-01');
CREATE TABLE IF NOT EXISTS ops.mobile_events_default PARTITION OF ops.mobile_events DEFAULT;

CREATE TABLE IF NOT EXISTS app.mobile_crash_reports (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid,
  device_id       uuid REFERENCES app.mobile_devices(id),
  user_id         uuid,
  app_version     text,
  platform        text,
  exception_type  text,
  exception_message text,
  stack_trace     text,
  breadcrumbs     jsonb,
  fingerprint     text,
  occurred_at     timestamptz NOT NULL,
  reported_at     timestamptz NOT NULL DEFAULT now(),
  resolved_at     timestamptz
);

-- =============== INDEXES ===============
CREATE INDEX IF NOT EXISTS idx_apps_active          ON app.mobile_apps(code) WHERE active;
CREATE INDEX IF NOT EXISTS idx_versions_app_status  ON app.mobile_app_versions(app_id, status, version_code DESC);
CREATE INDEX IF NOT EXISTS idx_devices_user         ON app.mobile_devices(tenant_id, user_id);
CREATE INDEX IF NOT EXISTS idx_devices_last_seen    ON app.mobile_devices(last_seen_at DESC);
CREATE INDEX IF NOT EXISTS idx_devices_platform     ON app.mobile_devices(platform, status);
CREATE INDEX IF NOT EXISTS idx_ptokens_device       ON app.push_tokens(device_id) WHERE active;
CREATE INDEX IF NOT EXISTS idx_ptokens_user         ON app.push_tokens(user_id) WHERE active;
CREATE INDEX IF NOT EXISTS idx_sync_device_status   ON ops.offline_sync_queue(device_id, status);
CREATE INDEX IF NOT EXISTS idx_sync_pending         ON ops.offline_sync_queue(status, received_at) WHERE status IN ('pending','processing','failed');
CREATE INDEX IF NOT EXISTS idx_sync_entity          ON ops.offline_sync_queue(entity_type, server_entity_id);
CREATE INDEX IF NOT EXISTS idx_sync_wm_device       ON app.mobile_sync_watermarks(device_id);
CREATE INDEX IF NOT EXISTS idx_mff_feature          ON app.mobile_feature_flags(app_code, feature_code) WHERE enabled;
CREATE INDEX IF NOT EXISTS idx_mevents_device_time  ON ops.mobile_events(device_id, received_at DESC);
CREATE INDEX IF NOT EXISTS idx_mevents_name_time    ON ops.mobile_events(event_name, received_at DESC);
CREATE INDEX IF NOT EXISTS idx_crash_fingerprint    ON app.mobile_crash_reports(fingerprint, occurred_at DESC);
CREATE INDEX IF NOT EXISTS idx_crash_unresolved     ON app.mobile_crash_reports(tenant_id, occurred_at DESC) WHERE resolved_at IS NULL;

-- =============== RLS + TRIGGERS ===============
SELECT core.enable_tenant_rls('app.mobile_devices');
SELECT core.enable_tenant_rls('app.push_tokens');
SELECT core.enable_tenant_rls('app.mobile_sync_watermarks');
SELECT core.enable_tenant_rls('app.mobile_feature_flags');
SELECT core.enable_tenant_rls('app.mobile_crash_reports');

SELECT core.attach_standard_triggers('app.mobile_apps');
SELECT core.attach_standard_triggers('app.mobile_app_versions');

-- =============== FUNCTIONS ===============

-- Decide update action for a client based on installed version
CREATE OR REPLACE FUNCTION app.mobile_update_check(
  p_app_code text, p_platform text, p_client_version_code int
) RETURNS TABLE(action text, latest_version text, min_required int, release_notes text)
LANGUAGE sql STABLE AS $$
  WITH latest AS (
    SELECT mav.version_string, mav.version_code, mav.min_supported_version_code,
           mav.force_update, mav.release_notes
      FROM app.mobile_app_versions mav
      JOIN app.mobile_apps ma ON ma.id = mav.app_id
     WHERE ma.code = p_app_code AND ma.platform = p_platform
       AND mav.status IN ('released','staged_rollout')
     ORDER BY mav.version_code DESC LIMIT 1
  )
  SELECT CASE
           WHEN l.min_supported_version_code IS NOT NULL
                AND p_client_version_code < l.min_supported_version_code THEN 'force_update'
           WHEN l.force_update AND p_client_version_code < l.version_code THEN 'force_update'
           WHEN p_client_version_code < l.version_code THEN 'optional_update'
           ELSE 'up_to_date'
         END,
         l.version_string, l.min_supported_version_code, l.release_notes
    FROM latest l
$$;

-- Apply one offline mutation (app-layer picks result; stub records intent + conflict)
CREATE OR REPLACE PROCEDURE app.apply_offline_mutation(p_queue_id uuid, p_received_at timestamptz)
LANGUAGE plpgsql AS $$
DECLARE m ops.offline_sync_queue%ROWTYPE;
BEGIN
  UPDATE ops.offline_sync_queue
     SET status='processing', attempts = attempts + 1
   WHERE id = p_queue_id AND received_at = p_received_at
   RETURNING * INTO m;

  -- Delegate actual write to application service via NOTIFY (keeps DB generic)
  PERFORM pg_notify('offline_mutation',
    jsonb_build_object('id', m.id,
                       'entity', m.entity_type,
                       'op', m.operation,
                       'payload', m.payload,
                       'client_mutation_id', m.client_mutation_id,
                       'device_id', m.device_id)::text);
END $$;

-- =============== VIEWS ===============
CREATE OR REPLACE VIEW app.v_mobile_dau AS
SELECT tenant_id, platform,
       date_trunc('day', received_at)::date AS day,
       COUNT(DISTINCT device_id) AS dau,
       COUNT(DISTINCT user_id)   AS unique_users
  FROM ops.mobile_events
 GROUP BY tenant_id, platform, day;

CREATE OR REPLACE VIEW app.v_mobile_crash_rate AS
SELECT c.tenant_id, c.app_version, c.platform,
       COUNT(*) crash_count,
       COUNT(DISTINCT c.device_id) affected_devices,
       MAX(c.occurred_at) last_seen
  FROM app.mobile_crash_reports c
 WHERE c.occurred_at >= now() - interval '24 hours'
 GROUP BY c.tenant_id, c.app_version, c.platform;
