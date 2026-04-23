-- =====================================================================
-- STEP 8: Manufacturing / Production
-- =====================================================================

CREATE TABLE manufacturing.bom (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    company_id      UUID NOT NULL,
    item_id         UUID NOT NULL REFERENCES inventory.item(id),
    variant_id      UUID,
    version         TEXT NOT NULL DEFAULT '1',
    bom_type        TEXT DEFAULT 'manufacturing' CHECK (bom_type IN ('manufacturing','engineering','sales','phantom','template')),
    is_default      BOOLEAN DEFAULT FALSE,
    is_active       BOOLEAN DEFAULT TRUE,
    output_qty      core.qty_amt NOT NULL DEFAULT 1,
    uom_id          UUID NOT NULL REFERENCES inventory.uom(id),
    total_cost      core.money_amt,
    valid_from      DATE,
    valid_to        DATE,
    created_at      TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE (item_id, variant_id, version)
);

CREATE TABLE manufacturing.bom_item (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    bom_id          UUID NOT NULL REFERENCES manufacturing.bom(id) ON DELETE CASCADE,
    line_no         INT NOT NULL,
    component_item_id UUID NOT NULL REFERENCES inventory.item(id),
    component_variant_id UUID,
    qty             core.qty_amt NOT NULL,
    uom_id          UUID NOT NULL,
    scrap_pct       core.pct_amt DEFAULT 0,
    is_phantom      BOOLEAN DEFAULT FALSE,
    alternative_items UUID[],
    operation_id    UUID,
    cost_per_unit   core.money_amt,
    UNIQUE (bom_id, line_no)
);

-- Work center / machine
CREATE TABLE manufacturing.work_center (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    company_id      UUID NOT NULL,
    code            TEXT NOT NULL,
    name            TEXT NOT NULL,
    wc_type         TEXT CHECK (wc_type IN ('machine','manual','line','cell','virtual')),
    capacity_per_hour NUMERIC(19,4),
    cost_per_hour   core.money_amt,
    warehouse_id    UUID REFERENCES inventory.warehouse(id),
    is_active       BOOLEAN DEFAULT TRUE,
    UNIQUE (company_id, code)
);

-- Operation / routing
CREATE TABLE manufacturing.operation (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    code            TEXT NOT NULL,
    name            TEXT NOT NULL,
    work_center_id  UUID REFERENCES manufacturing.work_center(id),
    setup_time_min  INT,
    runtime_per_unit_min NUMERIC(10,4),
    description     TEXT,
    UNIQUE (tenant_id, code)
);

CREATE TABLE manufacturing.bom_operation (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    bom_id          UUID NOT NULL REFERENCES manufacturing.bom(id) ON DELETE CASCADE,
    sequence_no     INT NOT NULL,
    operation_id    UUID NOT NULL REFERENCES manufacturing.operation(id),
    work_center_id  UUID REFERENCES manufacturing.work_center(id),
    setup_time_min  INT,
    runtime_per_unit_min NUMERIC(10,4),
    cost_per_unit   core.money_amt,
    UNIQUE (bom_id, sequence_no)
);

-- Work order
CREATE TABLE manufacturing.work_order (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    company_id      UUID NOT NULL,
    branch_id       UUID,
    doc_no          TEXT NOT NULL,
    doc_date        DATE NOT NULL,
    item_id         UUID NOT NULL REFERENCES inventory.item(id),
    variant_id      UUID,
    bom_id          UUID NOT NULL REFERENCES manufacturing.bom(id),
    qty_to_produce  core.qty_amt NOT NULL,
    qty_produced    core.qty_amt DEFAULT 0,
    qty_rejected    core.qty_amt DEFAULT 0,
    qty_scrap       core.qty_amt DEFAULT 0,
    from_warehouse_id UUID REFERENCES inventory.warehouse(id),
    to_warehouse_id UUID REFERENCES inventory.warehouse(id),
    planned_start   DATE,
    planned_end     DATE,
    actual_start    TIMESTAMPTZ,
    actual_end      TIMESTAMPTZ,
    status          TEXT DEFAULT 'draft' CHECK (status IN ('draft','planned','released','in_progress','completed','closed','cancelled','on_hold')),
    priority        INT DEFAULT 5,
    sales_order_id  UUID REFERENCES sales.sales_order(id),
    project_id      UUID,
    created_at      TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE (company_id, doc_no)
);

