-- =====================================================================
-- Module 29: Performance & Observability (baseline)
-- Covers PRD Step 29
-- =====================================================================

SET search_path = app, core, ops, public;

-- =============== SCHEMA ===============

CREATE TABLE IF NOT EXISTS ops.system_events (
  id              bigserial PRIMARY KEY,
  tenant_id       uuid,
  service_name    text NOT NULL,
  event_type      text NOT NULL,
  severity        text NOT NULL CHECK (severity IN ('debug','info','warn','error','fatal')),
  message         text NOT NULL,
  metadata        jsonb,
  occurred_at     timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS ops.error_log (
  id              bigserial PRIMARY KEY,
  tenant_id       uuid,
  user_id         uuid,
  service_name    text NOT NULL,
  error_code      text,
  error_message   text NOT NULL,
  stack_trace     text,
  request_id      text,
  correlation_id  text,
  context         jsonb,
  occurred_at     timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS ops.performance_metrics (
  id              bigserial,
  service_name    text NOT NULL,
  metric_name     text NOT NULL,
  metric_value    numeric NOT NULL,
  tags            jsonb NOT NULL DEFAULT '{}'::jsonb,
  recorded_at     timestamptz NOT NULL DEFAULT now(),
  PRIMARY KEY (id, recorded_at)
) PARTITION BY RANGE (recorded_at);

CREATE TABLE IF NOT EXISTS ops.performance_metrics_2026 PARTITION OF ops.performance_metrics
  FOR VALUES FROM ('2026-01-01') TO ('2027-01-01');
CREATE TABLE IF NOT EXISTS ops.performance_metrics_default PARTITION OF ops.performance_metrics DEFAULT;

CREATE TABLE IF NOT EXISTS ops.api_access_log (
  id              bigserial,
  tenant_id       uuid,
  user_id         uuid,
  request_id      text,
  method          text NOT NULL,
  path            text NOT NULL,
  status_code     int NOT NULL,
  latency_ms      int NOT NULL,
  ip_address      inet,
  user_agent      text,
  request_size    int,
  response_size   int,
  occurred_at     timestamptz NOT NULL DEFAULT now(),
  PRIMARY KEY (id, occurred_at)
) PARTITION BY RANGE (occurred_at);

CREATE TABLE IF NOT EXISTS ops.api_access_log_2026 PARTITION OF ops.api_access_log
  FOR VALUES FROM ('2026-01-01') TO ('2027-01-01');
CREATE TABLE IF NOT EXISTS ops.api_access_log_default PARTITION OF ops.api_access_log DEFAULT;

CREATE TABLE IF NOT EXISTS ops.health_checks (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  component       text NOT NULL,
  status          text NOT NULL CHECK (status IN ('healthy','degraded','unhealthy','unknown')),
  checked_at      timestamptz NOT NULL DEFAULT now(),
  latency_ms      int,
  details         jsonb
);

CREATE TABLE IF NOT EXISTS ops.alerts (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  alert_code      text NOT NULL,
  severity        text NOT NULL CHECK (severity IN ('info','warning','error','critical')),
  summary         text NOT NULL,
  details         jsonb,
  status          text NOT NULL DEFAULT 'firing' CHECK (status IN ('firing','acknowledged','resolved')),
  first_seen_at   timestamptz NOT NULL DEFAULT now(),
  last_seen_at    timestamptz NOT NULL DEFAULT now(),
  resolved_at     timestamptz,
  assigned_to     uuid REFERENCES app.users(id)
);

-- =============== INDEXES ===============
CREATE INDEX IF NOT EXISTS idx_sysevents_tenant_time ON ops.system_events(tenant_id, occurred_at DESC);
CREATE INDEX IF NOT EXISTS idx_sysevents_severity    ON ops.system_events(severity, occurred_at DESC) WHERE severity IN ('error','fatal');
CREATE INDEX IF NOT EXISTS idx_errlog_tenant_time    ON ops.error_log(tenant_id, occurred_at DESC);
CREATE INDEX IF NOT EXISTS idx_errlog_corr           ON ops.error_log(correlation_id) WHERE correlation_id IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_perf_service_metric   ON ops.performance_metrics(service_name, metric_name, recorded_at DESC);
CREATE INDEX IF NOT EXISTS idx_api_tenant_time       ON ops.api_access_log(tenant_id, occurred_at DESC);
CREATE INDEX IF NOT EXISTS idx_api_path_time         ON ops.api_access_log(path, occurred_at DESC);
CREATE INDEX IF NOT EXISTS idx_api_slow              ON ops.api_access_log(latency_ms) WHERE latency_ms > 1000;
CREATE INDEX IF NOT EXISTS idx_alerts_firing         ON ops.alerts(status, severity) WHERE status = 'firing';

-- =============== FUNCTIONS ===============

-- Compute p50/p95/p99 latency by endpoint
CREATE OR REPLACE FUNCTION ops.api_latency_percentiles(p_since interval DEFAULT interval '1 hour')
RETURNS TABLE(path text, req_count bigint, p50 numeric, p95 numeric, p99 numeric)
LANGUAGE sql STABLE AS $$
  SELECT path, COUNT(*)::bigint,
         percentile_cont(0.5)  WITHIN GROUP (ORDER BY latency_ms)::numeric,
         percentile_cont(0.95) WITHIN GROUP (ORDER BY latency_ms)::numeric,
         percentile_cont(0.99) WITHIN GROUP (ORDER BY latency_ms)::numeric
    FROM ops.api_access_log
   WHERE occurred_at >= now() - p_since
   GROUP BY path
   ORDER BY p95 DESC
$$;

-- Error rate by service
CREATE OR REPLACE FUNCTION ops.error_rate(p_since interval DEFAULT interval '1 hour')
RETURNS TABLE(service text, total bigint, errors bigint, error_rate numeric)
LANGUAGE sql STABLE AS $$
  SELECT service_name, COUNT(*)::bigint,
         COUNT(*) FILTER (WHERE severity IN ('error','fatal'))::bigint,
         round(COUNT(*) FILTER (WHERE severity IN ('error','fatal'))::numeric
               / NULLIF(COUNT(*),0) * 100, 4)
    FROM ops.system_events
   WHERE occurred_at >= now() - p_since
   GROUP BY service_name
$$;

-- Fire/update an alert
CREATE OR REPLACE FUNCTION ops.fire_alert(
  p_code text, p_severity text, p_summary text, p_details jsonb DEFAULT NULL
) RETURNS uuid
LANGUAGE plpgsql AS $$
DECLARE v_id uuid;
BEGIN
  UPDATE ops.alerts
     SET last_seen_at = now(),
         severity     = GREATEST(severity, p_severity),
         details      = p_details
   WHERE alert_code = p_code AND status = 'firing'
   RETURNING id INTO v_id;

  IF v_id IS NULL THEN
    INSERT INTO ops.alerts(alert_code, severity, summary, details)
    VALUES (p_code, p_severity, p_summary, p_details)
    RETURNING id INTO v_id;
  END IF;
  RETURN v_id;
END $$;

-- =============== VIEWS ===============
CREATE OR REPLACE VIEW ops.v_slow_queries AS
SELECT path, COUNT(*) slow_count, AVG(latency_ms) avg_latency
  FROM ops.api_access_log
 WHERE occurred_at >= now() - interval '1 hour' AND latency_ms > 1000
 GROUP BY path ORDER BY slow_count DESC;

CREATE OR REPLACE VIEW ops.v_errors_24h AS
SELECT service_name, COUNT(*) AS error_count
  FROM ops.error_log
 WHERE occurred_at >= now() - interval '24 hours'
 GROUP BY service_name ORDER BY error_count DESC;

CREATE OR REPLACE VIEW ops.v_alerts_open AS
SELECT id, alert_code, severity, summary, first_seen_at, last_seen_at,
       EXTRACT(EPOCH FROM (now() - first_seen_at))/60 AS age_minutes
  FROM ops.alerts WHERE status = 'firing'
 ORDER BY severity DESC, first_seen_at;
