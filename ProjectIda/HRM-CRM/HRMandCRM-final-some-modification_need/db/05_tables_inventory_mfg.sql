-- =============================================================================
-- tables.sql — Steps 7–10: Inventory, Manufacturing, Quality, Planning
-- =============================================================================

-- =============================================================================
-- STEP 7: INVENTORY MANAGEMENT
-- =============================================================================

-- Units of Measure
CREATE TABLE inventory.units_of_measure (
    uom_id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id           UUID         NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id           UUID         NOT NULL REFERENCES core.branches(branch_id),
    uom_code            VARCHAR(20)  NOT NULL,
    uom_name            VARCHAR(100) NOT NULL,
    uom_type            VARCHAR(50)  NOT NULL CHECK (uom_type IN ('length','weight','volume','area','count','time','custom')),
    base_uom_id         UUID         REFERENCES inventory.units_of_measure(uom_id),
    conversion_factor   NUMERIC(20,8) NOT NULL DEFAULT 1,
    is_base_uom         BOOLEAN      NOT NULL DEFAULT FALSE,
    is_active           BOOLEAN      NOT NULL DEFAULT TRUE,
    created_by          UUID         NOT NULL,
    updated_by          UUID         NOT NULL,
    deleted_by          UUID,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    deleted_at          TIMESTAMPTZ,
    UNIQUE (tenant_id, uom_code)
);

-- Item Categories
CREATE TABLE inventory.item_categories (
    item_category_id    UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id           UUID         NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id           UUID         NOT NULL REFERENCES core.branches(branch_id),
    parent_category_id  UUID         REFERENCES inventory.item_categories(item_category_id),
    category_code       VARCHAR(50)  NOT NULL,
    category_name       VARCHAR(200) NOT NULL,
    category_type       VARCHAR(50)  NOT NULL DEFAULT 'product' CHECK (category_type IN ('product','service','raw_material','finished_goods','semi_finished','consumable','asset')),
    is_active           BOOLEAN      NOT NULL DEFAULT TRUE,
    created_by          UUID         NOT NULL,
    updated_by          UUID         NOT NULL,
    deleted_by          UUID,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    deleted_at          TIMESTAMPTZ,
    UNIQUE (tenant_id, category_code)
);

-- Items (Product Catalog)
CREATE TABLE inventory.items (
    item_id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id           UUID         NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id           UUID         NOT NULL REFERENCES core.branches(branch_id),
    item_code           VARCHAR(100) NOT NULL,
    item_name           VARCHAR(255) NOT NULL,
    item_description    TEXT,
    item_category_id    UUID         REFERENCES inventory.item_categories(item_category_id),
    item_type           VARCHAR(50)  NOT NULL DEFAULT 'product' CHECK (item_type IN ('product','service','raw_material','finished_goods','semi_finished','consumable','kit','bundle')),
    base_uom_id         UUID         NOT NULL REFERENCES inventory.units_of_measure(uom_id),
    purchase_uom_id     UUID         REFERENCES inventory.units_of_measure(uom_id),
    sales_uom_id        UUID         REFERENCES inventory.units_of_measure(uom_id),
    hsn_sac_code_id     UUID         REFERENCES tax.hsn_sac_codes(hsn_sac_code_id),
    default_tax_rate_id UUID         REFERENCES tax.tax_rates(tax_rate_id),
    barcode             VARCHAR(100),
    sku                 VARCHAR(100),
    brand               VARCHAR(100),
    manufacturer        VARCHAR(200),
    weight_kg           NUMERIC(10,4),
    volume_cbm          NUMERIC(10,4),
    reorder_point       NUMERIC(20,4) NOT NULL DEFAULT 0,
    reorder_quantity    NUMERIC(20,4) NOT NULL DEFAULT 0,
    minimum_order_qty   NUMERIC(20,4) NOT NULL DEFAULT 1,
    lead_time_days      SMALLINT     NOT NULL DEFAULT 0,
    valuation_method    VARCHAR(30)  NOT NULL DEFAULT 'weighted_average' CHECK (valuation_method IN ('fifo','lifo','weighted_average','standard','specific')),
    standard_cost       NUMERIC(20,4) NOT NULL DEFAULT 0,
    last_purchase_price NUMERIC(20,4) NOT NULL DEFAULT 0,
    standard_selling_price NUMERIC(20,4) NOT NULL DEFAULT 0,
    track_batch         BOOLEAN      NOT NULL DEFAULT FALSE,
    track_serial        BOOLEAN      NOT NULL DEFAULT FALSE,
    track_expiry        BOOLEAN      NOT NULL DEFAULT FALSE,
    is_purchasable      BOOLEAN      NOT NULL DEFAULT TRUE,
    is_saleable         BOOLEAN      NOT NULL DEFAULT TRUE,
    is_stockable        BOOLEAN      NOT NULL DEFAULT TRUE,
    is_active           BOOLEAN      NOT NULL DEFAULT TRUE,
    image_url           TEXT,
    created_by          UUID         NOT NULL,
    updated_by          UUID         NOT NULL,
    deleted_by          UUID,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    deleted_at          TIMESTAMPTZ,
    UNIQUE (tenant_id, item_code)
);

