-- =====================================================================
-- Module 08: Manufacturing / Production
-- Covers PRD Step 8 — BOM, routing, work orders, shop floor, subcontract
-- =====================================================================

SET search_path = app, core, public;

-- =============== SCHEMA ===============

CREATE TABLE IF NOT EXISTS app.work_centers (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  company_id      uuid NOT NULL REFERENCES app.companies(id),
  code            citext NOT NULL,
  name            text NOT NULL,
  center_type     text NOT NULL CHECK (center_type IN ('machine','workstation','assembly','inspection','packing')),
  warehouse_id    uuid REFERENCES app.warehouses(id),
  cost_per_hour   numeric(19,4) NOT NULL DEFAULT 0,
  capacity_per_day numeric(19,4),
  active          boolean NOT NULL DEFAULT true,
  created_at      timestamptz NOT NULL DEFAULT now(),
  updated_at      timestamptz NOT NULL DEFAULT now(),
  created_by      uuid, updated_by uuid, version int NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, company_id, code)
);

CREATE TABLE IF NOT EXISTS app.boms (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  company_id      uuid NOT NULL REFERENCES app.companies(id),
  item_id         uuid NOT NULL,
  bom_code        citext NOT NULL,
  version_no      smallint NOT NULL DEFAULT 1,
  bom_type        text NOT NULL DEFAULT 'production'
                  CHECK (bom_type IN ('production','engineering','phantom','alternate')),
  default_qty     numeric(19,6) NOT NULL DEFAULT 1,
  uom_code        text NOT NULL,
  status          text NOT NULL DEFAULT 'draft'
                  CHECK (status IN ('draft','active','superseded','obsolete')),
  effective_from  date,
  effective_to    date,
  routing_id      uuid,
  is_default      boolean NOT NULL DEFAULT false,
  notes           text,
  created_at      timestamptz NOT NULL DEFAULT now(),
  updated_at      timestamptz NOT NULL DEFAULT now(),
  created_by      uuid, updated_by uuid, version int NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, item_id, bom_code, version_no)
);

CREATE TABLE IF NOT EXISTS app.bom_lines (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  bom_id          uuid NOT NULL REFERENCES app.boms(id) ON DELETE CASCADE,
  line_no         smallint NOT NULL,
  component_item_id uuid NOT NULL,
  qty_per         numeric(19,6) NOT NULL CHECK (qty_per > 0),
  uom_code        text NOT NULL,
  scrap_percent   numeric(5,2) NOT NULL DEFAULT 0,
  operation_no    smallint,
  is_phantom      boolean NOT NULL DEFAULT false,
  alternate_item_id uuid,
  source_warehouse_id uuid REFERENCES app.warehouses(id),
  created_at      timestamptz NOT NULL DEFAULT now(),
  updated_at      timestamptz NOT NULL DEFAULT now(),
  created_by      uuid, updated_by uuid, version int NOT NULL DEFAULT 1,
  UNIQUE (bom_id, line_no)
);

CREATE TABLE IF NOT EXISTS app.routings (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  company_id      uuid NOT NULL REFERENCES app.companies(id),
  code            citext NOT NULL,
  name            text NOT NULL,
  active          boolean NOT NULL DEFAULT true,
  created_at      timestamptz NOT NULL DEFAULT now(),
  updated_at      timestamptz NOT NULL DEFAULT now(),
  created_by      uuid, updated_by uuid, version int NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, company_id, code)
);

CREATE TABLE IF NOT EXISTS app.routing_operations (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  routing_id      uuid NOT NULL REFERENCES app.routings(id) ON DELETE CASCADE,
  operation_no    smallint NOT NULL,
  name            text NOT NULL,
  work_center_id  uuid NOT NULL REFERENCES app.work_centers(id),
  setup_time_min  numeric(9,2) NOT NULL DEFAULT 0,
  run_time_per_unit_min numeric(9,4) NOT NULL DEFAULT 0,
  description     text,
  UNIQUE (routing_id, operation_no)
);

