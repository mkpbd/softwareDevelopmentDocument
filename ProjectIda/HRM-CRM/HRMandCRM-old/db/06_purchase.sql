-- =====================================================================
-- STEP 6: Purchase Management
-- =====================================================================

CREATE TABLE purchase.supplier (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL REFERENCES core.tenant(id) ON DELETE CASCADE,
    company_id      UUID NOT NULL REFERENCES core.company(id) ON DELETE CASCADE,
    code            TEXT NOT NULL,
    legal_name      TEXT NOT NULL,
    display_name    TEXT NOT NULL,
    supplier_type   TEXT DEFAULT 'vendor' CHECK (supplier_type IN ('vendor','contractor','service','oem','reseller','government')),
    tax_id          TEXT,
    pan_no          TEXT,
    gstin           TEXT,
    msme_status     TEXT,
    email           core.email_t,
    phone           core.phone_t,
    website         TEXT,
    payment_term_id UUID,
    credit_days     INT DEFAULT 0,
    currency_code   CHAR(3) DEFAULT 'INR',
    default_billing_address JSONB,
    bank_details    JSONB,
    kyc_status      TEXT DEFAULT 'pending' CHECK (kyc_status IN ('pending','verified','rejected','expired')),
    rating          NUMERIC(3,2),
    status          core.status_generic DEFAULT 'active',
    attributes      JSONB DEFAULT '{}'::jsonb,
    created_at      TIMESTAMPTZ DEFAULT NOW(),
    updated_at      TIMESTAMPTZ DEFAULT NOW(),
    deleted_at      TIMESTAMPTZ,
    UNIQUE (company_id, code)
);

CREATE TABLE purchase.supplier_contact (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    supplier_id     UUID NOT NULL REFERENCES purchase.supplier(id) ON DELETE CASCADE,
    name            TEXT NOT NULL,
    designation     TEXT,
    email           core.email_t,
    phone           core.phone_t,
    is_primary      BOOLEAN DEFAULT FALSE
);

CREATE TABLE purchase.requisition (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    company_id      UUID NOT NULL,
    branch_id       UUID,
    doc_no          TEXT NOT NULL,
    doc_date        DATE NOT NULL,
    requested_by    UUID NOT NULL REFERENCES iam.user(id),
    department      TEXT,
    purpose         TEXT,
    required_by     DATE,
    status          TEXT DEFAULT 'draft' CHECK (status IN ('draft','submitted','approved','rejected','partial_ordered','ordered','closed','cancelled')),
    total_amount    core.money_amt,
    approved_by     UUID,
    approved_at     TIMESTAMPTZ,
    UNIQUE (company_id, doc_no)
);

CREATE TABLE purchase.requisition_line (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    requisition_id  UUID NOT NULL REFERENCES purchase.requisition(id) ON DELETE CASCADE,
    line_no         INT NOT NULL,
    item_id         UUID NOT NULL,
    description     TEXT,
    qty             core.qty_amt NOT NULL,
    ordered_qty     core.qty_amt DEFAULT 0,
    uom_id          UUID,
    estimated_price core.money_amt,
    required_date   DATE,
    UNIQUE (requisition_id, line_no)
);

CREATE TABLE purchase.rfq (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    company_id      UUID NOT NULL,
    doc_no          TEXT NOT NULL,
    doc_date        DATE NOT NULL,
    deadline        DATE,
    requisition_id  UUID REFERENCES purchase.requisition(id),
    status          TEXT DEFAULT 'draft' CHECK (status IN ('draft','issued','closed','cancelled')),
    UNIQUE (company_id, doc_no)
);

CREATE TABLE purchase.rfq_line (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    rfq_id          UUID NOT NULL REFERENCES purchase.rfq(id) ON DELETE CASCADE,
    line_no         INT NOT NULL,
    item_id         UUID NOT NULL,
    qty             core.qty_amt NOT NULL,
    uom_id          UUID,
    UNIQUE (rfq_id, line_no)
);

CREATE TABLE purchase.rfq_supplier (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    rfq_id          UUID NOT NULL REFERENCES purchase.rfq(id) ON DELETE CASCADE,
    supplier_id     UUID NOT NULL REFERENCES purchase.supplier(id),
    invited_at      TIMESTAMPTZ DEFAULT NOW(),
    responded_at    TIMESTAMPTZ,
    UNIQUE (rfq_id, supplier_id)
);

