-- =====================================================================
-- STEP 14: Payroll
-- =====================================================================

CREATE TABLE payroll.salary_component (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    code            TEXT NOT NULL,
    name            TEXT NOT NULL,
    component_type  TEXT NOT NULL CHECK (component_type IN ('earning','deduction','reimbursement','employer_contribution','statutory','loan','advance','tax')),
    is_taxable      BOOLEAN DEFAULT TRUE,
    is_statutory    BOOLEAN DEFAULT FALSE,
    is_pf_applicable BOOLEAN DEFAULT FALSE,
    is_esi_applicable BOOLEAN DEFAULT FALSE,
    is_gratuity_applicable BOOLEAN DEFAULT FALSE,
    formula         TEXT,                         -- e.g. 'basic*0.4'
    default_amount  core.money_amt,
    gl_account_id   UUID REFERENCES finance.account(id),
    sequence_no     INT,
    UNIQUE (tenant_id, code)
);

CREATE TABLE payroll.salary_structure (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    code            TEXT NOT NULL,
    name            TEXT NOT NULL,
    currency_code   CHAR(3) DEFAULT 'INR',
    is_active       BOOLEAN DEFAULT TRUE,
    UNIQUE (tenant_id, code)
);

CREATE TABLE payroll.structure_component (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    structure_id    UUID NOT NULL REFERENCES payroll.salary_structure(id) ON DELETE CASCADE,
    component_id    UUID NOT NULL REFERENCES payroll.salary_component(id),
    amount          core.money_amt,
    formula         TEXT,
    sequence_no     INT,
    UNIQUE (structure_id, component_id)
);

CREATE TABLE payroll.employee_salary (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    employee_id     UUID NOT NULL REFERENCES hr.employee(id),
    effective_from  DATE NOT NULL,
    effective_to    DATE,
    structure_id    UUID REFERENCES payroll.salary_structure(id),
    ctc             core.money_amt NOT NULL,
    currency_code   CHAR(3) DEFAULT 'INR',
    payment_mode    TEXT CHECK (payment_mode IN ('bank','cash','cheque')),
    UNIQUE (employee_id, effective_from),
    EXCLUDE USING gist (employee_id WITH =, daterange(effective_from, COALESCE(effective_to,'9999-12-31')) WITH &&)
);

CREATE TABLE payroll.employee_salary_component (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    employee_salary_id UUID NOT NULL REFERENCES payroll.employee_salary(id) ON DELETE CASCADE,
    component_id    UUID NOT NULL REFERENCES payroll.salary_component(id),
    amount          core.money_amt,
    formula         TEXT,
    UNIQUE (employee_salary_id, component_id)
);

-- Payroll cycle / run
CREATE TABLE payroll.payroll_cycle (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    company_id      UUID NOT NULL,
    code            TEXT NOT NULL,                -- MONTHLY/SEMI_MONTHLY/WEEKLY
    name            TEXT NOT NULL,
    frequency       TEXT CHECK (frequency IN ('monthly','semi_monthly','weekly','bi_weekly','daily')),
    cut_off_day     INT,
    pay_day_offset  INT,
    is_active       BOOLEAN DEFAULT TRUE,
    UNIQUE (company_id, code)
);

CREATE TABLE payroll.payroll_run (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    company_id      UUID NOT NULL,
    cycle_id        UUID REFERENCES payroll.payroll_cycle(id),
    period_start    DATE NOT NULL,
    period_end      DATE NOT NULL,
    pay_date        DATE NOT NULL,
    status          TEXT DEFAULT 'draft' CHECK (status IN ('draft','processing','reviewed','approved','paid','posted','locked','cancelled')),
    total_gross     core.money_amt,
    total_deduction core.money_amt,
    total_net       core.money_amt,
    currency_code   CHAR(3) DEFAULT 'INR',
    posted_je_id    UUID REFERENCES finance.journal_entry(id),
    processed_at    TIMESTAMPTZ,
    processed_by    UUID,
    UNIQUE (company_id, cycle_id, period_start)
);

