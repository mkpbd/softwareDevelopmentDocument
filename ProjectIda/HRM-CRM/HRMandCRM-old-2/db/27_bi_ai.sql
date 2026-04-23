-- =====================================================================
-- Module 27: Business Intelligence & AI
-- Data warehouse/lakehouse refs, ETL pipelines, OLAP cubes, forecasting,
-- scenarios, anomaly detection, embeddings + RAG, LLM gateway, ML registry
-- =====================================================================

SET search_path = app, core, ops, public;

-- Optional extension — pgvector. If not installed, embeddings stored as bytea.
DO $$
BEGIN
  PERFORM 1 FROM pg_available_extensions WHERE name = 'vector';
  IF FOUND THEN
    CREATE EXTENSION IF NOT EXISTS vector;
  ELSE
    RAISE NOTICE 'pgvector not available; app.embeddings.vector column stored as bytea fallback';
  END IF;
END $$;

-- =============== SCHEMA ===============

-- Lakehouse / warehouse registry (pointer only — actual data lives elsewhere)
CREATE TABLE IF NOT EXISTS app.data_warehouses (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  code            citext NOT NULL,
  name            text NOT NULL,
  platform        text NOT NULL CHECK (platform IN ('snowflake','bigquery','redshift','databricks','clickhouse','postgres','duckdb','s3_iceberg','s3_delta')),
  connection      jsonb NOT NULL,
  region          text,
  active          boolean NOT NULL DEFAULT true,
  created_at      timestamptz NOT NULL DEFAULT now(),
  updated_at      timestamptz NOT NULL DEFAULT now(),
  created_by      uuid, updated_by uuid, version int NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, code)
);

CREATE TABLE IF NOT EXISTS app.etl_pipelines (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  code            citext NOT NULL,
  name            text NOT NULL,
  pipeline_type   text NOT NULL DEFAULT 'elt' CHECK (pipeline_type IN ('etl','elt','cdc','streaming')),
  source          jsonb NOT NULL,
  target_warehouse_id uuid REFERENCES app.data_warehouses(id),
  target_schema   text,
  target_table    text,
  schedule_cron   text,
  transformation_ref text,
  dependencies    uuid[] NOT NULL DEFAULT '{}',
  owner_user_id   uuid REFERENCES app.users(id),
  active          boolean NOT NULL DEFAULT true,
  created_at      timestamptz NOT NULL DEFAULT now(),
  updated_at      timestamptz NOT NULL DEFAULT now(),
  created_by      uuid, updated_by uuid, version int NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, code)
);

CREATE TABLE IF NOT EXISTS ops.etl_runs (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid,
  pipeline_id     uuid NOT NULL REFERENCES app.etl_pipelines(id) ON DELETE CASCADE,
  run_key         text NOT NULL,
  status          text NOT NULL DEFAULT 'running'
                  CHECK (status IN ('queued','running','success','failed','cancelled','partial')),
  rows_read       bigint, rows_written bigint, rows_rejected bigint,
  bytes_read      bigint, bytes_written bigint,
  started_at      timestamptz NOT NULL DEFAULT now(),
  completed_at    timestamptz,
  duration_ms     int,
  error           text,
  watermark       jsonb,
  UNIQUE (pipeline_id, run_key)
);

CREATE TABLE IF NOT EXISTS app.olap_cubes (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  code            citext NOT NULL,
  name            text NOT NULL,
  warehouse_id    uuid REFERENCES app.data_warehouses(id),
  dimensions      jsonb NOT NULL,
  measures        jsonb NOT NULL,
  filters         jsonb,
  definition_sql  text,
  last_built_at   timestamptz,
  active          boolean NOT NULL DEFAULT true,
  created_at      timestamptz NOT NULL DEFAULT now(),
  updated_at      timestamptz NOT NULL DEFAULT now(),
  created_by      uuid, updated_by uuid, version int NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, code)
);

CREATE TABLE IF NOT EXISTS app.forecast_models (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  code            citext NOT NULL,
  name            text NOT NULL,
  target_entity   text NOT NULL,
  target_metric   text NOT NULL,
  algorithm       text NOT NULL CHECK (algorithm IN ('arima','sarimax','prophet','exponential_smoothing','lstm','xgboost','lightgbm','manual')),
  hyperparameters jsonb,
  training_window interval,
  horizon         interval,
  accuracy_mape   numeric(5,2),
  last_trained_at timestamptz,
  status          text NOT NULL DEFAULT 'draft' CHECK (status IN ('draft','training','ready','deployed','retired')),
  model_artifact_uri text,
  created_at      timestamptz NOT NULL DEFAULT now(),
  updated_at      timestamptz NOT NULL DEFAULT now(),
  created_by      uuid, updated_by uuid, version int NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, code)
);

