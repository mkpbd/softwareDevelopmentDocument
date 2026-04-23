-- =====================================================================
-- Module 10: Planning (Demand, Supply, MRP, Capacity, S&OP, DRP)
-- =====================================================================

SET search_path = app, core, public;

-- =============== SCHEMA ===============

CREATE TABLE IF NOT EXISTS app.demand_forecasts (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  company_id      uuid NOT NULL REFERENCES app.companies(id),
  item_id         uuid NOT NULL,
  warehouse_id    uuid REFERENCES app.warehouses(id),
  forecast_date   date NOT NULL,
  period_type     text NOT NULL CHECK (period_type IN ('daily','weekly','monthly','quarterly')),
  qty             numeric(19,6) NOT NULL,
  method          text NOT NULL DEFAULT 'manual' CHECK (method IN ('manual','moving_avg','exponential','regression','ml')),
  confidence_pct  numeric(5,2),
  source          text,
  created_at      timestamptz NOT NULL DEFAULT now(),
  updated_at      timestamptz NOT NULL DEFAULT now(),
  created_by      uuid, updated_by uuid, version int NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, item_id, warehouse_id, forecast_date, period_type)
);

CREATE TABLE IF NOT EXISTS app.supply_plans (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  company_id      uuid NOT NULL REFERENCES app.companies(id),
  item_id         uuid NOT NULL,
  warehouse_id    uuid,
  plan_date       date NOT NULL,
  source_type     text NOT NULL CHECK (source_type IN ('purchase','manufacture','transfer')),
  qty             numeric(19,6) NOT NULL,
  supplier_id     uuid,
  status          text NOT NULL DEFAULT 'proposed'
                  CHECK (status IN ('proposed','approved','released','cancelled')),
  created_at      timestamptz NOT NULL DEFAULT now(),
  updated_at      timestamptz NOT NULL DEFAULT now(),
  created_by      uuid, updated_by uuid, version int NOT NULL DEFAULT 1
);

CREATE TABLE IF NOT EXISTS app.mrp_runs (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  company_id      uuid NOT NULL REFERENCES app.companies(id),
  run_number      text NOT NULL,
  planning_horizon_days int NOT NULL DEFAULT 90,
  status          text NOT NULL DEFAULT 'running'
                  CHECK (status IN ('running','completed','failed','cancelled')),
  items_considered int,
  suggestions_created int,
  started_at      timestamptz NOT NULL DEFAULT now(),
  completed_at    timestamptz,
  error           text,
  created_by      uuid,
  UNIQUE (tenant_id, company_id, run_number)
);

