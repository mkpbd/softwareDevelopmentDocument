-- =====================================================================
-- Module 26: Reporting & Analytics (basic)
-- Covers PRD Step 26
-- =====================================================================

SET search_path = app, core, public;

-- =============== SCHEMA ===============

CREATE TABLE IF NOT EXISTS app.dashboards (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  code            citext NOT NULL,
  name            text NOT NULL,
  description     text,
  owner_user_id   uuid REFERENCES app.users(id),
  is_shared       boolean NOT NULL DEFAULT false,
  layout          jsonb NOT NULL DEFAULT '{}'::jsonb,
  created_at      timestamptz NOT NULL DEFAULT now(),
  updated_at      timestamptz NOT NULL DEFAULT now(),
  created_by      uuid, updated_by uuid, version int NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, code)
);

CREATE TABLE IF NOT EXISTS app.dashboard_widgets (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  dashboard_id    uuid NOT NULL REFERENCES app.dashboards(id) ON DELETE CASCADE,
  widget_type     text NOT NULL CHECK (widget_type IN ('kpi','chart_line','chart_bar','chart_pie','table','gauge','text')),
  title           text NOT NULL,
  config          jsonb NOT NULL DEFAULT '{}'::jsonb,
  query_id        uuid,
  position        jsonb NOT NULL DEFAULT '{}'::jsonb,
  created_at      timestamptz NOT NULL DEFAULT now(),
  updated_at      timestamptz NOT NULL DEFAULT now(),
  created_by      uuid, updated_by uuid, version int NOT NULL DEFAULT 1
);

CREATE TABLE IF NOT EXISTS app.report_definitions (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  code            citext NOT NULL,
  name            text NOT NULL,
  category        text,
  report_type     text NOT NULL CHECK (report_type IN ('tabular','pivot','chart','summary','custom')),
  sql_text        text,
  params          jsonb NOT NULL DEFAULT '[]'::jsonb,
  output_columns  jsonb,
  access_scope    text NOT NULL DEFAULT 'tenant' CHECK (access_scope IN ('private','tenant','role')),
  access_roles    text[],
  created_at      timestamptz NOT NULL DEFAULT now(),
  updated_at      timestamptz NOT NULL DEFAULT now(),
  created_by      uuid, updated_by uuid, version int NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, code)
);

CREATE TABLE IF NOT EXISTS app.scheduled_reports (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  report_id       uuid NOT NULL REFERENCES app.report_definitions(id) ON DELETE CASCADE,
  cron_expr       text NOT NULL,
  recipients      text[] NOT NULL,
  format          text NOT NULL DEFAULT 'pdf' CHECK (format IN ('pdf','csv','xlsx')),
  params          jsonb NOT NULL DEFAULT '{}'::jsonb,
  active          boolean NOT NULL DEFAULT true,
  last_run_at     timestamptz,
  next_run_at     timestamptz,
  created_at      timestamptz NOT NULL DEFAULT now(),
  updated_at      timestamptz NOT NULL DEFAULT now(),
  created_by      uuid, updated_by uuid, version int NOT NULL DEFAULT 1
);

CREATE TABLE IF NOT EXISTS app.kpi_definitions (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  code            citext NOT NULL,
  name            text NOT NULL,
  formula         text NOT NULL,             -- SQL expression
  unit            text,
  target_direction char(1) CHECK (target_direction IN ('H','L')),  -- Higher/Lower is better
  target_value    numeric(19,4),
  created_at      timestamptz NOT NULL DEFAULT now(),
  updated_at      timestamptz NOT NULL DEFAULT now(),
  created_by      uuid, updated_by uuid, version int NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, code)
);

CREATE TABLE IF NOT EXISTS app.kpi_snapshots (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  kpi_id          uuid NOT NULL REFERENCES app.kpi_definitions(id) ON DELETE CASCADE,
  snapshot_at     timestamptz NOT NULL DEFAULT now(),
  period          text,
  actual_value    numeric(19,4) NOT NULL,
  target_value    numeric(19,4),
  variance        numeric(19,4),
  metadata        jsonb
);

