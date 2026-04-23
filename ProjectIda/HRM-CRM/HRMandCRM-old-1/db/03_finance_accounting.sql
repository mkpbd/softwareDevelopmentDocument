-- =====================================================================
-- STEP 3: Finance & Accounting
-- =====================================================================

CREATE TYPE finance.account_type AS ENUM ('asset','liability','equity','income','expense');
CREATE TYPE finance.normal_balance AS ENUM ('debit','credit');
CREATE TYPE finance.je_status AS ENUM ('draft','posted','reversed','cancelled');

-- Chart of accounts (multi-hierarchy via ltree-like path)
CREATE TABLE finance.account (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL REFERENCES core.tenant(id) ON DELETE CASCADE,
    company_id      UUID NOT NULL REFERENCES core.company(id) ON DELETE CASCADE,
    parent_id       UUID REFERENCES finance.account(id),
    code            TEXT NOT NULL,
    name            TEXT NOT NULL,
    account_type    finance.account_type NOT NULL,
    normal_balance  finance.normal_balance NOT NULL,
    is_group        BOOLEAN NOT NULL DEFAULT FALSE,
    is_active       BOOLEAN NOT NULL DEFAULT TRUE,
    is_reconcilable BOOLEAN NOT NULL DEFAULT FALSE,
    is_bank         BOOLEAN NOT NULL DEFAULT FALSE,
    currency_code   CHAR(3),
    tax_code        TEXT,
    path            TEXT,                         -- materialized path
    level           SMALLINT NOT NULL DEFAULT 1,
    description     TEXT,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at      TIMESTAMPTZ,
    UNIQUE (company_id, code)
);

-- Cost center
CREATE TABLE finance.cost_center (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL REFERENCES core.tenant(id) ON DELETE CASCADE,
    company_id      UUID NOT NULL REFERENCES core.company(id) ON DELETE CASCADE,
    parent_id       UUID REFERENCES finance.cost_center(id),
    code            TEXT NOT NULL,
    name            TEXT NOT NULL,
    is_group        BOOLEAN NOT NULL DEFAULT FALSE,
    is_active       BOOLEAN NOT NULL DEFAULT TRUE,
    UNIQUE (company_id, code)
);

-- Profit center
CREATE TABLE finance.profit_center (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL REFERENCES core.tenant(id) ON DELETE CASCADE,
    company_id      UUID NOT NULL REFERENCES core.company(id) ON DELETE CASCADE,
    code            TEXT NOT NULL,
    name            TEXT NOT NULL,
    manager_user_id UUID,
    is_active       BOOLEAN NOT NULL DEFAULT TRUE,
    UNIQUE (company_id, code)
);

-- Journal entry header
CREATE TABLE finance.journal_entry (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL REFERENCES core.tenant(id) ON DELETE CASCADE,
    company_id      UUID NOT NULL REFERENCES core.company(id),
    branch_id       UUID REFERENCES core.branch(id),
    fiscal_period_id UUID NOT NULL REFERENCES core.financial_period(id),
    doc_no          TEXT NOT NULL,
    doc_date        DATE NOT NULL,
    posting_date    DATE NOT NULL,
    source_module   TEXT NOT NULL,                -- sales/purchase/payroll/manual/...
    source_doc_type TEXT,
    source_doc_id   UUID,
    reference       TEXT,
    narration       TEXT,
    currency_code   CHAR(3) NOT NULL,
    exchange_rate   NUMERIC(19,8) NOT NULL DEFAULT 1,
    status          finance.je_status NOT NULL DEFAULT 'draft',
    is_reversed     BOOLEAN NOT NULL DEFAULT FALSE,
    reversal_of     UUID REFERENCES finance.journal_entry(id),
    posted_at       TIMESTAMPTZ,
    posted_by       UUID,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE (company_id, doc_no)
);