CREATE TABLE IF NOT EXISTS app.forecast_results (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  model_id        uuid NOT NULL REFERENCES app.forecast_models(id) ON DELETE CASCADE,
  entity_id       uuid,
  forecast_date   date NOT NULL,
  predicted_value numeric(19,6) NOT NULL,
  lower_bound     numeric(19,6),
  upper_bound     numeric(19,6),
  confidence_pct  numeric(5,2),
  actual_value    numeric(19,6),
  generated_at    timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS app.scenarios (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  code            citext NOT NULL,
  name            text NOT NULL,
  description     text,
  scenario_type   text NOT NULL CHECK (scenario_type IN ('what_if','best_case','worst_case','budget','stretch','baseline')),
  assumptions     jsonb NOT NULL DEFAULT '{}'::jsonb,
  base_period     daterange,
  output_period   daterange,
  results         jsonb,
  status          text NOT NULL DEFAULT 'draft' CHECK (status IN ('draft','running','completed','approved','rejected','archived')),
  created_at      timestamptz NOT NULL DEFAULT now(),
  updated_at      timestamptz NOT NULL DEFAULT now(),
  created_by      uuid, updated_by uuid, version int NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, code)
);

CREATE TABLE IF NOT EXISTS app.anomaly_detectors (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  code            citext NOT NULL,
  name            text NOT NULL,
  entity_type     text NOT NULL,                      -- 'expense','stock','login','invoice','order'
  metric          text NOT NULL,
  algorithm       text NOT NULL CHECK (algorithm IN ('zscore','iqr','isolation_forest','dbscan','autoencoder','rule')),
  config          jsonb NOT NULL DEFAULT '{}'::jsonb,
  threshold       numeric(12,4),
  active          boolean NOT NULL DEFAULT true,
  UNIQUE (tenant_id, code)
);

CREATE TABLE IF NOT EXISTS app.anomaly_events (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  detector_id     uuid NOT NULL REFERENCES app.anomaly_detectors(id) ON DELETE CASCADE,
  entity_type     text NOT NULL,
  entity_id       uuid,
  detected_at     timestamptz NOT NULL DEFAULT now(),
  score           numeric(12,6),
  expected_value  numeric(19,4),
  actual_value    numeric(19,4),
  severity        text NOT NULL CHECK (severity IN ('info','low','medium','high','critical')),
  status          text NOT NULL DEFAULT 'open'
                  CHECK (status IN ('open','acknowledged','resolved','false_positive')),
  resolved_at     timestamptz,
  resolved_by     uuid,
  context         jsonb
);

-- Embeddings + RAG
CREATE TABLE IF NOT EXISTS app.embedding_models (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  code            citext NOT NULL UNIQUE,
  provider        text NOT NULL,
  model_name      text NOT NULL,
  dimensions      int NOT NULL,
  max_input_tokens int,
  active          boolean NOT NULL DEFAULT true
);

CREATE TABLE IF NOT EXISTS app.embeddings (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  embedding_model_id uuid NOT NULL REFERENCES app.embedding_models(id),
  source_type     text NOT NULL,                      -- 'document','kb_article','item','custom'
  source_id       uuid NOT NULL,
  chunk_no        smallint NOT NULL DEFAULT 0,
  chunk_text      text NOT NULL,
  token_count     int,
  vector_bytea    bytea,                              -- fallback if pgvector absent
  metadata        jsonb NOT NULL DEFAULT '{}'::jsonb,
  created_at      timestamptz NOT NULL DEFAULT now(),
  UNIQUE (tenant_id, source_type, source_id, chunk_no, embedding_model_id)
);

-- If pgvector present, add vector column + index (ivfflat cosine)
DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM pg_extension WHERE extname='vector') THEN
    BEGIN
      ALTER TABLE app.embeddings ADD COLUMN IF NOT EXISTS vector vector(1536);
    EXCEPTION WHEN others THEN
      RAISE NOTICE 'could not add vector column: %', SQLERRM;
    END;
  END IF;
END $$;

CREATE TABLE IF NOT EXISTS app.rag_queries (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  user_id         uuid REFERENCES app.users(id),
  query_text      text NOT NULL,
  embedding_model_id uuid REFERENCES app.embedding_models(id),
  retrieved_chunks jsonb,
  top_k           smallint NOT NULL DEFAULT 5,
  response_text   text,
  latency_ms      int,
  created_at      timestamptz NOT NULL DEFAULT now()
);

