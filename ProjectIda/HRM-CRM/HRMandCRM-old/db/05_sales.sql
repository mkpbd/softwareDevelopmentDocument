-- =====================================================================
-- STEP 5: Sales Management
-- =====================================================================

-- Customer master (party concept; shared with CRM)
CREATE TABLE sales.customer (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL REFERENCES core.tenant(id) ON DELETE CASCADE,
    company_id      UUID NOT NULL REFERENCES core.company(id) ON DELETE CASCADE,
    code            TEXT NOT NULL,
    legal_name      TEXT NOT NULL,
    display_name    TEXT NOT NULL,
    customer_type   TEXT NOT NULL DEFAULT 'b2b' CHECK (customer_type IN ('b2b','b2c','b2g','reseller')),
    tax_id          TEXT,
    pan_no          TEXT,
    email           core.email_t,
    phone           core.phone_t,
    website         TEXT,
    industry        TEXT,
    segment         TEXT,
    territory_id    UUID,
    sales_rep_id    UUID REFERENCES iam.user(id),
    price_list_id   UUID,
    payment_term_id UUID,
    credit_limit    core.money_amt,
    credit_days     INT DEFAULT 0,
    currency_code   CHAR(3) NOT NULL DEFAULT 'INR',
    default_billing_address JSONB,
    default_shipping_address JSONB,
    is_gst_registered BOOLEAN DEFAULT FALSE,
    gstin           TEXT,
    place_of_supply TEXT,
    status          core.status_generic DEFAULT 'active',
    attributes      JSONB DEFAULT '{}'::jsonb,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at      TIMESTAMPTZ,
    UNIQUE (company_id, code)
);

CREATE TABLE sales.customer_address (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    customer_id     UUID NOT NULL REFERENCES sales.customer(id) ON DELETE CASCADE,
    address_type    core.address_type NOT NULL,
    line1           TEXT NOT NULL,
    line2           TEXT,
    city            TEXT,
    state           TEXT,
    country_code    CHAR(2),
    postal_code     TEXT,
    is_default      BOOLEAN NOT NULL DEFAULT FALSE
);

CREATE TABLE sales.customer_contact (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    customer_id     UUID NOT NULL REFERENCES sales.customer(id) ON DELETE CASCADE,
    first_name      TEXT,
    last_name       TEXT,
    designation     TEXT,
    email           core.email_t,
    phone           core.phone_t,
    is_primary      BOOLEAN NOT NULL DEFAULT FALSE
);

-- Price list
CREATE TABLE sales.price_list (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    company_id      UUID NOT NULL REFERENCES core.company(id),
    code            TEXT NOT NULL,
    name            TEXT NOT NULL,
    currency_code   CHAR(3) NOT NULL,
    price_includes_tax BOOLEAN NOT NULL DEFAULT FALSE,
    valid_from      DATE,
    valid_to        DATE,
    is_active       BOOLEAN DEFAULT TRUE,
    UNIQUE (company_id, code)
);

CREATE TABLE sales.price_list_item (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    price_list_id   UUID NOT NULL REFERENCES sales.price_list(id) ON DELETE CASCADE,
    item_id         UUID NOT NULL,
    variant_id      UUID,
    uom_id          UUID,
    min_qty         core.qty_amt DEFAULT 0,
    unit_price      core.money_amt NOT NULL,
    discount_pct    core.pct_amt DEFAULT 0,
    valid_from      DATE,
    valid_to        DATE,
    UNIQUE (price_list_id, item_id, variant_id, min_qty, valid_from)
);

-- Payment terms
CREATE TABLE sales.payment_term (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    code            TEXT NOT NULL,
    name            TEXT NOT NULL,
    schedule        JSONB NOT NULL,               -- [{days:0,pct:50},{days:30,pct:50}]
    UNIQUE (tenant_id, code)
);

-- Discount & promotion
CREATE TABLE sales.promotion (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    code            TEXT NOT NULL,
    name            TEXT NOT NULL,
    promo_type      TEXT NOT NULL CHECK (promo_type IN ('percentage','fixed','bxgy','tiered','coupon')),
    conditions      JSONB NOT NULL,
    benefit         JSONB NOT NULL,
    valid_from      DATE NOT NULL,
    valid_to        DATE,
    usage_limit     INT,
    used_count      INT DEFAULT 0,
    is_active       BOOLEAN DEFAULT TRUE,
    UNIQUE (tenant_id, code)
);

