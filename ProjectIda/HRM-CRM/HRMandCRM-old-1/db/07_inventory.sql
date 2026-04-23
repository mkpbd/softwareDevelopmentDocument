-- =====================================================================
-- STEP 7: Inventory Management
-- =====================================================================

CREATE TYPE inventory.stock_movement_type AS ENUM
    ('receipt','issue','transfer_in','transfer_out','adjustment_plus','adjustment_minus',
     'consumption','production','return_in','return_out','sale','purchase');

CREATE TYPE inventory.valuation_method AS ENUM ('fifo','lifo','weighted_avg','standard','specific');

-- UoM
CREATE TABLE inventory.uom (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    code            TEXT NOT NULL,
    name            TEXT NOT NULL,
    uom_class       TEXT CHECK (uom_class IN ('quantity','weight','volume','length','area','time','custom')),
    UNIQUE (tenant_id, code)
);

CREATE TABLE inventory.uom_conversion (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    from_uom_id     UUID NOT NULL REFERENCES inventory.uom(id),
    to_uom_id       UUID NOT NULL REFERENCES inventory.uom(id),
    factor          NUMERIC(19,8) NOT NULL CHECK (factor > 0),
    item_id         UUID,                         -- item-specific when set
    UNIQUE (from_uom_id, to_uom_id, COALESCE(item_id, '00000000-0000-0000-0000-000000000000'::uuid))
);

-- Item category
CREATE TABLE inventory.item_category (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    parent_id       UUID REFERENCES inventory.item_category(id),
    code            TEXT NOT NULL,
    name            TEXT NOT NULL,
    UNIQUE (tenant_id, code)
);

-- Item (product) master
CREATE TABLE inventory.item (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    code            TEXT NOT NULL,
    name            TEXT NOT NULL,
    description     TEXT,
    category_id     UUID REFERENCES inventory.item_category(id),
    brand           TEXT,
    item_type       TEXT NOT NULL DEFAULT 'stock' CHECK (item_type IN ('stock','service','fixed_asset','subscription','bundle','raw_material','wip','finished_good')),
    hsn_code        TEXT,
    base_uom_id     UUID NOT NULL REFERENCES inventory.uom(id),
    sales_uom_id    UUID REFERENCES inventory.uom(id),
    purchase_uom_id UUID REFERENCES inventory.uom(id),
    valuation_method inventory.valuation_method DEFAULT 'weighted_avg',
    standard_cost   core.money_amt,
    standard_price  core.money_amt,
    is_batch_tracked BOOLEAN NOT NULL DEFAULT FALSE,
    is_serial_tracked BOOLEAN NOT NULL DEFAULT FALSE,
    is_expiry_tracked BOOLEAN NOT NULL DEFAULT FALSE,
    shelf_life_days INT,
    min_stock_qty   core.qty_amt,
    max_stock_qty   core.qty_amt,
    reorder_point   core.qty_amt,
    reorder_qty     core.qty_amt,
    lead_time_days  INT,
    abc_class       CHAR(1) CHECK (abc_class IN ('A','B','C')),
    is_sellable     BOOLEAN DEFAULT TRUE,
    is_purchasable  BOOLEAN DEFAULT TRUE,
    barcode         TEXT,
    weight          NUMERIC(19,6),
    weight_uom_id   UUID REFERENCES inventory.uom(id),
    image_url       TEXT,
    tags            TEXT[],
    attributes      JSONB DEFAULT '{}'::jsonb,
    search_tsv      tsvector,
    status          core.status_generic DEFAULT 'active',
    created_at      TIMESTAMPTZ DEFAULT NOW(),
    updated_at      TIMESTAMPTZ DEFAULT NOW(),
    deleted_at      TIMESTAMPTZ,
    UNIQUE (tenant_id, code)
);

-- Item variants (size/color/...)
CREATE TABLE inventory.item_variant (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    item_id         UUID NOT NULL REFERENCES inventory.item(id) ON DELETE CASCADE,
    sku             TEXT NOT NULL,
    barcode         TEXT,
    attributes      JSONB NOT NULL,               -- {size:'M', color:'red'}
    standard_cost   core.money_amt,
    standard_price  core.money_amt,
    is_active       BOOLEAN DEFAULT TRUE,
    UNIQUE (item_id, sku)
);