-- LLM gateway — token/cost tracking per call
CREATE TABLE IF NOT EXISTS app.llm_providers (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  code            citext NOT NULL UNIQUE,
  name            text NOT NULL,
  base_url        text,
  active          boolean NOT NULL DEFAULT true
);

CREATE TABLE IF NOT EXISTS app.llm_models (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  provider_id     uuid NOT NULL REFERENCES app.llm_providers(id),
  code            citext NOT NULL,
  model_family    text,
  input_cost_per_1k_tokens  numeric(12,6) NOT NULL DEFAULT 0,
  output_cost_per_1k_tokens numeric(12,6) NOT NULL DEFAULT 0,
  max_context_tokens int,
  active          boolean NOT NULL DEFAULT true,
  UNIQUE (provider_id, code)
);

CREATE TABLE IF NOT EXISTS app.llm_calls (
  id              uuid NOT NULL DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  user_id         uuid,
  feature_code    text,
  model_id        uuid NOT NULL REFERENCES app.llm_models(id),
  prompt_preview  text,
  input_tokens    int NOT NULL DEFAULT 0,
  output_tokens   int NOT NULL DEFAULT 0,
  total_tokens    int GENERATED ALWAYS AS (input_tokens + output_tokens) STORED,
  cost_usd        numeric(12,6) NOT NULL DEFAULT 0,
  latency_ms      int,
  status          text NOT NULL CHECK (status IN ('success','error','timeout','content_filtered','cancelled')),
  error           text,
  request_id      text,
  cached          boolean NOT NULL DEFAULT false,
  called_at       timestamptz NOT NULL DEFAULT now(),
  metadata        jsonb,
  PRIMARY KEY (id, called_at)
) PARTITION BY RANGE (called_at);

CREATE TABLE IF NOT EXISTS app.llm_calls_2026 PARTITION OF app.llm_calls
  FOR VALUES FROM ('2026-01-01') TO ('2027-01-01');
CREATE TABLE IF NOT EXISTS app.llm_calls_default PARTITION OF app.llm_calls DEFAULT;

-- ML model registry
CREATE TABLE IF NOT EXISTS app.ml_models (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  code            citext NOT NULL,
  name            text NOT NULL,
  task_type       text NOT NULL CHECK (task_type IN ('classification','regression','clustering','forecasting','recommendation','nlp','vision','ranking','other')),
  framework       text,
  version         text NOT NULL,
  status          text NOT NULL DEFAULT 'draft'
                  CHECK (status IN ('draft','training','staging','production','shadow','deprecated','archived')),
  artifact_uri    text,
  metrics         jsonb,
  training_dataset_ref text,
  deployed_at     timestamptz,
  deployed_by     uuid,
  created_at      timestamptz NOT NULL DEFAULT now(),
  updated_at      timestamptz NOT NULL DEFAULT now(),
  created_by      uuid, updated_by uuid, version_no int NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, code, version)
);

CREATE TABLE IF NOT EXISTS app.ml_predictions (
  id              uuid NOT NULL DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  model_id        uuid NOT NULL REFERENCES app.ml_models(id),
  entity_type     text,
  entity_id       uuid,
  features        jsonb,
  prediction      jsonb NOT NULL,
  confidence      numeric(5,4),
  predicted_at    timestamptz NOT NULL DEFAULT now(),
  actual_outcome  jsonb,
  feedback_at     timestamptz,
  PRIMARY KEY (id, predicted_at)
) PARTITION BY RANGE (predicted_at);

CREATE TABLE IF NOT EXISTS app.ml_predictions_2026 PARTITION OF app.ml_predictions
  FOR VALUES FROM ('2026-01-01') TO ('2027-01-01');
CREATE TABLE IF NOT EXISTS app.ml_predictions_default PARTITION OF app.ml_predictions DEFAULT;

