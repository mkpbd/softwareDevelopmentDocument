-- =====================================================================
-- Module 01: Organization & Configuration Foundation
-- Covers PRD Step 1 + tenant master (Step 0 SaaS piece)
-- Entities: tenants, organizations, companies, branches, fiscal_years,
--           financial_periods, document_sequences, system_parameters,
--           localization_settings, feature_flags, plans, subscriptions,
--           currencies, exchange_rates
-- =====================================================================

SET search_path = app, core, public;

-- =============== SCHEMA ===============

-- Tenants: SaaS-level row. Not RLS-protected (admin-scope only).
CREATE TABLE IF NOT EXISTS app.tenants (
  id            uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  code          citext NOT NULL UNIQUE,
  name          text   NOT NULL,
  status        text   NOT NULL DEFAULT 'active'
                CHECK (status IN ('active','suspended','trial','cancelled')),
  plan_id       uuid,
  trial_ends_at timestamptz,
  data_region   text   NOT NULL DEFAULT 'in-south-1',
  metadata      jsonb  NOT NULL DEFAULT '{}'::jsonb,
  created_at    timestamptz NOT NULL DEFAULT now(),
  updated_at    timestamptz NOT NULL DEFAULT now(),
  created_by    uuid,
  updated_by    uuid,
  version       int    NOT NULL DEFAULT 1
);

CREATE TABLE IF NOT EXISTS app.plans (
  id            uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  code          citext NOT NULL UNIQUE,
  name          text   NOT NULL,
  tier          text   NOT NULL CHECK (tier IN ('free','starter','pro','enterprise')),
  max_users     int,
  max_branches  int,
  entitlements  jsonb  NOT NULL DEFAULT '{}'::jsonb,
  price_monthly numeric(19,4),
  price_yearly  numeric(19,4),
  currency_code char(3) NOT NULL DEFAULT 'INR',
  active        boolean NOT NULL DEFAULT true,
  created_at    timestamptz NOT NULL DEFAULT now(),
  updated_at    timestamptz NOT NULL DEFAULT now(),
  created_by    uuid, updated_by uuid, version int NOT NULL DEFAULT 1
);

ALTER TABLE app.tenants
  ADD CONSTRAINT fk_tenants_plan FOREIGN KEY (plan_id) REFERENCES app.plans(id);

-- Tenant-scoped tables begin here. All carry tenant_id.

CREATE TABLE IF NOT EXISTS app.currencies (
  tenant_id     uuid NOT NULL,
  code          char(3) NOT NULL,
  name          text NOT NULL,
  symbol        text,
  decimal_places smallint NOT NULL DEFAULT 2 CHECK (decimal_places BETWEEN 0 AND 6),
  is_base       boolean NOT NULL DEFAULT false,
  active        boolean NOT NULL DEFAULT true,
  created_at    timestamptz NOT NULL DEFAULT now(),
  updated_at    timestamptz NOT NULL DEFAULT now(),
  created_by    uuid, updated_by uuid, version int NOT NULL DEFAULT 1,
  PRIMARY KEY (tenant_id, code)
);

CREATE TABLE IF NOT EXISTS app.exchange_rates (
  id            uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id     uuid NOT NULL,
  from_currency char(3) NOT NULL,
  to_currency   char(3) NOT NULL,
  rate          numeric(19,8) NOT NULL CHECK (rate > 0),
  effective_date date NOT NULL,
  source        text,
  created_at    timestamptz NOT NULL DEFAULT now(),
  updated_at    timestamptz NOT NULL DEFAULT now(),
  created_by    uuid, updated_by uuid, version int NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, from_currency, to_currency, effective_date),
  CHECK (from_currency <> to_currency)
);

CREATE TABLE IF NOT EXISTS app.organizations (
  id            uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id     uuid NOT NULL,
  code          citext NOT NULL,
  legal_name    text NOT NULL,
  display_name  text,
  gstin         text,
  pan           text,
  incorporation_date date,
  registered_address jsonb,
  base_currency char(3) NOT NULL DEFAULT 'INR',
  active        boolean NOT NULL DEFAULT true,
  created_at    timestamptz NOT NULL DEFAULT now(),
  updated_at    timestamptz NOT NULL DEFAULT now(),
  created_by    uuid, updated_by uuid, version int NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, code)
);

