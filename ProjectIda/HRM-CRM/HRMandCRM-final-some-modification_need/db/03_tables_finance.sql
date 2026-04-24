-- =============================================================================
-- tables.sql — Steps 3 & 4: Finance, Accounting & Tax
-- =============================================================================

-- =============================================================================
-- STEP 3: FINANCE & ACCOUNTING
-- =============================================================================

-- Chart of Accounts
CREATE TABLE finance.chart_of_accounts (
    account_id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id           UUID         NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id           UUID         NOT NULL REFERENCES core.branches(branch_id),
    parent_account_id   UUID         REFERENCES finance.chart_of_accounts(account_id),
    account_code        VARCHAR(50)  NOT NULL,
    account_name        VARCHAR(255) NOT NULL,
    account_type        VARCHAR(50)  NOT NULL CHECK (account_type IN ('asset','liability','equity','revenue','expense','contra')),
    account_subtype     VARCHAR(100),
    normal_balance      VARCHAR(10)  NOT NULL CHECK (normal_balance IN ('debit','credit')),
    currency_code       VARCHAR(10)  NOT NULL DEFAULT 'INR',
    is_control_account  BOOLEAN      NOT NULL DEFAULT FALSE,
    is_reconcilable     BOOLEAN      NOT NULL DEFAULT FALSE,
    is_active           BOOLEAN      NOT NULL DEFAULT TRUE,
    hierarchy_level     SMALLINT     NOT NULL DEFAULT 1,
    hierarchy_path      TEXT,
    created_by          UUID         NOT NULL,
    updated_by          UUID         NOT NULL,
    deleted_by          UUID,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    deleted_at          TIMESTAMPTZ,
    UNIQUE (tenant_id, account_code)
);

-- Cost Centers
CREATE TABLE finance.cost_centers (
    cost_center_id      UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id           UUID         NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id           UUID         NOT NULL REFERENCES core.branches(branch_id),
    parent_cost_center_id UUID       REFERENCES finance.cost_centers(cost_center_id),
    cost_center_code    VARCHAR(50)  NOT NULL,
    cost_center_name    VARCHAR(255) NOT NULL,
    cost_center_type    VARCHAR(50)  NOT NULL DEFAULT 'operational',
    manager_user_id     UUID         REFERENCES iam.users(user_id),
    budget_amount       NUMERIC(20,2),
    is_active           BOOLEAN      NOT NULL DEFAULT TRUE,
    created_by          UUID         NOT NULL,
    updated_by          UUID         NOT NULL,
    deleted_by          UUID,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    deleted_at          TIMESTAMPTZ,
    UNIQUE (tenant_id, cost_center_code)
);

-- Profit Centers
CREATE TABLE finance.profit_centers (
    profit_center_id    UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id           UUID         NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id           UUID         NOT NULL REFERENCES core.branches(branch_id),
    parent_profit_center_id UUID     REFERENCES finance.profit_centers(profit_center_id),
    profit_center_code  VARCHAR(50)  NOT NULL,
    profit_center_name  VARCHAR(255) NOT NULL,
    manager_user_id     UUID         REFERENCES iam.users(user_id),
    is_active           BOOLEAN      NOT NULL DEFAULT TRUE,
    created_by          UUID         NOT NULL,
    updated_by          UUID         NOT NULL,
    deleted_by          UUID,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    deleted_at          TIMESTAMPTZ,
    UNIQUE (tenant_id, profit_center_code)
);