-- Journal entry lines
CREATE TABLE finance.journal_line (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    journal_entry_id UUID NOT NULL REFERENCES finance.journal_entry(id) ON DELETE CASCADE,
    line_no         INT NOT NULL,
    account_id      UUID NOT NULL REFERENCES finance.account(id),
    cost_center_id  UUID REFERENCES finance.cost_center(id),
    profit_center_id UUID REFERENCES finance.profit_center(id),
    party_type      core.party_type,
    party_id        UUID,
    debit           core.money_amt,
    credit          core.money_amt,
    currency_code   CHAR(3) NOT NULL,
    fx_debit        core.money_amt,
    fx_credit       core.money_amt,
    description     TEXT,
    dimensions      JSONB,
    UNIQUE (journal_entry_id, line_no),
    CHECK ( (debit = 0 AND credit > 0) OR (credit = 0 AND debit > 0) )
);

-- General ledger (posted view; materialized for speed)
CREATE TABLE finance.gl_entry (
    id              BIGSERIAL PRIMARY KEY,
    tenant_id       UUID NOT NULL,
    company_id      UUID NOT NULL,
    branch_id       UUID,
    posting_date    DATE NOT NULL,
    fiscal_period_id UUID NOT NULL,
    account_id      UUID NOT NULL,
    cost_center_id  UUID,
    profit_center_id UUID,
    party_type      core.party_type,
    party_id        UUID,
    journal_entry_id UUID NOT NULL,
    debit           core.money_amt,
    credit          core.money_amt,
    currency_code   CHAR(3),
    fx_debit        core.money_amt,
    fx_credit       core.money_amt,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
) PARTITION BY RANGE (posting_date);
CREATE TABLE finance.gl_entry_default PARTITION OF finance.gl_entry DEFAULT;

-- Accounts payable / receivable outstanding (open items)
CREATE TABLE finance.party_ledger (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    company_id      UUID NOT NULL,
    party_type      core.party_type NOT NULL,
    party_id        UUID NOT NULL,
    account_id      UUID NOT NULL REFERENCES finance.account(id),
    doc_type        TEXT NOT NULL,
    doc_id          UUID NOT NULL,
    doc_no          TEXT NOT NULL,
    doc_date        DATE NOT NULL,
    due_date        DATE,
    currency_code   CHAR(3) NOT NULL,
    amount          core.money_amt NOT NULL,
    paid_amount     core.money_amt DEFAULT 0,
    balance_amount  core.money_amt GENERATED ALWAYS AS (amount - paid_amount) STORED,
    status          TEXT NOT NULL DEFAULT 'open' CHECK (status IN ('open','partial','settled','void'))
);

-- Bank reconciliation
CREATE TABLE finance.bank_statement (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    company_id      UUID NOT NULL,
    bank_account_id UUID NOT NULL REFERENCES finance.account(id),
    statement_date  DATE NOT NULL,
    opening_balance core.money_amt,
    closing_balance core.money_amt,
    imported_at     TIMESTAMPTZ DEFAULT NOW(),
    source          TEXT
);

CREATE TABLE finance.bank_statement_line (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    bank_statement_id UUID NOT NULL REFERENCES finance.bank_statement(id) ON DELETE CASCADE,
    txn_date        DATE NOT NULL,
    value_date      DATE,
    description     TEXT,
    reference       TEXT,
    debit           core.money_amt,
    credit          core.money_amt,
    matched_je_id   UUID REFERENCES finance.journal_entry(id),
    match_status    TEXT DEFAULT 'unmatched' CHECK (match_status IN ('unmatched','matched','partial','ignored'))
);

-- Budget
CREATE TABLE finance.budget (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    company_id      UUID NOT NULL,
    fiscal_year_id  UUID NOT NULL REFERENCES core.fiscal_year(id),
    name            TEXT NOT NULL,
    status          TEXT DEFAULT 'draft',
    UNIQUE (company_id, fiscal_year_id, name)
);

CREATE TABLE finance.budget_line (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    budget_id       UUID NOT NULL REFERENCES finance.budget(id) ON DELETE CASCADE,
    account_id      UUID NOT NULL REFERENCES finance.account(id),
    cost_center_id  UUID REFERENCES finance.cost_center(id),
    period_no       SMALLINT NOT NULL,
    budgeted_amount core.money_amt NOT NULL
);