-- =============== INDEXES ===============
CREATE INDEX IF NOT EXISTS idx_dashboards_tenant   ON app.dashboards(tenant_id);
CREATE INDEX IF NOT EXISTS idx_dw_dashboard        ON app.dashboard_widgets(dashboard_id);
CREATE INDEX IF NOT EXISTS idx_reportdef_tenant    ON app.report_definitions(tenant_id, category);
CREATE INDEX IF NOT EXISTS idx_schedrep_next       ON app.scheduled_reports(next_run_at) WHERE active;
CREATE INDEX IF NOT EXISTS idx_kpi_snap_kpi_time   ON app.kpi_snapshots(kpi_id, snapshot_at DESC);

-- =============== RLS ===============
SELECT core.enable_tenant_rls('app.dashboards');
SELECT core.enable_tenant_rls('app.dashboard_widgets');
SELECT core.enable_tenant_rls('app.report_definitions');
SELECT core.enable_tenant_rls('app.scheduled_reports');
SELECT core.enable_tenant_rls('app.kpi_definitions');
SELECT core.enable_tenant_rls('app.kpi_snapshots');

-- =============== TRIGGERS ===============
SELECT core.attach_standard_triggers('app.dashboards');
SELECT core.attach_standard_triggers('app.dashboard_widgets');
SELECT core.attach_standard_triggers('app.report_definitions');
SELECT core.attach_standard_triggers('app.scheduled_reports');
SELECT core.attach_standard_triggers('app.kpi_definitions');

-- =============== MATERIALIZED VIEWS (heavy aggregates) ===============
CREATE MATERIALIZED VIEW IF NOT EXISTS app.mv_monthly_sales AS
SELECT si.tenant_id, si.company_id,
       date_trunc('month', si.invoice_date)::date AS period,
       COUNT(*)                                   AS invoice_count,
       SUM(si.grand_total)                         AS gross_sales,
       SUM(si.taxable_amount)                      AS net_sales,
       SUM(si.cgst_total + si.sgst_total + si.igst_total) AS tax_total
  FROM app.sales_invoices si
 WHERE si.status IN ('posted','partial_paid','paid')
 GROUP BY 1,2,3
WITH NO DATA;

CREATE UNIQUE INDEX IF NOT EXISTS ux_mv_monthly_sales
  ON app.mv_monthly_sales(tenant_id, company_id, period);

CREATE MATERIALIZED VIEW IF NOT EXISTS app.mv_top_customers AS
SELECT si.tenant_id, si.customer_id,
       SUM(si.grand_total) AS revenue,
       COUNT(*)            AS invoice_count,
       MAX(si.invoice_date) AS last_invoice_date
  FROM app.sales_invoices si
 WHERE si.status IN ('posted','partial_paid','paid')
   AND si.invoice_date >= CURRENT_DATE - interval '365 days'
 GROUP BY si.tenant_id, si.customer_id
WITH NO DATA;

CREATE UNIQUE INDEX IF NOT EXISTS ux_mv_top_customers
  ON app.mv_top_customers(tenant_id, customer_id);

CREATE OR REPLACE FUNCTION app.refresh_reporting_mvs()
RETURNS void
LANGUAGE plpgsql AS $$
BEGIN
  REFRESH MATERIALIZED VIEW CONCURRENTLY app.mv_monthly_sales;
  REFRESH MATERIALIZED VIEW CONCURRENTLY app.mv_top_customers;
END $$;

-- =============== VIEWS ===============
CREATE OR REPLACE VIEW app.v_executive_snapshot AS
SELECT
  (SELECT tenant_id FROM app.users WHERE id = core.current_user_id() LIMIT 1) AS tenant_id,
  (SELECT COALESCE(SUM(grand_total),0) FROM app.sales_invoices
    WHERE invoice_date >= date_trunc('month', CURRENT_DATE) AND status <> 'cancelled')    AS mtd_sales,
  (SELECT COALESCE(SUM(grand_total),0) FROM app.supplier_invoices
    WHERE bill_date >= date_trunc('month', CURRENT_DATE) AND status <> 'cancelled')       AS mtd_purchases,
  (SELECT COALESCE(SUM(amount_due),0) FROM app.sales_invoices WHERE amount_due > 0)        AS ar_open,
  (SELECT COALESCE(SUM(amount_due),0) FROM app.supplier_invoices WHERE amount_due > 0)     AS ap_open,
  (SELECT COUNT(*) FROM app.v_reorder_alerts)                                              AS reorder_alerts;
