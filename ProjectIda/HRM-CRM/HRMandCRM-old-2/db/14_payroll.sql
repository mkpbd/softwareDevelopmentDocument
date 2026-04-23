-- =====================================================================
-- Module 14: Payroll
-- CTC structure, payroll runs, payslips, statutory (PF/ESI/PT/TDS/LWF),
-- bonus/gratuity/leave encash, loans, reimbursements, Form-16 hooks
-- =====================================================================

SET search_path = app, core, public;

-- =============== SCHEMA ===============

CREATE TABLE IF NOT EXISTS app.salary_components (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  code            citext NOT NULL,
  name            text NOT NULL,
  component_type  text NOT NULL CHECK (component_type IN ('earning','deduction','employer_contrib','reimbursement','statutory','info')),
  is_taxable      boolean NOT NULL DEFAULT true,
  calculation_type text NOT NULL DEFAULT 'fixed'
                   CHECK (calculation_type IN ('fixed','percent_of_basic','percent_of_ctc','formula','statutory')),
  percent_of      numeric(5,2),
  formula         text,
  exempt_upto     numeric(19,4),
  display_order   int NOT NULL DEFAULT 0,
  active          boolean NOT NULL DEFAULT true,
  created_at      timestamptz NOT NULL DEFAULT now(),
  updated_at      timestamptz NOT NULL DEFAULT now(),
  created_by      uuid, updated_by uuid, version int NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, code)
);

CREATE TABLE IF NOT EXISTS app.salary_structures (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  code            citext NOT NULL,
  name            text NOT NULL,
  currency_code   char(3) NOT NULL DEFAULT 'INR',
  active          boolean NOT NULL DEFAULT true,
  created_at      timestamptz NOT NULL DEFAULT now(),
  updated_at      timestamptz NOT NULL DEFAULT now(),
  created_by      uuid, updated_by uuid, version int NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, code)
);

CREATE TABLE IF NOT EXISTS app.salary_structure_lines (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  structure_id    uuid NOT NULL REFERENCES app.salary_structures(id) ON DELETE CASCADE,
  component_id    uuid NOT NULL REFERENCES app.salary_components(id),
  amount          numeric(19,4),
  percent_value   numeric(5,2),
  formula         text,
  display_order   int NOT NULL DEFAULT 0,
  UNIQUE (structure_id, component_id)
);

CREATE TABLE IF NOT EXISTS app.employee_salaries (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  employee_id     uuid NOT NULL REFERENCES app.employees(id) ON DELETE CASCADE,
  structure_id    uuid REFERENCES app.salary_structures(id),
  effective_from  date NOT NULL,
  effective_to    date,
  ctc_annual      numeric(19,4) NOT NULL,
  basic           numeric(19,4),
  hra             numeric(19,4),
  special         numeric(19,4),
  components      jsonb NOT NULL DEFAULT '{}'::jsonb,
  tax_regime      text CHECK (tax_regime IN (NULL,'old','new')),
  created_at      timestamptz NOT NULL DEFAULT now(),
  updated_at      timestamptz NOT NULL DEFAULT now(),
  created_by      uuid, updated_by uuid, version int NOT NULL DEFAULT 1,
  UNIQUE (employee_id, effective_from)
);

CREATE TABLE IF NOT EXISTS app.payroll_runs (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  company_id      uuid NOT NULL REFERENCES app.companies(id),
  run_number      text NOT NULL,
  run_period_start date NOT NULL,
  run_period_end  date NOT NULL,
  payroll_month   smallint NOT NULL,
  payroll_year    smallint NOT NULL,
  frequency       text NOT NULL DEFAULT 'monthly' CHECK (frequency IN ('monthly','weekly','bi_weekly','off_cycle')),
  status          text NOT NULL DEFAULT 'draft'
                  CHECK (status IN ('draft','computing','computed','approved','paid','rejected','cancelled')),
  total_gross     numeric(19,4) NOT NULL DEFAULT 0,
  total_deductions numeric(19,4) NOT NULL DEFAULT 0,
  total_net       numeric(19,4) NOT NULL DEFAULT 0,
  employee_count  int NOT NULL DEFAULT 0,
  computed_at     timestamptz, approved_at timestamptz, paid_at timestamptz,
  journal_entry_id uuid,
  notes           text,
  created_at      timestamptz NOT NULL DEFAULT now(),
  updated_at      timestamptz NOT NULL DEFAULT now(),
  created_by      uuid, updated_by uuid, version int NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, company_id, run_number),
  CHECK (run_period_end >= run_period_start)
);