CREATE TABLE purchase.supplier_quote (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    rfq_id          UUID REFERENCES purchase.rfq(id),
    supplier_id     UUID NOT NULL REFERENCES purchase.supplier(id),
    doc_no          TEXT NOT NULL,
    doc_date        DATE NOT NULL,
    valid_until     DATE,
    currency_code   CHAR(3) NOT NULL,
    total_amount    core.money_amt,
    status          TEXT DEFAULT 'received' CHECK (status IN ('received','selected','rejected','expired'))
);

CREATE TABLE purchase.supplier_quote_line (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    supplier_quote_id UUID NOT NULL REFERENCES purchase.supplier_quote(id) ON DELETE CASCADE,
    line_no         INT NOT NULL,
    item_id         UUID NOT NULL,
    qty             core.qty_amt NOT NULL,
    unit_price      core.money_amt NOT NULL,
    lead_time_days  INT,
    UNIQUE (supplier_quote_id, line_no)
);

CREATE TABLE purchase.purchase_order (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    company_id      UUID NOT NULL REFERENCES core.company(id),
    branch_id       UUID REFERENCES core.branch(id),
    doc_no          TEXT NOT NULL,
    doc_date        DATE NOT NULL,
    supplier_id     UUID NOT NULL REFERENCES purchase.supplier(id),
    requisition_id  UUID REFERENCES purchase.requisition(id),
    rfq_id          UUID REFERENCES purchase.rfq(id),
    po_type         TEXT DEFAULT 'standard' CHECK (po_type IN ('standard','blanket','scheduled','service','contract')),
    payment_term_id UUID REFERENCES sales.payment_term(id),
    currency_code   CHAR(3) NOT NULL,
    exchange_rate   NUMERIC(19,8) DEFAULT 1,
    delivery_date   DATE,
    shipping_address JSONB,
    subtotal        core.money_amt,
    discount_total  core.money_amt DEFAULT 0,
    tax_total       core.money_amt DEFAULT 0,
    freight         core.money_amt DEFAULT 0,
    total           core.money_amt,
    received_qty_pct NUMERIC(5,2) DEFAULT 0,
    invoiced_qty_pct NUMERIC(5,2) DEFAULT 0,
    status          TEXT DEFAULT 'draft' CHECK (status IN ('draft','submitted','approved','partial_received','received','partial_invoiced','invoiced','closed','cancelled')),
    approved_by     UUID,
    approved_at     TIMESTAMPTZ,
    terms           TEXT,
    created_at      TIMESTAMPTZ DEFAULT NOW(),
    updated_at      TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE (company_id, doc_no)
);

CREATE TABLE purchase.purchase_order_line (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    purchase_order_id UUID NOT NULL REFERENCES purchase.purchase_order(id) ON DELETE CASCADE,
    line_no         INT NOT NULL,
    item_id         UUID NOT NULL,
    description     TEXT,
    uom_id          UUID,
    qty             core.qty_amt NOT NULL,
    received_qty    core.qty_amt DEFAULT 0,
    invoiced_qty    core.qty_amt DEFAULT 0,
    returned_qty    core.qty_amt DEFAULT 0,
    unit_price      core.money_amt NOT NULL,
    discount_pct    core.pct_amt DEFAULT 0,
    tax_total       core.money_amt DEFAULT 0,
    line_total      core.money_amt NOT NULL,
    expected_date   DATE,
    warehouse_id    UUID,
    expense_account_id UUID REFERENCES finance.account(id),
    UNIQUE (purchase_order_id, line_no)
);

CREATE TABLE purchase.goods_receipt (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    company_id      UUID NOT NULL,
    branch_id       UUID,
    doc_no          TEXT NOT NULL,
    doc_date        DATE NOT NULL,
    purchase_order_id UUID REFERENCES purchase.purchase_order(id),
    supplier_id     UUID NOT NULL REFERENCES purchase.supplier(id),
    warehouse_id    UUID NOT NULL,
    received_by     UUID REFERENCES iam.user(id),
    vehicle_no      TEXT,
    lr_no           TEXT,
    status          TEXT DEFAULT 'draft' CHECK (status IN ('draft','submitted','inspected','accepted','rejected','cancelled')),
    UNIQUE (company_id, doc_no)
);

CREATE TABLE purchase.goods_receipt_line (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    goods_receipt_id UUID NOT NULL REFERENCES purchase.goods_receipt(id) ON DELETE CASCADE,
    purchase_order_line_id UUID REFERENCES purchase.purchase_order_line(id),
    line_no         INT NOT NULL,
    item_id         UUID NOT NULL,
    received_qty    core.qty_amt NOT NULL,
    accepted_qty    core.qty_amt,
    rejected_qty    core.qty_amt DEFAULT 0,
    batch_no        TEXT,
    serial_nos      TEXT[],
    expiry_date     DATE,
    UNIQUE (goods_receipt_id, line_no)
);

