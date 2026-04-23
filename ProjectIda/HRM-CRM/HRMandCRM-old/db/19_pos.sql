-- =====================================================================
-- STEP 19: Point of Sale (POS)
-- =====================================================================

CREATE TABLE pos.store (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    company_id      UUID NOT NULL,
    branch_id       UUID REFERENCES core.branch(id),
    code            TEXT NOT NULL,
    name            TEXT NOT NULL,
    address         JSONB,
    default_warehouse_id UUID REFERENCES inventory.warehouse(id),
    default_price_list_id UUID REFERENCES sales.price_list(id),
    default_customer_id UUID REFERENCES sales.customer(id),
    currency_code   CHAR(3) DEFAULT 'INR',
    timezone        TEXT,
    is_active       BOOLEAN DEFAULT TRUE,
    UNIQUE (company_id, code)
);

CREATE TABLE pos.terminal (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    store_id        UUID NOT NULL REFERENCES pos.store(id) ON DELETE CASCADE,
    code            TEXT NOT NULL,
    device_id       TEXT UNIQUE,
    printer_config  JSONB,
    is_active       BOOLEAN DEFAULT TRUE,
    UNIQUE (store_id, code)
);

CREATE TABLE pos.shift (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    terminal_id     UUID NOT NULL REFERENCES pos.terminal(id),
    cashier_user_id UUID NOT NULL REFERENCES iam.user(id),
    opened_at       TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    closed_at       TIMESTAMPTZ,
    opening_cash    core.money_amt DEFAULT 0,
    expected_cash   core.money_amt,
    counted_cash    core.money_amt,
    cash_variance   core.money_amt GENERATED ALWAYS AS (COALESCE(counted_cash,0) - COALESCE(expected_cash,0)) STORED,
    status          TEXT DEFAULT 'open' CHECK (status IN ('open','closed','reconciled'))
);

CREATE TABLE pos.sale (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    company_id      UUID NOT NULL,
    shift_id        UUID NOT NULL REFERENCES pos.shift(id),
    store_id        UUID NOT NULL REFERENCES pos.store(id),
    terminal_id     UUID REFERENCES pos.terminal(id),
    receipt_no      TEXT NOT NULL,
    sale_datetime   TIMESTAMPTZ DEFAULT NOW(),
    cashier_user_id UUID,
    customer_id     UUID REFERENCES sales.customer(id),
    currency_code   CHAR(3),
    subtotal        core.money_amt,
    discount_total  core.money_amt,
    tax_total       core.money_amt,
    round_off       core.money_amt,
    total           core.money_amt,
    status          TEXT DEFAULT 'draft' CHECK (status IN ('draft','completed','refunded','voided','held')),
    loyalty_points_earned NUMERIC(10,2),
    loyalty_points_redeemed NUMERIC(10,2),
    sales_invoice_id UUID REFERENCES sales.sales_invoice(id),
    is_offline_sync BOOLEAN DEFAULT FALSE,
    device_sync_id  TEXT UNIQUE,
    UNIQUE (company_id, receipt_no)
);

CREATE TABLE pos.sale_line (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    sale_id         UUID NOT NULL REFERENCES pos.sale(id) ON DELETE CASCADE,
    line_no         INT NOT NULL,
    item_id         UUID NOT NULL,
    variant_id      UUID,
    barcode         TEXT,
    qty             core.qty_amt NOT NULL,
    unit_price      core.money_amt NOT NULL,
    discount_amt    core.money_amt DEFAULT 0,
    tax_amt         core.money_amt DEFAULT 0,
    line_total      core.money_amt NOT NULL,
    UNIQUE (sale_id, line_no)
);

CREATE TABLE pos.payment (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    sale_id         UUID NOT NULL REFERENCES pos.sale(id) ON DELETE CASCADE,
    payment_mode    TEXT NOT NULL CHECK (payment_mode IN ('cash','card','upi','wallet','gift_card','loyalty','voucher','credit','bank_transfer')),
    amount          core.money_amt NOT NULL,
    reference_no    TEXT,
    card_last4      TEXT,
    approval_code   TEXT,
    gateway_txn_id  TEXT,
    tendered_cash   core.money_amt,
    change_given    core.money_amt
);