CREATE TABLE IF NOT EXISTS app.payslips (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  payroll_run_id  uuid NOT NULL REFERENCES app.payroll_runs(id) ON DELETE CASCADE,
  employee_id     uuid NOT NULL REFERENCES app.employees(id),
  period_start    date NOT NULL,
  period_end      date NOT NULL,
  days_worked     numeric(5,2),
  days_lop        numeric(5,2) NOT NULL DEFAULT 0,
  gross           numeric(19,4) NOT NULL DEFAULT 0,
  total_earnings  numeric(19,4) NOT NULL DEFAULT 0,
  total_deductions numeric(19,4) NOT NULL DEFAULT 0,
  tax             numeric(19,4) NOT NULL DEFAULT 0,
  net             numeric(19,4) NOT NULL DEFAULT 0,
  status          text NOT NULL DEFAULT 'computed'
                  CHECK (status IN ('computed','approved','paid','held','cancelled')),
  document_id     uuid REFERENCES app.documents(id),
  paid_at         timestamptz,
  UNIQUE (payroll_run_id, employee_id)
);

CREATE TABLE IF NOT EXISTS app.payslip_components (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  payslip_id      uuid NOT NULL REFERENCES app.payslips(id) ON DELETE CASCADE,
  component_id    uuid NOT NULL REFERENCES app.salary_components(id),
  component_type  text NOT NULL,
  amount          numeric(19,4) NOT NULL,
  display_order   int NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS app.statutory_contributions (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  payslip_id      uuid NOT NULL REFERENCES app.payslips(id) ON DELETE CASCADE,
  employee_id     uuid NOT NULL REFERENCES app.employees(id),
  scheme          text NOT NULL CHECK (scheme IN ('PF','EPS','ESI','PT','LWF','TDS','GRATUITY')),
  wage_base       numeric(19,4) NOT NULL DEFAULT 0,
  employee_amount numeric(19,4) NOT NULL DEFAULT 0,
  employer_amount numeric(19,4) NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS app.tds_computations (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  employee_id     uuid NOT NULL REFERENCES app.employees(id) ON DELETE CASCADE,
  financial_year  text NOT NULL,                      -- '2026-27'
  tax_regime      text NOT NULL CHECK (tax_regime IN ('old','new')),
  gross_salary    numeric(19,4) NOT NULL,
  exemptions      numeric(19,4) NOT NULL DEFAULT 0,
  std_deduction   numeric(19,4) NOT NULL DEFAULT 50000,
  chapter_vi_a    numeric(19,4) NOT NULL DEFAULT 0,
  taxable_income  numeric(19,4) NOT NULL,
  tax_liability   numeric(19,4) NOT NULL DEFAULT 0,
  surcharge       numeric(19,4) NOT NULL DEFAULT 0,
  cess            numeric(19,4) NOT NULL DEFAULT 0,
  rebate_87a      numeric(19,4) NOT NULL DEFAULT 0,
  total_tax       numeric(19,4) NOT NULL DEFAULT 0,
  tax_paid_ytd    numeric(19,4) NOT NULL DEFAULT 0,
  months_remaining smallint NOT NULL DEFAULT 12,
  tds_per_month   numeric(19,4) NOT NULL DEFAULT 0,
  computed_at     timestamptz NOT NULL DEFAULT now(),
  UNIQUE (employee_id, financial_year)
);

CREATE TABLE IF NOT EXISTS app.loans (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  employee_id     uuid NOT NULL REFERENCES app.employees(id),
  loan_number     text NOT NULL,
  loan_type       text NOT NULL CHECK (loan_type IN ('personal','housing','vehicle','education','emergency','advance')),
  principal       numeric(19,4) NOT NULL CHECK (principal > 0),
  interest_rate   numeric(5,2) NOT NULL DEFAULT 0,
  tenure_months   smallint NOT NULL CHECK (tenure_months > 0),
  emi_amount      numeric(19,4) NOT NULL,
  disbursed_on    date,
  starts_on       date,
  balance         numeric(19,4) NOT NULL,
  status          text NOT NULL DEFAULT 'pending'
                  CHECK (status IN ('pending','approved','disbursed','in_repayment','closed','written_off','rejected')),
  notes           text,
  created_at      timestamptz NOT NULL DEFAULT now(),
  updated_at      timestamptz NOT NULL DEFAULT now(),
  created_by      uuid, updated_by uuid, version int NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, loan_number)
);

CREATE TABLE IF NOT EXISTS app.loan_schedules (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  loan_id         uuid NOT NULL REFERENCES app.loans(id) ON DELETE CASCADE,
  installment_no  smallint NOT NULL,
  due_date        date NOT NULL,
  principal_due   numeric(19,4) NOT NULL,
  interest_due    numeric(19,4) NOT NULL,
  total_due       numeric(19,4) NOT NULL,
  paid_amount     numeric(19,4) NOT NULL DEFAULT 0,
  status          text NOT NULL DEFAULT 'pending'
                  CHECK (status IN ('pending','paid','partial','skipped','written_off')),
  paid_on         date,
  UNIQUE (loan_id, installment_no)
);

CREATE TABLE IF NOT EXISTS app.reimbursements (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  employee_id     uuid NOT NULL REFERENCES app.employees(id) ON DELETE CASCADE,
  claim_number    text NOT NULL,
  claim_date      date NOT NULL,
  category        text NOT NULL,
  amount          numeric(19,4) NOT NULL CHECK (amount > 0),
  currency_code   char(3) NOT NULL DEFAULT 'INR',
  description     text,
  document_id     uuid REFERENCES app.documents(id),
  status          text NOT NULL DEFAULT 'submitted'
                  CHECK (status IN ('draft','submitted','approved','rejected','paid','cancelled')),
  approved_by     uuid, approved_at timestamptz,
  payroll_run_id  uuid REFERENCES app.payroll_runs(id),
  paid_at         timestamptz,
  created_at      timestamptz NOT NULL DEFAULT now(),
  updated_at      timestamptz NOT NULL DEFAULT now(),
  UNIQUE (tenant_id, claim_number)
);

CREATE TABLE IF NOT EXISTS app.bonus_runs (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  name            text NOT NULL,
  bonus_type      text NOT NULL CHECK (bonus_type IN ('festival','annual','performance','retention','adhoc')),
  financial_year  text,
  run_date        date NOT NULL,
  total_amount    numeric(19,4) NOT NULL DEFAULT 0,
  status          text NOT NULL DEFAULT 'draft' CHECK (status IN ('draft','approved','paid','cancelled')),
  created_at      timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS app.gratuity_accruals (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  employee_id     uuid NOT NULL REFERENCES app.employees(id),
  as_of_date      date NOT NULL,
  years_service   numeric(5,2),
  eligible_amount numeric(19,4),
  accrued_amount  numeric(19,4),
  computed_at     timestamptz NOT NULL DEFAULT now(),
  UNIQUE (employee_id, as_of_date)
);

CREATE TABLE IF NOT EXISTS app.bank_advices (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  payroll_run_id  uuid NOT NULL REFERENCES app.payroll_runs(id) ON DELETE CASCADE,
  bank_account_id uuid REFERENCES app.bank_accounts(id),
  file_format     text NOT NULL DEFAULT 'xlsx' CHECK (file_format IN ('xlsx','csv','xml','fixed','swift_mt103')),
  total_amount    numeric(19,4) NOT NULL,
  employee_count  int NOT NULL,
  document_id     uuid REFERENCES app.documents(id),
  generated_at    timestamptz NOT NULL DEFAULT now(),
  generated_by    uuid
);

-- =============== INDEXES ===============
CREATE INDEX IF NOT EXISTS idx_salcomp_active      ON app.salary_components(tenant_id) WHERE active;
CREATE INDEX IF NOT EXISTS idx_salstruct_active    ON app.salary_structures(tenant_id) WHERE active;
CREATE INDEX IF NOT EXISTS idx_empsal_emp_effect   ON app.employee_salaries(employee_id, effective_from DESC);
CREATE INDEX IF NOT EXISTS idx_prun_month          ON app.payroll_runs(tenant_id, payroll_year, payroll_month);
CREATE INDEX IF NOT EXISTS idx_prun_status         ON app.payroll_runs(tenant_id, status);
CREATE INDEX IF NOT EXISTS idx_pslip_run_emp       ON app.payslips(payroll_run_id, employee_id);
CREATE INDEX IF NOT EXISTS idx_pslip_emp           ON app.payslips(employee_id);
CREATE INDEX IF NOT EXISTS idx_pslip_comp_slip     ON app.payslip_components(payslip_id);
CREATE INDEX IF NOT EXISTS idx_stat_emp            ON app.statutory_contributions(employee_id, scheme);
CREATE INDEX IF NOT EXISTS idx_tds_emp_fy          ON app.tds_computations(employee_id, financial_year);
CREATE INDEX IF NOT EXISTS idx_loans_emp_status    ON app.loans(employee_id, status);
CREATE INDEX IF NOT EXISTS idx_lsched_loan         ON app.loan_schedules(loan_id, installment_no);
CREATE INDEX IF NOT EXISTS idx_reimb_emp_status    ON app.reimbursements(employee_id, status);
CREATE INDEX IF NOT EXISTS idx_ba_run              ON app.bank_advices(payroll_run_id);

-- =============== RLS + TRIGGERS ===============
SELECT core.enable_tenant_rls('app.salary_components');
SELECT core.enable_tenant_rls('app.salary_structures');
SELECT core.enable_tenant_rls('app.salary_structure_lines');
SELECT core.enable_tenant_rls('app.employee_salaries');
SELECT core.enable_tenant_rls('app.payroll_runs');
SELECT core.enable_tenant_rls('app.payslips');
SELECT core.enable_tenant_rls('app.payslip_components');
SELECT core.enable_tenant_rls('app.statutory_contributions');
SELECT core.enable_tenant_rls('app.tds_computations');
SELECT core.enable_tenant_rls('app.loans');
SELECT core.enable_tenant_rls('app.loan_schedules');
SELECT core.enable_tenant_rls('app.reimbursements');
SELECT core.enable_tenant_rls('app.bonus_runs');
SELECT core.enable_tenant_rls('app.gratuity_accruals');
SELECT core.enable_tenant_rls('app.bank_advices');

SELECT core.attach_standard_triggers('app.salary_components');
SELECT core.attach_standard_triggers('app.salary_structures');
SELECT core.attach_standard_triggers('app.employee_salaries');
SELECT core.attach_standard_triggers('app.payroll_runs');
SELECT core.attach_standard_triggers('app.loans');
SELECT core.attach_standard_triggers('app.reimbursements');

-- =============== FUNCTIONS ===============

-- Compute India statutory PF/ESI (FY 2025-26 caps; tweak yearly)
CREATE OR REPLACE FUNCTION app.compute_india_statutory(p_basic numeric, p_gross numeric)
RETURNS TABLE(pf_emp numeric, pf_er numeric, eps_er numeric, esi_emp numeric, esi_er numeric)
LANGUAGE sql IMMUTABLE AS $$
  SELECT
    -- PF: 12% of min(basic, 15000). Employee share.
    round(LEAST(p_basic, 15000) * 0.12, 2) AS pf_emp,
    -- Employer share 12% minus EPS 8.33% of min(basic, 15000)
    round(LEAST(p_basic, 15000) * 0.0367, 2) AS pf_er,
    round(LEAST(p_basic, 15000) * 0.0833, 2) AS eps_er,
    -- ESI: gross <= 21000; employee 0.75%, employer 3.25%
    CASE WHEN p_gross <= 21000 THEN round(p_gross * 0.0075, 2) ELSE 0 END,
    CASE WHEN p_gross <= 21000 THEN round(p_gross * 0.0325, 2) ELSE 0 END
$$;

-- Compute India income tax (new regime, FY 2025-26 slabs)
CREATE OR REPLACE FUNCTION app.compute_india_tax_new_regime(p_taxable numeric)
RETURNS numeric
LANGUAGE plpgsql IMMUTABLE AS $$
DECLARE v numeric := 0;
BEGIN
  IF p_taxable <= 300000 THEN v := 0;
  ELSIF p_taxable <= 700000  THEN v := (p_taxable - 300000) * 0.05;
  ELSIF p_taxable <= 1000000 THEN v := 20000 + (p_taxable - 700000) * 0.10;
  ELSIF p_taxable <= 1200000 THEN v := 50000 + (p_taxable - 1000000) * 0.15;
  ELSIF p_taxable <= 1500000 THEN v := 80000 + (p_taxable - 1200000) * 0.20;
  ELSE v := 140000 + (p_taxable - 1500000) * 0.30;
  END IF;

  -- Section 87A rebate for income up to 7L in new regime
  IF p_taxable <= 700000 THEN v := 0; END IF;

  -- Add 4% cess
  v := v * 1.04;
  RETURN round(v, 2);
END $$;

-- Build amortized loan schedule
CREATE OR REPLACE PROCEDURE app.generate_loan_schedule(p_loan_id uuid)
LANGUAGE plpgsql AS $$
DECLARE
  v app.loans%ROWTYPE;
  v_bal numeric(19,4); v_rate numeric; v_int numeric; v_prin numeric;
  v_due date; i int;
BEGIN
  SELECT * INTO v FROM app.loans WHERE id = p_loan_id;
  IF v.status NOT IN ('approved','disbursed','pending') THEN
    RAISE EXCEPTION 'loan status %, cannot generate schedule', v.status;
  END IF;

  DELETE FROM app.loan_schedules WHERE loan_id = p_loan_id;

  v_bal  := v.principal;
  v_rate := v.interest_rate / 1200;          -- monthly rate
  v_due  := COALESCE(v.starts_on, v.disbursed_on, CURRENT_DATE);

  FOR i IN 1 .. v.tenure_months LOOP
    v_int  := round(v_bal * v_rate, 4);
    v_prin := round(v.emi_amount - v_int, 4);
    IF i = v.tenure_months THEN
      v_prin := v_bal;                       -- clear rounding on last EMI
    END IF;

    INSERT INTO app.loan_schedules(tenant_id, loan_id, installment_no, due_date,
           principal_due, interest_due, total_due)
    VALUES (v.tenant_id, p_loan_id, i, v_due, v_prin, v_int, v_prin + v_int);

    v_bal := v_bal - v_prin;
    v_due := v_due + interval '1 month';
  END LOOP;
END $$;

-- Run payroll for a period (simplified — per-employee compute loop)
CREATE OR REPLACE PROCEDURE app.run_payroll(
  p_company_id uuid, p_run_period_start date, p_run_period_end date
)
LANGUAGE plpgsql AS $$
DECLARE
  v_run_id uuid := gen_random_uuid();
  v_tenant uuid := core.require_tenant();
  r record;
  v_basic numeric; v_gross numeric; v_lop_days numeric;
  v_total_gross numeric(19,4) := 0; v_total_ded numeric(19,4) := 0; v_total_net numeric(19,4) := 0;
  v_emp_count int := 0;
  v_slip_id uuid;
  v_pf record; v_tax numeric;
BEGIN
  INSERT INTO app.payroll_runs(id,tenant_id,company_id,run_number,
         run_period_start,run_period_end,payroll_month,payroll_year,status,created_by)
  VALUES (v_run_id, v_tenant, p_company_id, core.next_doc_number('PAYROLL'),
          p_run_period_start, p_run_period_end,
          EXTRACT(MONTH FROM p_run_period_end)::smallint,
          EXTRACT(YEAR  FROM p_run_period_end)::smallint,
          'computing', core.current_user_id());

  FOR r IN
    SELECT e.id AS emp_id, es.ctc_annual, COALESCE(es.basic, es.ctc_annual*0.4/12) AS basic_m,
           COALESCE(es.tax_regime,'new') AS regime
      FROM app.employees e
      JOIN LATERAL (
        SELECT * FROM app.employee_salaries
         WHERE employee_id = e.id AND effective_from <= p_run_period_end
         ORDER BY effective_from DESC LIMIT 1
      ) es ON true
     WHERE e.company_id = p_company_id AND e.status = 'active'
  LOOP
    v_emp_count := v_emp_count + 1;
    v_basic := r.basic_m;
    v_gross := r.ctc_annual / 12;

    v_lop_days := COALESCE((
      SELECT COUNT(*) FROM app.attendance_records
       WHERE employee_id = r.emp_id
         AND attendance_date BETWEEN p_run_period_start AND p_run_period_end
         AND status = 'absent'
    ),0);

    SELECT * INTO v_pf FROM app.compute_india_statutory(v_basic, v_gross);
    v_tax := app.compute_india_tax_new_regime(r.ctc_annual) / 12;

    v_slip_id := gen_random_uuid();
    INSERT INTO app.payslips(id,tenant_id,payroll_run_id,employee_id,
           period_start,period_end,days_lop,gross,total_earnings,total_deductions,tax,net)
    VALUES (v_slip_id, v_tenant, v_run_id, r.emp_id,
            p_run_period_start, p_run_period_end, v_lop_days,
            v_gross, v_gross,
            v_pf.pf_emp + v_pf.esi_emp + v_tax,
            v_tax,
            v_gross - (v_pf.pf_emp + v_pf.esi_emp + v_tax));

    INSERT INTO app.statutory_contributions(tenant_id,payslip_id,employee_id,scheme,wage_base,employee_amount,employer_amount) VALUES
      (v_tenant, v_slip_id, r.emp_id, 'PF',  v_basic, v_pf.pf_emp, v_pf.pf_er),
      (v_tenant, v_slip_id, r.emp_id, 'EPS', v_basic, 0,           v_pf.eps_er),
      (v_tenant, v_slip_id, r.emp_id, 'ESI', v_gross, v_pf.esi_emp,v_pf.esi_er),
      (v_tenant, v_slip_id, r.emp_id, 'TDS', v_gross, v_tax,       0);

    v_total_gross := v_total_gross + v_gross;
    v_total_ded   := v_total_ded + v_pf.pf_emp + v_pf.esi_emp + v_tax;
    v_total_net   := v_total_net + (v_gross - v_pf.pf_emp - v_pf.esi_emp - v_tax);
  END LOOP;

  UPDATE app.payroll_runs
     SET total_gross = v_total_gross, total_deductions = v_total_ded,
         total_net = v_total_net, employee_count = v_emp_count,
         status='computed', computed_at=now()
   WHERE id = v_run_id;
END $$;

-- =============== VIEWS ===============
CREATE OR REPLACE VIEW app.v_payroll_summary AS
SELECT pr.tenant_id, pr.run_number, pr.payroll_year, pr.payroll_month,
       pr.employee_count, pr.total_gross, pr.total_deductions, pr.total_net,
       pr.status
  FROM app.payroll_runs pr
 ORDER BY pr.payroll_year DESC, pr.payroll_month DESC;

CREATE OR REPLACE VIEW app.v_active_loans AS
SELECT l.tenant_id, l.employee_id, l.loan_number, l.loan_type, l.principal,
       l.balance, l.emi_amount,
       (SELECT COUNT(*) FROM app.loan_schedules ls
         WHERE ls.loan_id = l.id AND ls.status='pending') AS installments_pending
  FROM app.loans l WHERE l.status = 'in_repayment';