CREATE TABLE payroll.payslip (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    payroll_run_id  UUID NOT NULL REFERENCES payroll.payroll_run(id) ON DELETE CASCADE,
    employee_id     UUID NOT NULL REFERENCES hr.employee(id),
    doc_no          TEXT NOT NULL,
    period_start    DATE NOT NULL,
    period_end      DATE NOT NULL,
    working_days    NUMERIC(5,1),
    present_days    NUMERIC(5,1),
    paid_days       NUMERIC(5,1),
    lop_days        NUMERIC(5,1),
    gross_earnings  core.money_amt,
    gross_deductions core.money_amt,
    net_pay         core.money_amt,
    tax_amount      core.money_amt,
    currency_code   CHAR(3),
    status          TEXT DEFAULT 'draft' CHECK (status IN ('draft','generated','reviewed','released','paid','held')),
    payment_txn_id  UUID,
    bank_advice_id  UUID,
    UNIQUE (payroll_run_id, employee_id)
);

CREATE TABLE payroll.payslip_line (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    payslip_id      UUID NOT NULL REFERENCES payroll.payslip(id) ON DELETE CASCADE,
    component_id    UUID NOT NULL REFERENCES payroll.salary_component(id),
    amount          core.money_amt NOT NULL,
    is_earning      BOOLEAN NOT NULL,
    sequence_no     INT,
    UNIQUE (payslip_id, component_id)
);

-- Statutory
CREATE TABLE payroll.tds_slab (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    financial_year  TEXT NOT NULL,                -- FY2025-26
    regime          TEXT CHECK (regime IN ('old','new')),
    from_amount     core.money_amt,
    to_amount       core.money_amt,
    rate_pct        NUMERIC(5,2),
    surcharge_pct   NUMERIC(5,2) DEFAULT 0,
    cess_pct        NUMERIC(5,2) DEFAULT 4
);

CREATE TABLE payroll.employee_tax_declaration (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    employee_id     UUID NOT NULL REFERENCES hr.employee(id),
    financial_year  TEXT NOT NULL,
    regime          TEXT NOT NULL CHECK (regime IN ('old','new')),
    declarations    JSONB NOT NULL,               -- {80C,80D,HRA,...}
    total_declared  core.money_amt,
    status          TEXT DEFAULT 'submitted',
    UNIQUE (employee_id, financial_year)
);

CREATE TABLE payroll.tds_challan (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    company_id      UUID NOT NULL,
    challan_no      TEXT NOT NULL,
    challan_date    DATE NOT NULL,
    amount          core.money_amt NOT NULL,
    bsr_code        TEXT,
    tender_date     DATE,
    period_month    INT,
    period_year     INT,
    section_code    TEXT,
    UNIQUE (company_id, challan_no)
);

CREATE TABLE payroll.form16 (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    employee_id     UUID NOT NULL REFERENCES hr.employee(id),
    financial_year  TEXT NOT NULL,
    gross_salary    core.money_amt,
    total_deductions core.money_amt,
    tax_deducted    core.money_amt,
    document_id     UUID,
    issued_date     DATE,
    UNIQUE (employee_id, financial_year)
);

-- Statutory contributions
CREATE TABLE payroll.pf_contribution (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    employee_id     UUID NOT NULL REFERENCES hr.employee(id),
    payslip_id      UUID REFERENCES payroll.payslip(id),
    period_start    DATE NOT NULL,
    employee_pf     core.money_amt,
    employer_pf     core.money_amt,
    employer_pension core.money_amt,
    admin_charges   core.money_amt,
    total           core.money_amt
);

CREATE TABLE payroll.esi_contribution (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    employee_id     UUID NOT NULL REFERENCES hr.employee(id),
    payslip_id      UUID REFERENCES payroll.payslip(id),
    period_start    DATE NOT NULL,
    employee_esi    core.money_amt,
    employer_esi    core.money_amt
);

-- Loans & advances
CREATE TABLE payroll.employee_loan (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    employee_id     UUID NOT NULL REFERENCES hr.employee(id),
    loan_type       TEXT CHECK (loan_type IN ('personal','vehicle','home','education','advance')),
    principal       core.money_amt NOT NULL,
    interest_rate   NUMERIC(5,2),
    emi_amount      core.money_amt,
    tenure_months   INT,
    start_date      DATE NOT NULL,
    outstanding     core.money_amt,
    status          TEXT DEFAULT 'active' CHECK (status IN ('active','completed','written_off','cancelled'))
);