CREATE TABLE pos.cash_movement (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    shift_id        UUID NOT NULL REFERENCES pos.shift(id) ON DELETE CASCADE,
    movement_type   TEXT CHECK (movement_type IN ('deposit','withdrawal','pay_out','pay_in','refund')),
    amount          core.money_amt NOT NULL,
    reason          TEXT,
    reference       TEXT,
    created_at      TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE pos.gift_card (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    code            TEXT NOT NULL UNIQUE,
    pin_hash        TEXT,
    initial_value   core.money_amt,
    current_balance core.money_amt,
    currency_code   CHAR(3),
    expiry_date     DATE,
    issued_to_customer_id UUID,
    status          TEXT DEFAULT 'active' CHECK (status IN ('active','redeemed','expired','cancelled','blocked'))
);

-- =====================================================================
-- INDEXES
-- =====================================================================
CREATE INDEX idx_pos_sale_store_date   ON pos.sale(store_id, sale_datetime DESC);
CREATE INDEX idx_pos_sale_shift        ON pos.sale(shift_id);
CREATE INDEX idx_pos_sale_customer     ON pos.sale(customer_id, sale_datetime DESC);
CREATE INDEX idx_pos_line_item         ON pos.sale_line(item_id);

-- =====================================================================
-- FUNCTIONS
-- =====================================================================

-- Close POS shift (reconcile cash)
CREATE OR REPLACE FUNCTION pos.fn_close_shift(p_shift UUID, p_counted_cash core.money_amt)
RETURNS VOID AS $$
DECLARE
    v_expected core.money_amt;
    v_opening core.money_amt;
    v_cash_sales core.money_amt;
    v_cash_move core.money_amt;
BEGIN
    SELECT opening_cash INTO v_opening FROM pos.shift WHERE id = p_shift;
    SELECT COALESCE(SUM(p.amount),0) INTO v_cash_sales
      FROM pos.sale s JOIN pos.payment p ON p.sale_id = s.id
     WHERE s.shift_id = p_shift AND p.payment_mode = 'cash';
    SELECT COALESCE(SUM(CASE WHEN movement_type IN ('deposit','pay_in') THEN amount ELSE -amount END),0)
      INTO v_cash_move FROM pos.cash_movement WHERE shift_id = p_shift;
    v_expected := v_opening + v_cash_sales + v_cash_move;
    UPDATE pos.shift SET closed_at = NOW(), expected_cash = v_expected,
                        counted_cash = p_counted_cash, status = 'closed' WHERE id = p_shift;
END;
$$ LANGUAGE plpgsql;

-- Post POS sale to inventory + finance
CREATE OR REPLACE FUNCTION pos.fn_complete_sale(p_sale UUID, p_user UUID)
RETURNS VOID AS $$
DECLARE
    v_sale pos.sale%ROWTYPE;
    v_wh UUID;
BEGIN
    SELECT * INTO v_sale FROM pos.sale WHERE id = p_sale FOR UPDATE;
    IF v_sale.status <> 'draft' THEN RAISE EXCEPTION 'Sale not in draft'; END IF;
    SELECT default_warehouse_id INTO v_wh FROM pos.store WHERE id = v_sale.store_id;

    -- Reduce stock
    PERFORM inventory.fn_post_stock_movement(v_sale.tenant_id, v_sale.company_id, sl.item_id, sl.variant_id,
        v_wh, NULL, NULL, NULL, NULL, 'sale', -sl.qty, NULL, 'pos_sale', v_sale.id, v_sale.receipt_no)
      FROM pos.sale_line sl WHERE sl.sale_id = p_sale;

    UPDATE pos.sale SET status='completed' WHERE id = p_sale;
END;
$$ LANGUAGE plpgsql;

-- =====================================================================
-- VIEWS
-- =====================================================================
CREATE OR REPLACE VIEW pos.v_daily_sales AS
SELECT store_id, date_trunc('day', sale_datetime)::date AS day,
       COUNT(*) AS transactions, SUM(total) AS gross, SUM(tax_total) AS tax
  FROM pos.sale WHERE status='completed' GROUP BY 1,2;

CREATE OR REPLACE VIEW pos.v_shift_summary AS
SELECT s.id, s.terminal_id, s.opened_at, s.closed_at, s.status,
       (SELECT COUNT(*) FROM pos.sale WHERE shift_id=s.id) AS txn_count,
       (SELECT SUM(total) FROM pos.sale WHERE shift_id=s.id AND status='completed') AS total_sales,
       s.opening_cash, s.expected_cash, s.counted_cash, s.cash_variance
  FROM pos.shift s;