CREATE TABLE IF NOT EXISTS app.companies (
  id            uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id     uuid NOT NULL,
  organization_id uuid NOT NULL REFERENCES app.organizations(id) ON DELETE RESTRICT,
  code          citext NOT NULL,
  legal_name    text NOT NULL,
  gstin         text,
  pan           text,
  tan           text,
  cin           text,
  address       jsonb,
  base_currency char(3) NOT NULL DEFAULT 'INR',
  active        boolean NOT NULL DEFAULT true,
  created_at    timestamptz NOT NULL DEFAULT now(),
  updated_at    timestamptz NOT NULL DEFAULT now(),
  created_by    uuid, updated_by uuid, version int NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, code)
);

CREATE TABLE IF NOT EXISTS app.branches (
  id            uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id     uuid NOT NULL,
  company_id    uuid NOT NULL REFERENCES app.companies(id) ON DELETE RESTRICT,
  parent_id     uuid REFERENCES app.branches(id) ON DELETE RESTRICT,
  code          citext NOT NULL,
  name          text NOT NULL,
  branch_type   text NOT NULL DEFAULT 'office'
                CHECK (branch_type IN ('hq','office','factory','warehouse','retail','virtual')),
  gstin         text,
  address       jsonb,
  timezone      text NOT NULL DEFAULT 'Asia/Kolkata',
  active        boolean NOT NULL DEFAULT true,
  created_at    timestamptz NOT NULL DEFAULT now(),
  updated_at    timestamptz NOT NULL DEFAULT now(),
  created_by    uuid, updated_by uuid, version int NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, company_id, code)
);

CREATE TABLE IF NOT EXISTS app.fiscal_years (
  id            uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id     uuid NOT NULL,
  company_id    uuid NOT NULL REFERENCES app.companies(id) ON DELETE RESTRICT,
  code          text NOT NULL,
  start_date    date NOT NULL,
  end_date      date NOT NULL,
  status        text NOT NULL DEFAULT 'open'
                CHECK (status IN ('open','closed','locked')),
  closed_at     timestamptz,
  closed_by     uuid,
  created_at    timestamptz NOT NULL DEFAULT now(),
  updated_at    timestamptz NOT NULL DEFAULT now(),
  created_by    uuid, updated_by uuid, version int NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, company_id, code),
  CHECK (end_date > start_date)
);

CREATE TABLE IF NOT EXISTS app.financial_periods (
  id            uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id     uuid NOT NULL,
  fiscal_year_id uuid NOT NULL REFERENCES app.fiscal_years(id) ON DELETE CASCADE,
  period_no     smallint NOT NULL CHECK (period_no BETWEEN 1 AND 13),
  start_date    date NOT NULL,
  end_date      date NOT NULL,
  status        text NOT NULL DEFAULT 'open'
                CHECK (status IN ('open','closed','locked')),
  closed_at     timestamptz,
  closed_by     uuid,
  created_at    timestamptz NOT NULL DEFAULT now(),
  updated_at    timestamptz NOT NULL DEFAULT now(),
  created_by    uuid, updated_by uuid, version int NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, fiscal_year_id, period_no),
  CHECK (end_date >= start_date)
);

CREATE TABLE IF NOT EXISTS app.document_sequences (
  id            uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id     uuid NOT NULL,
  company_id    uuid REFERENCES app.companies(id),
  code          citext NOT NULL,                  -- e.g. 'SALES_INV','PO','GRN'
  prefix        text,
  padding       smallint NOT NULL DEFAULT 6 CHECK (padding BETWEEN 1 AND 12),
  current_value bigint NOT NULL DEFAULT 0,
  reset_policy  text NOT NULL DEFAULT 'never'
                CHECK (reset_policy IN ('never','yearly','monthly')),
  format        text,
  created_at    timestamptz NOT NULL DEFAULT now(),
  updated_at    timestamptz NOT NULL DEFAULT now(),
  created_by    uuid, updated_by uuid, version int NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, company_id, code)
);

CREATE TABLE IF NOT EXISTS app.system_parameters (
  tenant_id     uuid NOT NULL,
  param_key     citext NOT NULL,
  param_value   jsonb NOT NULL,
  description   text,
  is_sensitive  boolean NOT NULL DEFAULT false,
  updated_at    timestamptz NOT NULL DEFAULT now(),
  updated_by    uuid,
  PRIMARY KEY (tenant_id, param_key)
);

CREATE TABLE IF NOT EXISTS app.localization_settings (
  tenant_id     uuid PRIMARY KEY,
  default_language char(5) NOT NULL DEFAULT 'en-IN',
  default_timezone text   NOT NULL DEFAULT 'Asia/Kolkata',
  date_format   text NOT NULL DEFAULT 'DD-MM-YYYY',
  number_format text NOT NULL DEFAULT 'indian',
  base_currency char(3) NOT NULL DEFAULT 'INR',
  rtl_enabled   boolean NOT NULL DEFAULT false,
  updated_at    timestamptz NOT NULL DEFAULT now(),
  updated_by    uuid
);