CREATE TABLE payroll.loan_repayment (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    loan_id         UUID NOT NULL REFERENCES payroll.employee_loan(id) ON DELETE CASCADE,
    payslip_id      UUID REFERENCES payroll.payslip(id),
    repayment_date  DATE NOT NULL,
    principal_paid  core.money_amt,
    interest_paid   core.money_amt,
    balance_after   core.money_amt
);

-- Reimbursement / expense
CREATE TABLE payroll.expense_claim (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    employee_id     UUID NOT NULL REFERENCES hr.employee(id),
    doc_no          TEXT NOT NULL,
    claim_date      DATE NOT NULL,
    claim_type      TEXT,
    total_amount    core.money_amt,
    status          core.approval_state DEFAULT 'pending',
    approver_id     UUID,
    paid_in_payslip_id UUID REFERENCES payroll.payslip(id)
);

CREATE TABLE payroll.expense_claim_line (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    expense_claim_id UUID NOT NULL REFERENCES payroll.expense_claim(id) ON DELETE CASCADE,
    expense_date    DATE,
    category        TEXT,
    description     TEXT,
    amount          core.money_amt NOT NULL,
    receipt_doc_id  UUID,
    approved_amount core.money_amt
);

-- Bank advice
CREATE TABLE payroll.bank_advice (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    payroll_run_id  UUID NOT NULL REFERENCES payroll.payroll_run(id),
    bank_account_id UUID NOT NULL REFERENCES finance.account(id),
    generated_at    TIMESTAMPTZ DEFAULT NOW(),
    total_amount    core.money_amt,
    employee_count  INT,
    file_format     TEXT,                         -- NACH/SWIFT/NEFT
    file_path       TEXT,
    status          TEXT DEFAULT 'generated'
);

-- =====================================================================
-- INDEXES
-- =====================================================================
CREATE INDEX idx_emp_salary_emp        ON payroll.employee_salary(employee_id, effective_from DESC);
CREATE INDEX idx_payroll_run_period    ON payroll.payroll_run(company_id, period_start);
CREATE INDEX idx_payslip_emp           ON payroll.payslip(employee_id, period_start DESC);
CREATE INDEX idx_payslip_status        ON payroll.payslip(payroll_run_id, status);
CREATE INDEX idx_loan_emp              ON payroll.employee_loan(employee_id) WHERE status='active';
CREATE INDEX idx_expense_claim_status  ON payroll.expense_claim(employee_id, status);

-- =====================================================================
-- FUNCTIONS
-- =====================================================================

-- Calculate TDS for a given FY gross + declaration
CREATE OR REPLACE FUNCTION payroll.fn_calc_tds(
    p_tenant UUID, p_gross core.money_amt, p_deductions core.money_amt, p_fy TEXT, p_regime TEXT
) RETURNS core.money_amt AS $$
DECLARE
    v_taxable core.money_amt;
    v_tax core.money_amt := 0;
    v_slab RECORD;
BEGIN
    v_taxable := GREATEST(p_gross - p_deductions, 0);
    FOR v_slab IN
        SELECT * FROM payroll.tds_slab
         WHERE tenant_id = p_tenant AND financial_year = p_fy AND regime = p_regime
         ORDER BY from_amount
    LOOP
        IF v_taxable > v_slab.from_amount THEN
            v_tax := v_tax + (LEAST(v_taxable, COALESCE(v_slab.to_amount, v_taxable)) - v_slab.from_amount)
                            * v_slab.rate_pct / 100;
        END IF;
    END LOOP;
    -- Add cess
    v_tax := v_tax * 1.04;
    RETURN v_tax;
END;
$$ LANGUAGE plpgsql STABLE;

-- Run payroll for period (skeletal; real impl iterates employees)
CREATE OR REPLACE FUNCTION payroll.fn_run_payroll(p_run UUID)
RETURNS VOID AS $$
DECLARE
    v_run payroll.payroll_run%ROWTYPE;
    v_emp RECORD;
    v_slip UUID;
    v_gross core.money_amt;
    v_ded   core.money_amt;
    v_net   core.money_amt;
    v_wd    NUMERIC;
    v_pd    NUMERIC;