ALTER TABLE app.boms ADD CONSTRAINT fk_bom_routing
  FOREIGN KEY (routing_id) REFERENCES app.routings(id);

CREATE TABLE IF NOT EXISTS app.work_orders (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  company_id      uuid NOT NULL REFERENCES app.companies(id),
  wo_number       text NOT NULL,
  wo_date         date NOT NULL,
  item_id         uuid NOT NULL,
  bom_id          uuid REFERENCES app.boms(id),
  routing_id      uuid REFERENCES app.routings(id),
  qty_to_produce  numeric(19,6) NOT NULL CHECK (qty_to_produce > 0),
  qty_produced    numeric(19,6) NOT NULL DEFAULT 0,
  qty_scrapped    numeric(19,6) NOT NULL DEFAULT 0,
  uom_code        text NOT NULL,
  fg_warehouse_id uuid REFERENCES app.warehouses(id),
  wip_warehouse_id uuid REFERENCES app.warehouses(id),
  planned_start   timestamptz,
  planned_end     timestamptz,
  actual_start    timestamptz,
  actual_end      timestamptz,
  priority        smallint NOT NULL DEFAULT 100,
  status          text NOT NULL DEFAULT 'draft'
                  CHECK (status IN ('draft','planned','released','in_progress','on_hold','completed','closed','cancelled')),
  source_type     text CHECK (source_type IN (NULL,'sales_order','mrp','stock','manual')),
  source_id       uuid,
  notes           text,
  created_at      timestamptz NOT NULL DEFAULT now(),
  updated_at      timestamptz NOT NULL DEFAULT now(),
  created_by      uuid, updated_by uuid, version int NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, company_id, wo_number),
  CHECK (qty_produced + qty_scrapped <= qty_to_produce)
);

CREATE TABLE IF NOT EXISTS app.wo_materials (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  work_order_id   uuid NOT NULL REFERENCES app.work_orders(id) ON DELETE CASCADE,
  line_no         smallint NOT NULL,
  component_item_id uuid NOT NULL,
  qty_required    numeric(19,6) NOT NULL CHECK (qty_required > 0),
  qty_issued      numeric(19,6) NOT NULL DEFAULT 0,
  qty_returned    numeric(19,6) NOT NULL DEFAULT 0,
  uom_code        text NOT NULL,
  source_warehouse_id uuid REFERENCES app.warehouses(id),
  UNIQUE (work_order_id, line_no)
);

CREATE TABLE IF NOT EXISTS app.wo_operations (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  work_order_id   uuid NOT NULL REFERENCES app.work_orders(id) ON DELETE CASCADE,
  operation_no    smallint NOT NULL,
  name            text NOT NULL,
  work_center_id  uuid REFERENCES app.work_centers(id),
  planned_start   timestamptz, planned_end   timestamptz,
  actual_start    timestamptz, actual_end    timestamptz,
  status          text NOT NULL DEFAULT 'pending'
                  CHECK (status IN ('pending','in_progress','completed','skipped')),
  qty_produced    numeric(19,6) NOT NULL DEFAULT 0,
  qty_rejected    numeric(19,6) NOT NULL DEFAULT 0,
  UNIQUE (work_order_id, operation_no)
);

CREATE TABLE IF NOT EXISTS app.job_cards (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  wo_operation_id uuid NOT NULL REFERENCES app.wo_operations(id) ON DELETE CASCADE,
  card_number     text NOT NULL,
  employee_id     uuid,
  start_time      timestamptz NOT NULL DEFAULT now(),
  end_time        timestamptz,
  qty_produced    numeric(19,6) NOT NULL DEFAULT 0,
  qty_rejected    numeric(19,6) NOT NULL DEFAULT 0,
  downtime_min    numeric(9,2) NOT NULL DEFAULT 0,
  notes           text,
  UNIQUE (tenant_id, card_number)
);

