-- =====================================================================
-- STEP 10: Planning (Demand / Supply / MRP / S&OP / DRP)
-- =====================================================================

CREATE TABLE planning.forecast (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    company_id      UUID NOT NULL,
    name            TEXT NOT NULL,
    forecast_type   TEXT CHECK (forecast_type IN ('demand','supply','sales','cash')),
    method          TEXT CHECK (method IN ('moving_avg','exp_smooth','holt_winters','arima','ml','manual')),
    granularity     TEXT CHECK (granularity IN ('day','week','month','quarter','year')),
    horizon_periods INT NOT NULL,
    start_date      DATE NOT NULL,
    created_by      UUID,
    created_at      TIMESTAMPTZ DEFAULT NOW(),
    status          TEXT DEFAULT 'draft'
);

CREATE TABLE planning.forecast_line (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    forecast_id     UUID NOT NULL REFERENCES planning.forecast(id) ON DELETE CASCADE,
    item_id         UUID REFERENCES inventory.item(id),
    warehouse_id    UUID REFERENCES inventory.warehouse(id),
    territory_id    UUID,
    period_start    DATE NOT NULL,
    period_end      DATE NOT NULL,
    forecast_qty    core.qty_amt,
    forecast_amount core.money_amt,
    actual_qty      core.qty_amt,
    actual_amount   core.money_amt,
    UNIQUE (forecast_id, item_id, warehouse_id, period_start)
);

CREATE TABLE planning.mrp_run (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    company_id      UUID NOT NULL,
    run_date        TIMESTAMPTZ DEFAULT NOW(),
    horizon_days    INT NOT NULL,
    run_type        TEXT CHECK (run_type IN ('regenerative','net_change')),
    status          TEXT DEFAULT 'running',
    completed_at    TIMESTAMPTZ,
    triggered_by    UUID,
    parameters      JSONB
);

CREATE TABLE planning.mrp_requirement (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    mrp_run_id      UUID NOT NULL REFERENCES planning.mrp_run(id) ON DELETE CASCADE,
    item_id         UUID NOT NULL REFERENCES inventory.item(id),
    warehouse_id    UUID REFERENCES inventory.warehouse(id),
    required_date   DATE NOT NULL,
    gross_requirement core.qty_amt,
    scheduled_receipt core.qty_amt,
    projected_available core.qty_amt,
    net_requirement core.qty_amt,
    planned_order_release_date DATE,
    planned_order_qty core.qty_amt,
    source_doc_type TEXT,
    source_doc_id   UUID,
    action          TEXT CHECK (action IN ('create_po','create_wo','transfer','no_action','expedite','delay'))
);

CREATE TABLE planning.capacity_plan (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    work_center_id  UUID REFERENCES manufacturing.work_center(id),
    period_date     DATE NOT NULL,
    available_hours NUMERIC(10,2),
    required_hours  NUMERIC(10,2),
    utilization_pct NUMERIC(5,2) GENERATED ALWAYS AS (
        CASE WHEN available_hours > 0 THEN required_hours/available_hours*100 ELSE 0 END
    ) STORED,
    UNIQUE (work_center_id, period_date)
);

CREATE TABLE planning.sop_scenario (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    company_id      UUID NOT NULL,
    name            TEXT NOT NULL,
    description     TEXT,
    parameters      JSONB,
    created_by      UUID,
    created_at      TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE planning.distribution_plan (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    item_id         UUID NOT NULL,
    from_warehouse_id UUID NOT NULL REFERENCES inventory.warehouse(id),
    to_warehouse_id UUID NOT NULL REFERENCES inventory.warehouse(id),
    period_date     DATE NOT NULL,
    planned_qty     core.qty_amt NOT NULL,
    executed_qty    core.qty_amt DEFAULT 0,
    status          TEXT DEFAULT 'planned'
);

-- =====================================================================
-- INDEXES
-- =====================================================================
CREATE INDEX idx_forecast_line_item    ON planning.forecast_line(item_id, period_start);
CREATE INDEX idx_mrp_req_item_date     ON planning.mrp_requirement(item_id, required_date);
CREATE INDEX idx_capacity_plan_wc_date ON planning.capacity_plan(work_center_id, period_date);

-- =====================================================================
-- FUNCTIONS
-- =====================================================================

-- Simple demand calculation from SO + forecast
CREATE OR REPLACE FUNCTION planning.fn_gross_demand(p_item UUID, p_from DATE, p_to DATE)
RETURNS core.qty_amt AS $$
DECLARE v_demand core.qty_amt := 0;
BEGIN
    SELECT COALESCE(SUM(sol.qty - sol.delivered_qty),0) INTO v_demand
      FROM sales.sales_order_line sol
      JOIN sales.sales_order so ON so.id = sol.sales_order_id
     WHERE sol.item_id = p_item AND so.status NOT IN ('closed','cancelled')
       AND so.delivery_date BETWEEN p_from AND p_to;
    RETURN v_demand;
END;
$$ LANGUAGE plpgsql STABLE;

-- =====================================================================
-- VIEWS
-- =====================================================================
CREATE OR REPLACE VIEW planning.v_forecast_vs_actual AS
SELECT forecast_id, item_id, period_start, forecast_qty, actual_qty,
       actual_qty - forecast_qty AS variance,
       (actual_qty - forecast_qty) / NULLIF(forecast_qty,0) * 100 AS variance_pct
  FROM planning.forecast_line WHERE actual_qty IS NOT NULL;
