-- =====================================================================
-- STEP 4: Tax & Compliance
-- =====================================================================

CREATE TYPE tax.tax_regime AS ENUM ('gst_in','vat_eu','vat_gcc','sut_us','generic');
CREATE TYPE tax.filing_status AS ENUM ('pending','draft','filed','accepted','rejected','amended');

-- Tax jurisdiction
CREATE TABLE tax.jurisdiction (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL REFERENCES core.tenant(id) ON DELETE CASCADE,
    code            TEXT NOT NULL,
    name            TEXT NOT NULL,
    country_code    CHAR(2) NOT NULL,
    state_code      TEXT,
    regime          tax.tax_regime NOT NULL,
    parent_id       UUID REFERENCES tax.jurisdiction(id),
    is_active       BOOLEAN NOT NULL DEFAULT TRUE,
    UNIQUE (tenant_id, code)
);

-- Tax rate
CREATE TABLE tax.tax_rate (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL REFERENCES core.tenant(id) ON DELETE CASCADE,
    jurisdiction_id UUID NOT NULL REFERENCES tax.jurisdiction(id),
    code            TEXT NOT NULL,
    name            TEXT NOT NULL,
    rate_type       TEXT NOT NULL CHECK (rate_type IN ('percentage','fixed','compound')),
    rate            NUMERIC(9,4) NOT NULL,
    tax_component   TEXT,                         -- CGST/SGST/IGST/CESS/VAT/...
    effective_from  DATE NOT NULL,
    effective_to    DATE,
    apply_on        TEXT NOT NULL DEFAULT 'taxable' CHECK (apply_on IN ('taxable','total','pre_tax')),
    is_reverse_charge BOOLEAN NOT NULL DEFAULT FALSE,
    is_input_eligible BOOLEAN NOT NULL DEFAULT TRUE,
    gl_account_id   UUID REFERENCES finance.account(id),
    UNIQUE (tenant_id, code, effective_from)
);

-- HSN/SAC code
CREATE TABLE tax.hsn_code (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    code            TEXT NOT NULL UNIQUE,
    description     TEXT,
    default_gst_rate NUMERIC(5,2),
    is_service      BOOLEAN NOT NULL DEFAULT FALSE
);

-- Tax rule (engine input)
CREATE TABLE tax.tax_rule (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL REFERENCES core.tenant(id) ON DELETE CASCADE,
    name            TEXT NOT NULL,
    priority        INT NOT NULL DEFAULT 100,
    conditions      JSONB NOT NULL,               -- e.g. {from_state,to_state,hsn,party_type}
    tax_rate_ids    UUID[] NOT NULL,
    effective_from  DATE NOT NULL,
    effective_to    DATE,
    is_active       BOOLEAN NOT NULL DEFAULT TRUE
);

-- Tax transaction (computed tax lines, tied to any document)
CREATE TABLE tax.tax_transaction (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    company_id      UUID NOT NULL,
    doc_type        TEXT NOT NULL,                -- sales_invoice/purchase_invoice/...
    doc_id          UUID NOT NULL,
    doc_line_id     UUID,
    tax_rate_id     UUID REFERENCES tax.tax_rate(id),
    tax_component   TEXT NOT NULL,
    taxable_amount  core.money_amt NOT NULL,
    tax_amount      core.money_amt NOT NULL,
    is_input        BOOLEAN NOT NULL DEFAULT FALSE,
    is_reverse_charge BOOLEAN NOT NULL DEFAULT FALSE,
    jurisdiction_id UUID REFERENCES tax.jurisdiction(id),
    posting_date    DATE NOT NULL,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
) PARTITION BY RANGE (posting_date);
CREATE TABLE tax.tax_transaction_default PARTITION OF tax.tax_transaction DEFAULT;

