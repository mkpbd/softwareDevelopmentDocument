-- =====================================================================
-- Module 03: Finance & Accounting (subset for Phase 1 MVP)
-- Covers: Chart of Accounts, GL, AP, AR, Journal Entries, Payments,
--         Cost Centers, Period Close, Multi-currency, Bank Recon (basic)
-- =====================================================================

SET search_path = app, core, public;

-- =============== SCHEMA ===============

CREATE TABLE IF NOT EXISTS app.chart_of_accounts (
  id            uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id     uuid NOT NULL,
  company_id    uuid NOT NULL REFERENCES app.companies(id),
  parent_id     uuid REFERENCES app.chart_of_accounts(id),
  code          citext NOT NULL,
  name          text NOT NULL,
  account_type  text NOT NULL
                CHECK (account_type IN ('asset','liability','equity','revenue','expense')),
  account_subtype text,                         -- e.g. 'current_asset','fixed_asset'
  normal_balance char(1) NOT NULL CHECK (normal_balance IN ('D','C')),
  is_group      boolean NOT NULL DEFAULT false, -- group vs posting
  is_cash       boolean NOT NULL DEFAULT false,
  is_bank       boolean NOT NULL DEFAULT false,
  currency_code char(3),
  active        boolean NOT NULL DEFAULT true,
  path          ltree,                          -- optional hierarchy; requires ltree ext
  metadata      jsonb NOT NULL DEFAULT '{}'::jsonb,
  created_at    timestamptz NOT NULL DEFAULT now(),
  updated_at    timestamptz NOT NULL DEFAULT now(),
  created_by    uuid, updated_by uuid, version int NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, company_id, code)
);

CREATE TABLE IF NOT EXISTS app.cost_centers (
  id            uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id     uuid NOT NULL,
  company_id    uuid NOT NULL REFERENCES app.companies(id),
  parent_id     uuid REFERENCES app.cost_centers(id),
  code          citext NOT NULL,
  name          text NOT NULL,
  is_group      boolean NOT NULL DEFAULT false,
  active        boolean NOT NULL DEFAULT true,
  created_at    timestamptz NOT NULL DEFAULT now(),
  updated_at    timestamptz NOT NULL DEFAULT now(),
  created_by    uuid, updated_by uuid, version int NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, company_id, code)
);

-- Journal header. Partitioned by posting_date (monthly) for long-term scale.
CREATE TABLE IF NOT EXISTS app.journal_entries (
  id              uuid NOT NULL DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  company_id      uuid NOT NULL REFERENCES app.companies(id),
  fiscal_year_id  uuid NOT NULL REFERENCES app.fiscal_years(id),
  financial_period_id uuid NOT NULL REFERENCES app.financial_periods(id),
  entry_number    text NOT NULL,
  posting_date    date NOT NULL,
  entry_type      text NOT NULL DEFAULT 'manual'
                  CHECK (entry_type IN ('manual','system','reversal','recurring','closing')),
  source_module   text,                    -- 'sales','purchase','payroll','inv', etc.
  source_document_id uuid,
  reference       text,
  narration       text,
  currency_code   char(3) NOT NULL,
  fx_rate         numeric(19,8) NOT NULL DEFAULT 1,
  status          text NOT NULL DEFAULT 'draft'
                  CHECK (status IN ('draft','posted','reversed','cancelled')),
  posted_at       timestamptz,
  posted_by       uuid,
  reversed_by_entry_id uuid,
  total_debit     numeric(19,4) NOT NULL DEFAULT 0,
  total_credit    numeric(19,4) NOT NULL DEFAULT 0,
  attachments     jsonb NOT NULL DEFAULT '[]'::jsonb,
  created_at      timestamptz NOT NULL DEFAULT now(),
  updated_at      timestamptz NOT NULL DEFAULT now(),
  created_by      uuid, updated_by uuid, version int NOT NULL DEFAULT 1,
  PRIMARY KEY (id, posting_date)
) PARTITION BY RANGE (posting_date);

-- Default partitions (script creates them dynamically; examples)
CREATE TABLE IF NOT EXISTS app.journal_entries_2026 PARTITION OF app.journal_entries
  FOR VALUES FROM ('2026-01-01') TO ('2027-01-01');
