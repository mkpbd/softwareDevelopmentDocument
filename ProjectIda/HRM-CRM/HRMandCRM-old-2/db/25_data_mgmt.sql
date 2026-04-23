-- =====================================================================
-- Module 25: Data Management
-- Covers PRD Step 25 (import/export, archival, MDM, retention, dedup)
-- =====================================================================

SET search_path = app, core, public;

-- =============== SCHEMA ===============

CREATE TABLE IF NOT EXISTS ops.import_jobs (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  entity_type     text NOT NULL,
  source_file     text,
  source_key      text,
  file_format     text NOT NULL CHECK (file_format IN ('csv','xlsx','json','xml')),
  mapping         jsonb NOT NULL DEFAULT '{}'::jsonb,
  status          text NOT NULL DEFAULT 'queued'
                  CHECK (status IN ('queued','validating','running','completed','failed','cancelled')),
  rows_total      int NOT NULL DEFAULT 0,
  rows_succeeded  int NOT NULL DEFAULT 0,
  rows_failed     int NOT NULL DEFAULT 0,
  error_report    jsonb,
  dedup_strategy  text CHECK (dedup_strategy IN (NULL,'skip','update','error')),
  started_at      timestamptz,
  completed_at    timestamptz,
  created_at      timestamptz NOT NULL DEFAULT now(),
  created_by      uuid
);

CREATE TABLE IF NOT EXISTS ops.import_errors (
  id              bigserial PRIMARY KEY,
  job_id          uuid NOT NULL REFERENCES ops.import_jobs(id) ON DELETE CASCADE,
  row_no          int NOT NULL,
  column_name     text,
  error_code      text,
  error_message   text NOT NULL,
  raw_row         jsonb
);

CREATE TABLE IF NOT EXISTS ops.export_jobs (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  entity_type     text NOT NULL,
  format          text NOT NULL CHECK (format IN ('csv','xlsx','json','pdf')),
  filters         jsonb,
  output_file     text,
  output_key      text,
  status          text NOT NULL DEFAULT 'queued'
                  CHECK (status IN ('queued','running','completed','failed')),
  row_count       int,
  created_at      timestamptz NOT NULL DEFAULT now(),
  completed_at    timestamptz,
  created_by      uuid,
  expires_at      timestamptz
);

CREATE TABLE IF NOT EXISTS app.retention_policies (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  entity_type     text NOT NULL,
  retention_days  int NOT NULL CHECK (retention_days > 0),
  archive_first   boolean NOT NULL DEFAULT true,
  active          boolean NOT NULL DEFAULT true,
  created_at      timestamptz NOT NULL DEFAULT now(),
  updated_at      timestamptz NOT NULL DEFAULT now(),
  created_by      uuid, updated_by uuid, version int NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, entity_type)
);

CREATE TABLE IF NOT EXISTS audit.archive_log (
  id              bigserial PRIMARY KEY,
  tenant_id       uuid NOT NULL,
  entity_type     text NOT NULL,
  entity_id       uuid NOT NULL,
  archive_location text,
  archived_at     timestamptz NOT NULL DEFAULT now(),
  archived_by     uuid,
  snapshot        jsonb
);

CREATE TABLE IF NOT EXISTS app.mdm_merges (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  entity_type     text NOT NULL,
  surviving_id    uuid NOT NULL,
  merged_id       uuid NOT NULL,
  merged_at       timestamptz NOT NULL DEFAULT now(),
  merged_by       uuid,
  reason          text,
  CHECK (surviving_id <> merged_id)
);

CREATE TABLE IF NOT EXISTS app.data_quality_rules (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  code            citext NOT NULL,
  entity_type     text NOT NULL,
  column_name     text,
  rule_type       text NOT NULL CHECK (rule_type IN ('not_null','unique','regex','range','lookup','custom')),
  rule_expr       jsonb NOT NULL,
  severity        text NOT NULL DEFAULT 'warning' CHECK (severity IN ('info','warning','error','critical')),
  active          boolean NOT NULL DEFAULT true,
  created_at      timestamptz NOT NULL DEFAULT now(),
  updated_at      timestamptz NOT NULL DEFAULT now(),
  created_by      uuid, updated_by uuid, version int NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, code)
);

CREATE TABLE IF NOT EXISTS app.data_quality_violations (
  id              bigserial PRIMARY KEY,
  tenant_id       uuid NOT NULL,
  rule_id         uuid NOT NULL REFERENCES app.data_quality_rules(id) ON DELETE CASCADE,
  entity_type     text NOT NULL,
  entity_id       uuid NOT NULL,
  violation_detail jsonb,
  detected_at     timestamptz NOT NULL DEFAULT now(),
  resolved_at     timestamptz,
  resolved_by     uuid
);