-- Warehouse
CREATE TABLE inventory.warehouse (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    company_id      UUID NOT NULL REFERENCES core.company(id),
    branch_id       UUID REFERENCES core.branch(id),
    code            TEXT NOT NULL,
    name            TEXT NOT NULL,
    warehouse_type  TEXT DEFAULT 'main' CHECK (warehouse_type IN ('main','transit','quarantine','scrap','consignment','virtual','third_party')),
    parent_id       UUID REFERENCES inventory.warehouse(id),
    address         JSONB,
    manager_user_id UUID,
    is_active       BOOLEAN DEFAULT TRUE,
    UNIQUE (company_id, code)
);

-- Bin / location inside warehouse
CREATE TABLE inventory.bin (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    warehouse_id    UUID NOT NULL REFERENCES inventory.warehouse(id) ON DELETE CASCADE,
    code            TEXT NOT NULL,
    zone            TEXT,
    aisle           TEXT,
    rack            TEXT,
    shelf           TEXT,
    is_pickable     BOOLEAN DEFAULT TRUE,
    max_capacity    NUMERIC(19,6),
    UNIQUE (warehouse_id, code)
);

-- Stock ledger (immutable double-entry for inventory)
CREATE TABLE inventory.stock_ledger (
    id              BIGSERIAL,
    tenant_id       UUID NOT NULL,
    company_id      UUID NOT NULL,
    item_id         UUID NOT NULL,
    variant_id      UUID,
    warehouse_id    UUID NOT NULL,
    bin_id          UUID,
    batch_no        TEXT,
    serial_no       TEXT,
    expiry_date     DATE,
    txn_date        TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    movement_type   inventory.stock_movement_type NOT NULL,
    qty_change      core.qty_amt NOT NULL,        -- signed
    balance_qty     core.qty_amt NOT NULL,
    unit_cost       core.money_amt,
    cost_change     core.money_amt,
    balance_value   core.money_amt,
    doc_type        TEXT,
    doc_id          UUID,
    doc_no          TEXT,
    notes           TEXT,
    created_by      UUID,
    PRIMARY KEY (id, txn_date)
) PARTITION BY RANGE (txn_date);
CREATE TABLE inventory.stock_ledger_default PARTITION OF inventory.stock_ledger DEFAULT;

-- Stock balance (materialized for speed; reconcile from ledger)
CREATE TABLE inventory.stock_balance (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    company_id      UUID NOT NULL,
    warehouse_id    UUID NOT NULL REFERENCES inventory.warehouse(id),
    item_id         UUID NOT NULL REFERENCES inventory.item(id),
    variant_id      UUID REFERENCES inventory.item_variant(id),
    batch_no        TEXT,
    on_hand_qty     core.qty_amt DEFAULT 0,
    reserved_qty    core.qty_amt DEFAULT 0,
    available_qty   core.qty_amt GENERATED ALWAYS AS (on_hand_qty - reserved_qty) STORED,
    avg_cost        core.money_amt,
    last_updated    TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE (warehouse_id, item_id, COALESCE(variant_id, '00000000-0000-0000-0000-000000000000'::uuid), COALESCE(batch_no,''))
);

-- Batch / Lot
CREATE TABLE inventory.batch (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    item_id         UUID NOT NULL REFERENCES inventory.item(id),
    variant_id      UUID REFERENCES inventory.item_variant(id),
    batch_no        TEXT NOT NULL,
    mfg_date        DATE,
    expiry_date     DATE,
    supplier_batch_no TEXT,
    supplier_id     UUID REFERENCES purchase.supplier(id),
    attributes      JSONB,
    UNIQUE (item_id, variant_id, batch_no)
);

-- Serial number
CREATE TABLE inventory.serial_number (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    item_id         UUID NOT NULL,
    variant_id      UUID,
    serial_no       TEXT NOT NULL,
    batch_id        UUID REFERENCES inventory.batch(id),
    warehouse_id    UUID REFERENCES inventory.warehouse(id),
    bin_id          UUID REFERENCES inventory.bin(id),
    status          TEXT DEFAULT 'available' CHECK (status IN ('available','reserved','shipped','installed','scrapped','returned')),
    customer_id     UUID,
    warranty_until  DATE,
    attributes      JSONB,
    UNIQUE (item_id, serial_no)
);