BEGIN
    SELECT * INTO v_run FROM payroll.payroll_run WHERE id = p_run FOR UPDATE;
    UPDATE payroll.payroll_run SET status='processing' WHERE id = p_run;

    FOR v_emp IN
        SELECT e.id, e.tenant_id, es.ctc, es.id AS emp_salary_id
          FROM hr.employee e
          JOIN payroll.employee_salary es ON es.employee_id = e.id
         WHERE e.company_id = v_run.company_id
           AND e.employment_status IN ('active','on_leave','notice_period')
           AND es.effective_from <= v_run.period_end
           AND (es.effective_to IS NULL OR es.effective_to >= v_run.period_start)
    LOOP
        v_wd := (v_run.period_end - v_run.period_start) + 1;
        SELECT COUNT(*) FILTER (WHERE status IN ('present','half_day','leave','holiday','week_off'))
          INTO v_pd FROM attendance.daily_attendance
         WHERE employee_id = v_emp.id AND attendance_date BETWEEN v_run.period_start AND v_run.period_end;

        v_gross := 0; v_ded := 0;

        INSERT INTO payroll.payslip(payroll_run_id, employee_id, doc_no, period_start, period_end,
            working_days, present_days, paid_days, lop_days, currency_code, status)
        VALUES (p_run, v_emp.id, core.fn_next_doc_number(v_emp.tenant_id,'payslip'),
            v_run.period_start, v_run.period_end, v_wd, v_pd, v_pd, v_wd - v_pd, v_run.currency_code, 'draft')
        RETURNING id INTO v_slip;

        -- Copy components at prorated amount
        INSERT INTO payroll.payslip_line(payslip_id, component_id, amount, is_earning, sequence_no)
        SELECT v_slip, esc.component_id,
               ROUND(COALESCE(esc.amount,0) * v_pd / NULLIF(v_wd,0), 2),
               CASE WHEN sc.component_type IN ('earning','reimbursement') THEN TRUE ELSE FALSE END,
               sc.sequence_no
          FROM payroll.employee_salary_component esc
          JOIN payroll.salary_component sc ON sc.id = esc.component_id
         WHERE esc.employee_salary_id = v_emp.emp_salary_id;

        SELECT COALESCE(SUM(amount) FILTER (WHERE is_earning),0),
               COALESCE(SUM(amount) FILTER (WHERE NOT is_earning),0)
          INTO v_gross, v_ded
          FROM payroll.payslip_line WHERE payslip_id = v_slip;

        v_net := v_gross - v_ded;
        UPDATE payroll.payslip SET gross_earnings = v_gross, gross_deductions = v_ded,
               net_pay = v_net, status='generated' WHERE id = v_slip;
    END LOOP;

    SELECT SUM(gross_earnings), SUM(gross_deductions), SUM(net_pay)
      INTO v_run.total_gross, v_run.total_deduction, v_run.total_net
      FROM payroll.payslip WHERE payroll_run_id = p_run;

    UPDATE payroll.payroll_run
       SET total_gross = v_run.total_gross, total_deduction = v_run.total_deduction,
           total_net = v_run.total_net, status='reviewed', processed_at = NOW()
     WHERE id = p_run;
END;
$$ LANGUAGE plpgsql;

-- Post payroll to finance (salary expense + payable)
CREATE OR REPLACE FUNCTION payroll.fn_post_payroll(p_run UUID, p_user UUID)
RETURNS UUID AS $$
DECLARE
    v_run payroll.payroll_run%ROWTYPE;
    v_je UUID;
    v_fp UUID;
    v_salary_exp UUID;
    v_payable UUID;