-- Warehouses
CREATE TABLE inventory.warehouses (
    warehouse_id        UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id           UUID         NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id           UUID         NOT NULL REFERENCES core.branches(branch_id),
    warehouse_code      VARCHAR(50)  NOT NULL,
    warehouse_name      VARCHAR(255) NOT NULL,
    warehouse_type      VARCHAR(50)  NOT NULL DEFAULT 'main' CHECK (warehouse_type IN ('main','transit','consignment','virtual','quarantine','scrap')),
    address_line1       VARCHAR(255),
    city                VARCHAR(100),
    state_province      VARCHAR(100),
    country_code        VARCHAR(10)  NOT NULL DEFAULT 'IN',
    manager_user_id     UUID         REFERENCES iam.users(user_id),
    is_active           BOOLEAN      NOT NULL DEFAULT TRUE,
    created_by          UUID         NOT NULL,
    updated_by          UUID         NOT NULL,
    deleted_by          UUID,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    deleted_at          TIMESTAMPTZ,
    UNIQUE (tenant_id, warehouse_code)
);

-- Warehouse Locations (bins/racks)
CREATE TABLE inventory.warehouse_locations (
    warehouse_location_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id             UUID        NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id             UUID        NOT NULL REFERENCES core.branches(branch_id),
    warehouse_id          UUID        NOT NULL REFERENCES inventory.warehouses(warehouse_id),
    parent_location_id    UUID        REFERENCES inventory.warehouse_locations(warehouse_location_id),
    location_code         VARCHAR(100) NOT NULL,
    location_name         VARCHAR(200) NOT NULL,
    location_type         VARCHAR(30) NOT NULL DEFAULT 'bin' CHECK (location_type IN ('zone','aisle','rack','shelf','bin')),
    max_weight_kg         NUMERIC(10,2),
    max_volume_cbm        NUMERIC(10,2),
    is_active             BOOLEAN     NOT NULL DEFAULT TRUE,
    created_by            UUID        NOT NULL,
    updated_by            UUID        NOT NULL,
    deleted_by            UUID,
    created_at            TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at            TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at            TIMESTAMPTZ,
    UNIQUE (tenant_id, warehouse_id, location_code)
);

-- Batches
CREATE TABLE inventory.batches (
    batch_id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id           UUID         NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id           UUID         NOT NULL REFERENCES core.branches(branch_id),
    item_id             UUID         NOT NULL REFERENCES inventory.items(item_id),
    batch_number        VARCHAR(100) NOT NULL,
    manufacturing_date  DATE,
    expiry_date         DATE,
    supplier_id         UUID         REFERENCES purchase.suppliers(supplier_id),
    grn_id              UUID         REFERENCES purchase.goods_receipt_notes(grn_id),
    quantity            NUMERIC(20,4) NOT NULL DEFAULT 0,
    status              VARCHAR(20)  NOT NULL DEFAULT 'active' CHECK (status IN ('active','quarantine','expired','exhausted')),
    notes               TEXT,
    created_by          UUID         NOT NULL,
    updated_by          UUID         NOT NULL,
    deleted_by          UUID,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    deleted_at          TIMESTAMPTZ,
    UNIQUE (tenant_id, item_id, batch_number)
);

-- Serial Numbers
CREATE TABLE inventory.serial_numbers (
    serial_number_id    UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id           UUID         NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id           UUID         NOT NULL REFERENCES core.branches(branch_id),
    item_id             UUID         NOT NULL REFERENCES inventory.items(item_id),
    serial_number       VARCHAR(200) NOT NULL,
    batch_id            UUID         REFERENCES inventory.batches(batch_id),
    warehouse_id        UUID         REFERENCES inventory.warehouses(warehouse_id),
    status              VARCHAR(20)  NOT NULL DEFAULT 'in_stock' CHECK (status IN ('in_stock','sold','returned','scrapped','in_transit','reserved')),
    current_owner_type  VARCHAR(50),
    current_owner_id    UUID,
    warranty_expiry     DATE,
    notes               TEXT,
    created_by          UUID         NOT NULL,
    updated_by          UUID         NOT NULL,
    deleted_by          UUID,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    deleted_at          TIMESTAMPTZ,
    UNIQUE (tenant_id, item_id, serial_number)
);