-- General Ledger (Journal Entries header)
CREATE TABLE finance.journal_entries (
    journal_entry_id    UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id           UUID         NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id           UUID         NOT NULL REFERENCES core.branches(branch_id),
    entry_number        VARCHAR(50)  NOT NULL,
    fiscal_year_id      UUID         NOT NULL REFERENCES core.fiscal_years(fiscal_year_id),
    financial_period_id UUID         NOT NULL REFERENCES core.financial_periods(financial_period_id),
    entry_date          DATE         NOT NULL,
    posting_date        DATE         NOT NULL,
    entry_type          VARCHAR(50)  NOT NULL CHECK (entry_type IN ('manual','system','opening','closing','accrual','reversal','intercompany')),
    source_document_type VARCHAR(100),
    source_document_id  UUID,
    source_document_number VARCHAR(100),
    narration           TEXT,
    reference_number    VARCHAR(100),
    currency_code       VARCHAR(10)  NOT NULL DEFAULT 'INR',
    exchange_rate       NUMERIC(20,8) NOT NULL DEFAULT 1,
    total_debit         NUMERIC(20,2) NOT NULL DEFAULT 0,
    total_credit        NUMERIC(20,2) NOT NULL DEFAULT 0,
    status              VARCHAR(20)  NOT NULL DEFAULT 'draft' CHECK (status IN ('draft','posted','cancelled','reversed')),
    is_reversed         BOOLEAN      NOT NULL DEFAULT FALSE,
    reversed_by_entry_id UUID        REFERENCES finance.journal_entries(journal_entry_id),
    posted_at           TIMESTAMPTZ,
    posted_by           UUID,
    approved_at         TIMESTAMPTZ,
    approved_by         UUID,
    created_by          UUID         NOT NULL,
    updated_by          UUID         NOT NULL,
    deleted_by          UUID,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    deleted_at          TIMESTAMPTZ,
    UNIQUE (tenant_id, branch_id, entry_number),
    CHECK (total_debit = total_credit OR status = 'draft')
);

-- Journal Entry Lines
CREATE TABLE finance.journal_entry_lines (
    journal_entry_line_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id             UUID        NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id             UUID        NOT NULL REFERENCES core.branches(branch_id),
    journal_entry_id      UUID        NOT NULL REFERENCES finance.journal_entries(journal_entry_id),
    line_number           SMALLINT    NOT NULL,
    account_id            UUID        NOT NULL REFERENCES finance.chart_of_accounts(account_id),
    cost_center_id        UUID        REFERENCES finance.cost_centers(cost_center_id),
    profit_center_id      UUID        REFERENCES finance.profit_centers(profit_center_id),
    debit_amount          NUMERIC(20,2) NOT NULL DEFAULT 0 CHECK (debit_amount >= 0),
    credit_amount         NUMERIC(20,2) NOT NULL DEFAULT 0 CHECK (credit_amount >= 0),
    base_debit_amount     NUMERIC(20,2) NOT NULL DEFAULT 0,
    base_credit_amount    NUMERIC(20,2) NOT NULL DEFAULT 0,
    narration             TEXT,
    partner_type          VARCHAR(50),
    partner_id            UUID,
    created_by            UUID        NOT NULL,
    updated_by            UUID        NOT NULL,
    deleted_by            UUID,
    created_at            TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at            TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at            TIMESTAMPTZ,
    UNIQUE (tenant_id, journal_entry_id, line_number),
    CHECK (debit_amount = 0 OR credit_amount = 0)
);

-- Bank Accounts
CREATE TABLE finance.bank_accounts (
    bank_account_id     UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id           UUID         NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id           UUID         NOT NULL REFERENCES core.branches(branch_id),
    gl_account_id       UUID         NOT NULL REFERENCES finance.chart_of_accounts(account_id),
    bank_name           VARCHAR(255) NOT NULL,
    account_name        VARCHAR(255) NOT NULL,
    account_number      VARCHAR(100) NOT NULL,
    ifsc_code           VARCHAR(20),
    swift_code          VARCHAR(20),
    bank_branch         VARCHAR(255),
    currency_code       VARCHAR(10)  NOT NULL DEFAULT 'INR',
    account_type        VARCHAR(50)  NOT NULL DEFAULT 'current' CHECK (account_type IN ('current','savings','overdraft','cash_credit','fixed_deposit')),
    opening_balance     NUMERIC(20,2) NOT NULL DEFAULT 0,
    current_balance     NUMERIC(20,2) NOT NULL DEFAULT 0,
    last_reconciled_at  TIMESTAMPTZ,
    last_reconciled_balance NUMERIC(20,2),
    is_active           BOOLEAN      NOT NULL DEFAULT TRUE,
    created_by          UUID         NOT NULL,
    updated_by          UUID         NOT NULL,
    deleted_by          UUID,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    deleted_at          TIMESTAMPTZ,
    UNIQUE (tenant_id, account_number)
);

