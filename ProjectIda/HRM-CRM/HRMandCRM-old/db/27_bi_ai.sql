-- =====================================================================
-- STEP 27: Business Intelligence & AI
-- =====================================================================

CREATE TABLE bi_ai.data_source (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    code            TEXT NOT NULL,
    name            TEXT NOT NULL,
    source_type     TEXT CHECK (source_type IN ('db','api','file','stream','warehouse')),
    connection      JSONB,
    is_active       BOOLEAN DEFAULT TRUE,
    UNIQUE (tenant_id, code)
);

CREATE TABLE bi_ai.etl_pipeline (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    code            TEXT NOT NULL,
    name            TEXT NOT NULL,
    source_id       UUID REFERENCES bi_ai.data_source(id),
    target_schema   TEXT,
    target_table    TEXT,
    schedule        TEXT,                         -- cron
    transformation  JSONB,
    last_run_at     TIMESTAMPTZ,
    last_run_status TEXT,
    is_active       BOOLEAN DEFAULT TRUE,
    UNIQUE (tenant_id, code)
);

CREATE TABLE bi_ai.etl_run (
    id              BIGSERIAL PRIMARY KEY,
    pipeline_id     UUID NOT NULL REFERENCES bi_ai.etl_pipeline(id),
    started_at      TIMESTAMPTZ DEFAULT NOW(),
    ended_at        TIMESTAMPTZ,
    rows_read       BIGINT,
    rows_written    BIGINT,
    rows_failed     BIGINT,
    status          TEXT,
    error           TEXT
);

-- OLAP cubes (metadata; actual cubes in analytic store)
CREATE TABLE bi_ai.cube (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    code            TEXT NOT NULL,
    name            TEXT NOT NULL,
    fact_table      TEXT NOT NULL,
    dimensions      JSONB NOT NULL,
    measures        JSONB NOT NULL,
    grain           TEXT,
    refresh_schedule TEXT,
    UNIQUE (tenant_id, code)
);

-- Forecasting
CREATE TABLE bi_ai.forecast_model (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    code            TEXT NOT NULL,
    name            TEXT NOT NULL,
    model_type      TEXT CHECK (model_type IN ('arima','sarima','holt_winters','prophet','lstm','xgboost','linear','custom')),
    entity_type     TEXT,                         -- demand/sales/cash
    parameters      JSONB,
    training_data_query TEXT,
    model_artifact_url TEXT,
    mape            NUMERIC(6,4),
    rmse            NUMERIC(19,6),
    trained_at      TIMESTAMPTZ,
    version         INT,
    UNIQUE (tenant_id, code, version)
);