-- Stock Ledger (immutable transaction log)
CREATE TABLE inventory.stock_ledger (
    stock_ledger_id     UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id           UUID         NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id           UUID         NOT NULL REFERENCES core.branches(branch_id),
    posting_date        DATE         NOT NULL,
    item_id             UUID         NOT NULL REFERENCES inventory.items(item_id),
    warehouse_id        UUID         NOT NULL REFERENCES inventory.warehouses(warehouse_id),
    warehouse_location_id UUID       REFERENCES inventory.warehouse_locations(warehouse_location_id),
    batch_id            UUID         REFERENCES inventory.batches(batch_id),
    serial_number_id    UUID         REFERENCES inventory.serial_numbers(serial_number_id),
    voucher_type        VARCHAR(100) NOT NULL,
    voucher_id          UUID         NOT NULL,
    voucher_number      VARCHAR(100) NOT NULL,
    actual_quantity     NUMERIC(20,4) NOT NULL DEFAULT 0,
    qty_after_transaction NUMERIC(20,4) NOT NULL DEFAULT 0,
    incoming_rate       NUMERIC(20,4) NOT NULL DEFAULT 0,
    valuation_rate      NUMERIC(20,4) NOT NULL DEFAULT 0,
    stock_value         NUMERIC(20,4) NOT NULL DEFAULT 0,
    cost_center_id      UUID         REFERENCES finance.cost_centers(cost_center_id),
    created_by          UUID         NOT NULL,
    updated_by          UUID         NOT NULL,
    deleted_by          UUID,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    deleted_at          TIMESTAMPTZ
) PARTITION BY RANGE (posting_date);

CREATE TABLE inventory.stock_ledger_2026 PARTITION OF inventory.stock_ledger
    FOR VALUES FROM ('2026-01-01') TO ('2027-01-01');
CREATE TABLE inventory.stock_ledger_2025 PARTITION OF inventory.stock_ledger
    FOR VALUES FROM ('2025-01-01') TO ('2026-01-01');

-- Stock Balance (aggregated view materialized)
CREATE TABLE inventory.stock_balances (
    stock_balance_id    UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id           UUID         NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id           UUID         NOT NULL REFERENCES core.branches(branch_id),
    item_id             UUID         NOT NULL REFERENCES inventory.items(item_id),
    warehouse_id        UUID         NOT NULL REFERENCES inventory.warehouses(warehouse_id),
    warehouse_location_id UUID       REFERENCES inventory.warehouse_locations(warehouse_location_id),
    batch_id            UUID         REFERENCES inventory.batches(batch_id),
    quantity_on_hand    NUMERIC(20,4) NOT NULL DEFAULT 0,
    quantity_reserved   NUMERIC(20,4) NOT NULL DEFAULT 0,
    quantity_available  NUMERIC(20,4) GENERATED ALWAYS AS (quantity_on_hand - quantity_reserved) STORED,
    quantity_on_order   NUMERIC(20,4) NOT NULL DEFAULT 0,
    valuation_rate      NUMERIC(20,4) NOT NULL DEFAULT 0,
    stock_value         NUMERIC(20,4) NOT NULL DEFAULT 0,
    last_updated_at     TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    created_by          UUID         NOT NULL,
    updated_by          UUID         NOT NULL,
    deleted_by          UUID,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    deleted_at          TIMESTAMPTZ,
    UNIQUE (tenant_id, item_id, warehouse_id, warehouse_location_id, batch_id)
);

-- =============================================================================
-- STEP 8: MANUFACTURING / PRODUCTION
-- =============================================================================

-- Bill of Materials
CREATE TABLE mfg.bills_of_materials (
    bom_id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id           UUID         NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id           UUID         NOT NULL REFERENCES core.branches(branch_id),
    item_id             UUID         NOT NULL REFERENCES inventory.items(item_id),
    bom_number          VARCHAR(50)  NOT NULL,
    bom_name            VARCHAR(255) NOT NULL,
    bom_type            VARCHAR(20)  NOT NULL DEFAULT 'production' CHECK (bom_type IN ('production','template','phantom','subcontract')),
    version             VARCHAR(20)  NOT NULL DEFAULT '1.0',
    quantity            NUMERIC(20,4) NOT NULL DEFAULT 1 CHECK (quantity > 0),
    uom_id              UUID         NOT NULL REFERENCES inventory.units_of_measure(uom_id),
    is_default          BOOLEAN      NOT NULL DEFAULT FALSE,
    is_active           BOOLEAN      NOT NULL DEFAULT TRUE,
    effective_from      DATE,
    effective_until     DATE,
    routing_id          UUID,                          -- FK to mfg.routings
    total_raw_material_cost NUMERIC(20,4) NOT NULL DEFAULT 0,
    created_by          UUID         NOT NULL,
    updated_by          UUID         NOT NULL,
    deleted_by          UUID,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    deleted_at          TIMESTAMPTZ,
    UNIQUE (tenant_id, item_id, version)
);