-- Sales channel
CREATE TABLE sales.channel (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    code            TEXT NOT NULL,
    name            TEXT NOT NULL,
    channel_type    TEXT CHECK (channel_type IN ('direct','online','pos','partner','marketplace','telesales')),
    is_active       BOOLEAN DEFAULT TRUE,
    UNIQUE (tenant_id, code)
);

-- Quotation
CREATE TABLE sales.quotation (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    company_id      UUID NOT NULL REFERENCES core.company(id),
    branch_id       UUID REFERENCES core.branch(id),
    doc_no          TEXT NOT NULL,
    doc_date        DATE NOT NULL,
    valid_until     DATE,
    customer_id     UUID NOT NULL REFERENCES sales.customer(id),
    opportunity_id  UUID,
    sales_rep_id    UUID REFERENCES iam.user(id),
    channel_id      UUID REFERENCES sales.channel(id),
    currency_code   CHAR(3) NOT NULL,
    exchange_rate   NUMERIC(19,8) DEFAULT 1,
    subtotal        core.money_amt,
    discount_total  core.money_amt,
    tax_total       core.money_amt,
    total           core.money_amt,
    status          TEXT DEFAULT 'draft' CHECK (status IN ('draft','sent','accepted','rejected','expired','converted')),
    terms           TEXT,
    notes           TEXT,
    converted_order_id UUID,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE (company_id, doc_no)
);

CREATE TABLE sales.quotation_line (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    quotation_id    UUID NOT NULL REFERENCES sales.quotation(id) ON DELETE CASCADE,
    line_no         INT NOT NULL,
    item_id         UUID NOT NULL,
    variant_id      UUID,
    description     TEXT,
    uom_id          UUID,
    qty             core.qty_amt NOT NULL,
    unit_price      core.money_amt NOT NULL,
    discount_pct    core.pct_amt DEFAULT 0,
    discount_amt    core.money_amt DEFAULT 0,
    tax_total       core.money_amt DEFAULT 0,
    line_total      core.money_amt NOT NULL,
    UNIQUE (quotation_id, line_no)
);

-- Sales order
CREATE TABLE sales.sales_order (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    company_id      UUID NOT NULL REFERENCES core.company(id),
    branch_id       UUID REFERENCES core.branch(id),
    doc_no          TEXT NOT NULL,
    doc_date        DATE NOT NULL,
    customer_id     UUID NOT NULL REFERENCES sales.customer(id),
    quotation_id    UUID REFERENCES sales.quotation(id),
    sales_rep_id    UUID REFERENCES iam.user(id),
    channel_id      UUID REFERENCES sales.channel(id),
    price_list_id   UUID REFERENCES sales.price_list(id),
    payment_term_id UUID REFERENCES sales.payment_term(id),
    currency_code   CHAR(3) NOT NULL,
    exchange_rate   NUMERIC(19,8) DEFAULT 1,
    delivery_date   DATE,
    billing_address JSONB,
    shipping_address JSONB,
    subtotal        core.money_amt,
    discount_total  core.money_amt,
    tax_total       core.money_amt,
    shipping_charge core.money_amt DEFAULT 0,
    total           core.money_amt,
    paid_amount     core.money_amt DEFAULT 0,
    delivered_qty_pct NUMERIC(5,2) DEFAULT 0,
    invoiced_qty_pct  NUMERIC(5,2) DEFAULT 0,
    status          TEXT DEFAULT 'draft'
        CHECK (status IN ('draft','submitted','approved','partial_delivered','delivered','partial_invoiced','invoiced','closed','cancelled')),
    is_backorder    BOOLEAN DEFAULT FALSE,
    parent_order_id UUID REFERENCES sales.sales_order(id),
    notes           TEXT,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE (company_id, doc_no)
);

