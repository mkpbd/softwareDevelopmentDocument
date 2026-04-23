-- =====================================================================
-- Module 28: Security & Data Protection (baseline)
-- Covers PRD Step 28 (encryption keys, PII tags, incidents, rate limits)
-- =====================================================================

SET search_path = app, core, public;

-- =============== SCHEMA ===============

CREATE TABLE IF NOT EXISTS app.encryption_keys (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid,                          -- NULL = platform-wide
  key_code        citext NOT NULL,
  kms_provider    text NOT NULL CHECK (kms_provider IN ('aws_kms','gcp_kms','azure_kv','local')),
  kms_key_id      text NOT NULL,
  purpose         text NOT NULL,                 -- 'column_pii','doc_at_rest','field_bank'
  status          text NOT NULL DEFAULT 'active' CHECK (status IN ('active','rotating','retired')),
  rotated_at      timestamptz,
  created_at      timestamptz NOT NULL DEFAULT now(),
  updated_at      timestamptz NOT NULL DEFAULT now(),
  created_by      uuid, updated_by uuid, version int NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, key_code)
);

CREATE TABLE IF NOT EXISTS app.pii_field_catalog (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  table_schema    text NOT NULL,
  table_name      text NOT NULL,
  column_name     text NOT NULL,
  pii_category    text NOT NULL CHECK (pii_category IN ('name','email','phone','address','id_number','financial','health','biometric','other')),
  classification  text NOT NULL CHECK (classification IN ('public','internal','confidential','restricted')),
  encrypted       boolean NOT NULL DEFAULT false,
  masked_in_ui    boolean NOT NULL DEFAULT false,
  retention_days  int,
  notes           text,
  UNIQUE (table_schema, table_name, column_name)
);