-- Stock entry (receipt/issue/transfer/adjust)
CREATE TABLE inventory.stock_entry (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    company_id      UUID NOT NULL,
    doc_no          TEXT NOT NULL,
    doc_date        DATE NOT NULL,
    entry_type      inventory.stock_movement_type NOT NULL,
    from_warehouse_id UUID REFERENCES inventory.warehouse(id),
    to_warehouse_id   UUID REFERENCES inventory.warehouse(id),
    reference_doc_type TEXT,
    reference_doc_id  UUID,
    status          core.doc_state DEFAULT 'draft',
    notes           TEXT,
    created_at      TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE (company_id, doc_no)
);

CREATE TABLE inventory.stock_entry_line (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    stock_entry_id  UUID NOT NULL REFERENCES inventory.stock_entry(id) ON DELETE CASCADE,
    line_no         INT NOT NULL,
    item_id         UUID NOT NULL,
    variant_id      UUID,
    batch_no        TEXT,
    serial_nos      TEXT[],
    qty             core.qty_amt NOT NULL,
    uom_id          UUID,
    unit_cost       core.money_amt,
    from_bin_id     UUID,
    to_bin_id       UUID,
    UNIQUE (stock_entry_id, line_no)
);

-- Reservation
CREATE TABLE inventory.stock_reservation (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    item_id         UUID NOT NULL,
    variant_id      UUID,
    warehouse_id    UUID NOT NULL,
    reserved_qty    core.qty_amt NOT NULL,
    doc_type        TEXT NOT NULL,
    doc_id          UUID NOT NULL,
    line_id         UUID,
    reserved_by     UUID,
    reserved_until  TIMESTAMPTZ,
    status          TEXT DEFAULT 'active' CHECK (status IN ('active','fulfilled','released','expired'))
);

-- Physical / cycle count
CREATE TABLE inventory.physical_count (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    company_id      UUID NOT NULL,
    warehouse_id    UUID NOT NULL REFERENCES inventory.warehouse(id),
    doc_no          TEXT NOT NULL,
    count_date      DATE NOT NULL,
    count_type      TEXT CHECK (count_type IN ('full','cycle','spot')),
    status          TEXT DEFAULT 'open' CHECK (status IN ('open','in_progress','counted','adjusted','closed')),
    UNIQUE (company_id, doc_no)
);

CREATE TABLE inventory.physical_count_line (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    physical_count_id UUID NOT NULL REFERENCES inventory.physical_count(id) ON DELETE CASCADE,
    item_id         UUID NOT NULL,
    variant_id      UUID,
    bin_id          UUID,
    book_qty        core.qty_amt NOT NULL,
    counted_qty     core.qty_amt,
    variance_qty    core.qty_amt GENERATED ALWAYS AS (counted_qty - book_qty) STORED,
    counted_by      UUID,
    counted_at      TIMESTAMPTZ
);

-- Kit / bundle
CREATE TABLE inventory.bundle (
    parent_item_id  UUID NOT NULL REFERENCES inventory.item(id) ON DELETE CASCADE,
    component_item_id UUID NOT NULL REFERENCES inventory.item(id),
    qty             core.qty_amt NOT NULL,
    PRIMARY KEY (parent_item_id, component_item_id)
);

-- Reorder rules
CREATE TABLE inventory.reorder_rule (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    item_id         UUID NOT NULL REFERENCES inventory.item(id),
    warehouse_id    UUID REFERENCES inventory.warehouse(id),
    min_qty         core.qty_amt NOT NULL,
    max_qty         core.qty_amt,
    reorder_qty     core.qty_amt NOT NULL,
    preferred_supplier_id UUID REFERENCES purchase.supplier(id),
    is_active       BOOLEAN DEFAULT TRUE
);