-- =============== INDEXES ===============
CREATE INDEX IF NOT EXISTS idx_dw_active           ON app.data_warehouses(tenant_id) WHERE active;
CREATE INDEX IF NOT EXISTS idx_etlp_active         ON app.etl_pipelines(tenant_id) WHERE active;
CREATE INDEX IF NOT EXISTS idx_etlr_pipe           ON ops.etl_runs(pipeline_id, started_at DESC);
CREATE INDEX IF NOT EXISTS idx_etlr_status         ON ops.etl_runs(status) WHERE status IN ('queued','running','failed');
CREATE INDEX IF NOT EXISTS idx_fm_active           ON app.forecast_models(tenant_id, status);
CREATE INDEX IF NOT EXISTS idx_fr_model_date       ON app.forecast_results(model_id, forecast_date DESC);
CREATE INDEX IF NOT EXISTS idx_scen_tenant_status  ON app.scenarios(tenant_id, status);
CREATE INDEX IF NOT EXISTS idx_anom_detector_time  ON app.anomaly_events(detector_id, detected_at DESC);
CREATE INDEX IF NOT EXISTS idx_anom_open           ON app.anomaly_events(tenant_id, severity) WHERE status='open';
CREATE INDEX IF NOT EXISTS idx_emb_source          ON app.embeddings(tenant_id, source_type, source_id);
CREATE INDEX IF NOT EXISTS idx_emb_meta_gin        ON app.embeddings USING gin (metadata jsonb_path_ops);
CREATE INDEX IF NOT EXISTS idx_rag_user_time       ON app.rag_queries(user_id, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_llm_tenant_time     ON app.llm_calls(tenant_id, called_at DESC);
CREATE INDEX IF NOT EXISTS idx_llm_user_time       ON app.llm_calls(user_id, called_at DESC);
CREATE INDEX IF NOT EXISTS idx_llm_status          ON app.llm_calls(status, called_at DESC);
CREATE INDEX IF NOT EXISTS idx_llm_feature_time    ON app.llm_calls(feature_code, called_at DESC);
CREATE INDEX IF NOT EXISTS idx_mlmodels_status     ON app.ml_models(tenant_id, status);
CREATE INDEX IF NOT EXISTS idx_mlpred_model_time   ON app.ml_predictions(model_id, predicted_at DESC);
CREATE INDEX IF NOT EXISTS idx_mlpred_entity       ON app.ml_predictions(entity_type, entity_id);

-- pgvector IVFFLAT index (only if extension + column exist)
DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM pg_extension WHERE extname='vector')
     AND EXISTS (SELECT 1 FROM information_schema.columns
                  WHERE table_schema='app' AND table_name='embeddings' AND column_name='vector') THEN
    EXECUTE 'CREATE INDEX IF NOT EXISTS idx_emb_vector_cosine
             ON app.embeddings USING ivfflat (vector vector_cosine_ops) WITH (lists = 100)';
  END IF;
END $$;

-- =============== RLS + TRIGGERS ===============
SELECT core.enable_tenant_rls('app.data_warehouses');
SELECT core.enable_tenant_rls('app.etl_pipelines');
SELECT core.enable_tenant_rls('app.olap_cubes');
SELECT core.enable_tenant_rls('app.forecast_models');
SELECT core.enable_tenant_rls('app.forecast_results');
SELECT core.enable_tenant_rls('app.scenarios');
SELECT core.enable_tenant_rls('app.anomaly_detectors');
SELECT core.enable_tenant_rls('app.anomaly_events');
SELECT core.enable_tenant_rls('app.embeddings');
SELECT core.enable_tenant_rls('app.rag_queries');
SELECT core.enable_tenant_rls('app.llm_calls');
SELECT core.enable_tenant_rls('app.ml_models');
SELECT core.enable_tenant_rls('app.ml_predictions');

SELECT core.attach_standard_triggers('app.data_warehouses');
SELECT core.attach_standard_triggers('app.etl_pipelines');
SELECT core.attach_standard_triggers('app.olap_cubes');
SELECT core.attach_standard_triggers('app.forecast_models');
SELECT core.attach_standard_triggers('app.scenarios');
SELECT core.attach_standard_triggers('app.ml_models');

-- =============== FUNCTIONS ===============

-- Record an LLM call (used by app layer; auto-computes cost)
CREATE OR REPLACE FUNCTION app.record_llm_call(
  p_user_id uuid, p_feature text, p_model_code text,
  p_input_tokens int, p_output_tokens int,
  p_latency_ms int, p_status text, p_error text DEFAULT NULL,
  p_request_id text DEFAULT NULL, p_cached boolean DEFAULT false
) RETURNS uuid
LANGUAGE plpgsql AS $$
DECLARE
  v_id uuid := gen_random_uuid();
  v_model app.llm_models%ROWTYPE;
  v_cost numeric(12,6);