CREATE TABLE IF NOT EXISTS app.subcontract_orders (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  company_id      uuid NOT NULL REFERENCES app.companies(id),
  sco_number      text NOT NULL,
  sco_date        date NOT NULL,
  supplier_id     uuid NOT NULL REFERENCES app.suppliers(id),
  work_order_id   uuid REFERENCES app.work_orders(id),
  item_id         uuid NOT NULL,
  qty             numeric(19,6) NOT NULL CHECK (qty > 0),
  uom_code        text NOT NULL,
  rate            numeric(19,4) NOT NULL DEFAULT 0,
  status          text NOT NULL DEFAULT 'draft'
                  CHECK (status IN ('draft','sent','in_progress','received','cancelled')),
  sent_date       date, received_date date,
  created_at      timestamptz NOT NULL DEFAULT now(),
  updated_at      timestamptz NOT NULL DEFAULT now(),
  created_by      uuid, updated_by uuid, version int NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, company_id, sco_number)
);

CREATE TABLE IF NOT EXISTS app.engineering_change_orders (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  eco_number      text NOT NULL,
  title           text NOT NULL,
  description     text,
  affected_items  uuid[] NOT NULL DEFAULT '{}',
  old_bom_id      uuid REFERENCES app.boms(id),
  new_bom_id      uuid REFERENCES app.boms(id),
  status          text NOT NULL DEFAULT 'draft'
                  CHECK (status IN ('draft','submitted','approved','rejected','implemented','cancelled')),
  effective_from  date,
  created_at      timestamptz NOT NULL DEFAULT now(),
  updated_at      timestamptz NOT NULL DEFAULT now(),
  created_by      uuid, updated_by uuid, version int NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, eco_number)
);

-- =============== INDEXES ===============
CREATE INDEX IF NOT EXISTS idx_boms_item_active ON app.boms(tenant_id, item_id, status) WHERE status='active';
CREATE INDEX IF NOT EXISTS idx_boml_bom        ON app.bom_lines(bom_id);
CREATE INDEX IF NOT EXISTS idx_boml_component  ON app.bom_lines(component_item_id);
CREATE INDEX IF NOT EXISTS idx_routing_ops     ON app.routing_operations(routing_id, operation_no);
CREATE INDEX IF NOT EXISTS idx_wo_status       ON app.work_orders(tenant_id, status) WHERE status IN ('released','in_progress','on_hold');
CREATE INDEX IF NOT EXISTS idx_wo_item_date    ON app.work_orders(item_id, wo_date DESC);
CREATE INDEX IF NOT EXISTS idx_wo_source       ON app.work_orders(source_type, source_id);
CREATE INDEX IF NOT EXISTS idx_wom_wo          ON app.wo_materials(work_order_id);
CREATE INDEX IF NOT EXISTS idx_woop_wo         ON app.wo_operations(work_order_id, operation_no);
CREATE INDEX IF NOT EXISTS idx_jc_op           ON app.job_cards(wo_operation_id);
CREATE INDEX IF NOT EXISTS idx_sco_supplier    ON app.subcontract_orders(supplier_id, sco_date DESC);
CREATE INDEX IF NOT EXISTS idx_eco_status      ON app.engineering_change_orders(tenant_id, status);

-- =============== RLS ===============
SELECT core.enable_tenant_rls('app.work_centers');
SELECT core.enable_tenant_rls('app.boms');
SELECT core.enable_tenant_rls('app.bom_lines');
SELECT core.enable_tenant_rls('app.routings');
SELECT core.enable_tenant_rls('app.routing_operations');
SELECT core.enable_tenant_rls('app.work_orders');
SELECT core.enable_tenant_rls('app.wo_materials');
SELECT core.enable_tenant_rls('app.wo_operations');
SELECT core.enable_tenant_rls('app.job_cards');
SELECT core.enable_tenant_rls('app.subcontract_orders');
SELECT core.enable_tenant_rls('app.engineering_change_orders');