CREATE TABLE purchase.purchase_invoice (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    company_id      UUID NOT NULL,
    branch_id       UUID,
    doc_no          TEXT NOT NULL,
    doc_date        DATE NOT NULL,
    due_date        DATE,
    posting_date    DATE NOT NULL,
    supplier_id     UUID NOT NULL REFERENCES purchase.supplier(id),
    supplier_invoice_no TEXT,
    supplier_invoice_date DATE,
    purchase_order_id UUID REFERENCES purchase.purchase_order(id),
    goods_receipt_id UUID REFERENCES purchase.goods_receipt(id),
    currency_code   CHAR(3) NOT NULL,
    exchange_rate   NUMERIC(19,8) DEFAULT 1,
    subtotal        core.money_amt,
    tax_total       core.money_amt DEFAULT 0,
    tds_amount      core.money_amt DEFAULT 0,
    total           core.money_amt,
    paid_amount     core.money_amt DEFAULT 0,
    balance_amount  core.money_amt GENERATED ALWAYS AS (total - paid_amount) STORED,
    is_reverse_charge BOOLEAN DEFAULT FALSE,
    status          core.doc_state DEFAULT 'draft',
    payment_status  TEXT DEFAULT 'unpaid',
    three_way_match_status TEXT DEFAULT 'pending' CHECK (three_way_match_status IN ('pending','matched','mismatch','bypassed')),
    posted_je_id    UUID REFERENCES finance.journal_entry(id),
    created_at      TIMESTAMPTZ DEFAULT NOW(),
    updated_at      TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE (company_id, doc_no)
);

CREATE TABLE purchase.purchase_invoice_line (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    purchase_invoice_id UUID NOT NULL REFERENCES purchase.purchase_invoice(id) ON DELETE CASCADE,
    purchase_order_line_id UUID REFERENCES purchase.purchase_order_line(id),
    line_no         INT NOT NULL,
    item_id         UUID NOT NULL,
    description     TEXT,
    hsn_code        TEXT,
    uom_id          UUID,
    qty             core.qty_amt NOT NULL,
    unit_price      core.money_amt NOT NULL,
    discount_amt    core.money_amt DEFAULT 0,
    tax_total       core.money_amt DEFAULT 0,
    line_total      core.money_amt NOT NULL,
    expense_account_id UUID REFERENCES finance.account(id),
    cost_center_id  UUID,
    UNIQUE (purchase_invoice_id, line_no)
);

CREATE TABLE purchase.purchase_return (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    company_id      UUID NOT NULL,
    doc_no          TEXT NOT NULL,
    doc_date        DATE NOT NULL,
    supplier_id     UUID NOT NULL REFERENCES purchase.supplier(id),
    original_invoice_id UUID REFERENCES purchase.purchase_invoice(id),
    reason          TEXT,
    status          TEXT DEFAULT 'draft',
    UNIQUE (company_id, doc_no)
);

CREATE TABLE purchase.purchase_return_line (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    purchase_return_id UUID NOT NULL REFERENCES purchase.purchase_return(id) ON DELETE CASCADE,
    line_no         INT NOT NULL,
    item_id         UUID NOT NULL,
    qty             core.qty_amt NOT NULL,
    reason          TEXT
);

-- Contract
CREATE TABLE purchase.contract (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    company_id      UUID NOT NULL,
    supplier_id     UUID NOT NULL REFERENCES purchase.supplier(id),
    contract_no     TEXT NOT NULL,
    contract_type   TEXT,
    start_date      DATE NOT NULL,
    end_date        DATE,
    total_value     core.money_amt,
    currency_code   CHAR(3),
    terms           TEXT,
    document_id     UUID,
    status          TEXT DEFAULT 'active' CHECK (status IN ('draft','active','expired','terminated','renewed')),
    UNIQUE (company_id, contract_no)
);

-- Supplier evaluation
CREATE TABLE purchase.supplier_evaluation (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    supplier_id     UUID NOT NULL REFERENCES purchase.supplier(id),
    period_start    DATE NOT NULL,
    period_end      DATE NOT NULL,
    quality_score   NUMERIC(5,2),
    delivery_score  NUMERIC(5,2),
    price_score     NUMERIC(5,2),
    service_score   NUMERIC(5,2),
    overall_score   NUMERIC(5,2),
    comments        TEXT,
    evaluated_by    UUID
);