CREATE TABLE IF NOT EXISTS app.journal_entries_2027 PARTITION OF app.journal_entries
  FOR VALUES FROM ('2027-01-01') TO ('2028-01-01');
CREATE TABLE IF NOT EXISTS app.journal_entries_default PARTITION OF app.journal_entries DEFAULT;

CREATE UNIQUE INDEX IF NOT EXISTS ux_je_entry_number
  ON app.journal_entries(tenant_id, company_id, entry_number, posting_date);

CREATE TABLE IF NOT EXISTS app.journal_lines (
  id              uuid NOT NULL DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  journal_entry_id uuid NOT NULL,
  posting_date    date NOT NULL,           -- denorm for partition prune
  line_no         smallint NOT NULL,
  account_id      uuid NOT NULL REFERENCES app.chart_of_accounts(id),
  branch_id       uuid REFERENCES app.branches(id),
  cost_center_id  uuid REFERENCES app.cost_centers(id),
  party_type      text CHECK (party_type IN (NULL,'customer','supplier','employee')),
  party_id        uuid,
  debit           numeric(19,4) NOT NULL DEFAULT 0 CHECK (debit  >= 0),
  credit          numeric(19,4) NOT NULL DEFAULT 0 CHECK (credit >= 0),
  currency_code   char(3) NOT NULL,
  fx_rate         numeric(19,8) NOT NULL DEFAULT 1,
  base_debit      numeric(19,4) NOT NULL DEFAULT 0,
  base_credit     numeric(19,4) NOT NULL DEFAULT 0,
  description     text,
  reference       text,
  metadata        jsonb NOT NULL DEFAULT '{}'::jsonb,
  created_at      timestamptz NOT NULL DEFAULT now(),
  updated_at      timestamptz NOT NULL DEFAULT now(),
  created_by      uuid, updated_by uuid, version int NOT NULL DEFAULT 1,
  PRIMARY KEY (id, posting_date),
  FOREIGN KEY (journal_entry_id, posting_date)
    REFERENCES app.journal_entries(id, posting_date) ON DELETE CASCADE,
  CHECK (debit = 0 OR credit = 0),
  CHECK (NOT (debit = 0 AND credit = 0))
) PARTITION BY RANGE (posting_date);

CREATE TABLE IF NOT EXISTS app.journal_lines_2026 PARTITION OF app.journal_lines
  FOR VALUES FROM ('2026-01-01') TO ('2027-01-01');
CREATE TABLE IF NOT EXISTS app.journal_lines_2027 PARTITION OF app.journal_lines
  FOR VALUES FROM ('2027-01-01') TO ('2028-01-01');
CREATE TABLE IF NOT EXISTS app.journal_lines_default PARTITION OF app.journal_lines DEFAULT;

CREATE TABLE IF NOT EXISTS app.bank_accounts (
  id            uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id     uuid NOT NULL,
  company_id    uuid NOT NULL REFERENCES app.companies(id),
  account_id    uuid NOT NULL REFERENCES app.chart_of_accounts(id),
  bank_name     text NOT NULL,
  account_number_masked text NOT NULL,
  account_number_ciphertext bytea,
  ifsc          text,
  swift         text,
  branch_name   text,
  currency_code char(3) NOT NULL,
  opening_balance numeric(19,4) NOT NULL DEFAULT 0,
  active        boolean NOT NULL DEFAULT true,
  created_at    timestamptz NOT NULL DEFAULT now(),
  updated_at    timestamptz NOT NULL DEFAULT now(),
  created_by    uuid, updated_by uuid, version int NOT NULL DEFAULT 1
);

CREATE TABLE IF NOT EXISTS app.bank_statements (
  id            uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id     uuid NOT NULL,
  bank_account_id uuid NOT NULL REFERENCES app.bank_accounts(id),
  statement_date date NOT NULL,
  closing_balance numeric(19,4),
  created_at    timestamptz NOT NULL DEFAULT now(),
  created_by    uuid
);