CREATE TABLE IF NOT EXISTS app.mrp_suggestions (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  mrp_run_id      uuid NOT NULL REFERENCES app.mrp_runs(id) ON DELETE CASCADE,
  item_id         uuid NOT NULL,
  warehouse_id    uuid,
  action          text NOT NULL CHECK (action IN ('purchase','produce','transfer','expedite','postpone')),
  qty             numeric(19,6) NOT NULL,
  needed_by       date NOT NULL,
  supplier_id     uuid,
  source_document_type text,
  source_document_id   uuid,
  status          text NOT NULL DEFAULT 'pending'
                  CHECK (status IN ('pending','accepted','converted','rejected','ignored')),
  converted_to    text,
  converted_id    uuid,
  created_at      timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS app.capacity_plans (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  work_center_id  uuid NOT NULL REFERENCES app.work_centers(id),
  plan_date       date NOT NULL,
  available_hours numeric(9,2) NOT NULL,
  loaded_hours    numeric(9,2) NOT NULL DEFAULT 0,
  utilization_pct numeric(5,2),
  UNIQUE (tenant_id, work_center_id, plan_date)
);

CREATE TABLE IF NOT EXISTS app.sop_scenarios (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  company_id      uuid NOT NULL REFERENCES app.companies(id),
  scenario_name   text NOT NULL,
  period_start    date NOT NULL,
  period_end      date NOT NULL,
  assumptions     jsonb NOT NULL DEFAULT '{}'::jsonb,
  status          text NOT NULL DEFAULT 'draft' CHECK (status IN ('draft','approved','rejected','archived')),
  created_at      timestamptz NOT NULL DEFAULT now(),
  updated_at      timestamptz NOT NULL DEFAULT now(),
  created_by      uuid, updated_by uuid, version int NOT NULL DEFAULT 1
);

-- =============== INDEXES ===============
CREATE INDEX IF NOT EXISTS idx_df_item_date     ON app.demand_forecasts(tenant_id, item_id, forecast_date DESC);
CREATE INDEX IF NOT EXISTS idx_sp_item_date     ON app.supply_plans(tenant_id, item_id, plan_date DESC);
CREATE INDEX IF NOT EXISTS idx_mrp_run_status   ON app.mrp_runs(tenant_id, status, started_at DESC);
CREATE INDEX IF NOT EXISTS idx_mrp_sugg_status  ON app.mrp_suggestions(tenant_id, status, needed_by);
CREATE INDEX IF NOT EXISTS idx_mrp_sugg_item    ON app.mrp_suggestions(item_id, needed_by);
CREATE INDEX IF NOT EXISTS idx_cap_wc_date      ON app.capacity_plans(work_center_id, plan_date);

-- =============== RLS + TRIGGERS ===============
SELECT core.enable_tenant_rls('app.demand_forecasts');
SELECT core.enable_tenant_rls('app.supply_plans');
SELECT core.enable_tenant_rls('app.mrp_runs');
SELECT core.enable_tenant_rls('app.mrp_suggestions');
SELECT core.enable_tenant_rls('app.capacity_plans');
SELECT core.enable_tenant_rls('app.sop_scenarios');

SELECT core.attach_standard_triggers('app.demand_forecasts');
SELECT core.attach_standard_triggers('app.supply_plans');
SELECT core.attach_standard_triggers('app.sop_scenarios');

-- =============== FUNCTIONS ===============

-- Simple MRP: net-requirements = gross - on_hand - on_order
CREATE OR REPLACE FUNCTION app.mrp_net_requirement(
  p_item_id uuid, p_by_date date
) RETURNS numeric
LANGUAGE sql STABLE AS $$
  WITH d AS (
    SELECT COALESCE(SUM(qty),0) AS gross
      FROM app.demand_forecasts
     WHERE item_id = p_item_id AND forecast_date <= p_by_date
  ), h AS (
    SELECT COALESCE(SUM(qty_on_hand - qty_reserved),0) AS on_hand
      FROM app.stock_balances WHERE item_id = p_item_id
  ), o AS (
    SELECT COALESCE(SUM(qty_ordered - qty_received),0) AS on_order
      FROM app.po_lines WHERE item_id = p_item_id
  )
  SELECT GREATEST(0, d.gross - h.on_hand - o.on_order) FROM d, h, o
$$;

-- Simple MRP run (creates suggestions)
CREATE OR REPLACE PROCEDURE app.run_mrp(p_company_id uuid, p_horizon_days int DEFAULT 90)
LANGUAGE plpgsql AS $$
DECLARE
  v_run uuid := gen_random_uuid();
  v_items int := 0;
  v_suggs int := 0;
  r record;
  v_net numeric;
BEGIN
  INSERT INTO app.mrp_runs(id,tenant_id,company_id,run_number,planning_horizon_days,created_by)
  VALUES (v_run, core.require_tenant(), p_company_id, core.next_doc_number('MRP'),
          p_horizon_days, core.current_user_id());

  FOR r IN
    SELECT id, code FROM app.items
     WHERE company_id = p_company_id AND active AND maintain_stock
  LOOP
    v_items := v_items + 1;
    v_net := app.mrp_net_requirement(r.id, CURRENT_DATE + p_horizon_days);
    IF v_net > 0 THEN
      INSERT INTO app.mrp_suggestions(tenant_id, mrp_run_id, item_id, action, qty, needed_by)
      VALUES (core.require_tenant(), v_run, r.id, 'purchase', v_net,
              CURRENT_DATE + LEAST(p_horizon_days, 30));
      v_suggs := v_suggs + 1;
    END IF;
  END LOOP;

  UPDATE app.mrp_runs
     SET status='completed', completed_at=now(),
         items_considered = v_items, suggestions_created = v_suggs
   WHERE id = v_run;
END $$;

-- =============== VIEWS ===============
CREATE OR REPLACE VIEW app.v_capacity_utilization AS
SELECT work_center_id, plan_date, available_hours, loaded_hours,
       round(loaded_hours / NULLIF(available_hours,0) * 100, 2) AS utilization_pct
  FROM app.capacity_plans;