-- BOM Items (components)
CREATE TABLE mfg.bom_items (
    bom_item_id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id           UUID         NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id           UUID         NOT NULL REFERENCES core.branches(branch_id),
    bom_id              UUID         NOT NULL REFERENCES mfg.bills_of_materials(bom_id),
    parent_bom_item_id  UUID         REFERENCES mfg.bom_items(bom_item_id),
    item_id             UUID         NOT NULL REFERENCES inventory.items(item_id),
    component_type      VARCHAR(20)  NOT NULL DEFAULT 'component' CHECK (component_type IN ('component','byproduct','coproduct','scrap','phantom')),
    quantity            NUMERIC(20,4) NOT NULL CHECK (quantity > 0),
    uom_id              UUID         NOT NULL REFERENCES inventory.units_of_measure(uom_id),
    scrap_percentage    NUMERIC(8,4) NOT NULL DEFAULT 0,
    is_optional         BOOLEAN      NOT NULL DEFAULT FALSE,
    operation_id        UUID,
    notes               TEXT,
    created_by          UUID         NOT NULL,
    updated_by          UUID         NOT NULL,
    deleted_by          UUID,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    deleted_at          TIMESTAMPTZ
);

-- Work Centers
CREATE TABLE mfg.work_centers (
    work_center_id      UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id           UUID         NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id           UUID         NOT NULL REFERENCES core.branches(branch_id),
    work_center_code    VARCHAR(50)  NOT NULL,
    work_center_name    VARCHAR(255) NOT NULL,
    work_center_type    VARCHAR(30)  NOT NULL DEFAULT 'machine' CHECK (work_center_type IN ('machine','workstation','labor','subcontract')),
    capacity_uom        VARCHAR(20)  NOT NULL DEFAULT 'hours',
    capacity_per_day    NUMERIC(10,2) NOT NULL DEFAULT 8,
    cost_per_hour       NUMERIC(20,4) NOT NULL DEFAULT 0,
    overhead_rate       NUMERIC(20,4) NOT NULL DEFAULT 0,
    efficiency_percentage NUMERIC(8,4) NOT NULL DEFAULT 100,
    is_active           BOOLEAN      NOT NULL DEFAULT TRUE,
    created_by          UUID         NOT NULL,
    updated_by          UUID         NOT NULL,
    deleted_by          UUID,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    deleted_at          TIMESTAMPTZ,
    UNIQUE (tenant_id, work_center_code)
);

-- Routings
CREATE TABLE mfg.routings (
    routing_id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id           UUID         NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id           UUID         NOT NULL REFERENCES core.branches(branch_id),
    routing_code        VARCHAR(50)  NOT NULL,
    routing_name        VARCHAR(255) NOT NULL,
    is_active           BOOLEAN      NOT NULL DEFAULT TRUE,
    created_by          UUID         NOT NULL,
    updated_by          UUID         NOT NULL,
    deleted_by          UUID,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    deleted_at          TIMESTAMPTZ,
    UNIQUE (tenant_id, routing_code)
);

-- Routing Operations
CREATE TABLE mfg.routing_operations (
    routing_operation_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id            UUID        NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id            UUID        NOT NULL REFERENCES core.branches(branch_id),
    routing_id           UUID        NOT NULL REFERENCES mfg.routings(routing_id),
    sequence_number      SMALLINT    NOT NULL,
    operation_name       VARCHAR(200) NOT NULL,
    work_center_id       UUID        NOT NULL REFERENCES mfg.work_centers(work_center_id),
    setup_time_minutes   NUMERIC(10,2) NOT NULL DEFAULT 0,
    run_time_per_unit    NUMERIC(10,4) NOT NULL DEFAULT 0,
    queue_time_minutes   NUMERIC(10,2) NOT NULL DEFAULT 0,
    move_time_minutes    NUMERIC(10,2) NOT NULL DEFAULT 0,
    created_by           UUID        NOT NULL,
    updated_by           UUID        NOT NULL,
    deleted_by           UUID,
    created_at           TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at           TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at           TIMESTAMPTZ,
    UNIQUE (tenant_id, routing_id, sequence_number)
);