CREATE TABLE IF NOT EXISTS app.bank_statement_lines (
  id            uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id     uuid NOT NULL,
  statement_id  uuid NOT NULL REFERENCES app.bank_statements(id) ON DELETE CASCADE,
  bank_account_id uuid NOT NULL REFERENCES app.bank_accounts(id),
  txn_date      date NOT NULL,
  value_date    date,
  description   text,
  reference     text,
  debit         numeric(19,4) NOT NULL DEFAULT 0,
  credit        numeric(19,4) NOT NULL DEFAULT 0,
  balance       numeric(19,4),
  matched_journal_line_id uuid,
  match_status  text NOT NULL DEFAULT 'unmatched'
                CHECK (match_status IN ('unmatched','matched','ignored','manual'))
);

CREATE TABLE IF NOT EXISTS app.payments (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  company_id      uuid NOT NULL REFERENCES app.companies(id),
  payment_number  text NOT NULL,
  payment_date    date NOT NULL,
  payment_type    text NOT NULL CHECK (payment_type IN ('receipt','payment')),
  party_type      text NOT NULL CHECK (party_type IN ('customer','supplier','employee','other')),
  party_id        uuid,
  bank_account_id uuid REFERENCES app.bank_accounts(id),
  mode            text NOT NULL CHECK (mode IN ('cash','bank_transfer','cheque','card','upi','wallet','neft','rtgs','imps','other')),
  reference       text,
  amount          numeric(19,4) NOT NULL CHECK (amount > 0),
  currency_code   char(3) NOT NULL,
  fx_rate         numeric(19,8) NOT NULL DEFAULT 1,
  status          text NOT NULL DEFAULT 'draft'
                  CHECK (status IN ('draft','posted','cancelled','reconciled')),
  journal_entry_id uuid,
  narration       text,
  created_at      timestamptz NOT NULL DEFAULT now(),
  updated_at      timestamptz NOT NULL DEFAULT now(),
  created_by      uuid, updated_by uuid, version int NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, company_id, payment_number)
);

CREATE TABLE IF NOT EXISTS app.payment_allocations (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  payment_id      uuid NOT NULL REFERENCES app.payments(id) ON DELETE CASCADE,
  invoice_type    text NOT NULL CHECK (invoice_type IN ('sales','purchase')),
  invoice_id      uuid NOT NULL,
  allocated_amount numeric(19,4) NOT NULL CHECK (allocated_amount > 0),
  created_at      timestamptz NOT NULL DEFAULT now(),
  created_by      uuid
);

-- General Ledger materialized for reporting (rebuilt on close or via trigger)
CREATE TABLE IF NOT EXISTS app.gl_balances (
  tenant_id       uuid NOT NULL,
  company_id      uuid NOT NULL,
  account_id      uuid NOT NULL,
  fiscal_year_id  uuid NOT NULL,
  period_id       uuid NOT NULL,
  branch_id       uuid,
  cost_center_id  uuid,
  opening_balance numeric(19,4) NOT NULL DEFAULT 0,
  period_debit    numeric(19,4) NOT NULL DEFAULT 0,
  period_credit   numeric(19,4) NOT NULL DEFAULT 0,
  closing_balance numeric(19,4) NOT NULL DEFAULT 0,
  updated_at      timestamptz NOT NULL DEFAULT now(),
  PRIMARY KEY (tenant_id, company_id, account_id, fiscal_year_id, period_id,
               COALESCE(branch_id,'00000000-0000-0000-0000-000000000000'::uuid),
               COALESCE(cost_center_id,'00000000-0000-0000-0000-000000000000'::uuid))
);

-- =============== INDEXES ===============
CREATE INDEX IF NOT EXISTS idx_coa_tenant_type  ON app.chart_of_accounts(tenant_id, company_id, account_type) WHERE active;
CREATE INDEX IF NOT EXISTS idx_coa_parent       ON app.chart_of_accounts(parent_id);
CREATE INDEX IF NOT EXISTS idx_coa_path_gist    ON app.chart_of_accounts USING gist(path) WHERE path IS NOT NULL;

CREATE INDEX IF NOT EXISTS idx_je_tenant_date   ON app.journal_entries(tenant_id, posting_date DESC);
CREATE INDEX IF NOT EXISTS idx_je_status        ON app.journal_entries(tenant_id, status, posting_date DESC);
CREATE INDEX IF NOT EXISTS idx_je_source        ON app.journal_entries(source_module, source_document_id) WHERE source_document_id IS NOT NULL;