-- =====================================================================
-- INDEXES
-- =====================================================================
CREATE INDEX idx_item_category          ON inventory.item(category_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_item_tsv               ON inventory.item USING gin (search_tsv);
CREATE INDEX idx_item_code              ON inventory.item(tenant_id, code);
CREATE INDEX idx_item_barcode           ON inventory.item(barcode) WHERE barcode IS NOT NULL;
CREATE INDEX idx_item_tags              ON inventory.item USING gin (tags);
CREATE INDEX idx_item_attributes        ON inventory.item USING gin (attributes);
CREATE INDEX idx_variant_sku            ON inventory.item_variant(sku);
CREATE INDEX idx_stock_ledger_item_wh   ON inventory.stock_ledger(item_id, warehouse_id, txn_date DESC);
CREATE INDEX idx_stock_ledger_doc       ON inventory.stock_ledger(doc_type, doc_id);
CREATE INDEX idx_stock_balance_item     ON inventory.stock_balance(item_id, warehouse_id);
CREATE INDEX idx_stock_balance_low      ON inventory.stock_balance(item_id) WHERE on_hand_qty > 0;
CREATE INDEX idx_batch_expiry           ON inventory.batch(expiry_date) WHERE expiry_date IS NOT NULL;
CREATE INDEX idx_serial_status          ON inventory.serial_number(item_id, status);
CREATE INDEX idx_reservation_doc        ON inventory.stock_reservation(doc_type, doc_id) WHERE status='active';
CREATE INDEX idx_bin_warehouse          ON inventory.bin(warehouse_id);

-- =====================================================================
-- FUNCTIONS
-- =====================================================================
CREATE OR REPLACE FUNCTION inventory.fn_item_search_tsv() RETURNS TRIGGER AS $$
BEGIN
    NEW.search_tsv := to_tsvector('simple',
        coalesce(NEW.code,'')||' '||coalesce(NEW.name,'')||' '||coalesce(NEW.description,'')||' '||
        coalesce(NEW.brand,'')||' '||coalesce(array_to_string(NEW.tags,' '),''));
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
CREATE TRIGGER trg_item_tsv BEFORE INSERT OR UPDATE ON inventory.item
    FOR EACH ROW EXECUTE FUNCTION inventory.fn_item_search_tsv();

-- Post stock movement + update balance
CREATE OR REPLACE FUNCTION inventory.fn_post_stock_movement(
    p_tenant UUID, p_company UUID, p_item UUID, p_variant UUID, p_wh UUID, p_bin UUID,
    p_batch TEXT, p_serials TEXT[], p_expiry DATE, p_movement inventory.stock_movement_type,
    p_qty_change core.qty_amt, p_unit_cost core.money_amt, p_doc_type TEXT, p_doc_id UUID, p_doc_no TEXT
) RETURNS VOID AS $$
DECLARE
    v_prev_qty  core.qty_amt;
    v_prev_val  core.money_amt;
    v_new_qty   core.qty_amt;
    v_new_val   core.money_amt;
    v_avg_cost  core.money_amt;
BEGIN
    -- Lock balance row
    SELECT on_hand_qty, avg_cost INTO v_prev_qty, v_avg_cost
      FROM inventory.stock_balance
     WHERE warehouse_id = p_wh AND item_id = p_item
       AND COALESCE(variant_id,'00000000-0000-0000-0000-000000000000'::uuid) = COALESCE(p_variant,'00000000-0000-0000-0000-000000000000'::uuid)
       AND COALESCE(batch_no,'') = COALESCE(p_batch,'')
     FOR UPDATE;

    v_prev_qty := COALESCE(v_prev_qty, 0);
    v_avg_cost := COALESCE(v_avg_cost, 0);
    v_prev_val := v_prev_qty * v_avg_cost;

    v_new_qty  := v_prev_qty + p_qty_change;
    IF v_new_qty < 0 THEN
        RAISE EXCEPTION 'Negative stock not allowed: item %, wh %, resulting qty %', p_item, p_wh, v_new_qty;
    END IF;

    -- Weighted average
    IF p_qty_change > 0 THEN
        v_new_val := v_prev_val + (p_qty_change * COALESCE(p_unit_cost, v_avg_cost));
        v_avg_cost := CASE WHEN v_new_qty > 0 THEN v_new_val / v_new_qty ELSE 0 END;
    ELSE
        v_new_val := v_new_qty * v_avg_cost;
    END IF;

    INSERT INTO inventory.stock_ledger(tenant_id, company_id, item_id, variant_id, warehouse_id, bin_id,
        batch_no, expiry_date, movement_type, qty_change, balance_qty, unit_cost, cost_change, balance_value,
        doc_type, doc_id, doc_no)
    VALUES (p_tenant, p_company, p_item, p_variant, p_wh, p_bin,
        p_batch, p_expiry, p_movement, p_qty_change, v_new_qty, COALESCE(p_unit_cost, v_avg_cost),
        (p_qty_change * COALESCE(p_unit_cost, v_avg_cost)), v_new_val,
        p_doc_type, p_doc_id, p_doc_no);

    INSERT INTO inventory.stock_balance(tenant_id, company_id, warehouse_id, item_id, variant_id,
        batch_no, on_hand_qty, avg_cost, last_updated)
    VALUES (p_tenant, p_company, p_wh, p_item, p_variant, p_batch, v_new_qty, v_avg_cost, NOW())
    ON CONFLICT (warehouse_id, item_id, COALESCE(variant_id,'00000000-0000-0000-0000-000000000000'::uuid), COALESCE(batch_no,''))
    DO UPDATE SET on_hand_qty = EXCLUDED.on_hand_qty, avg_cost = EXCLUDED.avg_cost, last_updated = NOW();
END;
$$ LANGUAGE plpgsql;

-- ABC classification refresh
CREATE OR REPLACE FUNCTION inventory.fn_refresh_abc()
RETURNS VOID AS $$
BEGIN
    WITH usage AS (
        SELECT item_id, SUM(ABS(qty_change) * COALESCE(unit_cost,0)) val
          FROM inventory.stock_ledger
         WHERE txn_date >= NOW() - INTERVAL '365 days'
         GROUP BY item_id
    ),
    ranked AS (
        SELECT item_id, val,
               PERCENT_RANK() OVER (ORDER BY val DESC) AS p
          FROM usage
    )
    UPDATE inventory.item i
       SET abc_class = CASE WHEN r.p <= 0.20 THEN 'A'
                             WHEN r.p <= 0.50 THEN 'B'
                             ELSE 'C' END
      FROM ranked r WHERE r.item_id = i.id;
END;
$$ LANGUAGE plpgsql;

-- Available to promise
CREATE OR REPLACE FUNCTION inventory.fn_atp(p_item UUID, p_warehouse UUID DEFAULT NULL)
RETURNS core.qty_amt AS $$
    SELECT COALESCE(SUM(available_qty),0)
      FROM inventory.stock_balance
     WHERE item_id = p_item AND (p_warehouse IS NULL OR warehouse_id = p_warehouse);
$$ LANGUAGE sql STABLE;

-- =====================================================================
-- VIEWS
-- =====================================================================
CREATE OR REPLACE VIEW inventory.v_low_stock AS
SELECT sb.warehouse_id, w.name AS warehouse, i.code, i.name,
       sb.on_hand_qty, i.reorder_point, i.reorder_qty
  FROM inventory.stock_balance sb
  JOIN inventory.item i ON i.id = sb.item_id
  JOIN inventory.warehouse w ON w.id = sb.warehouse_id
 WHERE i.reorder_point IS NOT NULL AND sb.on_hand_qty <= i.reorder_point;

CREATE OR REPLACE VIEW inventory.v_expiring_batches AS
SELECT b.*, i.name AS item_name
  FROM inventory.batch b JOIN inventory.item i ON i.id = b.item_id
 WHERE b.expiry_date IS NOT NULL AND b.expiry_date <= CURRENT_DATE + INTERVAL '30 days';

CREATE OR REPLACE VIEW inventory.v_inventory_valuation AS
SELECT company_id, warehouse_id, item_id,
       SUM(on_hand_qty) qty, SUM(on_hand_qty * avg_cost) value
  FROM inventory.stock_balance
 GROUP BY company_id, warehouse_id, item_id;

-- =====================================================================
-- TRIGGERS
-- =====================================================================
CREATE TRIGGER trg_item_updated BEFORE UPDATE ON inventory.item
    FOR EACH ROW EXECUTE FUNCTION core.fn_set_updated_at();
CREATE TRIGGER trg_item_audit AFTER INSERT OR UPDATE OR DELETE ON inventory.item
    FOR EACH ROW EXECUTE FUNCTION audit.fn_row_audit();
CREATE TRIGGER trg_stock_entry_audit AFTER INSERT OR UPDATE OR DELETE ON inventory.stock_entry
    FOR EACH ROW EXECUTE FUNCTION audit.fn_row_audit();