-- Bank Reconciliation
CREATE TABLE finance.bank_reconciliations (
    bank_reconciliation_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id              UUID        NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id              UUID        NOT NULL REFERENCES core.branches(branch_id),
    bank_account_id        UUID        NOT NULL REFERENCES finance.bank_accounts(bank_account_id),
    reconciliation_date    DATE        NOT NULL,
    statement_opening_balance NUMERIC(20,2) NOT NULL,
    statement_closing_balance NUMERIC(20,2) NOT NULL,
    book_balance           NUMERIC(20,2) NOT NULL,
    difference             NUMERIC(20,2) NOT NULL DEFAULT 0,
    status                 VARCHAR(20) NOT NULL DEFAULT 'in_progress' CHECK (status IN ('in_progress','completed','approved')),
    completed_at           TIMESTAMPTZ,
    approved_at            TIMESTAMPTZ,
    approved_by            UUID,
    notes                  TEXT,
    created_by             UUID        NOT NULL,
    updated_by             UUID        NOT NULL,
    deleted_by             UUID,
    created_at             TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at             TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at             TIMESTAMPTZ
);

-- Budgets
CREATE TABLE finance.budgets (
    budget_id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id           UUID         NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id           UUID         NOT NULL REFERENCES core.branches(branch_id),
    fiscal_year_id      UUID         NOT NULL REFERENCES core.fiscal_years(fiscal_year_id),
    budget_name         VARCHAR(255) NOT NULL,
    budget_type         VARCHAR(50)  NOT NULL DEFAULT 'annual' CHECK (budget_type IN ('annual','quarterly','monthly','project')),
    status              VARCHAR(20)  NOT NULL DEFAULT 'draft' CHECK (status IN ('draft','submitted','approved','active','closed')),
    total_amount        NUMERIC(20,2) NOT NULL DEFAULT 0,
    approved_at         TIMESTAMPTZ,
    approved_by         UUID,
    created_by          UUID         NOT NULL,
    updated_by          UUID         NOT NULL,
    deleted_by          UUID,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    deleted_at          TIMESTAMPTZ
);

-- Budget Lines
CREATE TABLE finance.budget_lines (
    budget_line_id      UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id           UUID         NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id           UUID         NOT NULL REFERENCES core.branches(branch_id),
    budget_id           UUID         NOT NULL REFERENCES finance.budgets(budget_id),
    account_id          UUID         NOT NULL REFERENCES finance.chart_of_accounts(account_id),
    cost_center_id      UUID         REFERENCES finance.cost_centers(cost_center_id),
    financial_period_id UUID         REFERENCES core.financial_periods(financial_period_id),
    budgeted_amount     NUMERIC(20,2) NOT NULL DEFAULT 0,
    actual_amount       NUMERIC(20,2) NOT NULL DEFAULT 0,
    variance_amount     NUMERIC(20,2) GENERATED ALWAYS AS (budgeted_amount - actual_amount) STORED,
    created_by          UUID         NOT NULL,
    updated_by          UUID         NOT NULL,
    deleted_by          UUID,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    deleted_at          TIMESTAMPTZ
);

-- Depreciation Schedule
CREATE TABLE finance.depreciation_schedules (
    depreciation_schedule_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id                UUID        NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id                UUID        NOT NULL REFERENCES core.branches(branch_id),
    asset_id                 UUID        NOT NULL, -- FK to assets.assets (circular ref avoided via app)
    depreciation_method      VARCHAR(50) NOT NULL CHECK (depreciation_method IN ('straight_line','declining_balance','double_declining','units_of_production','sum_of_years')),
    asset_value              NUMERIC(20,2) NOT NULL,
    salvage_value            NUMERIC(20,2) NOT NULL DEFAULT 0,
    useful_life_months       INTEGER     NOT NULL,
    depreciation_rate        NUMERIC(10,4),
    start_date               DATE        NOT NULL,
    is_active                BOOLEAN     NOT NULL DEFAULT TRUE,
    created_by               UUID        NOT NULL,
    updated_by               UUID        NOT NULL,
    deleted_by               UUID,
    created_at               TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at               TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at               TIMESTAMPTZ
);