-- =============== TRIGGERS ===============
SELECT core.attach_standard_triggers('app.work_centers');
SELECT core.attach_standard_triggers('app.boms');
SELECT core.attach_standard_triggers('app.bom_lines');
SELECT core.attach_standard_triggers('app.routings');
SELECT core.attach_standard_triggers('app.work_orders');
SELECT core.attach_standard_triggers('app.wo_materials');
SELECT core.attach_standard_triggers('app.wo_operations');
SELECT core.attach_standard_triggers('app.subcontract_orders');
SELECT core.attach_standard_triggers('app.engineering_change_orders');

-- =============== FUNCTIONS ===============

-- Explode BOM (multi-level, recursive) for a given item & qty
CREATE OR REPLACE FUNCTION app.explode_bom(p_item_id uuid, p_qty numeric)
RETURNS TABLE(level int, component_item_id uuid, total_qty numeric, uom_code text)
LANGUAGE sql STABLE AS $$
  WITH RECURSIVE explode(level, bom_id, component_item_id, qty, uom_code, is_phantom) AS (
    SELECT 1, b.id, bl.component_item_id, bl.qty_per * p_qty, bl.uom_code, bl.is_phantom
      FROM app.boms b
      JOIN app.bom_lines bl ON bl.bom_id = b.id
     WHERE b.item_id = p_item_id AND b.status = 'active' AND b.is_default
    UNION ALL
    SELECT e.level + 1, b.id, bl.component_item_id, bl.qty_per * e.qty, bl.uom_code, bl.is_phantom
      FROM explode e
      JOIN app.boms b       ON b.item_id = e.component_item_id AND b.status='active' AND b.is_default
      JOIN app.bom_lines bl ON bl.bom_id = b.id
     WHERE e.level < 20
  )
  SELECT level, component_item_id, SUM(qty), uom_code
    FROM explode WHERE NOT is_phantom
   GROUP BY level, component_item_id, uom_code
   ORDER BY level
$$;

-- Create work order from sales order line (simple pegging)
CREATE OR REPLACE FUNCTION app.create_wo_from_so_line(p_so_line_id uuid)
RETURNS uuid
LANGUAGE plpgsql AS $$
DECLARE
  v_sol app.sales_order_lines%ROWTYPE;
  v_so  app.sales_orders%ROWTYPE;
  v_bom uuid;
  v_wo_id uuid := gen_random_uuid();
BEGIN
  SELECT * INTO v_sol FROM app.sales_order_lines WHERE id = p_so_line_id;
  SELECT * INTO v_so FROM app.sales_orders WHERE id = v_sol.sales_order_id;

  SELECT id INTO v_bom FROM app.boms
   WHERE tenant_id = v_sol.tenant_id AND item_id = v_sol.item_id
     AND status='active' AND is_default LIMIT 1;

  INSERT INTO app.work_orders(id,tenant_id,company_id,wo_number,wo_date,item_id,bom_id,
         qty_to_produce,uom_code,source_type,source_id)
  VALUES (v_wo_id, v_sol.tenant_id, v_so.company_id, core.next_doc_number('WO'),
          CURRENT_DATE, v_sol.item_id, v_bom, v_sol.qty_ordered, v_sol.uom_code,
          'sales_order', v_sol.sales_order_id);

  -- Seed WO materials from BOM lines
  IF v_bom IS NOT NULL THEN
    INSERT INTO app.wo_materials(tenant_id,work_order_id,line_no,component_item_id,qty_required,uom_code,source_warehouse_id)
    SELECT v_sol.tenant_id, v_wo_id, bl.line_no, bl.component_item_id,
           bl.qty_per * v_sol.qty_ordered * (1 + bl.scrap_percent/100),
           bl.uom_code, bl.source_warehouse_id
      FROM app.bom_lines bl WHERE bl.bom_id = v_bom;
  END IF;

  RETURN v_wo_id;
END $$;