CREATE TABLE IF NOT EXISTS app.feature_flags (
  tenant_id     uuid NOT NULL,
  feature_code  citext NOT NULL,
  enabled       boolean NOT NULL DEFAULT false,
  rollout_percent smallint NOT NULL DEFAULT 0 CHECK (rollout_percent BETWEEN 0 AND 100),
  config        jsonb NOT NULL DEFAULT '{}'::jsonb,
  updated_at    timestamptz NOT NULL DEFAULT now(),
  updated_by    uuid,
  PRIMARY KEY (tenant_id, feature_code)
);

CREATE TABLE IF NOT EXISTS app.subscriptions (
  id            uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id     uuid NOT NULL UNIQUE,
  plan_id       uuid NOT NULL REFERENCES app.plans(id),
  status        text NOT NULL DEFAULT 'active'
                CHECK (status IN ('trial','active','past_due','cancelled','expired')),
  started_at    timestamptz NOT NULL DEFAULT now(),
  current_period_start timestamptz NOT NULL,
  current_period_end   timestamptz NOT NULL,
  cancel_at_period_end boolean NOT NULL DEFAULT false,
  created_at    timestamptz NOT NULL DEFAULT now(),
  updated_at    timestamptz NOT NULL DEFAULT now(),
  created_by    uuid, updated_by uuid, version int NOT NULL DEFAULT 1
);

-- =============== INDEXES ===============
CREATE INDEX IF NOT EXISTS idx_org_tenant          ON app.organizations(tenant_id);
CREATE INDEX IF NOT EXISTS idx_companies_tenant    ON app.companies(tenant_id, organization_id);
CREATE INDEX IF NOT EXISTS idx_branches_tenant     ON app.branches(tenant_id, company_id);
CREATE INDEX IF NOT EXISTS idx_branches_parent     ON app.branches(parent_id) WHERE parent_id IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_fy_tenant_dates     ON app.fiscal_years(tenant_id, company_id, start_date, end_date);
CREATE INDEX IF NOT EXISTS idx_fp_fy               ON app.financial_periods(fiscal_year_id, period_no);
CREATE INDEX IF NOT EXISTS idx_xrate_lookup        ON app.exchange_rates(tenant_id, from_currency, to_currency, effective_date DESC);
CREATE INDEX IF NOT EXISTS idx_docseq_lookup       ON app.document_sequences(tenant_id, code);
CREATE INDEX IF NOT EXISTS idx_ff_enabled          ON app.feature_flags(tenant_id) WHERE enabled;

-- =============== RLS ===============
SELECT core.enable_tenant_rls('app.currencies');
SELECT core.enable_tenant_rls('app.exchange_rates');
SELECT core.enable_tenant_rls('app.organizations');
SELECT core.enable_tenant_rls('app.companies');
SELECT core.enable_tenant_rls('app.branches');
SELECT core.enable_tenant_rls('app.fiscal_years');
SELECT core.enable_tenant_rls('app.financial_periods');
SELECT core.enable_tenant_rls('app.document_sequences');
SELECT core.enable_tenant_rls('app.system_parameters');
SELECT core.enable_tenant_rls('app.localization_settings');
SELECT core.enable_tenant_rls('app.feature_flags');
SELECT core.enable_tenant_rls('app.subscriptions');

-- =============== TRIGGERS ===============
SELECT core.attach_standard_triggers('app.organizations');
SELECT core.attach_standard_triggers('app.companies');
SELECT core.attach_standard_triggers('app.branches');
SELECT core.attach_standard_triggers('app.fiscal_years');
SELECT core.attach_standard_triggers('app.financial_periods');
SELECT core.attach_standard_triggers('app.document_sequences');
SELECT core.attach_standard_triggers('app.currencies');
SELECT core.attach_standard_triggers('app.exchange_rates');
SELECT core.attach_standard_triggers('app.subscriptions');

-- Special: enforce one-and-only-one is_base currency per tenant
CREATE OR REPLACE FUNCTION core.tg_single_base_currency()
RETURNS trigger
LANGUAGE plpgsql
AS $$
BEGIN
  IF NEW.is_base THEN
    UPDATE app.currencies SET is_base=false
     WHERE tenant_id = NEW.tenant_id AND code <> NEW.code AND is_base;
  END IF;
  RETURN NEW;