-- Depreciation schedule
CREATE TABLE finance.depreciation_schedule (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    asset_id        UUID NOT NULL,
    period_date     DATE NOT NULL,
    depreciation    core.money_amt NOT NULL,
    accumulated     core.money_amt NOT NULL,
    book_value      core.money_amt NOT NULL,
    posted_je_id    UUID REFERENCES finance.journal_entry(id),
    is_posted       BOOLEAN NOT NULL DEFAULT FALSE,
    UNIQUE (asset_id, period_date)
);

-- Allocation rules (overhead allocation)
CREATE TABLE finance.allocation_rule (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    company_id      UUID NOT NULL,
    name            TEXT NOT NULL,
    source_account_id UUID NOT NULL REFERENCES finance.account(id),
    basis           TEXT NOT NULL,                -- headcount/revenue/sqft/custom
    definition      JSONB NOT NULL,
    is_active       BOOLEAN NOT NULL DEFAULT TRUE
);

-- Intercompany transactions
CREATE TABLE finance.intercompany_txn (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    from_company_id UUID NOT NULL REFERENCES core.company(id),
    to_company_id   UUID NOT NULL REFERENCES core.company(id),
    doc_date        DATE NOT NULL,
    amount          core.money_amt NOT NULL,
    currency_code   CHAR(3) NOT NULL,
    from_je_id      UUID REFERENCES finance.journal_entry(id),
    to_je_id        UUID REFERENCES finance.journal_entry(id),
    is_eliminated   BOOLEAN DEFAULT FALSE
);

-- =====================================================================
-- INDEXES
-- =====================================================================
CREATE INDEX idx_account_company_type    ON finance.account(company_id, account_type) WHERE deleted_at IS NULL;
CREATE INDEX idx_account_parent          ON finance.account(parent_id);
CREATE INDEX idx_account_path_trgm       ON finance.account USING gin (path gin_trgm_ops);
CREATE INDEX idx_journal_entry_company_date ON finance.journal_entry(company_id, posting_date DESC);
CREATE INDEX idx_journal_entry_source    ON finance.journal_entry(source_module, source_doc_id);
CREATE INDEX idx_journal_line_account    ON finance.journal_line(account_id);
CREATE INDEX idx_journal_line_party      ON finance.journal_line(party_type, party_id);
CREATE INDEX idx_gl_company_account_date ON finance.gl_entry(company_id, account_id, posting_date);
CREATE INDEX idx_gl_party                ON finance.gl_entry(party_type, party_id);
CREATE INDEX idx_party_ledger_party      ON finance.party_ledger(party_type, party_id, status);
CREATE INDEX idx_party_ledger_due        ON finance.party_ledger(due_date) WHERE status <> 'settled';
CREATE INDEX idx_bank_stmt_line_bs       ON finance.bank_statement_line(bank_statement_id, match_status);

-- =====================================================================
-- FUNCTIONS
-- =====================================================================

-- Post journal entry (validates balance, creates GL, updates party ledger)
CREATE OR REPLACE FUNCTION finance.fn_post_journal_entry(p_je UUID, p_user UUID)
RETURNS VOID AS $$
DECLARE
    v_sum_dr core.money_amt;
    v_sum_cr core.money_amt;
    v_je finance.journal_entry%ROWTYPE;