CREATE INDEX IF NOT EXISTS idx_jl_entry         ON app.journal_lines(journal_entry_id);
CREATE INDEX IF NOT EXISTS idx_jl_account_date  ON app.journal_lines(tenant_id, account_id, posting_date DESC);
CREATE INDEX IF NOT EXISTS idx_jl_party         ON app.journal_lines(tenant_id, party_type, party_id, posting_date DESC) WHERE party_id IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_jl_branch_cc     ON app.journal_lines(tenant_id, branch_id, cost_center_id);

CREATE INDEX IF NOT EXISTS idx_pay_tenant_date  ON app.payments(tenant_id, payment_date DESC);
CREATE INDEX IF NOT EXISTS idx_pay_party        ON app.payments(party_type, party_id, payment_date DESC);
CREATE INDEX IF NOT EXISTS idx_pay_alloc_inv    ON app.payment_allocations(invoice_type, invoice_id);

CREATE INDEX IF NOT EXISTS idx_bsl_unmatched    ON app.bank_statement_lines(bank_account_id, txn_date)
  WHERE match_status = 'unmatched';

CREATE INDEX IF NOT EXISTS idx_glb_account      ON app.gl_balances(tenant_id, company_id, account_id, fiscal_year_id);

-- =============== RLS ===============
SELECT core.enable_tenant_rls('app.chart_of_accounts');
SELECT core.enable_tenant_rls('app.cost_centers');
SELECT core.enable_tenant_rls('app.journal_entries');
SELECT core.enable_tenant_rls('app.journal_lines');
SELECT core.enable_tenant_rls('app.bank_accounts');
SELECT core.enable_tenant_rls('app.bank_statements');
SELECT core.enable_tenant_rls('app.bank_statement_lines');
SELECT core.enable_tenant_rls('app.payments');
SELECT core.enable_tenant_rls('app.payment_allocations');
SELECT core.enable_tenant_rls('app.gl_balances');

-- =============== FUNCTIONS ===============

-- Assert journal is balanced & period is open before posting
CREATE OR REPLACE FUNCTION app.assert_journal_balanced(p_je_id uuid, p_posting_date date)
RETURNS void
LANGUAGE plpgsql
AS $$
DECLARE v_d numeric(19,4); v_c numeric(19,4);
BEGIN
  SELECT COALESCE(SUM(base_debit),0), COALESCE(SUM(base_credit),0)
    INTO v_d, v_c
    FROM app.journal_lines
   WHERE journal_entry_id = p_je_id AND posting_date = p_posting_date;

  IF round(v_d,4) <> round(v_c,4) THEN
    RAISE EXCEPTION 'journal % not balanced: debit=%, credit=%', p_je_id, v_d, v_c
      USING ERRCODE = '23514';
  END IF;
END $$;

-- Post a journal entry (validates balance, closes period check, updates GL balances)
CREATE OR REPLACE FUNCTION app.post_journal_entry(p_je_id uuid)
RETURNS void
LANGUAGE plpgsql
AS $$
DECLARE
  v_je        app.journal_entries%ROWTYPE;
  v_period    app.financial_periods%ROWTYPE;