-- =============================================================================
-- STEP 4: TAX & COMPLIANCE
-- =============================================================================

-- Tax Rates
CREATE TABLE tax.tax_rates (
    tax_rate_id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id           UUID         NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id           UUID         NOT NULL REFERENCES core.branches(branch_id),
    tax_code            VARCHAR(50)  NOT NULL,
    tax_name            VARCHAR(200) NOT NULL,
    tax_type            VARCHAR(50)  NOT NULL CHECK (tax_type IN ('gst','vat','sales_tax','withholding','tds','service_tax','custom')),
    country_code        VARCHAR(10)  NOT NULL DEFAULT 'IN',
    rate_percentage     NUMERIC(8,4) NOT NULL CHECK (rate_percentage >= 0),
    cgst_rate           NUMERIC(8,4) NOT NULL DEFAULT 0,
    sgst_rate           NUMERIC(8,4) NOT NULL DEFAULT 0,
    igst_rate           NUMERIC(8,4) NOT NULL DEFAULT 0,
    cess_rate           NUMERIC(8,4) NOT NULL DEFAULT 0,
    effective_from      DATE         NOT NULL,
    effective_until     DATE,
    is_active           BOOLEAN      NOT NULL DEFAULT TRUE,
    created_by          UUID         NOT NULL,
    updated_by          UUID         NOT NULL,
    deleted_by          UUID,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    deleted_at          TIMESTAMPTZ,
    UNIQUE (tenant_id, tax_code)
);

-- GST HSN/SAC Codes
CREATE TABLE tax.hsn_sac_codes (
    hsn_sac_code_id     UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id           UUID         NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id           UUID         NOT NULL REFERENCES core.branches(branch_id),
    code                VARCHAR(20)  NOT NULL,
    code_type           VARCHAR(10)  NOT NULL DEFAULT 'HSN' CHECK (code_type IN ('HSN','SAC')),
    description         TEXT         NOT NULL,
    gst_rate_percentage NUMERIC(8,4) NOT NULL,
    tax_rate_id         UUID         REFERENCES tax.tax_rates(tax_rate_id),
    is_active           BOOLEAN      NOT NULL DEFAULT TRUE,
    created_by          UUID         NOT NULL,
    updated_by          UUID         NOT NULL,
    deleted_by          UUID,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    deleted_at          TIMESTAMPTZ,
    UNIQUE (tenant_id, code, code_type)
);

-- E-Invoicing (IRN tracking)
CREATE TABLE tax.einvoice_records (
    einvoice_record_id  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id           UUID         NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id           UUID         NOT NULL REFERENCES core.branches(branch_id),
    source_document_type VARCHAR(100) NOT NULL,
    source_document_id  UUID         NOT NULL,
    source_document_number VARCHAR(100) NOT NULL,
    irn                 TEXT         UNIQUE,
    ack_number          TEXT,
    ack_date            TIMESTAMPTZ,
    qr_code_data        TEXT,
    signed_invoice_json JSONB,
    status              VARCHAR(20)  NOT NULL DEFAULT 'pending' CHECK (status IN ('pending','generated','cancelled','failed')),
    failure_reason      TEXT,
    cancelled_at        TIMESTAMPTZ,
    cancelled_by        UUID,
    cancel_reason       VARCHAR(255),
    created_by          UUID         NOT NULL,
    updated_by          UUID         NOT NULL,
    deleted_by          UUID,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    deleted_at          TIMESTAMPTZ
);