CREATE TABLE sales.sales_order_line (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    sales_order_id  UUID NOT NULL REFERENCES sales.sales_order(id) ON DELETE CASCADE,
    line_no         INT NOT NULL,
    item_id         UUID NOT NULL,
    variant_id      UUID,
    description     TEXT,
    uom_id          UUID,
    warehouse_id    UUID,
    qty             core.qty_amt NOT NULL,
    delivered_qty   core.qty_amt DEFAULT 0,
    invoiced_qty    core.qty_amt DEFAULT 0,
    returned_qty    core.qty_amt DEFAULT 0,
    unit_price      core.money_amt NOT NULL,
    discount_pct    core.pct_amt DEFAULT 0,
    discount_amt    core.money_amt DEFAULT 0,
    tax_total       core.money_amt DEFAULT 0,
    line_total      core.money_amt NOT NULL,
    promised_date   DATE,
    UNIQUE (sales_order_id, line_no)
);

-- Delivery / dispatch
CREATE TABLE sales.delivery_note (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    company_id      UUID NOT NULL,
    branch_id       UUID,
    doc_no          TEXT NOT NULL,
    doc_date        DATE NOT NULL,
    sales_order_id  UUID REFERENCES sales.sales_order(id),
    customer_id     UUID NOT NULL REFERENCES sales.customer(id),
    warehouse_id    UUID,
    transporter     TEXT,
    vehicle_no      TEXT,
    lr_no           TEXT,
    lr_date         DATE,
    shipping_address JSONB,
    status          TEXT DEFAULT 'draft' CHECK (status IN ('draft','submitted','dispatched','delivered','cancelled')),
    delivered_at    TIMESTAMPTZ,
    received_by     TEXT,
    created_at      TIMESTAMPTZ DEFAULT NOW(),
    updated_at      TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE (company_id, doc_no)
);

CREATE TABLE sales.delivery_line (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    delivery_note_id UUID NOT NULL REFERENCES sales.delivery_note(id) ON DELETE CASCADE,
    sales_order_line_id UUID REFERENCES sales.sales_order_line(id),
    line_no         INT NOT NULL,
    item_id         UUID NOT NULL,
    variant_id      UUID,
    qty             core.qty_amt NOT NULL,
    batch_no        TEXT,
    serial_nos      TEXT[],
    uom_id          UUID
);

-- Sales invoice
CREATE TABLE sales.sales_invoice (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    company_id      UUID NOT NULL REFERENCES core.company(id),
    branch_id       UUID REFERENCES core.branch(id),
    doc_no          TEXT NOT NULL,
    doc_date        DATE NOT NULL,
    due_date        DATE NOT NULL,
    posting_date    DATE NOT NULL,
    customer_id     UUID NOT NULL REFERENCES sales.customer(id),
    sales_order_id  UUID REFERENCES sales.sales_order(id),
    delivery_note_id UUID REFERENCES sales.delivery_note(id),
    invoice_type    TEXT NOT NULL DEFAULT 'regular' CHECK (invoice_type IN ('regular','proforma','recurring','debit_note','export','b2c','b2b')),
    currency_code   CHAR(3) NOT NULL,
    exchange_rate   NUMERIC(19,8) DEFAULT 1,
    subtotal        core.money_amt,
    discount_total  core.money_amt,
    tax_total       core.money_amt,
    round_off       core.money_amt DEFAULT 0,
    total           core.money_amt,
    paid_amount     core.money_amt DEFAULT 0,
    balance_amount  core.money_amt GENERATED ALWAYS AS (total - paid_amount) STORED,
    status          core.doc_state NOT NULL DEFAULT 'draft',
    payment_status  TEXT DEFAULT 'unpaid' CHECK (payment_status IN ('unpaid','partial','paid','overpaid','refunded','voided')),
    posted_je_id    UUID REFERENCES finance.journal_entry(id),
    irn             TEXT,
    eway_bill_no    TEXT,
    notes           TEXT,
    created_at      TIMESTAMPTZ DEFAULT NOW(),
    updated_at      TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE (company_id, doc_no)
);

