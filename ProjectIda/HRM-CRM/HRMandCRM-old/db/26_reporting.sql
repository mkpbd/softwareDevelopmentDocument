-- =====================================================================
-- STEP 26: Reporting & Analytics
-- =====================================================================

CREATE TABLE reporting.dashboard (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    code            TEXT NOT NULL,
    name            TEXT NOT NULL,
    description     TEXT,
    owner_user_id   UUID,
    is_shared       BOOLEAN DEFAULT FALSE,
    is_default      BOOLEAN DEFAULT FALSE,
    layout          JSONB,
    filters         JSONB,
    created_at      TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE (tenant_id, code)
);

CREATE TABLE reporting.widget (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    dashboard_id    UUID NOT NULL REFERENCES reporting.dashboard(id) ON DELETE CASCADE,
    widget_type     TEXT CHECK (widget_type IN ('chart','table','kpi','pivot','gauge','map','list','text','iframe')),
    title           TEXT,
    query_id        UUID,
    config          JSONB,
    position        JSONB,                        -- {x,y,w,h}
    refresh_interval_sec INT
);

CREATE TABLE reporting.report_template (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    code            TEXT NOT NULL,
    name            TEXT NOT NULL,
    category        TEXT,
    report_type     TEXT,
    query_sql       TEXT,
    parameters      JSONB,
    columns         JSONB,
    chart_config    JSONB,
    is_system       BOOLEAN DEFAULT FALSE,
    is_active       BOOLEAN DEFAULT TRUE,
    UNIQUE (tenant_id, code)
);

CREATE TABLE reporting.custom_report (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    owner_user_id   UUID,
    name            TEXT NOT NULL,
    entity_type     TEXT,
    definition      JSONB NOT NULL,               -- no-code builder definition
    is_shared       BOOLEAN DEFAULT FALSE,
    created_at      TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE reporting.scheduled_report (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    report_id       UUID,
    cron_expression TEXT NOT NULL,
    output_format   TEXT CHECK (output_format IN ('pdf','xlsx','csv','html','json')),
    recipients      JSONB,
    last_run_at     TIMESTAMPTZ,
    next_run_at     TIMESTAMPTZ,
    is_active       BOOLEAN DEFAULT TRUE
);

CREATE TABLE reporting.report_run (
    id              BIGSERIAL PRIMARY KEY,
    report_id       UUID,
    scheduled_id    UUID,
    run_at          TIMESTAMPTZ DEFAULT NOW(),
    run_by          UUID,
    parameters      JSONB,
    output_key      TEXT,
    row_count       INT,
    status          TEXT,
    duration_ms     INT,
    error           TEXT
);

CREATE TABLE reporting.kpi (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    code            TEXT NOT NULL,
    name            TEXT NOT NULL,
    formula         TEXT NOT NULL,
    uom             TEXT,
    target_value    NUMERIC,
    threshold_green NUMERIC,
    threshold_amber NUMERIC,
    threshold_red   NUMERIC,
    direction       TEXT CHECK (direction IN ('higher_better','lower_better')),
    UNIQUE (tenant_id, code)
);

CREATE TABLE reporting.kpi_snapshot (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    kpi_id          UUID NOT NULL REFERENCES reporting.kpi(id),
    period_date     DATE NOT NULL,
    value           NUMERIC,
    status          TEXT,
    created_at      TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE (kpi_id, period_date)
);

CREATE TABLE reporting.alert_rule (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    name            TEXT NOT NULL,
    entity_type     TEXT,
    condition       JSONB,
    threshold       NUMERIC,
    channel         TEXT[],
    recipients      JSONB,
    is_active       BOOLEAN DEFAULT TRUE
);

CREATE TABLE reporting.alert_event (
    id              BIGSERIAL PRIMARY KEY,
    alert_rule_id   UUID NOT NULL REFERENCES reporting.alert_rule(id),
    triggered_at    TIMESTAMPTZ DEFAULT NOW(),
    value           NUMERIC,
    payload         JSONB,
    status          TEXT DEFAULT 'open',
    resolved_at     TIMESTAMPTZ
);

-- =====================================================================
-- INDEXES
-- =====================================================================
CREATE INDEX idx_dashboard_owner      ON reporting.dashboard(owner_user_id);
CREATE INDEX idx_scheduled_report_due ON reporting.scheduled_report(next_run_at) WHERE is_active;
CREATE INDEX idx_kpi_snapshot_lookup  ON reporting.kpi_snapshot(kpi_id, period_date);
CREATE INDEX idx_alert_event_rule     ON reporting.alert_event(alert_rule_id, triggered_at DESC);

-- =====================================================================
-- SHARED REPORTING VIEWS (executive snapshot)
-- =====================================================================
CREATE MATERIALIZED VIEW reporting.mv_executive_summary AS
SELECT c.id AS company_id, c.legal_name,
       (SELECT SUM(total) FROM sales.sales_invoice WHERE company_id=c.id AND status='posted'
          AND doc_date >= date_trunc('month', CURRENT_DATE)) AS mtd_revenue,
       (SELECT SUM(total) FROM sales.sales_invoice WHERE company_id=c.id AND status='posted'
          AND doc_date >= date_trunc('year', CURRENT_DATE)) AS ytd_revenue,
       (SELECT COUNT(*) FROM sales.sales_invoice WHERE company_id=c.id AND payment_status IN ('unpaid','partial')) AS open_invoices,
       (SELECT SUM(balance_amount) FROM sales.sales_invoice WHERE company_id=c.id AND payment_status IN ('unpaid','partial')) AS ar_outstanding,
       (SELECT COUNT(*) FROM hr.employee WHERE company_id=c.id AND employment_status='active' AND deleted_at IS NULL) AS active_employees
  FROM core.company c;
CREATE UNIQUE INDEX ON reporting.mv_executive_summary(company_id);

-- Refresh helper
CREATE OR REPLACE FUNCTION reporting.fn_refresh_mv(p_mv TEXT)
RETURNS VOID AS $$
BEGIN
    EXECUTE format('REFRESH MATERIALIZED VIEW CONCURRENTLY %I', p_mv);
END; $$ LANGUAGE plpgsql;