-- Work Orders
CREATE TABLE mfg.work_orders (
    work_order_id       UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id           UUID         NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id           UUID         NOT NULL REFERENCES core.branches(branch_id),
    work_order_number   VARCHAR(50)  NOT NULL,
    item_id             UUID         NOT NULL REFERENCES inventory.items(item_id),
    bom_id              UUID         NOT NULL REFERENCES mfg.bills_of_materials(bom_id),
    routing_id          UUID         REFERENCES mfg.routings(routing_id),
    planned_quantity    NUMERIC(20,4) NOT NULL CHECK (planned_quantity > 0),
    produced_quantity   NUMERIC(20,4) NOT NULL DEFAULT 0,
    rejected_quantity   NUMERIC(20,4) NOT NULL DEFAULT 0,
    uom_id              UUID         NOT NULL REFERENCES inventory.units_of_measure(uom_id),
    planned_start_date  DATE         NOT NULL,
    planned_end_date    DATE         NOT NULL,
    actual_start_date   DATE,
    actual_end_date     DATE,
    warehouse_id        UUID         NOT NULL REFERENCES inventory.warehouses(warehouse_id),
    sales_order_id      UUID         REFERENCES sales.sales_orders(sales_order_id),
    status              VARCHAR(20)  NOT NULL DEFAULT 'draft' CHECK (status IN ('draft','released','in_progress','completed','cancelled','on_hold')),
    priority            VARCHAR(20)  NOT NULL DEFAULT 'normal' CHECK (priority IN ('low','normal','high','urgent')),
    actual_cost         NUMERIC(20,4) NOT NULL DEFAULT 0,
    standard_cost       NUMERIC(20,4) NOT NULL DEFAULT 0,
    created_by          UUID         NOT NULL,
    updated_by          UUID         NOT NULL,
    deleted_by          UUID,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    deleted_at          TIMESTAMPTZ,
    UNIQUE (tenant_id, branch_id, work_order_number)
);

-- Job Cards (shop floor operations tracking)
CREATE TABLE mfg.job_cards (
    job_card_id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id           UUID         NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id           UUID         NOT NULL REFERENCES core.branches(branch_id),
    job_card_number     VARCHAR(50)  NOT NULL,
    work_order_id       UUID         NOT NULL REFERENCES mfg.work_orders(work_order_id),
    routing_operation_id UUID        REFERENCES mfg.routing_operations(routing_operation_id),
    work_center_id      UUID         NOT NULL REFERENCES mfg.work_centers(work_center_id),
    operator_user_id    UUID         REFERENCES iam.users(user_id),
    planned_start_time  TIMESTAMPTZ,
    planned_end_time    TIMESTAMPTZ,
    actual_start_time   TIMESTAMPTZ,
    actual_end_time     TIMESTAMPTZ,
    planned_hours       NUMERIC(10,2) NOT NULL DEFAULT 0,
    actual_hours        NUMERIC(10,2) NOT NULL DEFAULT 0,
    produced_quantity   NUMERIC(20,4) NOT NULL DEFAULT 0,
    rejected_quantity   NUMERIC(20,4) NOT NULL DEFAULT 0,
    scrap_quantity      NUMERIC(20,4) NOT NULL DEFAULT 0,
    status              VARCHAR(20)  NOT NULL DEFAULT 'open' CHECK (status IN ('open','in_progress','completed','cancelled')),
    notes               TEXT,
    created_by          UUID         NOT NULL,
    updated_by          UUID         NOT NULL,
    deleted_by          UUID,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    deleted_at          TIMESTAMPTZ,
    UNIQUE (tenant_id, branch_id, job_card_number)
);

-- =============================================================================
-- STEP 9: QUALITY MANAGEMENT
-- =============================================================================

-- Quality Inspection Templates
CREATE TABLE quality.inspection_templates (
    inspection_template_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id              UUID        NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id              UUID        NOT NULL REFERENCES core.branches(branch_id),
    template_code          VARCHAR(50) NOT NULL,
    template_name          VARCHAR(255) NOT NULL,
    inspection_type        VARCHAR(30) NOT NULL CHECK (inspection_type IN ('incoming','in_process','outgoing','audit')),
    item_id                UUID        REFERENCES inventory.items(item_id),
    item_category_id       UUID        REFERENCES inventory.item_categories(item_category_id),
    is_active              BOOLEAN     NOT NULL DEFAULT TRUE,
    created_by             UUID        NOT NULL,
    updated_by             UUID        NOT NULL,
    deleted_by             UUID,
    created_at             TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at             TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at             TIMESTAMPTZ,
    UNIQUE (tenant_id, template_code)
);

