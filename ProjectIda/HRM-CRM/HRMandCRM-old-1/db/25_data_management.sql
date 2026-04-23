-- =====================================================================
-- STEP 25: Data Management
-- =====================================================================

CREATE TABLE data_mgmt.import_job (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    job_type        TEXT,
    entity_type     TEXT NOT NULL,
    file_name       TEXT,
    file_size       BIGINT,
    storage_key     TEXT,
    format          TEXT CHECK (format IN ('csv','xlsx','json','xml','jsonl','parquet')),
    total_rows      INT,
    processed_rows  INT DEFAULT 0,
    success_rows    INT DEFAULT 0,
    error_rows      INT DEFAULT 0,
    status          TEXT DEFAULT 'queued' CHECK (status IN ('queued','validating','running','completed','failed','cancelled','partial')),
    mapping         JSONB,
    dedupe_keys     TEXT[],
    error_log_key   TEXT,
    started_by      UUID,
    started_at      TIMESTAMPTZ,
    completed_at    TIMESTAMPTZ
);

CREATE TABLE data_mgmt.import_error (
    id              BIGSERIAL PRIMARY KEY,
    import_job_id   UUID NOT NULL REFERENCES data_mgmt.import_job(id) ON DELETE CASCADE,
    row_no          INT,
    column_name     TEXT,
    error_code      TEXT,
    error_message   TEXT,
    raw_row         JSONB
);

CREATE TABLE data_mgmt.export_job (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    entity_type     TEXT NOT NULL,
    format          TEXT,
    filter          JSONB,
    columns         TEXT[],
    storage_key     TEXT,
    row_count       INT,
    status          TEXT DEFAULT 'queued',
    requested_by    UUID,
    expires_at      TIMESTAMPTZ,
    created_at      TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE data_mgmt.correction_log (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    entity_type     TEXT NOT NULL,
    entity_id       UUID NOT NULL,
    field_changes   JSONB NOT NULL,
    reason          TEXT NOT NULL,
    approval_status TEXT DEFAULT 'pending',
    approved_by     UUID,
    executed_at     TIMESTAMPTZ,
    requested_by    UUID,
    created_at      TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE data_mgmt.retention_policy (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    entity_type     TEXT NOT NULL,
    condition       JSONB,
    retention_days  INT NOT NULL,
    action          TEXT CHECK (action IN ('archive','anonymize','delete')),
    is_active       BOOLEAN DEFAULT TRUE,
    UNIQUE (tenant_id, entity_type)
);

CREATE TABLE data_mgmt.archive_store (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    entity_type     TEXT NOT NULL,
    entity_id       UUID NOT NULL,
    archived_at     TIMESTAMPTZ DEFAULT NOW(),
    archive_key     TEXT,                         -- object store key
    data            JSONB,
    retention_until DATE
);

CREATE TABLE data_mgmt.backup_job (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    backup_type     TEXT CHECK (backup_type IN ('full','incremental','snapshot','logical')),
    started_at      TIMESTAMPTZ,
    completed_at    TIMESTAMPTZ,
    size_bytes      BIGINT,
    location        TEXT,
    status          TEXT,
    retention_until DATE,
    checksum        TEXT
);

CREATE TABLE data_mgmt.golden_record (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    entity_type     TEXT NOT NULL,
    master_id       UUID NOT NULL,
    merged_ids      UUID[],
    confidence      NUMERIC(5,2),
    rules_applied   JSONB,
    last_merged_at  TIMESTAMPTZ
);

CREATE TABLE data_mgmt.duplicate_candidate (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    entity_type     TEXT NOT NULL,
    record_a_id     UUID NOT NULL,
    record_b_id     UUID NOT NULL,
    similarity_score NUMERIC(5,4),
    matching_fields JSONB,
    status          TEXT DEFAULT 'pending' CHECK (status IN ('pending','merged','dismissed','kept'))
);

CREATE TABLE data_mgmt.data_quality_rule (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    entity_type     TEXT NOT NULL,
    rule_name       TEXT NOT NULL,
    rule_type       TEXT CHECK (rule_type IN ('not_null','unique','range','regex','reference','custom')),
    definition      JSONB,
    severity        TEXT CHECK (severity IN ('info','warning','error','critical')),
    is_active       BOOLEAN DEFAULT TRUE
);

CREATE TABLE data_mgmt.data_quality_run (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    rule_id         UUID NOT NULL REFERENCES data_mgmt.data_quality_rule(id),
    run_at          TIMESTAMPTZ DEFAULT NOW(),
    total_records   INT,
    violations      INT,
    details         JSONB
);

CREATE TABLE data_mgmt.data_lineage (
    id              BIGSERIAL PRIMARY KEY,
    source_system   TEXT,
    source_entity   TEXT,
    source_id       UUID,
    target_entity   TEXT,
    target_id       UUID,
    transformation  TEXT,
    created_at      TIMESTAMPTZ DEFAULT NOW()
);

-- =====================================================================
-- INDEXES
-- =====================================================================
CREATE INDEX idx_import_job_status      ON data_mgmt.import_job(status, tenant_id);
CREATE INDEX idx_import_error_job       ON data_mgmt.import_error(import_job_id);
CREATE INDEX idx_dup_candidate_status   ON data_mgmt.duplicate_candidate(entity_type, status);
CREATE INDEX idx_archive_entity         ON data_mgmt.archive_store(entity_type, entity_id);
CREATE INDEX idx_correction_entity      ON data_mgmt.correction_log(entity_type, entity_id);