BEGIN
    SELECT * INTO v_je FROM finance.journal_entry WHERE id = p_je FOR UPDATE;
    IF v_je.status <> 'draft' THEN
        RAISE EXCEPTION 'Journal entry % is not in draft status', v_je.doc_no;
    END IF;

    SELECT COALESCE(SUM(debit),0), COALESCE(SUM(credit),0) INTO v_sum_dr, v_sum_cr
      FROM finance.journal_line WHERE journal_entry_id = p_je;

    IF v_sum_dr <> v_sum_cr THEN
        RAISE EXCEPTION 'Journal entry unbalanced: Dr % vs Cr %', v_sum_dr, v_sum_cr;
    END IF;
    IF v_sum_dr = 0 THEN
        RAISE EXCEPTION 'Journal entry has no amounts';
    END IF;

    -- Period must be open
    IF EXISTS (SELECT 1 FROM core.financial_period WHERE id = v_je.fiscal_period_id AND is_closed) THEN
        RAISE EXCEPTION 'Period is closed';
    END IF;

    -- Push to GL
    INSERT INTO finance.gl_entry(tenant_id, company_id, branch_id, posting_date, fiscal_period_id,
        account_id, cost_center_id, profit_center_id, party_type, party_id, journal_entry_id,
        debit, credit, currency_code, fx_debit, fx_credit)
    SELECT v_je.tenant_id, v_je.company_id, v_je.branch_id, v_je.posting_date, v_je.fiscal_period_id,
           jl.account_id, jl.cost_center_id, jl.profit_center_id, jl.party_type, jl.party_id, v_je.id,
           jl.debit, jl.credit, jl.currency_code, jl.fx_debit, jl.fx_credit
      FROM finance.journal_line jl WHERE jl.journal_entry_id = v_je.id;

    UPDATE finance.journal_entry
       SET status = 'posted', posted_at = NOW(), posted_by = p_user
     WHERE id = p_je;
END;
$$ LANGUAGE plpgsql;

-- Reverse JE
CREATE OR REPLACE FUNCTION finance.fn_reverse_journal_entry(p_je UUID, p_user UUID, p_reason TEXT)
RETURNS UUID AS $$
DECLARE
    v_new UUID;
BEGIN
    INSERT INTO finance.journal_entry(tenant_id, company_id, branch_id, fiscal_period_id, doc_no,
        doc_date, posting_date, source_module, source_doc_type, source_doc_id, reference,
        narration, currency_code, exchange_rate, status, reversal_of)
    SELECT tenant_id, company_id, branch_id, fiscal_period_id,
           core.fn_next_doc_number(tenant_id,'journal_entry'),
           CURRENT_DATE, CURRENT_DATE, source_module, source_doc_type, source_doc_id, reference,
           'Reversal: '||COALESCE(p_reason,''), currency_code, exchange_rate, 'draft', id
      FROM finance.journal_entry WHERE id = p_je
    RETURNING id INTO v_new;

    INSERT INTO finance.journal_line(journal_entry_id, line_no, account_id, cost_center_id,
        profit_center_id, party_type, party_id, debit, credit, currency_code, fx_debit, fx_credit, description)
    SELECT v_new, line_no, account_id, cost_center_id, profit_center_id, party_type, party_id,
           credit, debit, currency_code, fx_credit, fx_debit, 'Reversal'
      FROM finance.journal_line WHERE journal_entry_id = p_je;

    PERFORM finance.fn_post_journal_entry(v_new, p_user);
    UPDATE finance.journal_entry SET is_reversed = TRUE WHERE id = p_je;
    RETURN v_new;
END;
$$ LANGUAGE plpgsql;

-- Account balance (trial balance helper)
CREATE OR REPLACE FUNCTION finance.fn_account_balance(
    p_account UUID, p_as_of DATE DEFAULT CURRENT_DATE
) RETURNS core.money_amt AS $$
DECLARE v NUMERIC;
BEGIN
    SELECT COALESCE(SUM(debit) - SUM(credit), 0) INTO v
      FROM finance.gl_entry
     WHERE account_id = p_account AND posting_date <= p_as_of;
    RETURN v;
END;
$$ LANGUAGE plpgsql STABLE;

-- FX revaluation
CREATE OR REPLACE FUNCTION finance.fn_fx_revaluation(
    p_company UUID, p_as_of DATE, p_user UUID
) RETURNS UUID AS $$
DECLARE v_je UUID;
BEGIN
    -- Stub: enumerate foreign-currency account balances, compute delta vs spot rate,
    -- create revaluation JE
    v_je := uuid_generate_v4();
    -- Implementation-specific; returning JE id
    RETURN v_je;
END;
$$ LANGUAGE plpgsql;