-- Quality Inspection Parameters
CREATE TABLE quality.inspection_parameters (
    inspection_parameter_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id               UUID        NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id               UUID        NOT NULL REFERENCES core.branches(branch_id),
    inspection_template_id  UUID        NOT NULL REFERENCES quality.inspection_templates(inspection_template_id),
    parameter_name          VARCHAR(200) NOT NULL,
    parameter_type          VARCHAR(20) NOT NULL CHECK (parameter_type IN ('numeric','boolean','text','measurement')),
    min_value               NUMERIC(20,4),
    max_value               NUMERIC(20,4),
    target_value            NUMERIC(20,4),
    uom_id                  UUID        REFERENCES inventory.units_of_measure(uom_id),
    is_mandatory            BOOLEAN     NOT NULL DEFAULT TRUE,
    sequence_number         SMALLINT    NOT NULL DEFAULT 1,
    created_by              UUID        NOT NULL,
    updated_by              UUID        NOT NULL,
    deleted_by              UUID,
    created_at              TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at              TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at              TIMESTAMPTZ
);

-- Quality Inspections
CREATE TABLE quality.quality_inspections (
    quality_inspection_id   UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id               UUID        NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id               UUID        NOT NULL REFERENCES core.branches(branch_id),
    inspection_number       VARCHAR(50) NOT NULL,
    inspection_template_id  UUID        NOT NULL REFERENCES quality.inspection_templates(inspection_template_id),
    inspection_type         VARCHAR(30) NOT NULL,
    source_document_type    VARCHAR(100),
    source_document_id      UUID,
    item_id                 UUID        NOT NULL REFERENCES inventory.items(item_id),
    batch_id                UUID        REFERENCES inventory.batches(batch_id),
    sample_size             NUMERIC(20,4) NOT NULL DEFAULT 1,
    inspected_quantity      NUMERIC(20,4) NOT NULL DEFAULT 0,
    accepted_quantity       NUMERIC(20,4) NOT NULL DEFAULT 0,
    rejected_quantity       NUMERIC(20,4) NOT NULL DEFAULT 0,
    inspector_user_id       UUID        NOT NULL REFERENCES iam.users(user_id),
    inspection_date         DATE        NOT NULL,
    result                  VARCHAR(20) CHECK (result IN ('pass','fail','conditional')),
    status                  VARCHAR(20) NOT NULL DEFAULT 'open' CHECK (status IN ('open','in_progress','completed','cancelled')),
    notes                   TEXT,
    created_by              UUID        NOT NULL,
    updated_by              UUID        NOT NULL,
    deleted_by              UUID,
    created_at              TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at              TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at              TIMESTAMPTZ,
    UNIQUE (tenant_id, branch_id, inspection_number)
);

-- Non-Conformance Reports
CREATE TABLE quality.non_conformance_reports (
    ncr_id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id           UUID         NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id           UUID         NOT NULL REFERENCES core.branches(branch_id),
    ncr_number          VARCHAR(50)  NOT NULL,
    quality_inspection_id UUID       REFERENCES quality.quality_inspections(quality_inspection_id),
    item_id             UUID         NOT NULL REFERENCES inventory.items(item_id),
    nonconformance_type VARCHAR(50)  NOT NULL CHECK (nonconformance_type IN ('incoming','in_process','outgoing','customer_complaint','audit_finding')),
    severity            VARCHAR(20)  NOT NULL DEFAULT 'minor' CHECK (severity IN ('minor','major','critical')),
    description         TEXT         NOT NULL,
    quantity_affected   NUMERIC(20,4) NOT NULL DEFAULT 0,
    disposition         VARCHAR(50)  CHECK (disposition IN ('use_as_is','rework','return_to_supplier','scrap','regrade')),
    root_cause          TEXT,
    reported_by         UUID         NOT NULL REFERENCES iam.users(user_id),
    assigned_to         UUID         REFERENCES iam.users(user_id),
    due_date            DATE,
    closed_at           TIMESTAMPTZ,
    status              VARCHAR(20)  NOT NULL DEFAULT 'open' CHECK (status IN ('open','under_review','corrective_action','closed','cancelled')),
    created_by          UUID         NOT NULL,
    updated_by          UUID         NOT NULL,
    deleted_by          UUID,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    deleted_at          TIMESTAMPTZ,
    UNIQUE (tenant_id, branch_id, ncr_number)
);

-- CAPA (Corrective and Preventive Actions)
CREATE TABLE quality.capa_records (
    capa_id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id           UUID         NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id           UUID         NOT NULL REFERENCES core.branches(branch_id),
    capa_number         VARCHAR(50)  NOT NULL,
    ncr_id              UUID         REFERENCES quality.non_conformance_reports(ncr_id),
    capa_type           VARCHAR(20)  NOT NULL DEFAULT 'corrective' CHECK (capa_type IN ('corrective','preventive')),
    title               VARCHAR(255) NOT NULL,
    root_cause_analysis TEXT,
    action_plan         TEXT,
    implementation_date DATE,
    effectiveness_check_date DATE,
    owner_user_id       UUID         NOT NULL REFERENCES iam.users(user_id),
    status              VARCHAR(20)  NOT NULL DEFAULT 'open' CHECK (status IN ('open','in_progress','implemented','verified','closed','cancelled')),
    effectiveness_result TEXT,
    closed_at           TIMESTAMPTZ,
    created_by          UUID         NOT NULL,
    updated_by          UUID         NOT NULL,
    deleted_by          UUID,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    deleted_at          TIMESTAMPTZ,
    UNIQUE (tenant_id, branch_id, capa_number)
);

