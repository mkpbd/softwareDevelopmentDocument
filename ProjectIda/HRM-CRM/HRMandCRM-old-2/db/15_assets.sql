-- =====================================================================
-- Module 15: Asset Management
-- Asset register, depreciation, assignment, maintenance, insurance, disposal
-- =====================================================================

SET search_path = app, core, public;

-- =============== SCHEMA ===============

CREATE TABLE IF NOT EXISTS app.asset_categories (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  parent_id       uuid REFERENCES app.asset_categories(id),
  code            citext NOT NULL,
  name            text NOT NULL,
  depreciation_method text NOT NULL DEFAULT 'SLM'
                      CHECK (depreciation_method IN ('SLM','WDV','UOP','DOUBLE_DECLINING','NONE')),
  useful_life_years numeric(5,2),
  salvage_percent  numeric(5,2) NOT NULL DEFAULT 5,
  asset_account_id uuid REFERENCES app.chart_of_accounts(id),
  accum_depr_account_id uuid REFERENCES app.chart_of_accounts(id),
  depr_expense_account_id uuid REFERENCES app.chart_of_accounts(id),
  active           boolean NOT NULL DEFAULT true,
  created_at       timestamptz NOT NULL DEFAULT now(),
  updated_at       timestamptz NOT NULL DEFAULT now(),
  created_by       uuid, updated_by uuid, version int NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, code)
);

CREATE TABLE IF NOT EXISTS app.assets (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  company_id      uuid NOT NULL REFERENCES app.companies(id),
  asset_code      citext NOT NULL,
  tag_number      text,
  barcode         text,
  category_id     uuid NOT NULL REFERENCES app.asset_categories(id),
  name            text NOT NULL,
  description     text,
  serial_number   text,
  manufacturer    text, model text,
  purchase_date   date NOT NULL,
  purchase_cost   numeric(19,4) NOT NULL CHECK (purchase_cost >= 0),
  currency_code   char(3) NOT NULL DEFAULT 'INR',
  supplier_id     uuid REFERENCES app.suppliers(id),
  invoice_reference text,
  installation_date date,
  warranty_expires date,
  useful_life_months int,
  salvage_value   numeric(19,4) NOT NULL DEFAULT 0,
  depreciation_method text CHECK (depreciation_method IN (NULL,'SLM','WDV','UOP','DOUBLE_DECLINING','NONE')),
  current_book_value numeric(19,4),
  accumulated_depreciation numeric(19,4) NOT NULL DEFAULT 0,
  status          text NOT NULL DEFAULT 'in_service'
                  CHECK (status IN ('in_stock','in_service','under_maintenance','idle','disposed','lost','stolen','scrapped')),
  location        jsonb,
  branch_id       uuid REFERENCES app.branches(id),
  department_id   uuid,
  cost_center_id  uuid REFERENCES app.cost_centers(id),
  custodian_id    uuid REFERENCES app.employees(id),
  condition       text CHECK (condition IN (NULL,'new','good','fair','poor','unusable')),
  metadata        jsonb NOT NULL DEFAULT '{}'::jsonb,
  created_at      timestamptz NOT NULL DEFAULT now(),
  updated_at      timestamptz NOT NULL DEFAULT now(),
  created_by      uuid, updated_by uuid, version int NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, company_id, asset_code)
);

CREATE TABLE IF NOT EXISTS app.depreciation_schedules (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  asset_id        uuid NOT NULL REFERENCES app.assets(id) ON DELETE CASCADE,
  book            text NOT NULL DEFAULT 'accounting'
                  CHECK (book IN ('accounting','tax','ifrs','internal')),
  period_start    date NOT NULL,
  period_end      date NOT NULL,
  opening_wdv     numeric(19,4) NOT NULL,
  depreciation    numeric(19,4) NOT NULL,
  accumulated     numeric(19,4) NOT NULL,
  closing_wdv     numeric(19,4) NOT NULL,
  posted          boolean NOT NULL DEFAULT false,
  journal_entry_id uuid,
  UNIQUE (asset_id, book, period_start)
);