BEGIN
    SELECT * INTO v_run FROM payroll.payroll_run WHERE id = p_run;
    IF v_run.status <> 'approved' THEN RAISE EXCEPTION 'Run not approved'; END IF;

    v_fp := core.fn_get_fiscal_period(v_run.company_id, v_run.pay_date);
    SELECT id INTO v_salary_exp FROM finance.account WHERE company_id=v_run.company_id AND code='5100' LIMIT 1;
    SELECT id INTO v_payable FROM finance.account WHERE company_id=v_run.company_id AND code='2200' LIMIT 1;

    INSERT INTO finance.journal_entry(tenant_id, company_id, fiscal_period_id, doc_no, doc_date,
        posting_date, source_module, source_doc_type, source_doc_id, reference, narration,
        currency_code, exchange_rate, status)
    VALUES (v_run.tenant_id, v_run.company_id, v_fp,
        core.fn_next_doc_number(v_run.tenant_id,'journal_entry'),
        v_run.pay_date, v_run.pay_date, 'payroll', 'payroll_run', v_run.id,
        'Payroll '||v_run.period_start::text, 'Payroll JE', v_run.currency_code, 1, 'draft')
    RETURNING id INTO v_je;

    INSERT INTO finance.journal_line(journal_entry_id, line_no, account_id, debit, credit, currency_code)
    VALUES (v_je, 1, v_salary_exp, v_run.total_gross, 0, v_run.currency_code),
           (v_je, 2, v_payable,     0, v_run.total_net, v_run.currency_code);
    -- Deductions credited to respective liability (statutory, tds) — real impl splits

    PERFORM finance.fn_post_journal_entry(v_je, p_user);
    UPDATE payroll.payroll_run SET status='posted', posted_je_id = v_je WHERE id = p_run;
    RETURN v_je;
END;
$$ LANGUAGE plpgsql;

-- Gratuity: 15 days salary per year of service
CREATE OR REPLACE FUNCTION payroll.fn_gratuity(p_emp UUID)
RETURNS core.money_amt AS $$
DECLARE
    v_years NUMERIC; v_basic core.money_amt;
BEGIN
    SELECT EXTRACT(YEAR FROM age(CURRENT_DATE, joining_date)) INTO v_years
      FROM hr.employee WHERE id = p_emp;
    IF v_years < 5 THEN RETURN 0; END IF;
    SELECT SUM(esc.amount) INTO v_basic
      FROM payroll.employee_salary es
      JOIN payroll.employee_salary_component esc ON esc.employee_salary_id = es.id
      JOIN payroll.salary_component sc ON sc.id = esc.component_id
     WHERE es.employee_id = p_emp AND es.effective_to IS NULL AND sc.code = 'BASIC';
    RETURN COALESCE(v_basic,0) * 15 / 26 * v_years;
END;
$$ LANGUAGE plpgsql STABLE;

-- =====================================================================
-- VIEWS
-- =====================================================================
CREATE OR REPLACE VIEW payroll.v_ytd_salary AS
SELECT p.employee_id, EXTRACT(YEAR FROM pr.period_start) AS year,
       SUM(p.gross_earnings) AS ytd_gross,
       SUM(p.gross_deductions) AS ytd_deductions,
       SUM(p.net_pay) AS ytd_net
  FROM payroll.payslip p JOIN payroll.payroll_run pr ON pr.id = p.payroll_run_id
 WHERE p.status IN ('released','paid')
 GROUP BY p.employee_id, EXTRACT(YEAR FROM pr.period_start);

CREATE OR REPLACE VIEW payroll.v_monthly_cost AS
SELECT pr.company_id, pr.period_start,
       SUM(p.gross_earnings) AS gross_cost,
       COUNT(p.id) AS employee_count
  FROM payroll.payroll_run pr JOIN payroll.payslip p ON p.payroll_run_id = pr.id
 WHERE pr.status IN ('posted','paid')
 GROUP BY pr.company_id, pr.period_start;

-- =====================================================================
-- TRIGGERS
-- =====================================================================
CREATE TRIGGER trg_payroll_run_audit AFTER INSERT OR UPDATE OR DELETE ON payroll.payroll_run
    FOR EACH ROW EXECUTE FUNCTION audit.fn_row_audit();
CREATE TRIGGER trg_payslip_audit AFTER INSERT OR UPDATE OR DELETE ON payroll.payslip
    FOR EACH ROW EXECUTE FUNCTION audit.fn_row_audit();