BEGIN
  SELECT * INTO v_model FROM app.llm_models WHERE code = p_model_code LIMIT 1;
  IF NOT FOUND THEN RAISE EXCEPTION 'llm model not found: %', p_model_code; END IF;

  v_cost := round(
    (p_input_tokens  * v_model.input_cost_per_1k_tokens
     + p_output_tokens * v_model.output_cost_per_1k_tokens) / 1000.0, 6);

  INSERT INTO app.llm_calls(id,tenant_id,user_id,feature_code,model_id,
         input_tokens,output_tokens,cost_usd,latency_ms,status,error,request_id,cached)
  VALUES (v_id, core.require_tenant(), p_user_id, p_feature, v_model.id,
          p_input_tokens, p_output_tokens, v_cost, p_latency_ms, p_status, p_error, p_request_id, p_cached);
  RETURN v_id;
END $$;

-- Top-K similar chunks (pgvector path). If pgvector absent, raises.
CREATE OR REPLACE FUNCTION app.rag_top_k(
  p_query_vec text, p_model_id uuid, p_top_k int DEFAULT 5, p_source_filter text DEFAULT NULL
) RETURNS TABLE(embedding_id uuid, source_type text, source_id uuid, chunk_text text, similarity numeric)
LANGUAGE plpgsql STABLE AS $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_extension WHERE extname='vector') THEN
    RAISE EXCEPTION 'pgvector extension required for rag_top_k';
  END IF;
  RETURN QUERY EXECUTE format(
    'SELECT id, source_type, source_id, chunk_text,
            1 - (vector <=> %L::vector) AS similarity
       FROM app.embeddings
      WHERE embedding_model_id = %L
        AND tenant_id = core.current_tenant_id()
        AND (%L IS NULL OR source_type = %L)
      ORDER BY vector <=> %L::vector
      LIMIT %s',
    p_query_vec, p_model_id, p_source_filter, p_source_filter, p_query_vec, p_top_k);
END $$;

-- =============== VIEWS ===============
CREATE OR REPLACE VIEW app.v_llm_cost_daily AS
SELECT tenant_id, feature_code,
       date_trunc('day', called_at)::date AS day,
       COUNT(*)                       AS calls,
       SUM(input_tokens + output_tokens) AS total_tokens,
       SUM(cost_usd)                   AS cost_usd,
       AVG(latency_ms)                 AS avg_latency_ms
  FROM app.llm_calls
 GROUP BY tenant_id, feature_code, day;

CREATE OR REPLACE VIEW app.v_model_drift AS
SELECT m.id AS model_id, m.code,
       date_trunc('day', p.predicted_at)::date AS day,
       COUNT(*)                        AS predictions,
       COUNT(*) FILTER (WHERE p.actual_outcome IS NOT NULL) AS with_feedback,
       AVG(p.confidence)               AS avg_confidence
  FROM app.ml_models m
  LEFT JOIN app.ml_predictions p ON p.model_id = m.id
 WHERE m.status = 'production'
 GROUP BY m.id, m.code, day;

-- =============== SEED ===============
INSERT INTO app.embedding_models(code,provider,model_name,dimensions,max_input_tokens) VALUES
  ('voyage-3',      'voyage',    'voyage-3',          1024, 16000),
  ('text-embed-3s', 'openai',    'text-embedding-3-small', 1536, 8191),
  ('text-embed-3l', 'openai',    'text-embedding-3-large', 3072, 8191),
  ('cohere-v3',     'cohere',    'embed-english-v3.0', 1024, 512)
ON CONFLICT (code) DO NOTHING;

INSERT INTO app.llm_providers(code,name) VALUES
  ('anthropic','Anthropic'),
  ('openai','OpenAI'),
  ('google','Google'),
  ('mistral','Mistral AI'),
  ('meta','Meta / Llama')
ON CONFLICT (code) DO NOTHING;

INSERT INTO app.llm_models(provider_id,code,model_family,input_cost_per_1k_tokens,output_cost_per_1k_tokens,max_context_tokens)
SELECT id,'claude-opus-4-7',    'claude-4', 0.015, 0.075, 1000000 FROM app.llm_providers WHERE code='anthropic'
ON CONFLICT (provider_id, code) DO NOTHING;
INSERT INTO app.llm_models(provider_id,code,model_family,input_cost_per_1k_tokens,output_cost_per_1k_tokens,max_context_tokens)
SELECT id,'claude-sonnet-4-6',  'claude-4', 0.003, 0.015, 1000000 FROM app.llm_providers WHERE code='anthropic'
ON CONFLICT (provider_id, code) DO NOTHING;
INSERT INTO app.llm_models(provider_id,code,model_family,input_cost_per_1k_tokens,output_cost_per_1k_tokens,max_context_tokens)
SELECT id,'claude-haiku-4-5',   'claude-4', 0.0008, 0.004, 200000 FROM app.llm_providers WHERE code='anthropic'
ON CONFLICT (provider_id, code) DO NOTHING;