-- e-Way Bills
CREATE TABLE tax.eway_bills (
    eway_bill_id        UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id           UUID         NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id           UUID         NOT NULL REFERENCES core.branches(branch_id),
    eway_bill_number    VARCHAR(50)  UNIQUE,
    source_document_type VARCHAR(100) NOT NULL,
    source_document_id  UUID         NOT NULL,
    source_document_number VARCHAR(100) NOT NULL,
    supply_type         VARCHAR(20)  NOT NULL CHECK (supply_type IN ('outward','inward')),
    transaction_type    VARCHAR(50),
    from_gstin          VARCHAR(20),
    to_gstin            VARCHAR(20),
    from_address        JSONB,
    to_address          JSONB,
    total_value         NUMERIC(20,2) NOT NULL,
    hsn_code            VARCHAR(20),
    transport_mode      VARCHAR(20)  CHECK (transport_mode IN ('road','rail','air','ship')),
    transporter_id      VARCHAR(50),
    vehicle_number      VARCHAR(20),
    distance_km         INTEGER,
    valid_upto          TIMESTAMPTZ,
    status              VARCHAR(20)  NOT NULL DEFAULT 'pending' CHECK (status IN ('pending','generated','cancelled','expired')),
    generated_at        TIMESTAMPTZ,
    cancelled_at        TIMESTAMPTZ,
    cancel_reason       VARCHAR(255),
    created_by          UUID         NOT NULL,
    updated_by          UUID         NOT NULL,
    deleted_by          UUID,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    deleted_at          TIMESTAMPTZ
);

-- TDS Sections
CREATE TABLE tax.tds_sections (
    tds_section_id      UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id           UUID         NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id           UUID         NOT NULL REFERENCES core.branches(branch_id),
    section_code        VARCHAR(20)  NOT NULL,
    description         TEXT         NOT NULL,
    threshold_limit     NUMERIC(20,2) NOT NULL DEFAULT 0,
    tds_rate_individual NUMERIC(8,4) NOT NULL DEFAULT 0,
    tds_rate_company    NUMERIC(8,4) NOT NULL DEFAULT 0,
    surcharge_rate      NUMERIC(8,4) NOT NULL DEFAULT 0,
    is_active           BOOLEAN      NOT NULL DEFAULT TRUE,
    created_by          UUID         NOT NULL,
    updated_by          UUID         NOT NULL,
    deleted_by          UUID,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    deleted_at          TIMESTAMPTZ,
    UNIQUE (tenant_id, section_code)
);

-- TDS Deductions
CREATE TABLE tax.tds_deductions (
    tds_deduction_id    UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id           UUID         NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id           UUID         NOT NULL REFERENCES core.branches(branch_id),
    tds_section_id      UUID         NOT NULL REFERENCES tax.tds_sections(tds_section_id),
    source_document_type VARCHAR(100) NOT NULL,
    source_document_id  UUID         NOT NULL,
    deductee_type       VARCHAR(20)  NOT NULL CHECK (deductee_type IN ('individual','company','firm','huf')),
    deductee_id         UUID         NOT NULL,
    deductee_pan        VARCHAR(20),
    payment_amount      NUMERIC(20,2) NOT NULL,
    tds_rate            NUMERIC(8,4) NOT NULL,
    tds_amount          NUMERIC(20,2) NOT NULL,
    surcharge_amount    NUMERIC(20,2) NOT NULL DEFAULT 0,
    education_cess      NUMERIC(20,2) NOT NULL DEFAULT 0,
    total_tds           NUMERIC(20,2) NOT NULL,
    payment_date        DATE         NOT NULL,
    deposit_due_date    DATE,
    deposited_at        TIMESTAMPTZ,
    challan_number      VARCHAR(50),
    journal_entry_id    UUID         REFERENCES finance.journal_entries(journal_entry_id),
    created_by          UUID         NOT NULL,
    updated_by          UUID         NOT NULL,
    deleted_by          UUID,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    deleted_at          TIMESTAMPTZ
);

