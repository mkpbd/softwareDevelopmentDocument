-- =====================================================================
-- STEP 29: Performance & Observability
-- =====================================================================

CREATE TABLE observability.metric (
    id              BIGSERIAL,
    tenant_id       UUID,
    metric_name     TEXT NOT NULL,
    value           DOUBLE PRECISION NOT NULL,
    tags            JSONB,
    recorded_at     TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    PRIMARY KEY (id, recorded_at)
) PARTITION BY RANGE (recorded_at);
CREATE TABLE observability.metric_default PARTITION OF observability.metric DEFAULT;

CREATE TABLE observability.log_event (
    id              BIGSERIAL,
    tenant_id       UUID,
    level           TEXT CHECK (level IN ('debug','info','warn','error','fatal')),
    logger          TEXT,
    message         TEXT,
    trace_id        TEXT,
    span_id         TEXT,
    user_id         UUID,
    context         JSONB,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    PRIMARY KEY (id, created_at)
) PARTITION BY RANGE (created_at);
CREATE TABLE observability.log_event_default PARTITION OF observability.log_event DEFAULT;

CREATE TABLE observability.trace (
    trace_id        TEXT NOT NULL,
    span_id         TEXT NOT NULL,
    parent_span_id  TEXT,
    operation       TEXT NOT NULL,
    service         TEXT,
    start_at        TIMESTAMPTZ NOT NULL,
    end_at          TIMESTAMPTZ,
    duration_ms     INT,
    status          TEXT,
    tags            JSONB,
    PRIMARY KEY (trace_id, span_id, start_at)
) PARTITION BY RANGE (start_at);
CREATE TABLE observability.trace_default PARTITION OF observability.trace DEFAULT;

CREATE TABLE observability.error_event (
    id              BIGSERIAL PRIMARY KEY,
    tenant_id       UUID,
    service         TEXT,
    error_type      TEXT,
    message         TEXT,
    stacktrace      TEXT,
    fingerprint     TEXT,                         -- dedupe
    count           INT DEFAULT 1,
    first_seen      TIMESTAMPTZ DEFAULT NOW(),
    last_seen       TIMESTAMPTZ DEFAULT NOW(),
    status          TEXT DEFAULT 'open' CHECK (status IN ('open','investigating','resolved','ignored')),
    assignee_id     UUID,
    environment     TEXT,
    release_version TEXT
);

CREATE TABLE observability.uptime_check (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name            TEXT NOT NULL,
    target_url      TEXT NOT NULL,
    method          TEXT DEFAULT 'GET',
    interval_sec    INT DEFAULT 60,
    timeout_sec     INT DEFAULT 10,
    expected_status INT,
    regions         TEXT[],
    is_active       BOOLEAN DEFAULT TRUE
);

CREATE TABLE observability.uptime_result (
    id              BIGSERIAL PRIMARY KEY,
    check_id        UUID NOT NULL REFERENCES observability.uptime_check(id),
    region          TEXT,
    checked_at      TIMESTAMPTZ DEFAULT NOW(),
    status_code     INT,
    response_ms     INT,
    is_up           BOOLEAN,
    error           TEXT
);

CREATE TABLE observability.slo (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    service         TEXT NOT NULL,
    indicator       TEXT NOT NULL,                -- latency_p95/error_rate/...
    target          NUMERIC(8,4) NOT NULL,
    target_unit     TEXT,
    window_days     INT DEFAULT 28,
    error_budget_pct NUMERIC(5,2) DEFAULT 0.1,
    UNIQUE (service, indicator)
);

CREATE TABLE observability.incident (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    incident_no     TEXT NOT NULL UNIQUE,
    summary         TEXT NOT NULL,
    severity        TEXT CHECK (severity IN ('sev1','sev2','sev3','sev4','sev5')),
    status          TEXT DEFAULT 'open' CHECK (status IN ('open','investigating','identified','monitoring','resolved','postmortem')),
    affected_services TEXT[],
    opened_at       TIMESTAMPTZ DEFAULT NOW(),
    resolved_at     TIMESTAMPTZ,
    root_cause      TEXT,
    mttd_min        INT,                          -- time to detect
    mttr_min        INT,                          -- time to resolve
    postmortem_doc_id UUID,
    on_call_engineer UUID
);

CREATE TABLE observability.background_job (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    queue_name      TEXT NOT NULL,
    job_type        TEXT NOT NULL,
    payload         JSONB,
    priority        INT DEFAULT 0,
    scheduled_at    TIMESTAMPTZ DEFAULT NOW(),
    started_at      TIMESTAMPTZ,
    completed_at    TIMESTAMPTZ,
    attempts        INT DEFAULT 0,
    max_attempts    INT DEFAULT 3,
    status          TEXT DEFAULT 'queued' CHECK (status IN ('queued','running','completed','failed','cancelled','retrying')),
    worker_id       TEXT,
    error           TEXT,
    duration_ms     INT
);

CREATE TABLE observability.db_slow_query (
    id              BIGSERIAL PRIMARY KEY,
    captured_at     TIMESTAMPTZ DEFAULT NOW(),
    query_hash      TEXT,
    query_text      TEXT,
    mean_ms         NUMERIC(12,2),
    calls           BIGINT,
    rows_sum        BIGINT,
    schema_name     TEXT
);

-- =====================================================================
-- INDEXES
-- =====================================================================
CREATE INDEX idx_metric_name_time      ON observability.metric(metric_name, recorded_at DESC);
CREATE INDEX idx_log_trace             ON observability.log_event(trace_id);
CREATE INDEX idx_log_level_time        ON observability.log_event(level, created_at DESC);
CREATE INDEX idx_trace_id              ON observability.trace(trace_id);
CREATE INDEX idx_error_fingerprint     ON observability.error_event(fingerprint);
CREATE INDEX idx_error_status          ON observability.error_event(status, last_seen DESC);
CREATE INDEX idx_uptime_result_check   ON observability.uptime_result(check_id, checked_at DESC);
CREATE INDEX idx_bg_job_queue_status   ON observability.background_job(queue_name, status, scheduled_at);
CREATE INDEX idx_incident_status       ON observability.incident(status, opened_at DESC);