-- Landed cost
CREATE TABLE purchase.landed_cost (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    purchase_invoice_id UUID NOT NULL REFERENCES purchase.purchase_invoice(id),
    cost_type       TEXT NOT NULL,                -- freight/duty/insurance/handling
    amount          core.money_amt NOT NULL,
    allocation_basis TEXT CHECK (allocation_basis IN ('qty','amount','weight','volume')),
    expense_account_id UUID REFERENCES finance.account(id)
);

-- =====================================================================
-- INDEXES
-- =====================================================================
CREATE INDEX idx_supplier_company       ON purchase.supplier(company_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_supplier_name_trgm     ON purchase.supplier USING gin (display_name gin_trgm_ops);
CREATE INDEX idx_po_supplier_date       ON purchase.purchase_order(supplier_id, doc_date DESC);
CREATE INDEX idx_po_status              ON purchase.purchase_order(company_id, status);
CREATE INDEX idx_pol_item               ON purchase.purchase_order_line(item_id);
CREATE INDEX idx_grn_po                 ON purchase.goods_receipt(purchase_order_id);
CREATE INDEX idx_pi_supplier            ON purchase.purchase_invoice(supplier_id, doc_date DESC);
CREATE INDEX idx_pi_status              ON purchase.purchase_invoice(company_id, status, payment_status);
CREATE INDEX idx_contract_expiry        ON purchase.contract(end_date) WHERE status = 'active';

-- =====================================================================
-- FUNCTIONS
-- =====================================================================

-- Three-way match: PO, GRN, PI
CREATE OR REPLACE FUNCTION purchase.fn_three_way_match(p_pi UUID)
RETURNS TEXT AS $$
DECLARE
    v_diff RECORD;
    v_status TEXT := 'matched';
BEGIN
    FOR v_diff IN
        WITH pol AS (
            SELECT pol.item_id, SUM(pol.qty) po_qty, SUM(pol.qty*pol.unit_price) po_amt
              FROM purchase.purchase_invoice pi
              JOIN purchase.purchase_order_line pol ON pol.purchase_order_id = pi.purchase_order_id
             WHERE pi.id = p_pi GROUP BY pol.item_id
        ),
        grn AS (
            SELECT grl.item_id, SUM(grl.accepted_qty) rec_qty
              FROM purchase.purchase_invoice pi
              JOIN purchase.goods_receipt gr ON gr.id = pi.goods_receipt_id
              JOIN purchase.goods_receipt_line grl ON grl.goods_receipt_id = gr.id
             WHERE pi.id = p_pi GROUP BY grl.item_id
        ),
        pil AS (
            SELECT item_id, SUM(qty) inv_qty, SUM(qty*unit_price) inv_amt
              FROM purchase.purchase_invoice_line WHERE purchase_invoice_id = p_pi GROUP BY item_id
        )
        SELECT COALESCE(pol.item_id,grn.item_id,pil.item_id) item_id,
               pol.po_qty, grn.rec_qty, pil.inv_qty, pol.po_amt, pil.inv_amt
          FROM pol FULL OUTER JOIN grn USING(item_id) FULL OUTER JOIN pil USING(item_id)
    LOOP
        IF v_diff.po_qty IS DISTINCT FROM v_diff.inv_qty
           OR v_diff.po_qty IS DISTINCT FROM v_diff.rec_qty
           OR ABS(COALESCE(v_diff.po_amt,0) - COALESCE(v_diff.inv_amt,0)) > 0.01 THEN
            v_status := 'mismatch';
        END IF;
    END LOOP;
    UPDATE purchase.purchase_invoice SET three_way_match_status = v_status WHERE id = p_pi;
    RETURN v_status;
END;
$$ LANGUAGE plpgsql;

-- Post purchase invoice
CREATE OR REPLACE FUNCTION purchase.fn_post_purchase_invoice(p_pi UUID, p_user UUID)
RETURNS UUID AS $$
DECLARE
    v_pi purchase.purchase_invoice%ROWTYPE;
    v_je UUID;
    v_ap_acc UUID;
    v_fp UUID;
BEGIN
    SELECT * INTO v_pi FROM purchase.purchase_invoice WHERE id = p_pi FOR UPDATE;
    IF v_pi.status <> 'draft' THEN RAISE EXCEPTION 'PI not draft'; END IF;

    v_fp := core.fn_get_fiscal_period(v_pi.company_id, v_pi.posting_date);
    SELECT id INTO v_ap_acc FROM finance.account
     WHERE company_id = v_pi.company_id AND code = '2100' LIMIT 1; -- AP control

    INSERT INTO finance.journal_entry(tenant_id, company_id, branch_id, fiscal_period_id, doc_no,
        doc_date, posting_date, source_module, source_doc_type, source_doc_id, reference,
        narration, currency_code, exchange_rate, status)
    VALUES (v_pi.tenant_id, v_pi.company_id, v_pi.branch_id, v_fp,
        core.fn_next_doc_number(v_pi.tenant_id,'journal_entry',v_pi.branch_id),
        v_pi.doc_date, v_pi.posting_date, 'purchase', 'purchase_invoice', v_pi.id,
        v_pi.doc_no, 'PI '||v_pi.doc_no, v_pi.currency_code, v_pi.exchange_rate, 'draft')
    RETURNING id INTO v_je;

    -- Expense debits
    INSERT INTO finance.journal_line(journal_entry_id, line_no, account_id, cost_center_id,
        debit, credit, currency_code)
    SELECT v_je, row_number() OVER (ORDER BY line_no), expense_account_id, cost_center_id,
           SUM(line_total - tax_total)::core.money_amt, 0, v_pi.currency_code
      FROM purchase.purchase_invoice_line
     WHERE purchase_invoice_id = p_pi AND expense_account_id IS NOT NULL
     GROUP BY expense_account_id, cost_center_id, line_no;

    -- Input tax debits
    INSERT INTO finance.journal_line(journal_entry_id, line_no, account_id, debit, credit, currency_code)
    SELECT v_je, 100+row_number() OVER (ORDER BY tt.tax_component), tr.gl_account_id,
           SUM(tt.tax_amount)::core.money_amt, 0, v_pi.currency_code
      FROM tax.tax_transaction tt JOIN tax.tax_rate tr ON tr.id = tt.tax_rate_id
     WHERE tt.doc_type = 'purchase_invoice' AND tt.doc_id = p_pi
     GROUP BY tr.gl_account_id, tt.tax_component;

    -- AP credit
    INSERT INTO finance.journal_line(journal_entry_id, line_no, account_id, party_type, party_id,
        debit, credit, currency_code)
    VALUES (v_je, 200, v_ap_acc, 'vendor', v_pi.supplier_id, 0, v_pi.total, v_pi.currency_code);

    PERFORM finance.fn_post_journal_entry(v_je, p_user);

    INSERT INTO finance.party_ledger(tenant_id, company_id, party_type, party_id, account_id,
        doc_type, doc_id, doc_no, doc_date, due_date, currency_code, amount, status)
    VALUES (v_pi.tenant_id, v_pi.company_id, 'vendor', v_pi.supplier_id, v_ap_acc,
        'purchase_invoice', v_pi.id, v_pi.doc_no, v_pi.doc_date, v_pi.due_date,
        v_pi.currency_code, v_pi.total, 'open');

    UPDATE purchase.purchase_invoice SET status = 'posted', posted_je_id = v_je WHERE id = p_pi;
    RETURN v_je;
END;
$$ LANGUAGE plpgsql;

-- =====================================================================
-- VIEWS
-- =====================================================================
CREATE OR REPLACE VIEW purchase.v_supplier_outstanding AS
SELECT s.id, s.code, s.display_name,
       COALESCE(SUM(pl.balance_amount),0) AS outstanding
  FROM purchase.supplier s
  LEFT JOIN finance.party_ledger pl ON pl.party_type='vendor' AND pl.party_id = s.id AND pl.status <> 'settled'
 WHERE s.deleted_at IS NULL
 GROUP BY s.id;

CREATE OR REPLACE VIEW purchase.v_po_pending AS
SELECT po.*, s.display_name AS supplier_name
  FROM purchase.purchase_order po JOIN purchase.supplier s ON s.id = po.supplier_id
 WHERE po.status IN ('approved','partial_received');

-- =====================================================================
-- TRIGGERS
-- =====================================================================
CREATE TRIGGER trg_supplier_updated BEFORE UPDATE ON purchase.supplier
    FOR EACH ROW EXECUTE FUNCTION core.fn_set_updated_at();
CREATE TRIGGER trg_po_updated BEFORE UPDATE ON purchase.purchase_order
    FOR EACH ROW EXECUTE FUNCTION core.fn_set_updated_at();
CREATE TRIGGER trg_pi_updated BEFORE UPDATE ON purchase.purchase_invoice
    FOR EACH ROW EXECUTE FUNCTION core.fn_set_updated_at();

CREATE TRIGGER trg_po_audit AFTER INSERT OR UPDATE OR DELETE ON purchase.purchase_order
    FOR EACH ROW EXECUTE FUNCTION audit.fn_row_audit();
CREATE TRIGGER trg_pi_audit AFTER INSERT OR UPDATE OR DELETE ON purchase.purchase_invoice
    FOR EACH ROW EXECUTE FUNCTION audit.fn_row_audit();