-- =============================================================================
-- STEP 10: PLANNING
-- =============================================================================

-- Demand Forecasts
CREATE TABLE planning.demand_forecasts (
    demand_forecast_id  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id           UUID         NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id           UUID         NOT NULL REFERENCES core.branches(branch_id),
    forecast_name       VARCHAR(255) NOT NULL,
    item_id             UUID         NOT NULL REFERENCES inventory.items(item_id),
    warehouse_id        UUID         REFERENCES inventory.warehouses(warehouse_id),
    forecast_period     VARCHAR(20)  NOT NULL,
    forecast_start_date DATE         NOT NULL,
    forecast_end_date   DATE         NOT NULL,
    forecasted_quantity NUMERIC(20,4) NOT NULL DEFAULT 0,
    actual_quantity     NUMERIC(20,4) NOT NULL DEFAULT 0,
    forecast_method     VARCHAR(50)  NOT NULL DEFAULT 'manual' CHECK (forecast_method IN ('manual','moving_average','exponential_smoothing','ml_model')),
    confidence_level    NUMERIC(5,2),
    status              VARCHAR(20)  NOT NULL DEFAULT 'draft' CHECK (status IN ('draft','approved','frozen','archived')),
    created_by          UUID         NOT NULL,
    updated_by          UUID         NOT NULL,
    deleted_by          UUID,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    deleted_at          TIMESTAMPTZ
);

-- MRP Runs
CREATE TABLE planning.mrp_runs (
    mrp_run_id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id           UUID         NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id           UUID         NOT NULL REFERENCES core.branches(branch_id),
    run_number          VARCHAR(50)  NOT NULL,
    run_date            DATE         NOT NULL,
    planning_horizon_days INTEGER    NOT NULL DEFAULT 90,
    status              VARCHAR(20)  NOT NULL DEFAULT 'running' CHECK (status IN ('running','completed','failed','cancelled')),
    started_at          TIMESTAMPTZ,
    completed_at        TIMESTAMPTZ,
    total_planned_orders INTEGER     NOT NULL DEFAULT 0,
    error_message       TEXT,
    created_by          UUID         NOT NULL,
    updated_by          UUID         NOT NULL,
    deleted_by          UUID,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    deleted_at          TIMESTAMPTZ,
    UNIQUE (tenant_id, branch_id, run_number)
);

-- MRP Planned Orders
CREATE TABLE planning.mrp_planned_orders (
    mrp_planned_order_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id            UUID        NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id            UUID        NOT NULL REFERENCES core.branches(branch_id),
    mrp_run_id           UUID        NOT NULL REFERENCES planning.mrp_runs(mrp_run_id),
    item_id              UUID        NOT NULL REFERENCES inventory.items(item_id),
    order_type           VARCHAR(20) NOT NULL CHECK (order_type IN ('purchase','production','transfer')),
    planned_quantity     NUMERIC(20,4) NOT NULL CHECK (planned_quantity > 0),
    uom_id               UUID        NOT NULL REFERENCES inventory.units_of_measure(uom_id),
    planned_start_date   DATE        NOT NULL,
    planned_end_date     DATE        NOT NULL,
    source_warehouse_id  UUID        REFERENCES inventory.warehouses(warehouse_id),
    target_warehouse_id  UUID        REFERENCES inventory.warehouses(warehouse_id),
    demand_source_type   VARCHAR(100),
    demand_source_id     UUID,
    action               VARCHAR(20) NOT NULL DEFAULT 'new' CHECK (action IN ('new','reschedule','cancel','expedite')),
    is_converted         BOOLEAN     NOT NULL DEFAULT FALSE,
    converted_at         TIMESTAMPTZ,
    created_by           UUID        NOT NULL,
    updated_by           UUID        NOT NULL,
    deleted_by           UUID,
    created_at           TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at           TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at           TIMESTAMPTZ
);

-- =============================================================================
-- INDEXES — Inventory, Mfg, Quality, Planning
-- =============================================================================

