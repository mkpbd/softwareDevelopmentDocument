-- =====================================================================
-- STEP 18: Logistics & Warehouse
-- =====================================================================

CREATE TABLE logistics.carrier (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    code            TEXT NOT NULL,
    name            TEXT NOT NULL,
    carrier_type    TEXT CHECK (carrier_type IN ('road','air','sea','rail','courier','3pl','own_fleet')),
    service_level   TEXT,
    contact         JSONB,
    tracking_url_pattern TEXT,
    api_config      JSONB,
    is_active       BOOLEAN DEFAULT TRUE,
    UNIQUE (tenant_id, code)
);

CREATE TABLE logistics.shipment (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    company_id      UUID NOT NULL,
    doc_no          TEXT NOT NULL,
    shipment_date   DATE NOT NULL,
    shipment_type   TEXT CHECK (shipment_type IN ('outbound','inbound','transfer','return')),
    carrier_id      UUID REFERENCES logistics.carrier(id),
    tracking_no     TEXT,
    from_warehouse_id UUID REFERENCES inventory.warehouse(id),
    to_warehouse_id UUID REFERENCES inventory.warehouse(id),
    from_address    JSONB,
    to_address      JSONB,
    shipping_mode   TEXT,
    weight          NUMERIC(12,3),
    volume          NUMERIC(12,3),
    freight_cost    core.money_amt,
    insurance_cost  core.money_amt,
    currency_code   CHAR(3),
    expected_delivery DATE,
    actual_delivery DATE,
    status          TEXT DEFAULT 'draft' CHECK (status IN ('draft','ready','picked_up','in_transit','out_for_delivery','delivered','returned','failed','cancelled')),
    pod_url         TEXT,
    signed_by       TEXT,
    created_at      TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE (company_id, doc_no)
);

CREATE TABLE logistics.shipment_item (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    shipment_id     UUID NOT NULL REFERENCES logistics.shipment(id) ON DELETE CASCADE,
    reference_type  TEXT,                         -- delivery_note/sales_order/grn/...
    reference_id    UUID,
    item_id         UUID NOT NULL,
    qty             core.qty_amt NOT NULL,
    serial_nos      TEXT[],
    package_no      TEXT
);

CREATE TABLE logistics.package (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    shipment_id     UUID NOT NULL REFERENCES logistics.shipment(id) ON DELETE CASCADE,
    package_no      TEXT NOT NULL,
    length_cm       NUMERIC(10,2),
    width_cm        NUMERIC(10,2),
    height_cm       NUMERIC(10,2),
    weight_kg       NUMERIC(10,3),
    barcode         TEXT,
    seal_no         TEXT
);

CREATE TABLE logistics.tracking_event (
    id              BIGSERIAL PRIMARY KEY,
    shipment_id     UUID NOT NULL REFERENCES logistics.shipment(id),
    event_time      TIMESTAMPTZ NOT NULL,
    event_code      TEXT,
    description     TEXT,
    location        TEXT,
    geo_location    POINT,
    status          TEXT,
    source          TEXT
);

-- Wave / batch pick
CREATE TABLE logistics.pick_wave (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    warehouse_id    UUID NOT NULL REFERENCES inventory.warehouse(id),
    wave_no         TEXT NOT NULL,
    wave_date       DATE NOT NULL,
    strategy        TEXT CHECK (strategy IN ('wave','batch','zone','discrete')),
    status          TEXT DEFAULT 'open'
);

CREATE TABLE logistics.pick_list (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    wave_id         UUID REFERENCES logistics.pick_wave(id) ON DELETE CASCADE,
    doc_no          TEXT NOT NULL,
    warehouse_id    UUID,
    picker_id       UUID REFERENCES iam.user(id),
    status          TEXT DEFAULT 'open' CHECK (status IN ('open','picking','picked','packed','cancelled')),
    created_at      TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE logistics.pick_list_line (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    pick_list_id    UUID NOT NULL REFERENCES logistics.pick_list(id) ON DELETE CASCADE,
    sequence_no     INT,
    item_id         UUID NOT NULL,
    bin_id          UUID REFERENCES inventory.bin(id),
    qty_to_pick     core.qty_amt NOT NULL,
    qty_picked      core.qty_amt DEFAULT 0,
    reference_type  TEXT,
    reference_id    UUID
);

CREATE TABLE logistics.putaway (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    warehouse_id    UUID NOT NULL REFERENCES inventory.warehouse(id),
    source_doc_type TEXT,
    source_doc_id   UUID,
    status          TEXT DEFAULT 'pending'
);

CREATE TABLE logistics.putaway_line (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    putaway_id      UUID NOT NULL REFERENCES logistics.putaway(id) ON DELETE CASCADE,
    item_id         UUID NOT NULL,
    qty             core.qty_amt NOT NULL,
    target_bin_id   UUID REFERENCES inventory.bin(id),
    status          TEXT DEFAULT 'pending'
);

-- =====================================================================
-- INDEXES
-- =====================================================================
CREATE INDEX idx_shipment_tracking     ON logistics.shipment(tracking_no);
CREATE INDEX idx_shipment_status       ON logistics.shipment(status, shipment_date DESC);
CREATE INDEX idx_tracking_shipment     ON logistics.tracking_event(shipment_id, event_time DESC);
CREATE INDEX idx_pick_list_picker      ON logistics.pick_list(picker_id, status);

-- =====================================================================
-- FUNCTIONS
-- =====================================================================
CREATE OR REPLACE FUNCTION logistics.fn_update_shipment_status(p_ship UUID, p_status TEXT, p_event TEXT, p_loc TEXT)
RETURNS VOID AS $$
BEGIN
    UPDATE logistics.shipment SET status = p_status WHERE id = p_ship;
    INSERT INTO logistics.tracking_event(shipment_id, event_time, event_code, description, location, status)
    VALUES (p_ship, NOW(), p_event, p_event, p_loc, p_status);
END; $$ LANGUAGE plpgsql;

-- =====================================================================
-- VIEWS
-- =====================================================================
CREATE OR REPLACE VIEW logistics.v_in_transit AS
SELECT s.*, c.name AS carrier_name
  FROM logistics.shipment s LEFT JOIN logistics.carrier c ON c.id = s.carrier_id
 WHERE s.status IN ('picked_up','in_transit','out_for_delivery');

CREATE OR REPLACE VIEW logistics.v_delivery_performance AS
SELECT carrier_id, date_trunc('month', shipment_date) AS month,
       COUNT(*) total_shipments,
       COUNT(*) FILTER (WHERE actual_delivery <= expected_delivery) on_time,
       AVG(actual_delivery - expected_delivery) AS avg_delay_days
  FROM logistics.shipment
 WHERE status = 'delivered' AND actual_delivery IS NOT NULL
 GROUP BY 1,2;