-- GST Returns
CREATE TABLE tax.gst_returns (
    gst_return_id       UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id           UUID         NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id           UUID         NOT NULL REFERENCES core.branches(branch_id),
    gstin               VARCHAR(20)  NOT NULL,
    return_type         VARCHAR(20)  NOT NULL CHECK (return_type IN ('GSTR1','GSTR2A','GSTR2B','GSTR3B','GSTR9','GSTR9C')),
    tax_period          VARCHAR(20)  NOT NULL,
    fiscal_year_id      UUID         NOT NULL REFERENCES core.fiscal_years(fiscal_year_id),
    total_taxable_value NUMERIC(20,2) NOT NULL DEFAULT 0,
    total_igst          NUMERIC(20,2) NOT NULL DEFAULT 0,
    total_cgst          NUMERIC(20,2) NOT NULL DEFAULT 0,
    total_sgst          NUMERIC(20,2) NOT NULL DEFAULT 0,
    total_cess          NUMERIC(20,2) NOT NULL DEFAULT 0,
    itc_igst            NUMERIC(20,2) NOT NULL DEFAULT 0,
    itc_cgst            NUMERIC(20,2) NOT NULL DEFAULT 0,
    itc_sgst            NUMERIC(20,2) NOT NULL DEFAULT 0,
    status              VARCHAR(20)  NOT NULL DEFAULT 'draft' CHECK (status IN ('draft','filed','revised','cancelled')),
    filing_date         DATE,
    arn_number          VARCHAR(50),
    created_by          UUID         NOT NULL,
    updated_by          UUID         NOT NULL,
    deleted_by          UUID,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    deleted_at          TIMESTAMPTZ,
    UNIQUE (tenant_id, gstin, return_type, tax_period)
);

-- Regulatory Filing Calendar
CREATE TABLE tax.regulatory_filing_calendar (
    filing_calendar_id  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id           UUID         NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id           UUID         NOT NULL REFERENCES core.branches(branch_id),
    filing_name         VARCHAR(255) NOT NULL,
    filing_type         VARCHAR(100) NOT NULL,
    country_code        VARCHAR(10)  NOT NULL DEFAULT 'IN',
    frequency           VARCHAR(20)  NOT NULL CHECK (frequency IN ('monthly','quarterly','half_yearly','annually','on_demand')),
    due_day_of_month    SMALLINT,
    applicable_from     DATE         NOT NULL,
    applicable_until    DATE,
    reminder_days_before SMALLINT   NOT NULL DEFAULT 7,
    is_active           BOOLEAN      NOT NULL DEFAULT TRUE,
    created_by          UUID         NOT NULL,
    updated_by          UUID         NOT NULL,
    deleted_by          UUID,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    deleted_at          TIMESTAMPTZ
);

-- =============================================================================
-- INDEXES — Finance & Tax
-- =============================================================================