CREATE TABLE IF NOT EXISTS app.asset_assignments (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  asset_id        uuid NOT NULL REFERENCES app.assets(id) ON DELETE CASCADE,
  employee_id     uuid REFERENCES app.employees(id),
  branch_id       uuid REFERENCES app.branches(id),
  assigned_from   date NOT NULL,
  assigned_to     date,
  condition_on_assign text,
  condition_on_return text,
  notes           text,
  created_at      timestamptz NOT NULL DEFAULT now(),
  created_by      uuid
);

CREATE TABLE IF NOT EXISTS app.maintenance_schedules (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  asset_id        uuid NOT NULL REFERENCES app.assets(id) ON DELETE CASCADE,
  frequency_days  int NOT NULL CHECK (frequency_days > 0),
  next_due_date   date NOT NULL,
  maintenance_type text NOT NULL CHECK (maintenance_type IN ('preventive','calibration','inspection','cleaning','lubrication')),
  checklist       jsonb,
  active          boolean NOT NULL DEFAULT true,
  created_at      timestamptz NOT NULL DEFAULT now(),
  updated_at      timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS app.maintenance_requests (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  asset_id        uuid NOT NULL REFERENCES app.assets(id),
  schedule_id     uuid REFERENCES app.maintenance_schedules(id),
  request_number  text NOT NULL,
  request_type    text NOT NULL CHECK (request_type IN ('preventive','breakdown','corrective','calibration')),
  reported_at     timestamptz NOT NULL DEFAULT now(),
  reported_by     uuid,
  priority        text NOT NULL DEFAULT 'normal' CHECK (priority IN ('low','normal','high','urgent')),
  description     text,
  assigned_to     uuid REFERENCES app.employees(id),
  started_at      timestamptz, completed_at timestamptz,
  status          text NOT NULL DEFAULT 'open'
                  CHECK (status IN ('open','assigned','in_progress','on_hold','completed','cancelled')),
  downtime_hours  numeric(6,2),
  cost            numeric(19,4),
  supplier_id     uuid REFERENCES app.suppliers(id),
  work_performed  text,
  created_at      timestamptz NOT NULL DEFAULT now(),
  updated_at      timestamptz NOT NULL DEFAULT now(),
  UNIQUE (tenant_id, request_number)
);

CREATE TABLE IF NOT EXISTS app.asset_insurance (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  asset_id        uuid NOT NULL REFERENCES app.assets(id) ON DELETE CASCADE,
  policy_number   text NOT NULL,
  insurer         text NOT NULL,
  coverage_amount numeric(19,4) NOT NULL,
  premium         numeric(19,4) NOT NULL,
  start_date      date NOT NULL,
  expiry_date     date NOT NULL,
  document_id     uuid REFERENCES app.documents(id),
  status          text NOT NULL DEFAULT 'active' CHECK (status IN ('active','expired','cancelled','claim_pending'))
);

CREATE TABLE IF NOT EXISTS app.asset_disposals (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  asset_id        uuid NOT NULL REFERENCES app.assets(id),
  disposal_date   date NOT NULL,
  disposal_method text NOT NULL CHECK (disposal_method IN ('sale','scrap','donation','transfer','destruction','lost')),
  sale_price      numeric(19,4),
  buyer_info      text,
  book_value_at_disposal numeric(19,4) NOT NULL,
  gain_loss       numeric(19,4),
  journal_entry_id uuid,
  notes           text,
  created_at      timestamptz NOT NULL DEFAULT now(),
  created_by      uuid
);

CREATE TABLE IF NOT EXISTS app.asset_relocations (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  asset_id        uuid NOT NULL REFERENCES app.assets(id),
  moved_at        timestamptz NOT NULL DEFAULT now(),
  from_location   jsonb, to_location jsonb,
  from_branch_id  uuid, to_branch_id uuid,
  moved_by        uuid, notes text
);

-- =============== INDEXES ===============
CREATE INDEX IF NOT EXISTS idx_assets_cat         ON app.assets(category_id, status);
CREATE INDEX IF NOT EXISTS idx_assets_tag         ON app.assets(tag_number);
CREATE INDEX IF NOT EXISTS idx_assets_barcode     ON app.assets(barcode);
CREATE INDEX IF NOT EXISTS idx_assets_custodian   ON app.assets(custodian_id) WHERE custodian_id IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_depr_asset_period  ON app.depreciation_schedules(asset_id, book, period_start);
CREATE INDEX IF NOT EXISTS idx_assign_asset       ON app.asset_assignments(asset_id, assigned_to NULLS FIRST);
CREATE INDEX IF NOT EXISTS idx_maint_schedule_due ON app.maintenance_schedules(next_due_date) WHERE active;
CREATE INDEX IF NOT EXISTS idx_maint_req_status   ON app.maintenance_requests(tenant_id, status, priority);
CREATE INDEX IF NOT EXISTS idx_insure_expiry      ON app.asset_insurance(expiry_date) WHERE status='active';

-- =============== RLS + TRIGGERS ===============
SELECT core.enable_tenant_rls('app.asset_categories');
SELECT core.enable_tenant_rls('app.assets');
SELECT core.enable_tenant_rls('app.depreciation_schedules');
SELECT core.enable_tenant_rls('app.asset_assignments');
SELECT core.enable_tenant_rls('app.maintenance_schedules');
SELECT core.enable_tenant_rls('app.maintenance_requests');
SELECT core.enable_tenant_rls('app.asset_insurance');
SELECT core.enable_tenant_rls('app.asset_disposals');
SELECT core.enable_tenant_rls('app.asset_relocations');

SELECT core.attach_standard_triggers('app.asset_categories');
SELECT core.attach_standard_triggers('app.assets');
SELECT core.attach_standard_triggers('app.maintenance_requests');

-- =============== FUNCTIONS ===============

-- Generate monthly depreciation schedule for an asset (SLM/WDV)
CREATE OR REPLACE PROCEDURE app.generate_depreciation_schedule(p_asset_id uuid, p_book text DEFAULT 'accounting')
LANGUAGE plpgsql AS $$
DECLARE
  a app.assets%ROWTYPE;
  c app.asset_categories%ROWTYPE;
  v_months int; v_method text; v_wdv numeric(19,4); v_dep numeric(19,4); v_accum numeric(19,4);
  v_period_start date; v_period_end date;
  v_rate numeric; i int;
BEGIN
  SELECT * INTO a FROM app.assets WHERE id = p_asset_id;
  SELECT * INTO c FROM app.asset_categories WHERE id = a.category_id;

  v_method := COALESCE(a.depreciation_method, c.depreciation_method);
  v_months := COALESCE(a.useful_life_months, (c.useful_life_years * 12)::int);

  IF v_method = 'NONE' OR v_months IS NULL THEN RETURN; END IF;

  DELETE FROM app.depreciation_schedules WHERE asset_id = p_asset_id AND book = p_book;

  v_wdv := a.purchase_cost;
  v_accum := 0;
  v_period_start := date_trunc('month', a.purchase_date)::date;

  FOR i IN 1 .. v_months LOOP
    v_period_end := (v_period_start + interval '1 month - 1 day')::date;

    v_dep := CASE v_method
      WHEN 'SLM' THEN round((a.purchase_cost - a.salvage_value) / v_months, 4)
      WHEN 'WDV' THEN round(v_wdv * (2.0 / v_months), 4)
      WHEN 'DOUBLE_DECLINING' THEN round(v_wdv * (2.0 / v_months), 4)
      ELSE 0
    END;

    IF v_wdv - v_dep < a.salvage_value THEN v_dep := v_wdv - a.salvage_value; END IF;

    v_accum := v_accum + v_dep;

    INSERT INTO app.depreciation_schedules(tenant_id,asset_id,book,
           period_start,period_end,opening_wdv,depreciation,accumulated,closing_wdv)
    VALUES (a.tenant_id, p_asset_id, p_book, v_period_start, v_period_end,
            v_wdv, v_dep, v_accum, v_wdv - v_dep);

    v_wdv := v_wdv - v_dep;
    v_period_start := (v_period_end + interval '1 day')::date;
    EXIT WHEN v_wdv <= a.salvage_value;
  END LOOP;
END $$;

-- Post depreciation journal entries for a period
CREATE OR REPLACE PROCEDURE app.post_depreciation(p_company_id uuid, p_period_end date)
LANGUAGE plpgsql AS $$
DECLARE
  v_tenant uuid := core.require_tenant();
  v_fy uuid; v_fp uuid; v_st text;
  v_je_id uuid; v_je_num text; v_total numeric(19,4) := 0;
  r record;
BEGIN
  SELECT fiscal_year_id, period_id, status INTO v_fy, v_fp, v_st
    FROM core.period_for_date(p_company_id, p_period_end);
  IF v_st IS DISTINCT FROM 'open' THEN RAISE EXCEPTION 'period not open'; END IF;

  v_je_id := gen_random_uuid();
  v_je_num := core.next_doc_number('JE_DEPR');

  INSERT INTO app.journal_entries(id,tenant_id,company_id,fiscal_year_id,financial_period_id,
         entry_number,posting_date,entry_type,source_module,currency_code,status)
  VALUES (v_je_id, v_tenant, p_company_id, v_fy, v_fp, v_je_num, p_period_end,
          'system', 'assets', 'INR', 'draft');

  FOR r IN
    SELECT ds.id AS ds_id, ds.asset_id, ds.depreciation, c.depr_expense_account_id, c.accum_depr_account_id
      FROM app.depreciation_schedules ds
      JOIN app.assets a ON a.id = ds.asset_id
      JOIN app.asset_categories c ON c.id = a.category_id
     WHERE a.company_id = p_company_id
       AND ds.period_end = p_period_end AND ds.book='accounting' AND NOT ds.posted
  LOOP
    INSERT INTO app.journal_lines(id,tenant_id,journal_entry_id,posting_date,line_no,
           account_id,debit,credit,currency_code,description)
    VALUES
      (gen_random_uuid(), v_tenant, v_je_id, p_period_end, 1,
       r.depr_expense_account_id, r.depreciation, 0, 'INR', 'Depreciation expense'),
      (gen_random_uuid(), v_tenant, v_je_id, p_period_end, 2,
       r.accum_depr_account_id, 0, r.depreciation, 'INR', 'Accumulated depreciation');

    UPDATE app.depreciation_schedules SET posted=true, journal_entry_id = v_je_id WHERE id = r.ds_id;
    UPDATE app.assets
       SET accumulated_depreciation = accumulated_depreciation + r.depreciation,
           current_book_value = GREATEST(0, purchase_cost - accumulated_depreciation - r.depreciation)
     WHERE id = r.asset_id;
    v_total := v_total + r.depreciation;
  END LOOP;

  IF v_total > 0 THEN
    PERFORM app.post_journal_entry(v_je_id);
  ELSE
    DELETE FROM app.journal_entries WHERE id = v_je_id;
  END IF;
END $$;

-- =============== VIEWS ===============
CREATE OR REPLACE VIEW app.v_asset_register AS
SELECT a.tenant_id, a.company_id, a.asset_code, a.name, ac.name AS category,
       a.purchase_date, a.purchase_cost, a.accumulated_depreciation,
       a.current_book_value, a.status, a.custodian_id, a.branch_id
  FROM app.assets a
  JOIN app.asset_categories ac ON ac.id = a.category_id;

CREATE OR REPLACE VIEW app.v_maintenance_due AS
SELECT ms.tenant_id, ms.asset_id, a.asset_code, a.name AS asset_name,
       ms.maintenance_type, ms.next_due_date,
       ms.next_due_date - CURRENT_DATE AS days_until_due
  FROM app.maintenance_schedules ms
  JOIN app.assets a ON a.id = ms.asset_id
 WHERE ms.active AND ms.next_due_date <= CURRENT_DATE + interval '14 days';