CREATE TABLE bi_ai.forecast_output (
    id              BIGSERIAL PRIMARY KEY,
    model_id        UUID NOT NULL REFERENCES bi_ai.forecast_model(id),
    entity_id       UUID,
    forecast_date   DATE NOT NULL,
    forecast_value  NUMERIC(19,6),
    lower_bound     NUMERIC(19,6),
    upper_bound     NUMERIC(19,6),
    confidence_pct  NUMERIC(5,2),
    created_at      TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE bi_ai.scenario (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    name            TEXT NOT NULL,
    description     TEXT,
    parameters      JSONB,
    baseline_run_id UUID,
    results         JSONB,
    created_by      UUID,
    created_at      TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE bi_ai.anomaly (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    entity_type     TEXT NOT NULL,
    entity_id       UUID,
    detected_at     TIMESTAMPTZ DEFAULT NOW(),
    anomaly_type    TEXT CHECK (anomaly_type IN ('fraud','expense_outlier','stock_variance','revenue_drop','login_abuse','usage_spike')),
    severity        TEXT CHECK (severity IN ('low','medium','high','critical')),
    score           NUMERIC(5,4),
    description     TEXT,
    payload         JSONB,
    status          TEXT DEFAULT 'open' CHECK (status IN ('open','investigating','resolved','false_positive','ignored')),
    assignee_id     UUID,
    resolved_at     TIMESTAMPTZ
);

-- Embeddings & RAG
CREATE EXTENSION IF NOT EXISTS vector;

CREATE TABLE bi_ai.embedding (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    entity_type     TEXT NOT NULL,
    entity_id       UUID NOT NULL,
    chunk_idx       INT DEFAULT 0,
    source_text     TEXT,
    embedding       vector(1536),
    model           TEXT,
    metadata        JSONB,
    created_at      TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE bi_ai.rag_collection (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    code            TEXT NOT NULL,
    name            TEXT NOT NULL,
    description     TEXT,
    embedding_model TEXT,
    chunk_size      INT DEFAULT 1000,
    chunk_overlap   INT DEFAULT 200,
    UNIQUE (tenant_id, code)
);

CREATE TABLE bi_ai.rag_document (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    collection_id   UUID NOT NULL REFERENCES bi_ai.rag_collection(id) ON DELETE CASCADE,
    document_id     UUID REFERENCES document.document(id),
    title           TEXT,
    status          TEXT DEFAULT 'pending',
    indexed_at      TIMESTAMPTZ
);

-- LLM gateway
CREATE TABLE bi_ai.llm_provider (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    provider        TEXT NOT NULL,                -- anthropic/openai/google/aws/azure
    api_key_enc     BYTEA,
    base_url        TEXT,
    default_model   TEXT,
    is_active       BOOLEAN DEFAULT TRUE
);

CREATE TABLE bi_ai.llm_usage (
    id              BIGSERIAL,
    tenant_id       UUID NOT NULL,
    user_id         UUID,
    provider_id     UUID,
    model           TEXT NOT NULL,
    prompt_tokens   INT,
    completion_tokens INT,
    cached_tokens   INT DEFAULT 0,
    total_tokens    INT,
    cost_usd        NUMERIC(12,6),
    latency_ms      INT,
    feature         TEXT,
    request_hash    TEXT,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    PRIMARY KEY (id, created_at)
) PARTITION BY RANGE (created_at);
CREATE TABLE bi_ai.llm_usage_default PARTITION OF bi_ai.llm_usage DEFAULT;

CREATE TABLE bi_ai.ml_model (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    code            TEXT NOT NULL,
    name            TEXT NOT NULL,
    framework       TEXT,
    model_version   TEXT,
    artifact_url    TEXT,
    metrics         JSONB,
    deployed        BOOLEAN DEFAULT FALSE,
    deployed_endpoint TEXT,
    created_at      TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE (tenant_id, code, model_version)
);

CREATE TABLE bi_ai.model_prediction_log (
    id              BIGSERIAL PRIMARY KEY,
    model_id        UUID NOT NULL REFERENCES bi_ai.ml_model(id),
    input           JSONB,
    output          JSONB,
    confidence      NUMERIC(5,4),
    latency_ms      INT,
    created_at      TIMESTAMPTZ DEFAULT NOW()
);

-- =====================================================================
-- INDEXES
-- =====================================================================
CREATE INDEX idx_embedding_ivfflat     ON bi_ai.embedding USING ivfflat (embedding vector_cosine_ops) WITH (lists=100);
CREATE INDEX idx_embedding_entity      ON bi_ai.embedding(entity_type, entity_id);
CREATE INDEX idx_anomaly_status        ON bi_ai.anomaly(tenant_id, status, severity);
CREATE INDEX idx_forecast_output_ent   ON bi_ai.forecast_output(model_id, entity_id, forecast_date);
CREATE INDEX idx_llm_usage_tenant_time ON bi_ai.llm_usage(tenant_id, created_at DESC);

-- =====================================================================
-- FUNCTIONS
-- =====================================================================
CREATE OR REPLACE FUNCTION bi_ai.fn_semantic_search(
    p_tenant UUID, p_query_embedding vector, p_entity_types TEXT[] DEFAULT NULL,
    p_limit INT DEFAULT 10
) RETURNS TABLE (entity_type TEXT, entity_id UUID, similarity NUMERIC, source_text TEXT) AS $$
    SELECT entity_type, entity_id, 1 - (embedding <=> p_query_embedding) AS similarity, source_text
      FROM bi_ai.embedding
     WHERE tenant_id = p_tenant
       AND (p_entity_types IS NULL OR entity_type = ANY(p_entity_types))
     ORDER BY embedding <=> p_query_embedding
     LIMIT p_limit;
$$ LANGUAGE sql STABLE;