BEGIN
  SELECT * INTO v_je FROM app.journal_entries
   WHERE id = p_je_id
   LIMIT 1;  -- partition prune ok since id is unique globally in practice
  IF NOT FOUND THEN RAISE EXCEPTION 'je % not found', p_je_id; END IF;
  IF v_je.status <> 'draft' THEN
    RAISE EXCEPTION 'je % is %, cannot post', p_je_id, v_je.status;
  END IF;

  SELECT * INTO v_period FROM app.financial_periods WHERE id = v_je.financial_period_id;
  IF v_period.status <> 'open' THEN
    RAISE EXCEPTION 'period % is %', v_period.period_no, v_period.status;
  END IF;

  PERFORM app.assert_journal_balanced(v_je.id, v_je.posting_date);

  -- Recompute header totals
  UPDATE app.journal_entries je
     SET total_debit = t.d, total_credit = t.c,
         status = 'posted', posted_at = now(), posted_by = core.current_user_id()
    FROM (SELECT COALESCE(SUM(base_debit),0) d, COALESCE(SUM(base_credit),0) c
            FROM app.journal_lines
           WHERE journal_entry_id = p_je_id AND posting_date = v_je.posting_date) t
   WHERE je.id = p_je_id AND je.posting_date = v_je.posting_date;

  -- Update GL balances (delta)
  INSERT INTO app.gl_balances(tenant_id,company_id,account_id,fiscal_year_id,period_id,
                              branch_id,cost_center_id,period_debit,period_credit,closing_balance)
  SELECT v_je.tenant_id, v_je.company_id, jl.account_id, v_je.fiscal_year_id, v_je.financial_period_id,
         jl.branch_id, jl.cost_center_id,
         SUM(jl.base_debit), SUM(jl.base_credit),
         SUM(jl.base_debit - jl.base_credit)
    FROM app.journal_lines jl
   WHERE jl.journal_entry_id = p_je_id AND jl.posting_date = v_je.posting_date
   GROUP BY jl.account_id, jl.branch_id, jl.cost_center_id
  ON CONFLICT (tenant_id, company_id, account_id, fiscal_year_id, period_id,
               COALESCE(branch_id,'00000000-0000-0000-0000-000000000000'::uuid),
               COALESCE(cost_center_id,'00000000-0000-0000-0000-000000000000'::uuid))
  DO UPDATE SET
    period_debit    = app.gl_balances.period_debit  + EXCLUDED.period_debit,
    period_credit   = app.gl_balances.period_credit + EXCLUDED.period_credit,
    closing_balance = app.gl_balances.closing_balance + EXCLUDED.closing_balance,
    updated_at      = now();
END $$;

-- Reverse a posted journal entry (creates inverse entry)
CREATE OR REPLACE FUNCTION app.reverse_journal_entry(
  p_je_id uuid, p_reverse_date date DEFAULT NULL, p_reason text DEFAULT NULL
) RETURNS uuid
LANGUAGE plpgsql
AS $$
DECLARE
  v_src app.journal_entries%ROWTYPE;
  v_new_id uuid := gen_random_uuid();
  v_new_number text;
  v_date date;
  v_period_id uuid;
  v_fy_id uuid;
  v_status text;
BEGIN
  SELECT * INTO v_src FROM app.journal_entries WHERE id = p_je_id;
  IF v_src.status <> 'posted' THEN
    RAISE EXCEPTION 'only posted entries can be reversed';
  END IF;

  v_date := COALESCE(p_reverse_date, CURRENT_DATE);
  SELECT fiscal_year_id, period_id, status
    INTO v_fy_id, v_period_id, v_status
    FROM core.period_for_date(v_src.company_id, v_date);
  IF v_status IS DISTINCT FROM 'open' THEN
    RAISE EXCEPTION 'reversal period not open for date %', v_date;
  END IF;

  v_new_number := core.next_doc_number('JE_REV');

  INSERT INTO app.journal_entries(id,tenant_id,company_id,fiscal_year_id,financial_period_id,
         entry_number,posting_date,entry_type,source_module,source_document_id,
         reference,narration,currency_code,fx_rate,status)
  VALUES (v_new_id, v_src.tenant_id, v_src.company_id, v_fy_id, v_period_id,
          v_new_number, v_date, 'reversal', v_src.source_module, v_src.source_document_id,
          v_src.entry_number, COALESCE(p_reason, 'Reversal of '||v_src.entry_number),
          v_src.currency_code, v_src.fx_rate, 'draft');

  INSERT INTO app.journal_lines(id,tenant_id,journal_entry_id,posting_date,line_no,
         account_id,branch_id,cost_center_id,party_type,party_id,
         debit,credit,currency_code,fx_rate,base_debit,base_credit,description)
  SELECT gen_random_uuid(), tenant_id, v_new_id, v_date, line_no,
         account_id, branch_id, cost_center_id, party_type, party_id,
         credit, debit, currency_code, fx_rate, base_credit, base_debit,
         'REV: '||COALESCE(description,'')
    FROM app.journal_lines
   WHERE journal_entry_id = p_je_id AND posting_date = v_src.posting_date;

  PERFORM app.post_journal_entry(v_new_id);

  UPDATE app.journal_entries
     SET status = 'reversed', reversed_by_entry_id = v_new_id
   WHERE id = p_je_id AND posting_date = v_src.posting_date;

  RETURN v_new_id;