-- Job card (operation execution)
CREATE TABLE manufacturing.job_card (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    work_order_id   UUID NOT NULL REFERENCES manufacturing.work_order(id) ON DELETE CASCADE,
    sequence_no     INT NOT NULL,
    operation_id    UUID NOT NULL REFERENCES manufacturing.operation(id),
    work_center_id  UUID REFERENCES manufacturing.work_center(id),
    operator_user_id UUID,
    planned_qty     core.qty_amt,
    completed_qty   core.qty_amt DEFAULT 0,
    rejected_qty    core.qty_amt DEFAULT 0,
    planned_start   TIMESTAMPTZ,
    planned_end     TIMESTAMPTZ,
    actual_start    TIMESTAMPTZ,
    actual_end      TIMESTAMPTZ,
    status          TEXT DEFAULT 'pending' CHECK (status IN ('pending','in_progress','completed','cancelled','on_hold')),
    UNIQUE (work_order_id, sequence_no)
);

-- Material issue / consumption
CREATE TABLE manufacturing.material_issue (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    work_order_id   UUID NOT NULL REFERENCES manufacturing.work_order(id),
    doc_date        DATE NOT NULL,
    stock_entry_id  UUID REFERENCES inventory.stock_entry(id),
    status          TEXT DEFAULT 'draft'
);

CREATE TABLE manufacturing.material_issue_line (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    material_issue_id UUID NOT NULL REFERENCES manufacturing.material_issue(id) ON DELETE CASCADE,
    item_id         UUID NOT NULL,
    planned_qty     core.qty_amt,
    issued_qty      core.qty_amt NOT NULL,
    consumed_qty    core.qty_amt,
    returned_qty    core.qty_amt DEFAULT 0,
    batch_no        TEXT
);

-- Subcontracting
CREATE TABLE manufacturing.subcontract (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    company_id      UUID NOT NULL,
    work_order_id   UUID REFERENCES manufacturing.work_order(id),
    supplier_id     UUID NOT NULL REFERENCES purchase.supplier(id),
    purchase_order_id UUID REFERENCES purchase.purchase_order(id),
    issued_date     DATE,
    expected_return DATE,
    status          TEXT DEFAULT 'issued' CHECK (status IN ('issued','received','partial','closed','cancelled'))
);

-- Engineering change order
CREATE TABLE manufacturing.eco (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    doc_no          TEXT NOT NULL,
    doc_date        DATE NOT NULL,
    item_id         UUID REFERENCES inventory.item(id),
    old_bom_id      UUID REFERENCES manufacturing.bom(id),
    new_bom_id      UUID REFERENCES manufacturing.bom(id),
    reason          TEXT,
    effective_date  DATE,
    status          TEXT DEFAULT 'draft' CHECK (status IN ('draft','submitted','approved','implemented','rejected'))
);

-- =====================================================================
-- INDEXES
-- =====================================================================
CREATE INDEX idx_bom_item               ON manufacturing.bom(item_id, is_default);
CREATE INDEX idx_bom_item_components    ON manufacturing.bom_item(component_item_id);
CREATE INDEX idx_work_order_status      ON manufacturing.work_order(company_id, status);
CREATE INDEX idx_work_order_dates       ON manufacturing.work_order(planned_start, planned_end);
CREATE INDEX idx_job_card_wo            ON manufacturing.job_card(work_order_id, sequence_no);
CREATE INDEX idx_job_card_operator      ON manufacturing.job_card(operator_user_id, status);

-- =====================================================================
-- FUNCTIONS
-- =====================================================================

