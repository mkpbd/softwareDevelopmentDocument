-- =====================================================================
-- STEP 1: Organization & Configuration Foundation
-- =====================================================================

-- Tenants (multi-tenancy root)
CREATE TABLE core.tenant (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    code            TEXT NOT NULL UNIQUE,
    name            TEXT NOT NULL,
    subdomain       TEXT UNIQUE,
    plan_code       TEXT NOT NULL DEFAULT 'starter',
    status          core.status_generic NOT NULL DEFAULT 'active',
    country_code    CHAR(2) NOT NULL DEFAULT 'IN',
    default_currency core.currency_code NOT NULL DEFAULT 'INR',
    default_locale  TEXT NOT NULL DEFAULT 'en-IN',
    timezone        TEXT NOT NULL DEFAULT 'Asia/Kolkata',
    data_region     TEXT NOT NULL DEFAULT 'in-south-1',
    settings        JSONB NOT NULL DEFAULT '{}'::jsonb,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at      TIMESTAMPTZ
);

-- Plan & entitlements (SaaS)
CREATE TABLE core.plan (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    code            TEXT NOT NULL UNIQUE,
    name            TEXT NOT NULL,
    monthly_price   core.money_amt,
    yearly_price    core.money_amt,
    max_users       INT,
    max_storage_gb  INT,
    features        JSONB NOT NULL DEFAULT '{}'::jsonb,
    is_active       BOOLEAN NOT NULL DEFAULT TRUE,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE core.tenant_entitlement (
    tenant_id       UUID NOT NULL REFERENCES core.tenant(id) ON DELETE CASCADE,
    feature_key     TEXT NOT NULL,
    limit_value     BIGINT,
    used_value      BIGINT DEFAULT 0,
    expires_at      TIMESTAMPTZ,
    PRIMARY KEY (tenant_id, feature_key)
);

-- Feature flags
CREATE TABLE core.feature_flag (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID REFERENCES core.tenant(id) ON DELETE CASCADE,
    key             TEXT NOT NULL,
    enabled         BOOLEAN NOT NULL DEFAULT FALSE,
    rollout_pct     NUMERIC(5,2) DEFAULT 0 CHECK (rollout_pct BETWEEN 0 AND 100),
    rules           JSONB,
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE (tenant_id, key)
);

-- Company (legal entity)
CREATE TABLE core.company (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL REFERENCES core.tenant(id) ON DELETE CASCADE,
    code            TEXT NOT NULL,
    legal_name      TEXT NOT NULL,
    short_name      TEXT,
    registration_no TEXT,
    tax_id          TEXT,                         -- GSTIN/VAT/EIN
    pan_no          TEXT,
    cin_no          TEXT,
    country_code    CHAR(2) NOT NULL,
    base_currency   core.currency_code NOT NULL DEFAULT 'INR',
    financial_year_start_month SMALLINT NOT NULL DEFAULT 4 CHECK (financial_year_start_month BETWEEN 1 AND 12),
    logo_url        TEXT,
    metadata        JSONB DEFAULT '{}'::jsonb,
    status          core.status_generic NOT NULL DEFAULT 'active',
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at      TIMESTAMPTZ,
    UNIQUE (tenant_id, code)
);

-- Branch (hierarchical: HO → region → branch)
CREATE TABLE core.branch (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL REFERENCES core.tenant(id) ON DELETE CASCADE,
    company_id      UUID NOT NULL REFERENCES core.company(id) ON DELETE CASCADE,
    parent_branch_id UUID REFERENCES core.branch(id) ON DELETE RESTRICT,
    code            TEXT NOT NULL,
    name            TEXT NOT NULL,
    branch_type     TEXT DEFAULT 'branch' CHECK (branch_type IN ('head_office','region','branch','virtual')),
    address_line1   TEXT,
    address_line2   TEXT,
    city            TEXT,
    state           TEXT,
    country_code    CHAR(2),
    postal_code     TEXT,
    phone           core.phone_t,
    email           core.email_t,
    tax_id          TEXT,                         -- branch-level GSTIN
    timezone        TEXT,
    is_active       BOOLEAN NOT NULL DEFAULT TRUE,
    metadata        JSONB DEFAULT '{}'::jsonb,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at      TIMESTAMPTZ,
    UNIQUE (tenant_id, company_id, code)
);

-- Fiscal year
CREATE TABLE core.fiscal_year (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL REFERENCES core.tenant(id) ON DELETE CASCADE,
    company_id      UUID NOT NULL REFERENCES core.company(id) ON DELETE CASCADE,
    code            TEXT NOT NULL,                -- 'FY2025-26'
    start_date      DATE NOT NULL,
    end_date        DATE NOT NULL,
    is_closed       BOOLEAN NOT NULL DEFAULT FALSE,
    closed_at       TIMESTAMPTZ,
    closed_by       UUID,
    UNIQUE (tenant_id, company_id, code),
    CHECK (end_date > start_date)
);

-- Financial periods
CREATE TABLE core.financial_period (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    fiscal_year_id  UUID NOT NULL REFERENCES core.fiscal_year(id) ON DELETE CASCADE,
    period_no       SMALLINT NOT NULL,
    start_date      DATE NOT NULL,
    end_date        DATE NOT NULL,
    is_closed       BOOLEAN NOT NULL DEFAULT FALSE,
    is_adjustment   BOOLEAN NOT NULL DEFAULT FALSE,
    UNIQUE (fiscal_year_id, period_no),
    EXCLUDE USING gist (fiscal_year_id WITH =, daterange(start_date, end_date, '[]') WITH &&)
);

-- System parameters
CREATE TABLE core.system_parameter (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID REFERENCES core.tenant(id) ON DELETE CASCADE,
    scope           TEXT NOT NULL DEFAULT 'tenant' CHECK (scope IN ('global','tenant','company','branch','user')),
    scope_id        UUID,
    key             TEXT NOT NULL,
    value           JSONB NOT NULL,
    data_type       TEXT NOT NULL DEFAULT 'string',
    is_secret       BOOLEAN NOT NULL DEFAULT FALSE,
    description     TEXT,
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_by      UUID,
    UNIQUE (tenant_id, scope, scope_id, key)
);

-- Localization
CREATE TABLE core.locale (
    code            TEXT PRIMARY KEY,             -- 'en-IN','hi-IN','ar-AE'
    name            TEXT NOT NULL,
    is_rtl          BOOLEAN NOT NULL DEFAULT FALSE,
    date_format     TEXT NOT NULL DEFAULT 'DD/MM/YYYY',
    number_format   TEXT NOT NULL DEFAULT '#,##,##0.00',
    decimal_sep     CHAR(1) NOT NULL DEFAULT '.',
    thousand_sep    CHAR(1) NOT NULL DEFAULT ',',
    first_day_of_week SMALLINT NOT NULL DEFAULT 1
);

-- Currency master + exchange rate
CREATE TABLE core.currency (
    code            CHAR(3) PRIMARY KEY,
    name            TEXT NOT NULL,
    symbol          TEXT,
    decimal_places  SMALLINT NOT NULL DEFAULT 2,
    is_active       BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE core.exchange_rate (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL REFERENCES core.tenant(id) ON DELETE CASCADE,
    from_currency   CHAR(3) NOT NULL REFERENCES core.currency(code),
    to_currency     CHAR(3) NOT NULL REFERENCES core.currency(code),
    rate            NUMERIC(19,8) NOT NULL CHECK (rate > 0),
    rate_date       DATE NOT NULL,
    source          TEXT,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE (tenant_id, from_currency, to_currency, rate_date)
);

-- =====================================================================
-- INDEXES
-- =====================================================================
CREATE INDEX idx_company_tenant          ON core.company(tenant_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_branch_tenant_company   ON core.branch(tenant_id, company_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_branch_parent           ON core.branch(parent_branch_id);
CREATE INDEX idx_fiscal_year_company     ON core.fiscal_year(company_id, start_date DESC);
CREATE INDEX idx_financial_period_fy     ON core.financial_period(fiscal_year_id, period_no);
CREATE INDEX idx_system_param_lookup     ON core.system_parameter(tenant_id, scope, scope_id, key);
CREATE INDEX idx_exchange_rate_lookup    ON core.exchange_rate(tenant_id, from_currency, to_currency, rate_date DESC);
CREATE INDEX idx_feature_flag_tenant_key ON core.feature_flag(tenant_id, key);
CREATE INDEX idx_tenant_status           ON core.tenant(status) WHERE deleted_at IS NULL;

-- =====================================================================
-- FUNCTIONS
-- =====================================================================
CREATE OR REPLACE FUNCTION core.fn_get_exchange_rate(
    p_tenant_id UUID, p_from CHAR(3), p_to CHAR(3), p_date DATE DEFAULT CURRENT_DATE
) RETURNS NUMERIC AS $$
DECLARE v_rate NUMERIC;
BEGIN
    IF p_from = p_to THEN RETURN 1; END IF;
    SELECT rate INTO v_rate
      FROM core.exchange_rate
     WHERE tenant_id = p_tenant_id
       AND from_currency = p_from AND to_currency = p_to
       AND rate_date <= p_date
     ORDER BY rate_date DESC LIMIT 1;
    IF v_rate IS NULL THEN
        RAISE EXCEPTION 'No exchange rate % → % on or before %', p_from, p_to, p_date;
    END IF;
    RETURN v_rate;
END;
$$ LANGUAGE plpgsql STABLE;

CREATE OR REPLACE FUNCTION core.fn_get_fiscal_period(p_company UUID, p_date DATE)
RETURNS UUID AS $$
DECLARE v_id UUID;
BEGIN
    SELECT fp.id INTO v_id
      FROM core.financial_period fp
      JOIN core.fiscal_year fy ON fy.id = fp.fiscal_year_id
     WHERE fy.company_id = p_company
       AND p_date BETWEEN fp.start_date AND fp.end_date
     LIMIT 1;
    RETURN v_id;
END;
$$ LANGUAGE plpgsql STABLE;

-- =====================================================================
-- VIEWS
-- =====================================================================
CREATE OR REPLACE VIEW core.v_branch_hierarchy AS
WITH RECURSIVE t AS (
    SELECT id, tenant_id, company_id, parent_branch_id, code, name, 1 AS lvl,
           ARRAY[code]::text[] AS path
      FROM core.branch WHERE parent_branch_id IS NULL AND deleted_at IS NULL
    UNION ALL
    SELECT b.id, b.tenant_id, b.company_id, b.parent_branch_id, b.code, b.name, t.lvl+1,
           t.path || b.code
      FROM core.branch b JOIN t ON b.parent_branch_id = t.id
     WHERE b.deleted_at IS NULL
)
SELECT * FROM t;

-- =====================================================================
-- TRIGGERS
-- =====================================================================
CREATE TRIGGER trg_tenant_updated    BEFORE UPDATE ON core.tenant
    FOR EACH ROW EXECUTE FUNCTION core.fn_set_updated_at();
CREATE TRIGGER trg_company_updated   BEFORE UPDATE ON core.company
    FOR EACH ROW EXECUTE FUNCTION core.fn_set_updated_at();
CREATE TRIGGER trg_branch_updated    BEFORE UPDATE ON core.branch
    FOR EACH ROW EXECUTE FUNCTION core.fn_set_updated_at();

CREATE TRIGGER trg_tenant_audit   AFTER INSERT OR UPDATE OR DELETE ON core.tenant
    FOR EACH ROW EXECUTE FUNCTION audit.fn_row_audit();
CREATE TRIGGER trg_company_audit  AFTER INSERT OR UPDATE OR DELETE ON core.company
    FOR EACH ROW EXECUTE FUNCTION audit.fn_row_audit();
CREATE TRIGGER trg_branch_audit   AFTER INSERT OR UPDATE OR DELETE ON core.branch
    FOR EACH ROW EXECUTE FUNCTION audit.fn_row_audit();