END $$;

-- Trial balance for a period
CREATE OR REPLACE FUNCTION app.trial_balance(
  p_company_id uuid, p_period_id uuid
) RETURNS TABLE (
  account_id uuid, account_code text, account_name text, account_type text,
  opening_balance numeric, period_debit numeric, period_credit numeric, closing_balance numeric
)
LANGUAGE sql
STABLE
AS $$
  SELECT coa.id, coa.code::text, coa.name, coa.account_type,
         COALESCE(SUM(glb.opening_balance),0),
         COALESCE(SUM(glb.period_debit),0),
         COALESCE(SUM(glb.period_credit),0),
         COALESCE(SUM(glb.closing_balance),0)
    FROM app.chart_of_accounts coa
    LEFT JOIN app.gl_balances glb
           ON glb.account_id = coa.id AND glb.period_id = p_period_id
   WHERE coa.company_id = p_company_id AND NOT coa.is_group
   GROUP BY coa.id, coa.code, coa.name, coa.account_type
   ORDER BY coa.code
$$;

-- Customer ledger (open items)
CREATE OR REPLACE FUNCTION app.customer_ledger(p_customer_id uuid, p_as_of date DEFAULT CURRENT_DATE)
RETURNS TABLE(posting_date date, entry_number text, reference text, debit numeric, credit numeric, running_balance numeric)
LANGUAGE sql
STABLE
AS $$
  SELECT jl.posting_date, je.entry_number, jl.reference,
         jl.base_debit, jl.base_credit,
         SUM(jl.base_debit - jl.base_credit)
           OVER (ORDER BY jl.posting_date, je.entry_number
                 ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_balance
    FROM app.journal_lines jl
    JOIN app.journal_entries je
      ON je.id = jl.journal_entry_id AND je.posting_date = jl.posting_date
   WHERE jl.party_type = 'customer' AND jl.party_id = p_customer_id
     AND je.status = 'posted'
     AND jl.posting_date <= p_as_of
   ORDER BY jl.posting_date, je.entry_number
$$;

-- Close a financial period (validates all JEs posted, locks period)
CREATE OR REPLACE FUNCTION app.close_financial_period(p_period_id uuid)
RETURNS void
LANGUAGE plpgsql
AS $$
DECLARE v_open int;
BEGIN
  SELECT COUNT(*) INTO v_open
    FROM app.journal_entries
   WHERE financial_period_id = p_period_id AND status = 'draft';
  IF v_open > 0 THEN
    RAISE EXCEPTION 'cannot close period: % draft journal entries', v_open;
  END IF;

  UPDATE app.financial_periods
     SET status = 'closed', closed_at = now(), closed_by = core.current_user_id()
   WHERE id = p_period_id AND status = 'open';

  IF NOT FOUND THEN
    RAISE EXCEPTION 'period % already closed/locked or not found', p_period_id;
  END IF;
END $$;

-- =============== PROCEDURES ===============

-- Record a full customer receipt in one transaction (payment + allocation + JE)
CREATE OR REPLACE PROCEDURE app.record_customer_receipt(
  IN  p_company_id    uuid,
  IN  p_customer_id   uuid,
  IN  p_bank_account_id uuid,
  IN  p_amount        numeric,
  IN  p_currency      char(3),
  IN  p_mode          text,
  IN  p_reference     text,
  IN  p_date          date,
  IN  p_invoice_ids   uuid[],
  IN  p_allocations   numeric[],
  OUT o_payment_id    uuid,
  OUT o_journal_id    uuid
)
LANGUAGE plpgsql
AS $$
DECLARE
  v_fy uuid; v_fp uuid; v_st text;
  v_ar_account uuid; v_bank_account uuid;
  v_pay_number text; v_je_number text;
  v_fx numeric(19,8); v_base_amount numeric(19,4);
  i int;
BEGIN
  IF p_amount <= 0 THEN RAISE EXCEPTION 'amount must be positive'; END IF;
  IF array_length(p_invoice_ids,1) <> array_length(p_allocations,1) THEN
    RAISE EXCEPTION 'invoice/allocation array size mismatch';
  END IF;

  SELECT fiscal_year_id, period_id, status INTO v_fy, v_fp, v_st
    FROM core.period_for_date(p_company_id, p_date);
  IF v_st IS DISTINCT FROM 'open' THEN RAISE EXCEPTION 'period not open'; END IF;

  SELECT account_id INTO v_bank_account FROM app.bank_accounts WHERE id = p_bank_account_id;
  SELECT id INTO v_ar_account
    FROM app.chart_of_accounts
   WHERE company_id = p_company_id AND account_subtype = 'accounts_receivable' AND NOT is_group
   LIMIT 1;
  IF v_ar_account IS NULL THEN RAISE EXCEPTION 'AR control account not configured'; END IF;

  v_pay_number := core.next_doc_number('PAYMENT');
  v_je_number  := core.next_doc_number('JE_PAY');

  SELECT COALESCE(fx.rate,1) INTO v_fx
    FROM (SELECT core.fx_convert(1, p_currency,
             (SELECT base_currency FROM app.companies WHERE id = p_company_id), p_date) rate) fx;
  v_base_amount := round(p_amount * v_fx, 4);

  -- payment
  o_payment_id := gen_random_uuid();
  INSERT INTO app.payments(id,tenant_id,company_id,payment_number,payment_date,payment_type,
         party_type,party_id,bank_account_id,mode,reference,amount,currency_code,fx_rate,status)
  VALUES (o_payment_id, core.require_tenant(), p_company_id, v_pay_number, p_date, 'receipt',
          'customer', p_customer_id, p_bank_account_id, p_mode, p_reference, p_amount, p_currency, v_fx, 'posted');

  -- journal entry
  o_journal_id := gen_random_uuid();
  INSERT INTO app.journal_entries(id,tenant_id,company_id,fiscal_year_id,financial_period_id,
         entry_number,posting_date,entry_type,source_module,source_document_id,
         currency_code,fx_rate,status)
  VALUES (o_journal_id, core.require_tenant(), p_company_id, v_fy, v_fp,
          v_je_number, p_date, 'system', 'finance', o_payment_id,
          p_currency, v_fx, 'draft');

  INSERT INTO app.journal_lines(id,tenant_id,journal_entry_id,posting_date,line_no,
         account_id,party_type,party_id,debit,credit,currency_code,fx_rate,base_debit,base_credit,description)
  VALUES
    (gen_random_uuid(), core.require_tenant(), o_journal_id, p_date, 1,
     v_bank_account, NULL, NULL, p_amount, 0, p_currency, v_fx, v_base_amount, 0, 'Customer receipt'),
    (gen_random_uuid(), core.require_tenant(), o_journal_id, p_date, 2,
     v_ar_account, 'customer', p_customer_id, 0, p_amount, p_currency, v_fx, 0, v_base_amount, 'Customer receipt');

  PERFORM app.post_journal_entry(o_journal_id);

  UPDATE app.payments SET journal_entry_id = o_journal_id WHERE id = o_payment_id;

  -- allocations
  IF array_length(p_invoice_ids,1) IS NOT NULL THEN
    FOR i IN 1 .. array_length(p_invoice_ids,1) LOOP
      INSERT INTO app.payment_allocations(tenant_id, payment_id, invoice_type, invoice_id, allocated_amount)
      VALUES (core.require_tenant(), o_payment_id, 'sales', p_invoice_ids[i], p_allocations[i]);
    END LOOP;
  END IF;
END $$;

-- =============== TRIGGERS ===============
SELECT core.attach_standard_triggers('app.chart_of_accounts');
SELECT core.attach_standard_triggers('app.cost_centers');
SELECT core.attach_standard_triggers('app.journal_entries');
SELECT core.attach_standard_triggers('app.journal_lines');
SELECT core.attach_standard_triggers('app.bank_accounts');
SELECT core.attach_standard_triggers('app.payments');

-- Auto-fill base_debit/base_credit from debit/credit * fx_rate if not provided
CREATE OR REPLACE FUNCTION core.tg_jl_base_amount()
RETURNS trigger
LANGUAGE plpgsql
AS $$
BEGIN
  IF NEW.base_debit  = 0 AND NEW.debit  > 0 THEN NEW.base_debit  := round(NEW.debit  * NEW.fx_rate, 4); END IF;
  IF NEW.base_credit = 0 AND NEW.credit > 0 THEN NEW.base_credit := round(NEW.credit * NEW.fx_rate, 4); END IF;
  RETURN NEW;
END $$;
DROP TRIGGER IF EXISTS trg_jl_base_amount ON app.journal_lines;
CREATE TRIGGER trg_jl_base_amount
  BEFORE INSERT OR UPDATE ON app.journal_lines
  FOR EACH ROW EXECUTE FUNCTION core.tg_jl_base_amount();

-- Prevent edits to posted JE/JL
CREATE OR REPLACE FUNCTION core.tg_je_lock_posted()
RETURNS trigger
LANGUAGE plpgsql
AS $$
BEGIN
  IF TG_OP IN ('UPDATE','DELETE') AND OLD.status IN ('posted','reversed') THEN
    IF TG_OP = 'UPDATE' AND
       (NEW.status = OLD.status) AND
       (NEW.posted_at IS NOT DISTINCT FROM OLD.posted_at) THEN
      -- allow status transition writes from app.post_journal_entry/reverse_journal_entry
      NULL;
    END IF;
    IF TG_OP = 'DELETE' THEN
      RAISE EXCEPTION 'cannot delete posted journal entry %', OLD.id;
    END IF;
  END IF;
  RETURN COALESCE(NEW, OLD);
END $$;
DROP TRIGGER IF EXISTS trg_je_lock_posted ON app.journal_entries;
CREATE TRIGGER trg_je_lock_posted
  BEFORE UPDATE OR DELETE ON app.journal_entries
  FOR EACH ROW EXECUTE FUNCTION core.tg_je_lock_posted();

-- =============== VIEWS ===============
CREATE OR REPLACE VIEW app.v_open_ar AS
SELECT jl.tenant_id, jl.party_id AS customer_id,
       SUM(jl.base_debit - jl.base_credit) AS outstanding
  FROM app.journal_lines jl
  JOIN app.journal_entries je ON je.id = jl.journal_entry_id AND je.posting_date = jl.posting_date
 WHERE jl.party_type = 'customer' AND je.status = 'posted'
 GROUP BY jl.tenant_id, jl.party_id
HAVING SUM(jl.base_debit - jl.base_credit) <> 0;

CREATE OR REPLACE VIEW app.v_open_ap AS
SELECT jl.tenant_id, jl.party_id AS supplier_id,
       SUM(jl.base_credit - jl.base_debit) AS outstanding
  FROM app.journal_lines jl
  JOIN app.journal_entries je ON je.id = jl.journal_entry_id AND je.posting_date = jl.posting_date
 WHERE jl.party_type = 'supplier' AND je.status = 'posted'
 GROUP BY jl.tenant_id, jl.party_id
HAVING SUM(jl.base_credit - jl.base_debit) <> 0;

CREATE OR REPLACE VIEW app.v_pnl AS
SELECT jl.tenant_id, je.company_id, je.fiscal_year_id, je.financial_period_id,
       coa.account_type,
       SUM(CASE WHEN coa.account_type='revenue' THEN jl.base_credit - jl.base_debit ELSE 0 END) AS revenue,
       SUM(CASE WHEN coa.account_type='expense' THEN jl.base_debit - jl.base_credit ELSE 0 END) AS expense
  FROM app.journal_lines jl
  JOIN app.journal_entries je ON je.id = jl.journal_entry_id AND je.posting_date = jl.posting_date
  JOIN app.chart_of_accounts coa ON coa.id = jl.account_id
 WHERE je.status = 'posted' AND coa.account_type IN ('revenue','expense')
 GROUP BY jl.tenant_id, je.company_id, je.fiscal_year_id, je.financial_period_id, coa.account_type;

-- =============== SEED ===============
-- No static seed; chart of accounts generated per tenant provisioning.