-- GST-specific: e-Invoice
CREATE TABLE tax.einvoice (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    company_id      UUID NOT NULL,
    sales_invoice_id UUID NOT NULL,
    irn             TEXT UNIQUE,
    ack_no          TEXT,
    ack_date        TIMESTAMPTZ,
    qr_code         TEXT,
    signed_invoice  TEXT,
    status          TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending','generated','cancelled','failed')),
    raw_response    JSONB,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- e-Way Bill
CREATE TABLE tax.eway_bill (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    company_id      UUID NOT NULL,
    doc_type        TEXT NOT NULL,                -- sales_invoice/delivery
    doc_id          UUID NOT NULL,
    ewb_no          TEXT UNIQUE,
    ewb_date        TIMESTAMPTZ,
    valid_upto      TIMESTAMPTZ,
    status          TEXT NOT NULL DEFAULT 'pending',
    transporter_id  TEXT,
    vehicle_no      TEXT,
    distance_km     INT,
    raw_response    JSONB
);

-- TDS
CREATE TABLE tax.tds_section (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    section_code    TEXT NOT NULL UNIQUE,         -- 194C, 194J, ...
    description     TEXT NOT NULL,
    default_rate    NUMERIC(5,2) NOT NULL,
    threshold_limit core.money_amt DEFAULT 0
);

CREATE TABLE tax.tds_entry (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    company_id      UUID NOT NULL,
    deductee_type   core.party_type NOT NULL,
    deductee_id     UUID NOT NULL,
    section_id      UUID NOT NULL REFERENCES tax.tds_section(id),
    doc_type        TEXT NOT NULL,
    doc_id          UUID NOT NULL,
    gross_amount    core.money_amt NOT NULL,
    tds_rate        NUMERIC(5,2) NOT NULL,
    tds_amount      core.money_amt NOT NULL,
    deduction_date  DATE NOT NULL,
    challan_id      UUID,
    certificate_no  TEXT,
    status          TEXT DEFAULT 'pending'
);

-- GST reconciliation (2A/2B vs purchase)
CREATE TABLE tax.gstr2_data (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    company_id      UUID NOT NULL,
    return_period   CHAR(6) NOT NULL,             -- 'MMYYYY'
    gstin_supplier  TEXT NOT NULL,
    invoice_no      TEXT NOT NULL,
    invoice_date    DATE NOT NULL,
    taxable_value   core.money_amt,
    igst            core.money_amt,
    cgst            core.money_amt,
    sgst            core.money_amt,
    cess            core.money_amt,
    matched_pi_id   UUID,
    match_status    TEXT DEFAULT 'unmatched',
    source          TEXT NOT NULL CHECK (source IN ('2a','2b')),
    imported_at     TIMESTAMPTZ DEFAULT NOW()
);

-- ITC ledger
CREATE TABLE tax.itc_ledger (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    company_id      UUID NOT NULL,
    txn_date        DATE NOT NULL,
    tax_component   TEXT NOT NULL,
    debit           core.money_amt,
    credit          core.money_amt,
    reference_type  TEXT,
    reference_id    UUID
);

-- Regulatory filing calendar
CREATE TABLE tax.filing_calendar (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    company_id      UUID NOT NULL,
    form_code       TEXT NOT NULL,                -- GSTR-1, GSTR-3B, TDS-24Q, ...
    period          TEXT NOT NULL,                -- '2026-04', 'Q1-2026'
    due_date        DATE NOT NULL,
    status          tax.filing_status NOT NULL DEFAULT 'pending',
    filed_on        DATE,
    arn_no          TEXT,
    late_fee        core.money_amt DEFAULT 0,
    interest        core.money_amt DEFAULT 0,
    UNIQUE (company_id, form_code, period)
);

-- Penalty & interest tracking
CREATE TABLE tax.penalty_entry (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    company_id      UUID NOT NULL,
    filing_id       UUID REFERENCES tax.filing_calendar(id),
    penalty_type    TEXT NOT NULL,
    amount          core.money_amt NOT NULL,
    imposed_on      DATE NOT NULL,
    paid_on         DATE,
    je_id           UUID REFERENCES finance.journal_entry(id)
);

-- =====================================================================
-- INDEXES
-- =====================================================================
CREATE INDEX idx_tax_rate_juris_effect   ON tax.tax_rate(jurisdiction_id, effective_from DESC);
CREATE INDEX idx_tax_txn_doc             ON tax.tax_transaction(doc_type, doc_id);
CREATE INDEX idx_tax_txn_company_date    ON tax.tax_transaction(company_id, posting_date);
CREATE INDEX idx_einvoice_si             ON tax.einvoice(sales_invoice_id);
CREATE INDEX idx_eway_doc                ON tax.eway_bill(doc_type, doc_id);
CREATE INDEX idx_tds_entry_deductee      ON tax.tds_entry(deductee_type, deductee_id);
CREATE INDEX idx_gstr2_period            ON tax.gstr2_data(company_id, return_period, match_status);
CREATE INDEX idx_filing_due              ON tax.filing_calendar(company_id, due_date) WHERE status = 'pending';

-- =====================================================================
-- FUNCTIONS
-- =====================================================================

-- Calculate tax for a line
CREATE OR REPLACE FUNCTION tax.fn_calc_tax(
    p_tenant UUID, p_company UUID, p_from_state TEXT, p_to_state TEXT,
    p_hsn TEXT, p_amount core.money_amt, p_date DATE DEFAULT CURRENT_DATE
) RETURNS TABLE (tax_rate_id UUID, component TEXT, rate NUMERIC, tax_amount core.money_amt) AS $$
DECLARE
    v_rule RECORD;
BEGIN
    FOR v_rule IN
        SELECT tr.*
          FROM tax.tax_rule tr
         WHERE tr.tenant_id = p_tenant AND tr.is_active
           AND tr.effective_from <= p_date
           AND (tr.effective_to IS NULL OR tr.effective_to >= p_date)
           AND (tr.conditions->>'hsn_prefix' IS NULL OR p_hsn LIKE (tr.conditions->>'hsn_prefix')||'%')
           AND (tr.conditions->>'from_state' IS NULL OR tr.conditions->>'from_state' = p_from_state)
           AND (tr.conditions->>'to_state'   IS NULL OR tr.conditions->>'to_state'   = p_to_state)
         ORDER BY tr.priority
         LIMIT 1
    LOOP
        RETURN QUERY
        SELECT tr.id, tr.tax_component, tr.rate,
               ROUND(p_amount * tr.rate / 100, 4)::core.money_amt
          FROM tax.tax_rate tr
         WHERE tr.id = ANY (v_rule.tax_rate_ids);
    END LOOP;
END;
$$ LANGUAGE plpgsql STABLE;

-- ITC eligibility check
CREATE OR REPLACE FUNCTION tax.fn_itc_eligible(p_tax_txn UUID)
RETURNS BOOLEAN AS $$
    SELECT tr.is_input_eligible
      FROM tax.tax_transaction tt JOIN tax.tax_rate tr ON tr.id = tt.tax_rate_id
     WHERE tt.id = p_tax_txn;
$$ LANGUAGE sql STABLE;

-- =====================================================================
-- VIEWS
-- =====================================================================
CREATE OR REPLACE VIEW tax.v_gstr1_summary AS
SELECT company_id, to_char(posting_date,'MMYYYY') AS period,
       tax_component, SUM(taxable_amount) taxable, SUM(tax_amount) tax
  FROM tax.tax_transaction
 WHERE doc_type IN ('sales_invoice','credit_note') AND NOT is_input
 GROUP BY company_id, to_char(posting_date,'MMYYYY'), tax_component;

CREATE OR REPLACE VIEW tax.v_gstr3b_summary AS
SELECT company_id, to_char(posting_date,'MMYYYY') AS period,
       SUM(CASE WHEN NOT is_input THEN tax_amount ELSE 0 END) AS output_tax,
       SUM(CASE WHEN is_input THEN tax_amount ELSE 0 END) AS input_tax,
       SUM(CASE WHEN NOT is_input THEN tax_amount ELSE 0 END) -
       SUM(CASE WHEN is_input THEN tax_amount ELSE 0 END) AS net_payable
  FROM tax.tax_transaction
 GROUP BY company_id, to_char(posting_date,'MMYYYY');

-- =====================================================================
-- TRIGGERS
-- =====================================================================
CREATE TRIGGER trg_tax_rate_audit AFTER INSERT OR UPDATE OR DELETE ON tax.tax_rate
    FOR EACH ROW EXECUTE FUNCTION audit.fn_row_audit();
CREATE TRIGGER trg_einvoice_audit AFTER INSERT OR UPDATE OR DELETE ON tax.einvoice
    FOR EACH ROW EXECUTE FUNCTION audit.fn_row_audit();