CREATE TABLE IF NOT EXISTS audit.data_access_log (
  id              bigserial PRIMARY KEY,
  tenant_id       uuid,
  user_id         uuid,
  resource_type   text NOT NULL,
  resource_id     text,
  action          text NOT NULL CHECK (action IN ('read','write','export','share','delete')),
  ip_address      inet,
  user_agent      text,
  metadata        jsonb,
  occurred_at     timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS app.security_incidents (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid,
  incident_type   text NOT NULL CHECK (incident_type IN ('breach','auth_abuse','ddos','malware','phishing','policy_violation','data_leak','other')),
  severity        text NOT NULL CHECK (severity IN ('low','medium','high','critical')),
  description     text NOT NULL,
  affected_users  uuid[],
  detected_at     timestamptz NOT NULL DEFAULT now(),
  resolved_at     timestamptz,
  resolution      text,
  status          text NOT NULL DEFAULT 'open' CHECK (status IN ('open','investigating','mitigated','closed','false_positive')),
  reported_to_regulator boolean NOT NULL DEFAULT false,
  created_at      timestamptz NOT NULL DEFAULT now(),
  updated_at      timestamptz NOT NULL DEFAULT now(),
  created_by      uuid, updated_by uuid, version int NOT NULL DEFAULT 1
);

CREATE TABLE IF NOT EXISTS ops.rate_limit_buckets (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid,
  bucket_key      text NOT NULL,               -- e.g. 'api:user:<uuid>:endpoint'
  limit_per_min   int NOT NULL,
  current_count   int NOT NULL DEFAULT 0,
  window_start    timestamptz NOT NULL DEFAULT now(),
  UNIQUE (bucket_key)
);

CREATE TABLE IF NOT EXISTS app.consent_records (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  subject_type    text NOT NULL CHECK (subject_type IN ('user','customer','employee')),
  subject_id      uuid NOT NULL,
  consent_type    text NOT NULL,                -- 'marketing','data_processing','profiling'
  granted         boolean NOT NULL,
  granted_at      timestamptz NOT NULL DEFAULT now(),
  withdrawn_at    timestamptz,
  source          text,
  evidence        jsonb
);

CREATE TABLE IF NOT EXISTS app.data_subject_requests (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  request_type    text NOT NULL CHECK (request_type IN ('access','erasure','portability','rectification','objection')),
  subject_email   citext NOT NULL,
  subject_id      uuid,
  status          text NOT NULL DEFAULT 'received'
                  CHECK (status IN ('received','verified','processing','completed','rejected')),
  due_date        date NOT NULL,
  completed_at    timestamptz,
  outcome         text,
  created_at      timestamptz NOT NULL DEFAULT now(),
  updated_at      timestamptz NOT NULL DEFAULT now(),
  created_by      uuid, updated_by uuid, version int NOT NULL DEFAULT 1
);

-- =============== INDEXES ===============
CREATE INDEX IF NOT EXISTS idx_enckeys_tenant      ON app.encryption_keys(tenant_id, status);
CREATE INDEX IF NOT EXISTS idx_pii_table           ON app.pii_field_catalog(table_schema, table_name);
CREATE INDEX IF NOT EXISTS idx_dal_tenant_time     ON audit.data_access_log(tenant_id, occurred_at DESC);
CREATE INDEX IF NOT EXISTS idx_dal_user_time       ON audit.data_access_log(user_id, occurred_at DESC);
CREATE INDEX IF NOT EXISTS idx_dal_resource        ON audit.data_access_log(resource_type, resource_id);
CREATE INDEX IF NOT EXISTS idx_incidents_status    ON app.security_incidents(tenant_id, status, severity);
CREATE INDEX IF NOT EXISTS idx_rlb_key             ON ops.rate_limit_buckets(bucket_key);
CREATE INDEX IF NOT EXISTS idx_consent_subject     ON app.consent_records(subject_type, subject_id);
CREATE INDEX IF NOT EXISTS idx_dsr_status_due      ON app.data_subject_requests(status, due_date);

-- =============== RLS ===============
SELECT core.enable_tenant_rls('app.security_incidents');
SELECT core.enable_tenant_rls('app.consent_records');
SELECT core.enable_tenant_rls('app.data_subject_requests');

-- =============== TRIGGERS ===============
SELECT core.attach_standard_triggers('app.encryption_keys');
SELECT core.attach_standard_triggers('app.security_incidents');
SELECT core.attach_standard_triggers('app.data_subject_requests');

-- =============== FUNCTIONS ===============

-- Mask PII for display (simple pattern-based)
CREATE OR REPLACE FUNCTION app.mask_pii(p_value text, p_category text)
RETURNS text
LANGUAGE sql IMMUTABLE AS $$
  SELECT CASE p_category
    WHEN 'email'    THEN regexp_replace(p_value, '(.).*(@.*)', '\1***\2')
    WHEN 'phone'    THEN regexp_replace(p_value, '(\d{2})\d+(\d{2})', '\1******\2')
    WHEN 'id_number' THEN repeat('*', GREATEST(0, length(p_value)-4)) || right(p_value,4)
    WHEN 'financial' THEN repeat('*', GREATEST(0, length(p_value)-4)) || right(p_value,4)
    ELSE left(p_value,1) || repeat('*', GREATEST(0, length(p_value)-2)) || right(p_value,1)
  END
$$;

-- Rate limit check (sliding window per minute)
CREATE OR REPLACE FUNCTION app.check_rate_limit(p_bucket_key text, p_limit int)
RETURNS boolean
LANGUAGE plpgsql AS $$
DECLARE v_cnt int;
BEGIN
  INSERT INTO ops.rate_limit_buckets(bucket_key, limit_per_min, current_count, window_start)
  VALUES (p_bucket_key, p_limit, 1, now())
  ON CONFLICT (bucket_key) DO UPDATE SET
    current_count = CASE
      WHEN ops.rate_limit_buckets.window_start < now() - interval '1 minute' THEN 1
      ELSE ops.rate_limit_buckets.current_count + 1 END,
    window_start  = CASE
      WHEN ops.rate_limit_buckets.window_start < now() - interval '1 minute' THEN now()
      ELSE ops.rate_limit_buckets.window_start END
  RETURNING current_count INTO v_cnt;
  RETURN v_cnt <= p_limit;
END $$;

-- Log data access (called from app layer)
CREATE OR REPLACE FUNCTION app.log_data_access(
  p_resource_type text, p_resource_id text, p_action text, p_metadata jsonb DEFAULT NULL
) RETURNS void
LANGUAGE sql AS $$
  INSERT INTO audit.data_access_log(tenant_id,user_id,resource_type,resource_id,action,metadata)
  VALUES (core.current_tenant_id(), core.current_user_id(), p_resource_type, p_resource_id, p_action, p_metadata)
$$;

-- =============== SEED ===============
-- Seed PII catalog for known tables
INSERT INTO app.pii_field_catalog(table_schema,table_name,column_name,pii_category,classification,masked_in_ui) VALUES
  ('app','users','email','email','confidential', false),
  ('app','users','phone','phone','confidential', true),
  ('app','customers','email','email','confidential', false),
  ('app','customers','phone','phone','confidential', true),
  ('app','customers','pan','id_number','restricted', true),
  ('app','customers','gstin','id_number','confidential', false),
  ('app','suppliers','pan','id_number','restricted', true),
  ('app','bank_accounts','account_number_masked','financial','restricted', true)
ON CONFLICT (table_schema, table_name, column_name) DO NOTHING;