END $$;
DROP TRIGGER IF EXISTS trg_single_base_currency ON app.currencies;
CREATE TRIGGER trg_single_base_currency
  AFTER INSERT OR UPDATE OF is_base ON app.currencies
  FOR EACH ROW WHEN (NEW.is_base)
  EXECUTE FUNCTION core.tg_single_base_currency();

-- Fiscal period dates must fall within fiscal year
CREATE OR REPLACE FUNCTION core.tg_fp_within_fy()
RETURNS trigger
LANGUAGE plpgsql
AS $$
DECLARE
  fy_start date; fy_end date;
BEGIN
  SELECT start_date, end_date INTO fy_start, fy_end
    FROM app.fiscal_years WHERE id = NEW.fiscal_year_id;
  IF NEW.start_date < fy_start OR NEW.end_date > fy_end THEN
    RAISE EXCEPTION 'period % out of fiscal year range [%..%]', NEW.period_no, fy_start, fy_end;
  END IF;
  RETURN NEW;
END $$;
DROP TRIGGER IF EXISTS trg_fp_within_fy ON app.financial_periods;
CREATE TRIGGER trg_fp_within_fy
  BEFORE INSERT OR UPDATE ON app.financial_periods
  FOR EACH ROW EXECUTE FUNCTION core.tg_fp_within_fy();

-- =============== FUNCTIONS ===============

-- Convert money across currencies at a given date
CREATE OR REPLACE FUNCTION core.fx_convert(
  p_amount    numeric,
  p_from      char(3),
  p_to        char(3),
  p_on_date   date DEFAULT CURRENT_DATE
) RETURNS numeric
LANGUAGE plpgsql
STABLE
AS $$
DECLARE v_rate numeric(19,8);
BEGIN
  IF p_from = p_to THEN RETURN p_amount; END IF;

  SELECT rate INTO v_rate
    FROM app.exchange_rates
   WHERE tenant_id = core.require_tenant()
     AND from_currency = p_from AND to_currency = p_to
     AND effective_date <= p_on_date
   ORDER BY effective_date DESC LIMIT 1;

  IF v_rate IS NULL THEN
    -- try inverse
    SELECT 1/rate INTO v_rate
      FROM app.exchange_rates
     WHERE tenant_id = core.require_tenant()
       AND from_currency = p_to AND to_currency = p_from
       AND effective_date <= p_on_date
     ORDER BY effective_date DESC LIMIT 1;
  END IF;

  IF v_rate IS NULL THEN
    RAISE EXCEPTION 'no exchange rate: % -> % on %', p_from, p_to, p_on_date;
  END IF;
  RETURN round(p_amount * v_rate, 4);
END $$;

-- Current open fiscal period for a company, given a posting date
CREATE OR REPLACE FUNCTION core.period_for_date(
  p_company_id uuid, p_posting_date date
) RETURNS TABLE (fiscal_year_id uuid, period_id uuid, status text)
LANGUAGE sql
STABLE
AS $$
  SELECT fy.id, fp.id, fp.status
    FROM app.fiscal_years fy
    JOIN app.financial_periods fp ON fp.fiscal_year_id = fy.id
   WHERE fy.tenant_id = core.require_tenant()
     AND fy.company_id = p_company_id
     AND p_posting_date BETWEEN fp.start_date AND fp.end_date
   LIMIT 1
$$;

-- =============== VIEWS ===============
CREATE OR REPLACE VIEW app.v_org_tree AS
SELECT o.id org_id, o.legal_name org_name,
       c.id company_id, c.legal_name company_name,
       b.id branch_id, b.name branch_name, b.branch_type,
       b.tenant_id
  FROM app.organizations o
  JOIN app.companies  c ON c.organization_id = o.id
  JOIN app.branches   b ON b.company_id = c.id
 WHERE o.active AND c.active AND b.active;

-- =============== SEED ===============
-- Minimal plan catalog + INR currency scaffolding (apply at tenant provisioning time)

INSERT INTO app.plans(code,name,tier,max_users,max_branches,price_monthly,price_yearly,currency_code)
VALUES
  ('FREE','Free','free',5,1,0,0,'INR'),
  ('STARTER','Starter','starter',25,3,1999,19990,'INR'),
  ('PRO','Professional','pro',100,10,4999,49990,'INR'),
  ('ENT','Enterprise','enterprise',NULL,NULL,NULL,NULL,'INR')
ON CONFLICT (code) DO NOTHING;