-- =============== INDEXES ===============
CREATE INDEX IF NOT EXISTS idx_import_tenant_status ON ops.import_jobs(tenant_id, status, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_import_errors_job    ON ops.import_errors(job_id);
CREATE INDEX IF NOT EXISTS idx_export_tenant_time   ON ops.export_jobs(tenant_id, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_export_expires       ON ops.export_jobs(expires_at) WHERE expires_at IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_retention_entity     ON app.retention_policies(tenant_id, entity_type) WHERE active;
CREATE INDEX IF NOT EXISTS idx_archive_entity       ON audit.archive_log(entity_type, entity_id);
CREATE INDEX IF NOT EXISTS idx_merge_entity         ON app.mdm_merges(tenant_id, entity_type, merged_id);
CREATE INDEX IF NOT EXISTS idx_dq_violations_entity ON app.data_quality_violations(entity_type, entity_id) WHERE resolved_at IS NULL;

-- =============== RLS ===============
SELECT core.enable_tenant_rls('app.retention_policies');
SELECT core.enable_tenant_rls('app.mdm_merges');
SELECT core.enable_tenant_rls('app.data_quality_rules');
SELECT core.enable_tenant_rls('app.data_quality_violations');

-- =============== TRIGGERS ===============
SELECT core.attach_standard_triggers('app.retention_policies');
SELECT core.attach_standard_triggers('app.data_quality_rules');

-- =============== FUNCTIONS ===============

-- Merge two master-data records (customers/suppliers/items). Repoints FK refs via NOTIFY — actual FK rewire must be app-coded; here we record intent.
CREATE OR REPLACE FUNCTION app.merge_records(
  p_entity_type text, p_surviving_id uuid, p_merged_id uuid, p_reason text DEFAULT NULL
) RETURNS uuid
LANGUAGE plpgsql AS $$
DECLARE v_id uuid := gen_random_uuid();
BEGIN
  IF p_surviving_id = p_merged_id THEN RAISE EXCEPTION 'cannot merge record with itself'; END IF;

  INSERT INTO app.mdm_merges(id,tenant_id,entity_type,surviving_id,merged_id,merged_by,reason)
  VALUES (v_id, core.require_tenant(), p_entity_type, p_surviving_id, p_merged_id, core.current_user_id(), p_reason);

  PERFORM pg_notify('mdm_merge',
    jsonb_build_object('entity', p_entity_type,
                       'surviving', p_surviving_id,
                       'merged',    p_merged_id)::text);
  RETURN v_id;
END $$;

-- Apply retention policies — archives rows older than retention, then deletes.
CREATE OR REPLACE FUNCTION app.apply_retention_policies()
RETURNS TABLE(entity_type text, archived int)
LANGUAGE plpgsql AS $$
DECLARE r record;
BEGIN
  FOR r IN SELECT * FROM app.retention_policies WHERE active LOOP
    -- Example: documents (extend per entity as needed)
    IF r.entity_type = 'documents' THEN
      WITH moved AS (
        DELETE FROM app.documents
         WHERE tenant_id = r.tenant_id
           AND created_at < now() - (r.retention_days || ' days')::interval
        RETURNING id, tenant_id, to_jsonb(documents.*) AS snap
      )
      INSERT INTO audit.archive_log(tenant_id, entity_type, entity_id, snapshot)
      SELECT tenant_id, 'documents', id, snap FROM moved;
      entity_type := 'documents';
      archived := ROW_COUNT;
      RETURN NEXT;
    END IF;
  END LOOP;
END $$;

-- Duplicate candidate detection (customers by name trigram)
CREATE OR REPLACE FUNCTION app.find_duplicate_customers(p_similarity_threshold numeric DEFAULT 0.8)
RETURNS TABLE(a_id uuid, b_id uuid, a_name text, b_name text, similarity numeric)
LANGUAGE sql STABLE AS $$
  SELECT c1.id, c2.id, c1.name, c2.name, similarity(c1.name, c2.name)::numeric
    FROM app.customers c1
    JOIN app.customers c2
      ON c1.tenant_id = c2.tenant_id AND c1.id < c2.id
     AND similarity(c1.name, c2.name) >= p_similarity_threshold
   WHERE c1.tenant_id = core.require_tenant()
$$;

-- =============== VIEWS ===============
CREATE OR REPLACE VIEW app.v_import_summary AS
SELECT tenant_id, entity_type,
       COUNT(*) FILTER (WHERE status='completed') AS completed,
       COUNT(*) FILTER (WHERE status='failed')    AS failed,
       SUM(rows_succeeded)                         AS rows_loaded,
       SUM(rows_failed)                            AS rows_errored,
       MAX(created_at)                             AS last_import_at
  FROM ops.import_jobs
 GROUP BY tenant_id, entity_type;