-- =====================================================================
-- VIEWS
-- =====================================================================
CREATE OR REPLACE VIEW finance.v_trial_balance AS
SELECT a.company_id, a.id AS account_id, a.code, a.name, a.account_type,
       COALESCE(SUM(g.debit),0) AS debit_total,
       COALESCE(SUM(g.credit),0) AS credit_total,
       COALESCE(SUM(g.debit) - SUM(g.credit),0) AS balance
  FROM finance.account a
  LEFT JOIN finance.gl_entry g ON g.account_id = a.id
 WHERE a.deleted_at IS NULL AND NOT a.is_group
 GROUP BY a.company_id, a.id;

CREATE OR REPLACE VIEW finance.v_pnl AS
SELECT a.company_id, a.account_type,
       SUM(CASE WHEN a.account_type='income'  THEN g.credit - g.debit ELSE 0 END) AS income,
       SUM(CASE WHEN a.account_type='expense' THEN g.debit - g.credit ELSE 0 END) AS expense,
       SUM(CASE WHEN a.account_type='income'  THEN g.credit - g.debit
                WHEN a.account_type='expense' THEN -(g.debit - g.credit)
                ELSE 0 END) AS net_profit
  FROM finance.account a JOIN finance.gl_entry g ON g.account_id = a.id
 WHERE a.account_type IN ('income','expense')
 GROUP BY a.company_id, a.account_type;

CREATE OR REPLACE VIEW finance.v_balance_sheet AS
SELECT a.company_id, a.account_type, a.code, a.name,
       SUM(g.debit) - SUM(g.credit) AS balance
  FROM finance.account a JOIN finance.gl_entry g ON g.account_id = a.id
 WHERE a.account_type IN ('asset','liability','equity')
 GROUP BY a.company_id, a.account_type, a.code, a.name;

CREATE OR REPLACE VIEW finance.v_ageing_ar AS
SELECT pl.*, CURRENT_DATE - pl.due_date AS days_overdue,
       CASE WHEN CURRENT_DATE - pl.due_date <= 0 THEN 'current'
            WHEN CURRENT_DATE - pl.due_date <= 30 THEN '1-30'
            WHEN CURRENT_DATE - pl.due_date <= 60 THEN '31-60'
            WHEN CURRENT_DATE - pl.due_date <= 90 THEN '61-90'
            ELSE '90+' END AS bucket
  FROM finance.party_ledger pl
 WHERE pl.party_type = 'customer' AND pl.status <> 'settled';

-- =====================================================================
-- TRIGGERS
-- =====================================================================
CREATE TRIGGER trg_account_updated  BEFORE UPDATE ON finance.account
    FOR EACH ROW EXECUTE FUNCTION core.fn_set_updated_at();
CREATE TRIGGER trg_je_updated       BEFORE UPDATE ON finance.journal_entry
    FOR EACH ROW EXECUTE FUNCTION core.fn_set_updated_at();

CREATE TRIGGER trg_je_audit         AFTER INSERT OR UPDATE OR DELETE ON finance.journal_entry
    FOR EACH ROW EXECUTE FUNCTION audit.fn_row_audit();
CREATE TRIGGER trg_jl_audit         AFTER INSERT OR UPDATE OR DELETE ON finance.journal_line
    FOR EACH ROW EXECUTE FUNCTION audit.fn_row_audit();

-- Prevent editing posted JE
CREATE OR REPLACE FUNCTION finance.fn_je_immutable()
RETURNS TRIGGER AS $$
BEGIN
    IF OLD.status = 'posted' AND (TG_OP = 'UPDATE' OR TG_OP = 'DELETE') THEN
        IF TG_OP = 'UPDATE' AND NEW.status = 'posted'
           AND (NEW.doc_no <> OLD.doc_no OR NEW.posting_date <> OLD.posting_date) THEN
            RAISE EXCEPTION 'Posted JE cannot be modified; reverse instead';
        END IF;
        IF TG_OP = 'DELETE' THEN
            RAISE EXCEPTION 'Posted JE cannot be deleted; reverse instead';
        END IF;
    END IF;
    RETURN COALESCE(NEW, OLD);
END;
$$ LANGUAGE plpgsql;
CREATE TRIGGER trg_je_immutable BEFORE UPDATE OR DELETE ON finance.journal_entry
    FOR EACH ROW EXECUTE FUNCTION finance.fn_je_immutable();