-- Multi-level BOM explosion
CREATE OR REPLACE FUNCTION manufacturing.fn_explode_bom(p_bom UUID, p_qty core.qty_amt)
RETURNS TABLE (level INT, item_id UUID, qty core.qty_amt, is_phantom BOOLEAN) AS $$
WITH RECURSIVE bom_tree AS (
    SELECT 1 AS level, bi.component_item_id AS item_id,
           (bi.qty * p_qty / b.output_qty) AS qty, bi.is_phantom,
           bi.component_item_id::text AS path
      FROM manufacturing.bom b JOIN manufacturing.bom_item bi ON bi.bom_id = b.id
     WHERE b.id = p_bom
    UNION ALL
    SELECT t.level + 1, bi.component_item_id,
           (bi.qty * t.qty / b.output_qty),
           bi.is_phantom,
           t.path || '>' || bi.component_item_id::text
      FROM bom_tree t
      JOIN manufacturing.bom b ON b.item_id = t.item_id AND b.is_default AND b.is_active
      JOIN manufacturing.bom_item bi ON bi.bom_id = b.id
     WHERE position(bi.component_item_id::text IN t.path) = 0  -- avoid cycles
)
SELECT level, item_id, qty, is_phantom FROM bom_tree;
$$ LANGUAGE sql;

-- Post production (WO complete → stock ledger entries)
CREATE OR REPLACE FUNCTION manufacturing.fn_complete_work_order(p_wo UUID, p_qty_good core.qty_amt, p_qty_scrap core.qty_amt, p_user UUID)
RETURNS VOID AS $$
DECLARE v_wo manufacturing.work_order%ROWTYPE;
BEGIN
    SELECT * INTO v_wo FROM manufacturing.work_order WHERE id = p_wo FOR UPDATE;
    IF v_wo.status NOT IN ('in_progress','released') THEN
        RAISE EXCEPTION 'WO not active';
    END IF;

    -- Consume materials (weighted to actual)
    PERFORM inventory.fn_post_stock_movement(v_wo.tenant_id, v_wo.company_id, bi.component_item_id, NULL,
            v_wo.from_warehouse_id, NULL, NULL, NULL, NULL, 'consumption',
            -(bi.qty * p_qty_good / b.output_qty), bi.cost_per_unit,
            'work_order', v_wo.id, v_wo.doc_no)
      FROM manufacturing.bom b JOIN manufacturing.bom_item bi ON bi.bom_id = b.id
     WHERE b.id = v_wo.bom_id;

    -- Produce finished good
    PERFORM inventory.fn_post_stock_movement(v_wo.tenant_id, v_wo.company_id, v_wo.item_id, v_wo.variant_id,
            v_wo.to_warehouse_id, NULL, NULL, NULL, NULL, 'production',
            p_qty_good, NULL, 'work_order', v_wo.id, v_wo.doc_no);

    UPDATE manufacturing.work_order
       SET qty_produced = qty_produced + p_qty_good,
           qty_scrap = qty_scrap + p_qty_scrap,
           actual_end = NOW(),
           status = CASE WHEN (qty_produced + p_qty_good) >= qty_to_produce THEN 'completed' ELSE 'in_progress' END
     WHERE id = p_wo;
END;
$$ LANGUAGE plpgsql;

-- =====================================================================
-- VIEWS
-- =====================================================================
CREATE OR REPLACE VIEW manufacturing.v_wo_variance AS
SELECT wo.id, wo.doc_no, wo.qty_to_produce, wo.qty_produced, wo.qty_scrap,
       (wo.qty_produced + wo.qty_scrap) / NULLIF(wo.qty_to_produce,0) AS yield_pct
  FROM manufacturing.work_order wo;

CREATE OR REPLACE VIEW manufacturing.v_work_center_load AS
SELECT wc.id, wc.name,
       COUNT(jc.id) FILTER (WHERE jc.status='in_progress') AS active_jobs,
       SUM(jc.planned_qty) FILTER (WHERE jc.status='pending') AS pending_qty
  FROM manufacturing.work_center wc
  LEFT JOIN manufacturing.job_card jc ON jc.work_center_id = wc.id
 GROUP BY wc.id, wc.name;

-- =====================================================================
-- TRIGGERS
-- =====================================================================
CREATE TRIGGER trg_bom_audit AFTER INSERT OR UPDATE OR DELETE ON manufacturing.bom
    FOR EACH ROW EXECUTE FUNCTION audit.fn_row_audit();
CREATE TRIGGER trg_wo_audit AFTER INSERT OR UPDATE OR DELETE ON manufacturing.work_order
    FOR EACH ROW EXECUTE FUNCTION audit.fn_row_audit();