CREATE TABLE sales.sales_invoice_line (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    sales_invoice_id UUID NOT NULL REFERENCES sales.sales_invoice(id) ON DELETE CASCADE,
    sales_order_line_id UUID REFERENCES sales.sales_order_line(id),
    line_no         INT NOT NULL,
    item_id         UUID NOT NULL,
    variant_id      UUID,
    description     TEXT,
    hsn_code        TEXT,
    uom_id          UUID,
    qty             core.qty_amt NOT NULL,
    unit_price      core.money_amt NOT NULL,
    discount_pct    core.pct_amt DEFAULT 0,
    discount_amt    core.money_amt DEFAULT 0,
    tax_total       core.money_amt DEFAULT 0,
    line_total      core.money_amt NOT NULL,
    income_account_id UUID REFERENCES finance.account(id),
    cost_center_id  UUID,
    UNIQUE (sales_invoice_id, line_no)
);

-- Credit note
CREATE TABLE sales.credit_note (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    company_id      UUID NOT NULL,
    doc_no          TEXT NOT NULL,
    doc_date        DATE NOT NULL,
    customer_id     UUID NOT NULL REFERENCES sales.customer(id),
    original_invoice_id UUID REFERENCES sales.sales_invoice(id),
    reason          TEXT,
    subtotal        core.money_amt,
    tax_total       core.money_amt,
    total           core.money_amt,
    status          core.doc_state DEFAULT 'draft',
    posted_je_id    UUID REFERENCES finance.journal_entry(id),
    created_at      TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE (company_id, doc_no)
);

CREATE TABLE sales.credit_note_line (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    credit_note_id  UUID NOT NULL REFERENCES sales.credit_note(id) ON DELETE CASCADE,
    line_no         INT NOT NULL,
    item_id         UUID,
    qty             core.qty_amt,
    unit_price      core.money_amt,
    line_total      core.money_amt NOT NULL,
    UNIQUE (credit_note_id, line_no)
);

-- Payment receipt
CREATE TABLE sales.payment_receipt (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    company_id      UUID NOT NULL,
    doc_no          TEXT NOT NULL,
    doc_date        DATE NOT NULL,
    customer_id     UUID NOT NULL REFERENCES sales.customer(id),
    payment_mode    TEXT NOT NULL CHECK (payment_mode IN ('cash','bank','cheque','upi','card','online','adjustment')),
    bank_account_id UUID REFERENCES finance.account(id),
    reference_no    TEXT,
    amount          core.money_amt NOT NULL,
    currency_code   CHAR(3) NOT NULL,
    exchange_rate   NUMERIC(19,8) DEFAULT 1,
    status          core.doc_state DEFAULT 'draft',
    posted_je_id    UUID REFERENCES finance.journal_entry(id),
    created_at      TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE (company_id, doc_no)
);

CREATE TABLE sales.payment_allocation (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    payment_id      UUID NOT NULL REFERENCES sales.payment_receipt(id) ON DELETE CASCADE,
    invoice_id      UUID NOT NULL REFERENCES sales.sales_invoice(id),
    amount          core.money_amt NOT NULL,
    UNIQUE (payment_id, invoice_id)
);

-- Sales target & commission
CREATE TABLE sales.sales_target (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    company_id      UUID NOT NULL,
    sales_rep_id    UUID REFERENCES iam.user(id),
    territory_id    UUID,
    period_start    DATE NOT NULL,
    period_end      DATE NOT NULL,
    target_amount   core.money_amt NOT NULL,
    achieved_amount core.money_amt DEFAULT 0,
    currency_code   CHAR(3) NOT NULL
);

CREATE TABLE sales.commission_rule (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    name            TEXT NOT NULL,
    applicable_to   TEXT CHECK (applicable_to IN ('user','role','territory','channel')),
    applicable_ref  UUID,
    rule_type       TEXT CHECK (rule_type IN ('flat_pct','slab','tiered')),
    definition      JSONB NOT NULL,
    valid_from      DATE NOT NULL,
    valid_to        DATE,
    is_active       BOOLEAN DEFAULT TRUE
);

CREATE TABLE sales.commission_entry (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    sales_rep_id    UUID REFERENCES iam.user(id),
    invoice_id      UUID REFERENCES sales.sales_invoice(id),
    base_amount     core.money_amt NOT NULL,
    rate            NUMERIC(9,4),
    commission_amt  core.money_amt NOT NULL,
    payout_status   TEXT DEFAULT 'pending' CHECK (payout_status IN ('pending','approved','paid','cancelled')),
    created_at      TIMESTAMPTZ DEFAULT NOW()
);