CREATE INDEX idx_items_tenant ON inventory.items(tenant_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_items_category ON inventory.items(item_category_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_items_barcode ON inventory.items(tenant_id, barcode) WHERE barcode IS NOT NULL AND deleted_at IS NULL;
CREATE INDEX idx_warehouses_tenant ON inventory.warehouses(tenant_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_batches_item ON inventory.batches(tenant_id, item_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_batches_expiry ON inventory.batches(expiry_date) WHERE status = 'active';
CREATE INDEX idx_serial_item ON inventory.serial_numbers(tenant_id, item_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_stock_ledger_item_date ON inventory.stock_ledger(tenant_id, item_id, posting_date);
CREATE INDEX idx_stock_ledger_warehouse ON inventory.stock_ledger(warehouse_id, posting_date);
CREATE INDEX idx_stock_balance_item_wh ON inventory.stock_balances(tenant_id, item_id, warehouse_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_work_orders_status ON mfg.work_orders(tenant_id, status) WHERE deleted_at IS NULL;
CREATE INDEX idx_work_orders_dates ON mfg.work_orders(tenant_id, planned_start_date, planned_end_date) WHERE deleted_at IS NULL;
CREATE INDEX idx_qi_status ON quality.quality_inspections(tenant_id, status) WHERE deleted_at IS NULL;
CREATE INDEX idx_ncr_status ON quality.non_conformance_reports(tenant_id, status) WHERE deleted_at IS NULL;
CREATE INDEX idx_mrp_planned_item ON planning.mrp_planned_orders(tenant_id, item_id) WHERE deleted_at IS NULL;

-- =============================================================================
-- MINIMAL DUMMY DATA — Inventory
-- =============================================================================

DO $$
DECLARE
    v_tenant_id   UUID := 'a0000000-0000-0000-0000-000000000001';
    v_branch_id   UUID := 'b0000000-0000-0000-0000-000000000001';
    v_system_user UUID := '00000000-0000-0000-0000-000000000001';
    v_uom_pcs     UUID := gen_random_uuid();
    v_uom_kg      UUID := gen_random_uuid();
    v_wh_id       UUID := gen_random_uuid();
BEGIN
    INSERT INTO inventory.units_of_measure (uom_id, tenant_id, branch_id, uom_code, uom_name, uom_type, is_base_uom, created_by, updated_by)
    VALUES
        (v_uom_pcs, v_tenant_id, v_branch_id, 'PCS',  'Pieces',     'count',  TRUE, v_system_user, v_system_user),
        (v_uom_kg,  v_tenant_id, v_branch_id, 'KG',   'Kilogram',   'weight', TRUE, v_system_user, v_system_user),
        (gen_random_uuid(), v_tenant_id, v_branch_id, 'MTR',  'Metre',      'length', TRUE, v_system_user, v_system_user),
        (gen_random_uuid(), v_tenant_id, v_branch_id, 'LTR',  'Litre',      'volume', TRUE, v_system_user, v_system_user),
        (gen_random_uuid(), v_tenant_id, v_branch_id, 'BOX',  'Box',        'count',  FALSE, v_system_user, v_system_user),
        (gen_random_uuid(), v_tenant_id, v_branch_id, 'SET',  'Set',        'count',  FALSE, v_system_user, v_system_user)
    ON CONFLICT DO NOTHING;

    INSERT INTO inventory.item_categories (tenant_id, branch_id, category_code, category_name, category_type, created_by, updated_by)
    VALUES
        (v_tenant_id, v_branch_id, 'RM',   'Raw Materials',     'raw_material',    v_system_user, v_system_user),
        (v_tenant_id, v_branch_id, 'FG',   'Finished Goods',    'finished_goods',  v_system_user, v_system_user),
        (v_tenant_id, v_branch_id, 'CONS', 'Consumables',       'consumable',      v_system_user, v_system_user),
        (v_tenant_id, v_branch_id, 'SFG',  'Semi-Finished',     'semi_finished',   v_system_user, v_system_user),
        (v_tenant_id, v_branch_id, 'SVC',  'Services',          'service',         v_system_user, v_system_user)
    ON CONFLICT DO NOTHING;

    INSERT INTO inventory.warehouses (warehouse_id, tenant_id, branch_id, warehouse_code, warehouse_name, warehouse_type, created_by, updated_by)
    VALUES
        (v_wh_id, v_tenant_id, v_branch_id, 'WH-MAIN',    'Main Warehouse',       'main',      v_system_user, v_system_user),
        (gen_random_uuid(), v_tenant_id, v_branch_id, 'WH-QC',      'Quality Control',      'quarantine', v_system_user, v_system_user),
        (gen_random_uuid(), v_tenant_id, v_branch_id, 'WH-SCRAP',   'Scrap Warehouse',      'scrap',     v_system_user, v_system_user)
    ON CONFLICT DO NOTHING;
END $$;