CREATE INDEX idx_coa_tenant_type ON finance.chart_of_accounts(tenant_id, account_type) WHERE deleted_at IS NULL;
CREATE INDEX idx_coa_parent ON finance.chart_of_accounts(parent_account_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_je_tenant_date ON finance.journal_entries(tenant_id, entry_date) WHERE deleted_at IS NULL;
CREATE INDEX idx_je_status ON finance.journal_entries(tenant_id, status) WHERE deleted_at IS NULL;
CREATE INDEX idx_je_source ON finance.journal_entries(tenant_id, source_document_type, source_document_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_jel_account ON finance.journal_entry_lines(account_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_jel_entry ON finance.journal_entry_lines(journal_entry_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_budgets_fy ON finance.budgets(tenant_id, fiscal_year_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_tax_rates_type ON tax.tax_rates(tenant_id, tax_type) WHERE deleted_at IS NULL;
CREATE INDEX idx_einvoice_irn ON tax.einvoice_records(irn) WHERE irn IS NOT NULL;
CREATE INDEX idx_tds_deductions_date ON tax.tds_deductions(tenant_id, payment_date) WHERE deleted_at IS NULL;
CREATE INDEX idx_gst_returns_period ON tax.gst_returns(tenant_id, gstin, tax_period) WHERE deleted_at IS NULL;

-- =============================================================================
-- MINIMAL DUMMY DATA — Finance & Tax
-- =============================================================================

DO $$
DECLARE
    v_tenant_id   UUID := 'a0000000-0000-0000-0000-000000000001';
    v_branch_id   UUID := 'b0000000-0000-0000-0000-000000000001';
    v_system_user UUID := '00000000-0000-0000-0000-000000000001';
    v_fy_id       UUID := 'f0000000-0000-0000-0000-000000000001';
    v_period_id   UUID;
BEGIN
    -- Chart of Accounts
    INSERT INTO finance.chart_of_accounts (tenant_id, branch_id, account_code, account_name, account_type, normal_balance, created_by, updated_by)
    VALUES
        (v_tenant_id, v_branch_id, '1000', 'Assets', 'asset', 'debit', v_system_user, v_system_user),
        (v_tenant_id, v_branch_id, '1100', 'Current Assets', 'asset', 'debit', v_system_user, v_system_user),
        (v_tenant_id, v_branch_id, '1110', 'Cash and Cash Equivalents', 'asset', 'debit', v_system_user, v_system_user),
        (v_tenant_id, v_branch_id, '1200', 'Accounts Receivable', 'asset', 'debit', v_system_user, v_system_user),
        (v_tenant_id, v_branch_id, '2000', 'Liabilities', 'liability', 'credit', v_system_user, v_system_user),
        (v_tenant_id, v_branch_id, '2100', 'Accounts Payable', 'liability', 'credit', v_system_user, v_system_user),
        (v_tenant_id, v_branch_id, '3000', 'Equity', 'equity', 'credit', v_system_user, v_system_user),
        (v_tenant_id, v_branch_id, '4000', 'Revenue', 'revenue', 'credit', v_system_user, v_system_user),
        (v_tenant_id, v_branch_id, '4100', 'Sales Revenue', 'revenue', 'credit', v_system_user, v_system_user),
        (v_tenant_id, v_branch_id, '5000', 'Expenses', 'expense', 'debit', v_system_user, v_system_user),
        (v_tenant_id, v_branch_id, '5100', 'Cost of Goods Sold', 'expense', 'debit', v_system_user, v_system_user)
    ON CONFLICT DO NOTHING;

    -- Financial Periods for FY2026
    FOR i IN 1..12 LOOP
        INSERT INTO core.financial_periods (tenant_id, branch_id, fiscal_year_id, period_number, period_name,
            start_date, end_date, created_by, updated_by)
        VALUES (
            v_tenant_id, v_branch_id, v_fy_id, i,
            TO_CHAR(('2025-03-01'::DATE + (i || ' months')::INTERVAL), 'Mon YYYY'),
            ('2025-03-01'::DATE + (i || ' months')::INTERVAL)::DATE,
            ('2025-04-01'::DATE + (i || ' months')::INTERVAL - INTERVAL '1 day')::DATE,
            v_system_user, v_system_user
        ) ON CONFLICT DO NOTHING;
    END LOOP;

    -- GST Tax Rates
    INSERT INTO tax.tax_rates (tenant_id, branch_id, tax_code, tax_name, tax_type, rate_percentage, cgst_rate, sgst_rate, igst_rate, effective_from, created_by, updated_by)
    VALUES
        (v_tenant_id, v_branch_id, 'GST0',   'GST 0%',   'gst', 0,  0,  0,  0,  '2017-07-01', v_system_user, v_system_user),
        (v_tenant_id, v_branch_id, 'GST5',   'GST 5%',   'gst', 5,  2.5, 2.5, 5, '2017-07-01', v_system_user, v_system_user),
        (v_tenant_id, v_branch_id, 'GST12',  'GST 12%',  'gst', 12, 6,  6,  12, '2017-07-01', v_system_user, v_system_user),
        (v_tenant_id, v_branch_id, 'GST18',  'GST 18%',  'gst', 18, 9,  9,  18, '2017-07-01', v_system_user, v_system_user),
        (v_tenant_id, v_branch_id, 'GST28',  'GST 28%',  'gst', 28, 14, 14, 28, '2017-07-01', v_system_user, v_system_user)
    ON CONFLICT DO NOTHING;

    -- TDS Sections
    INSERT INTO tax.tds_sections (tenant_id, branch_id, section_code, description, threshold_limit, tds_rate_individual, tds_rate_company, created_by, updated_by)
    VALUES
        (v_tenant_id, v_branch_id, '194C',  'Payment to Contractors',        30000,  1, 2, v_system_user, v_system_user),
        (v_tenant_id, v_branch_id, '194J',  'Professional/Technical Fees',   30000, 10, 10, v_system_user, v_system_user),
        (v_tenant_id, v_branch_id, '194I',  'Rent',                         240000, 10, 10, v_system_user, v_system_user),
        (v_tenant_id, v_branch_id, '192',   'Salary',                            0,  0,  0, v_system_user, v_system_user)
    ON CONFLICT DO NOTHING;
END $$;