-- Complete WO: moves FG into stock, consumes raw materials, calc variance
CREATE OR REPLACE PROCEDURE app.complete_work_order(p_wo_id uuid, p_qty_produced numeric)
LANGUAGE plpgsql AS $$
DECLARE
  v_wo app.work_orders%ROWTYPE;
  r record;
  v_consumed_cost numeric(19,4) := 0;
BEGIN
  SELECT * INTO v_wo FROM app.work_orders WHERE id = p_wo_id;
  IF v_wo.status NOT IN ('released','in_progress') THEN
    RAISE EXCEPTION 'WO % in status %, cannot complete', v_wo.wo_number, v_wo.status;
  END IF;

  -- Consume raw materials (proportional to qty produced)
  FOR r IN
    SELECT component_item_id, qty_required * (p_qty_produced / v_wo.qty_to_produce) AS qty_take,
           uom_code, source_warehouse_id
      FROM app.wo_materials WHERE work_order_id = p_wo_id
  LOOP
    PERFORM app.post_stock_entry(
      p_company_id   := v_wo.company_id,
      p_item_id      := r.component_item_id,
      p_warehouse_id := COALESCE(r.source_warehouse_id, v_wo.wip_warehouse_id),
      p_qty          := -r.qty_take,
      p_unit_rate    := 0,
      p_txn_type     := 'manufacturing_consume',
      p_posting_date := CURRENT_DATE,
      p_uom          := r.uom_code,
      p_source_table := 'work_orders',
      p_source_id    := p_wo_id);

    UPDATE app.wo_materials SET qty_issued = qty_issued + r.qty_take
     WHERE work_order_id = p_wo_id AND component_item_id = r.component_item_id;
  END LOOP;

  -- Calc absorbed cost (simplified: sum of ledger value_change for consumed)
  SELECT COALESCE(SUM(ABS(value_change)),0) INTO v_consumed_cost
    FROM app.stock_ledger
   WHERE source_table='work_orders' AND source_id = p_wo_id AND qty_change < 0;

  -- Produce FG at absorbed unit cost
  PERFORM app.post_stock_entry(
    p_company_id   := v_wo.company_id,
    p_item_id      := v_wo.item_id,
    p_warehouse_id := v_wo.fg_warehouse_id,
    p_qty          := p_qty_produced,
    p_unit_rate    := round(v_consumed_cost / NULLIF(p_qty_produced,0), 4),
    p_txn_type     := 'manufacturing_produce',
    p_posting_date := CURRENT_DATE,
    p_uom          := v_wo.uom_code,
    p_source_table := 'work_orders',
    p_source_id    := p_wo_id);

  UPDATE app.work_orders
     SET qty_produced = qty_produced + p_qty_produced,
         status = CASE WHEN qty_produced + p_qty_produced >= qty_to_produce
                       THEN 'completed' ELSE status END,
         actual_end = CASE WHEN qty_produced + p_qty_produced >= qty_to_produce
                           THEN now() ELSE actual_end END,
         updated_at = now()
   WHERE id = p_wo_id;
END $$;

-- =============== VIEWS ===============
CREATE OR REPLACE VIEW app.v_wo_status AS
SELECT wo.tenant_id, wo.id, wo.wo_number, wo.item_id, wo.status,
       wo.qty_to_produce, wo.qty_produced, wo.qty_scrapped,
       round(wo.qty_produced / NULLIF(wo.qty_to_produce,0) * 100, 2) AS pct_complete
  FROM app.work_orders wo;

CREATE OR REPLACE VIEW app.v_wip_valuation AS
SELECT sb.tenant_id, sb.warehouse_id, w.name AS warehouse_name,
       SUM(sb.total_value) AS wip_value
  FROM app.stock_balances sb
  JOIN app.warehouses w ON w.id = sb.warehouse_id
 WHERE w.warehouse_type IN ('transit','quarantine') OR w.code ILIKE '%WIP%'
 GROUP BY sb.tenant_id, sb.warehouse_id, w.name;