-- Return (RMA)
CREATE TABLE sales.sales_return (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    company_id      UUID NOT NULL,
    doc_no          TEXT NOT NULL,
    doc_date        DATE NOT NULL,
    customer_id     UUID NOT NULL REFERENCES sales.customer(id),
    original_invoice_id UUID REFERENCES sales.sales_invoice(id),
    reason          TEXT,
    status          TEXT DEFAULT 'draft' CHECK (status IN ('draft','received','inspected','approved','rejected','closed')),
    credit_note_id  UUID REFERENCES sales.credit_note(id),
    UNIQUE (company_id, doc_no)
);

CREATE TABLE sales.sales_return_line (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    sales_return_id UUID NOT NULL REFERENCES sales.sales_return(id) ON DELETE CASCADE,
    line_no         INT NOT NULL,
    item_id         UUID NOT NULL,
    qty             core.qty_amt NOT NULL,
    reason          TEXT,
    condition       TEXT CHECK (condition IN ('unopened','damaged','defective','expired'))
);

-- =====================================================================
-- INDEXES
-- =====================================================================
CREATE INDEX idx_customer_company        ON sales.customer(company_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_customer_name_trgm      ON sales.customer USING gin (display_name gin_trgm_ops);
CREATE INDEX idx_customer_gstin          ON sales.customer(gstin) WHERE gstin IS NOT NULL;
CREATE INDEX idx_sales_order_customer    ON sales.sales_order(customer_id, doc_date DESC);
CREATE INDEX idx_sales_order_status      ON sales.sales_order(company_id, status);
CREATE INDEX idx_sales_order_line_item   ON sales.sales_order_line(item_id);
CREATE INDEX idx_sales_invoice_customer  ON sales.sales_invoice(customer_id, doc_date DESC);
CREATE INDEX idx_sales_invoice_status    ON sales.sales_invoice(company_id, status, payment_status);
CREATE INDEX idx_sales_invoice_due       ON sales.sales_invoice(due_date) WHERE payment_status IN ('unpaid','partial');
CREATE INDEX idx_price_list_item         ON sales.price_list_item(price_list_id, item_id);
CREATE INDEX idx_delivery_customer_date  ON sales.delivery_note(customer_id, doc_date DESC);
CREATE INDEX idx_payment_customer        ON sales.payment_receipt(customer_id, doc_date DESC);

-- =====================================================================
-- FUNCTIONS
-- =====================================================================

-- Convert quotation → SO
CREATE OR REPLACE FUNCTION sales.fn_quote_to_order(p_quote UUID, p_user UUID)
RETURNS UUID AS $$
DECLARE v_so UUID;
BEGIN
    INSERT INTO sales.sales_order(tenant_id, company_id, branch_id, doc_no, doc_date, customer_id,
        quotation_id, sales_rep_id, currency_code, exchange_rate, subtotal, discount_total, tax_total, total, status)
    SELECT q.tenant_id, q.company_id, q.branch_id,
           core.fn_next_doc_number(q.tenant_id,'sales_order',q.branch_id),
           CURRENT_DATE, q.customer_id, q.id, q.sales_rep_id, q.currency_code, q.exchange_rate,
           q.subtotal, q.discount_total, q.tax_total, q.total, 'submitted'
      FROM sales.quotation q WHERE q.id = p_quote
    RETURNING id INTO v_so;

    INSERT INTO sales.sales_order_line(sales_order_id, line_no, item_id, variant_id, description,
        uom_id, qty, unit_price, discount_pct, discount_amt, tax_total, line_total)
    SELECT v_so, line_no, item_id, variant_id, description, uom_id, qty, unit_price,
           discount_pct, discount_amt, tax_total, line_total
      FROM sales.quotation_line WHERE quotation_id = p_quote;

    UPDATE sales.quotation SET status = 'converted', converted_order_id = v_so WHERE id = p_quote;
    RETURN v_so;
END;
$$ LANGUAGE plpgsql;

-- Post invoice → JE + party ledger
CREATE OR REPLACE FUNCTION sales.fn_post_sales_invoice(p_si UUID, p_user UUID)
RETURNS UUID AS $$
DECLARE
    v_si sales.sales_invoice%ROWTYPE;
    v_ar_acc UUID;
    v_je UUID;
    v_fp UUID;
    v_doc_no TEXT;
BEGIN
    SELECT * INTO v_si FROM sales.sales_invoice WHERE id = p_si FOR UPDATE;
    IF v_si.status NOT IN ('draft','submitted') THEN
        RAISE EXCEPTION 'Invoice % not postable from state %', v_si.doc_no, v_si.status;
    END IF;

    v_fp := core.fn_get_fiscal_period(v_si.company_id, v_si.posting_date);
    v_doc_no := core.fn_next_doc_number(v_si.tenant_id,'journal_entry',v_si.branch_id);

    -- Choose AR account (simplified: from customer settings or default)
    SELECT id INTO v_ar_acc FROM finance.account
     WHERE company_id = v_si.company_id AND code = '1200' LIMIT 1;   -- AR control a/c

    INSERT INTO finance.journal_entry(tenant_id, company_id, branch_id, fiscal_period_id, doc_no,
        doc_date, posting_date, source_module, source_doc_type, source_doc_id,
        reference, narration, currency_code, exchange_rate, status)
    VALUES (v_si.tenant_id, v_si.company_id, v_si.branch_id, v_fp, v_doc_no,
        v_si.doc_date, v_si.posting_date, 'sales', 'sales_invoice', v_si.id,
        v_si.doc_no, 'Sales Invoice '||v_si.doc_no, v_si.currency_code, v_si.exchange_rate, 'draft')
    RETURNING id INTO v_je;

    -- AR debit
    INSERT INTO finance.journal_line(journal_entry_id, line_no, account_id, party_type, party_id,
        debit, credit, currency_code)
    VALUES (v_je, 1, v_ar_acc, 'customer', v_si.customer_id, v_si.total, 0, v_si.currency_code);

    -- Income credit (sum per line income account)
    INSERT INTO finance.journal_line(journal_entry_id, line_no, account_id, cost_center_id,
        debit, credit, currency_code)
    SELECT v_je, 10 + row_number() OVER (ORDER BY line_no), income_account_id, cost_center_id,
           0, SUM(line_total - tax_total)::core.money_amt, v_si.currency_code
      FROM sales.sales_invoice_line
     WHERE sales_invoice_id = p_si AND income_account_id IS NOT NULL
     GROUP BY income_account_id, cost_center_id, line_no;

    -- Tax credit (per component) — simplified, real impl uses tax_transaction
    INSERT INTO finance.journal_line(journal_entry_id, line_no, account_id, debit, credit, currency_code)
    SELECT v_je, 100 + row_number() OVER (ORDER BY tt.tax_component), tr.gl_account_id,
           0, SUM(tt.tax_amount)::core.money_amt, v_si.currency_code
      FROM tax.tax_transaction tt JOIN tax.tax_rate tr ON tr.id = tt.tax_rate_id
     WHERE tt.doc_type = 'sales_invoice' AND tt.doc_id = p_si
     GROUP BY tr.gl_account_id, tt.tax_component;

    PERFORM finance.fn_post_journal_entry(v_je, p_user);

    INSERT INTO finance.party_ledger(tenant_id, company_id, party_type, party_id, account_id,
        doc_type, doc_id, doc_no, doc_date, due_date, currency_code, amount, status)
    VALUES (v_si.tenant_id, v_si.company_id, 'customer', v_si.customer_id, v_ar_acc,
        'sales_invoice', v_si.id, v_si.doc_no, v_si.doc_date, v_si.due_date,
        v_si.currency_code, v_si.total, 'open');

    UPDATE sales.sales_invoice SET status = 'posted', posted_je_id = v_je WHERE id = p_si;
    RETURN v_je;
END;
$$ LANGUAGE plpgsql;

-- Credit check on SO
CREATE OR REPLACE FUNCTION sales.fn_check_credit_limit(p_customer UUID, p_new_amount core.money_amt)
RETURNS BOOLEAN AS $$
DECLARE
    v_limit core.money_amt;
    v_outstanding core.money_amt;
BEGIN
    SELECT credit_limit INTO v_limit FROM sales.customer WHERE id = p_customer;
    IF v_limit IS NULL OR v_limit = 0 THEN RETURN TRUE; END IF;
    SELECT COALESCE(SUM(balance_amount),0) INTO v_outstanding
      FROM finance.party_ledger WHERE party_type='customer' AND party_id = p_customer AND status <> 'settled';
    RETURN (v_outstanding + p_new_amount) <= v_limit;
END;
$$ LANGUAGE plpgsql STABLE;

-- =====================================================================
-- VIEWS
-- =====================================================================
CREATE OR REPLACE VIEW sales.v_customer_outstanding AS
SELECT c.id, c.code, c.display_name, c.credit_limit,
       COALESCE(SUM(pl.balance_amount),0) AS outstanding,
       c.credit_limit - COALESCE(SUM(pl.balance_amount),0) AS available_credit
  FROM sales.customer c
  LEFT JOIN finance.party_ledger pl ON pl.party_type='customer' AND pl.party_id = c.id AND pl.status <> 'settled'
 WHERE c.deleted_at IS NULL
 GROUP BY c.id;

CREATE OR REPLACE VIEW sales.v_sales_register AS
SELECT si.doc_no, si.doc_date, c.display_name, si.subtotal, si.tax_total, si.total,
       si.paid_amount, si.balance_amount, si.status, si.payment_status
  FROM sales.sales_invoice si JOIN sales.customer c ON c.id = si.customer_id;

CREATE OR REPLACE VIEW sales.v_top_customers_mtd AS
SELECT c.id, c.display_name, SUM(si.total) AS revenue
  FROM sales.sales_invoice si JOIN sales.customer c ON c.id = si.customer_id
 WHERE si.doc_date >= date_trunc('month', CURRENT_DATE) AND si.status = 'posted'
 GROUP BY c.id, c.display_name ORDER BY revenue DESC;

-- =====================================================================
-- TRIGGERS
-- =====================================================================
CREATE TRIGGER trg_customer_updated BEFORE UPDATE ON sales.customer
    FOR EACH ROW EXECUTE FUNCTION core.fn_set_updated_at();
CREATE TRIGGER trg_so_updated BEFORE UPDATE ON sales.sales_order
    FOR EACH ROW EXECUTE FUNCTION core.fn_set_updated_at();
CREATE TRIGGER trg_si_updated BEFORE UPDATE ON sales.sales_invoice
    FOR EACH ROW EXECUTE FUNCTION core.fn_set_updated_at();

CREATE TRIGGER trg_customer_audit AFTER INSERT OR UPDATE OR DELETE ON sales.customer
    FOR EACH ROW EXECUTE FUNCTION audit.fn_row_audit();
CREATE TRIGGER trg_so_audit AFTER INSERT OR UPDATE OR DELETE ON sales.sales_order
    FOR EACH ROW EXECUTE FUNCTION audit.fn_row_audit();
CREATE TRIGGER trg_si_audit AFTER INSERT OR UPDATE OR DELETE ON sales.sales_invoice
    FOR EACH ROW EXECUTE FUNCTION audit.fn_row_audit();

-- Update invoice totals from lines
CREATE OR REPLACE FUNCTION sales.fn_recalc_invoice_totals()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE sales.sales_invoice SET
        subtotal = COALESCE((SELECT SUM(qty*unit_price - discount_amt) FROM sales.sales_invoice_line WHERE sales_invoice_id = NEW.sales_invoice_id),0),
        tax_total = COALESCE((SELECT SUM(tax_total) FROM sales.sales_invoice_line WHERE sales_invoice_id = NEW.sales_invoice_id),0),
        total    = COALESCE((SELECT SUM(line_total) FROM sales.sales_invoice_line WHERE sales_invoice_id = NEW.sales_invoice_id),0)
     WHERE id = NEW.sales_invoice_id;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
CREATE TRIGGER trg_si_line_recalc AFTER INSERT OR UPDATE OR DELETE ON sales.sales_invoice_line
    FOR EACH ROW EXECUTE FUNCTION sales.fn_recalc_invoice_totals();
