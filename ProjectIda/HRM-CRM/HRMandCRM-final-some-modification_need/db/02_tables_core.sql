-- =============================================================================
-- tables.sql — Step 2: Core Tables (Steps 1 & 2 of PRD)
-- Step 1: Organization & Configuration Foundation
-- Step 2: Identity & Access Management
-- =============================================================================

-- -----------------------------------------------------------------------------
-- STEP 1: ORGANIZATION & CONFIGURATION FOUNDATION
-- -----------------------------------------------------------------------------

-- Tenants (top-level SaaS isolation unit)
CREATE TABLE core.tenants (
    tenant_id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_code         VARCHAR(50)  NOT NULL UNIQUE,
    tenant_name         VARCHAR(255) NOT NULL,
    tenant_slug         VARCHAR(100) NOT NULL UNIQUE,
    plan_tier           VARCHAR(50)  NOT NULL DEFAULT 'standard' CHECK (plan_tier IN ('trial','standard','professional','enterprise')),
    is_active           BOOLEAN      NOT NULL DEFAULT TRUE,
    provisioned_at      TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    expires_at          TIMESTAMPTZ,
    max_users           INTEGER      NOT NULL DEFAULT 50,
    max_branches        INTEGER      NOT NULL DEFAULT 5,
    db_schema_name      VARCHAR(100),
    created_by          UUID         NOT NULL,
    updated_by          UUID         NOT NULL,
    deleted_by          UUID,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    deleted_at          TIMESTAMPTZ
);

-- Organizations (legal entity within a tenant)
CREATE TABLE core.organizations (
    organization_id     UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id           UUID         NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id           UUID,                          -- set after branch table created
    org_code            VARCHAR(50)  NOT NULL,
    org_name            VARCHAR(255) NOT NULL,
    legal_name          VARCHAR(255),
    registration_number VARCHAR(100),
    tax_number          VARCHAR(100),
    gstin               VARCHAR(20),
    pan_number          VARCHAR(20),
    cin_number          VARCHAR(30),
    org_type            VARCHAR(50)  NOT NULL DEFAULT 'private_limited',
    industry_sector     VARCHAR(100),
    incorporation_date  DATE,
    base_currency_code  VARCHAR(10)  NOT NULL DEFAULT 'INR',
    logo_url            TEXT,
    website_url         TEXT,
    is_active           BOOLEAN      NOT NULL DEFAULT TRUE,
    created_by          UUID         NOT NULL,
    updated_by          UUID         NOT NULL,
    deleted_by          UUID,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    deleted_at          TIMESTAMPTZ,
    UNIQUE (tenant_id, org_code)
);

-- Branches (physical/logical locations)
CREATE TABLE core.branches (
    branch_id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id           UUID         NOT NULL REFERENCES core.tenants(tenant_id),
    organization_id     UUID         NOT NULL REFERENCES core.organizations(organization_id),
    parent_branch_id    UUID         REFERENCES core.branches(branch_id),
    branch_code         VARCHAR(50)  NOT NULL,
    branch_name         VARCHAR(255) NOT NULL,
    branch_type         VARCHAR(50)  NOT NULL DEFAULT 'branch' CHECK (branch_type IN ('head_office','branch','warehouse','plant','virtual')),
    address_line1       VARCHAR(255),
    address_line2       VARCHAR(255),
    city                VARCHAR(100),
    state_province      VARCHAR(100),
    country_code        VARCHAR(10)  NOT NULL DEFAULT 'IN',
    postal_code         VARCHAR(20),
    phone               VARCHAR(30),
    email               VARCHAR(255),
    gstin               VARCHAR(20),
    timezone            VARCHAR(100) NOT NULL DEFAULT 'Asia/Kolkata',
    is_active           BOOLEAN      NOT NULL DEFAULT TRUE,
    created_by          UUID         NOT NULL,
    updated_by          UUID         NOT NULL,
    deleted_by          UUID,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    deleted_at          TIMESTAMPTZ,
    UNIQUE (tenant_id, branch_code)
);

-- Fiscal Years
CREATE TABLE core.fiscal_years (
    fiscal_year_id      UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id           UUID         NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id           UUID         NOT NULL REFERENCES core.branches(branch_id),
    fiscal_year_code    VARCHAR(20)  NOT NULL,
    fiscal_year_name    VARCHAR(100) NOT NULL,
    start_date          DATE         NOT NULL,
    end_date            DATE         NOT NULL,
    is_current          BOOLEAN      NOT NULL DEFAULT FALSE,
    is_closed           BOOLEAN      NOT NULL DEFAULT FALSE,
    closed_at           TIMESTAMPTZ,
    closed_by           UUID,
    created_by          UUID         NOT NULL,
    updated_by          UUID         NOT NULL,
    deleted_by          UUID,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    deleted_at          TIMESTAMPTZ,
    UNIQUE (tenant_id, fiscal_year_code),
    CHECK (end_date > start_date)
);

-- Financial Periods (months within fiscal year)
CREATE TABLE core.financial_periods (
    financial_period_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id           UUID         NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id           UUID         NOT NULL REFERENCES core.branches(branch_id),
    fiscal_year_id      UUID         NOT NULL REFERENCES core.fiscal_years(fiscal_year_id),
    period_number       SMALLINT     NOT NULL CHECK (period_number BETWEEN 1 AND 13),
    period_name         VARCHAR(50)  NOT NULL,
    start_date          DATE         NOT NULL,
    end_date            DATE         NOT NULL,
    is_closed           BOOLEAN      NOT NULL DEFAULT FALSE,
    closed_at           TIMESTAMPTZ,
    closed_by           UUID,
    created_by          UUID         NOT NULL,
    updated_by          UUID         NOT NULL,
    deleted_by          UUID,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    deleted_at          TIMESTAMPTZ,
    UNIQUE (tenant_id, fiscal_year_id, period_number)
);

-- Document Numbering Sequences
CREATE TABLE core.document_sequences (
    document_sequence_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id            UUID         NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id            UUID         NOT NULL REFERENCES core.branches(branch_id),
    document_type        VARCHAR(100) NOT NULL,
    prefix               VARCHAR(20),
    suffix               VARCHAR(20),
    separator            VARCHAR(5)   NOT NULL DEFAULT '-',
    current_number       BIGINT       NOT NULL DEFAULT 0,
    padding_length       SMALLINT     NOT NULL DEFAULT 6,
    reset_frequency      VARCHAR(20)  NOT NULL DEFAULT 'yearly' CHECK (reset_frequency IN ('never','yearly','monthly','daily')),
    last_reset_at        TIMESTAMPTZ,
    fiscal_year_id       UUID         REFERENCES core.fiscal_years(fiscal_year_id),
    is_active            BOOLEAN      NOT NULL DEFAULT TRUE,
    created_by           UUID         NOT NULL,
    updated_by           UUID         NOT NULL,
    deleted_by           UUID,
    created_at           TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at           TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    deleted_at           TIMESTAMPTZ,
    UNIQUE (tenant_id, branch_id, document_type, fiscal_year_id)
);

-- System Parameters (key-value config per tenant)
CREATE TABLE core.system_parameters (
    system_parameter_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id           UUID         NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id           UUID         NOT NULL REFERENCES core.branches(branch_id),
    parameter_group     VARCHAR(100) NOT NULL,
    parameter_key       VARCHAR(200) NOT NULL,
    parameter_value     TEXT,
    data_type           VARCHAR(20)  NOT NULL DEFAULT 'string' CHECK (data_type IN ('string','integer','decimal','boolean','json','date')),
    is_encrypted        BOOLEAN      NOT NULL DEFAULT FALSE,
    description         TEXT,
    is_system           BOOLEAN      NOT NULL DEFAULT FALSE,
    created_by          UUID         NOT NULL,
    updated_by          UUID         NOT NULL,
    deleted_by          UUID,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    deleted_at          TIMESTAMPTZ,
    UNIQUE (tenant_id, branch_id, parameter_group, parameter_key)
);

-- Currencies
CREATE TABLE core.currencies (
    currency_id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id           UUID         NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id           UUID         NOT NULL REFERENCES core.branches(branch_id),
    currency_code       VARCHAR(10)  NOT NULL,
    currency_name       VARCHAR(100) NOT NULL,
    currency_symbol     VARCHAR(10)  NOT NULL,
    decimal_places      SMALLINT     NOT NULL DEFAULT 2,
    is_base_currency    BOOLEAN      NOT NULL DEFAULT FALSE,
    is_active           BOOLEAN      NOT NULL DEFAULT TRUE,
    created_by          UUID         NOT NULL,
    updated_by          UUID         NOT NULL,
    deleted_by          UUID,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    deleted_at          TIMESTAMPTZ,
    UNIQUE (tenant_id, currency_code)
);

-- Exchange Rates
CREATE TABLE core.exchange_rates (
    exchange_rate_id    UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id           UUID         NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id           UUID         NOT NULL REFERENCES core.branches(branch_id),
    from_currency_code  VARCHAR(10)  NOT NULL,
    to_currency_code    VARCHAR(10)  NOT NULL,
    rate                NUMERIC(20,8) NOT NULL CHECK (rate > 0),
    rate_date           DATE         NOT NULL,
    rate_source         VARCHAR(100),
    created_by          UUID         NOT NULL,
    updated_by          UUID         NOT NULL,
    deleted_by          UUID,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    deleted_at          TIMESTAMPTZ
);

-- Countries / States / Cities lookup
CREATE TABLE core.countries (
    country_id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id           UUID         NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id           UUID         NOT NULL REFERENCES core.branches(branch_id),
    country_code        VARCHAR(10)  NOT NULL,
    country_name        VARCHAR(100) NOT NULL,
    phone_code          VARCHAR(10),
    currency_code       VARCHAR(10),
    is_active           BOOLEAN      NOT NULL DEFAULT TRUE,
    created_by          UUID         NOT NULL,
    updated_by          UUID         NOT NULL,
    deleted_by          UUID,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    deleted_at          TIMESTAMPTZ,
    UNIQUE (tenant_id, country_code)
);

-- Feature Flags
CREATE TABLE core.feature_flags (
    feature_flag_id     UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id           UUID         NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id           UUID         NOT NULL REFERENCES core.branches(branch_id),
    flag_key            VARCHAR(200) NOT NULL,
    flag_name           VARCHAR(200) NOT NULL,
    is_enabled          BOOLEAN      NOT NULL DEFAULT FALSE,
    rollout_percentage  SMALLINT     NOT NULL DEFAULT 0 CHECK (rollout_percentage BETWEEN 0 AND 100),
    target_roles        JSONB,
    valid_from          TIMESTAMPTZ,
    valid_until         TIMESTAMPTZ,
    created_by          UUID         NOT NULL,
    updated_by          UUID         NOT NULL,
    deleted_by          UUID,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    deleted_at          TIMESTAMPTZ,
    UNIQUE (tenant_id, flag_key)
);

-- =============================================================================
-- STEP 2: IDENTITY & ACCESS MANAGEMENT
-- =============================================================================

-- Roles
CREATE TABLE iam.roles (
    role_id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id           UUID         NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id           UUID         NOT NULL REFERENCES core.branches(branch_id),
    role_code           VARCHAR(100) NOT NULL,
    role_name           VARCHAR(200) NOT NULL,
    role_description    TEXT,
    is_system_role      BOOLEAN      NOT NULL DEFAULT FALSE,
    is_active           BOOLEAN      NOT NULL DEFAULT TRUE,
    created_by          UUID         NOT NULL,
    updated_by          UUID         NOT NULL,
    deleted_by          UUID,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    deleted_at          TIMESTAMPTZ,
    UNIQUE (tenant_id, role_code)
);

-- Permissions
CREATE TABLE iam.permissions (
    permission_id       UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id           UUID         NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id           UUID         NOT NULL REFERENCES core.branches(branch_id),
    resource            VARCHAR(200) NOT NULL,
    action              VARCHAR(50)  NOT NULL CHECK (action IN ('create','read','update','delete','approve','export','import','execute')),
    permission_code     VARCHAR(300) NOT NULL,
    description         TEXT,
    is_active           BOOLEAN      NOT NULL DEFAULT TRUE,
    created_by          UUID         NOT NULL,
    updated_by          UUID         NOT NULL,
    deleted_by          UUID,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    deleted_at          TIMESTAMPTZ,
    UNIQUE (tenant_id, permission_code)
);

-- Role <-> Permission mapping
CREATE TABLE iam.role_permissions (
    role_permission_id  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id           UUID         NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id           UUID         NOT NULL REFERENCES core.branches(branch_id),
    role_id             UUID         NOT NULL REFERENCES iam.roles(role_id),
    permission_id       UUID         NOT NULL REFERENCES iam.permissions(permission_id),
    granted_by          UUID         NOT NULL,
    granted_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    created_by          UUID         NOT NULL,
    updated_by          UUID         NOT NULL,
    deleted_by          UUID,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    deleted_at          TIMESTAMPTZ,
    UNIQUE (tenant_id, role_id, permission_id)
);

-- Users
CREATE TABLE iam.users (
    user_id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id           UUID         NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id           UUID         NOT NULL REFERENCES core.branches(branch_id),
    employee_id         UUID,                          -- FK to hr.employees (set later)
    username            VARCHAR(100) NOT NULL,
    email               VARCHAR(255) NOT NULL,
    phone               VARCHAR(30),
    password_hash       TEXT         NOT NULL,
    full_name           VARCHAR(255) NOT NULL,
    display_name        VARCHAR(100),
    avatar_url          TEXT,
    locale              VARCHAR(20)  NOT NULL DEFAULT 'en',
    timezone            VARCHAR(100) NOT NULL DEFAULT 'Asia/Kolkata',
    is_active           BOOLEAN      NOT NULL DEFAULT TRUE,
    is_email_verified   BOOLEAN      NOT NULL DEFAULT FALSE,
    is_phone_verified   BOOLEAN      NOT NULL DEFAULT FALSE,
    last_login_at       TIMESTAMPTZ,
    last_login_ip       INET,
    failed_login_count  SMALLINT     NOT NULL DEFAULT 0,
    locked_until        TIMESTAMPTZ,
    password_changed_at TIMESTAMPTZ,
    must_change_password BOOLEAN     NOT NULL DEFAULT FALSE,
    created_by          UUID         NOT NULL,
    updated_by          UUID         NOT NULL,
    deleted_by          UUID,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    deleted_at          TIMESTAMPTZ,
    UNIQUE (tenant_id, username),
    UNIQUE (tenant_id, email)
);

-- User <-> Role mapping
CREATE TABLE iam.user_roles (
    user_role_id        UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id           UUID         NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id           UUID         NOT NULL REFERENCES core.branches(branch_id),
    user_id             UUID         NOT NULL REFERENCES iam.users(user_id),
    role_id             UUID         NOT NULL REFERENCES iam.roles(role_id),
    assigned_by         UUID         NOT NULL,
    valid_from          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    valid_until         TIMESTAMPTZ,
    created_by          UUID         NOT NULL,
    updated_by          UUID         NOT NULL,
    deleted_by          UUID,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    deleted_at          TIMESTAMPTZ,
    UNIQUE (tenant_id, user_id, role_id)
);

-- User Branch Access (which branches a user can access)
CREATE TABLE iam.user_branch_access (
    user_branch_access_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id             UUID       NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id             UUID       NOT NULL REFERENCES core.branches(branch_id),
    user_id               UUID       NOT NULL REFERENCES iam.users(user_id),
    accessible_branch_id  UUID       NOT NULL REFERENCES core.branches(branch_id),
    access_level          VARCHAR(20) NOT NULL DEFAULT 'read' CHECK (access_level IN ('read','write','admin')),
    created_by            UUID       NOT NULL,
    updated_by            UUID       NOT NULL,
    deleted_by            UUID,
    created_at            TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at            TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at            TIMESTAMPTZ,
    UNIQUE (tenant_id, user_id, accessible_branch_id)
);

-- Sessions
CREATE TABLE iam.user_sessions (
    user_session_id     UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id           UUID         NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id           UUID         NOT NULL REFERENCES core.branches(branch_id),
    user_id             UUID         NOT NULL REFERENCES iam.users(user_id),
    session_token       TEXT         NOT NULL UNIQUE,
    refresh_token       TEXT         UNIQUE,
    ip_address          INET,
    user_agent          TEXT,
    device_fingerprint  TEXT,
    is_active           BOOLEAN      NOT NULL DEFAULT TRUE,
    expires_at          TIMESTAMPTZ  NOT NULL,
    revoked_at          TIMESTAMPTZ,
    revoked_reason      VARCHAR(100),
    created_by          UUID         NOT NULL,
    updated_by          UUID         NOT NULL,
    deleted_by          UUID,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    deleted_at          TIMESTAMPTZ
);

-- MFA configurations
CREATE TABLE iam.mfa_configurations (
    mfa_configuration_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id            UUID        NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id            UUID        NOT NULL REFERENCES core.branches(branch_id),
    user_id              UUID        NOT NULL REFERENCES iam.users(user_id),
    mfa_type             VARCHAR(20) NOT NULL CHECK (mfa_type IN ('totp','sms','email','push')),
    secret_encrypted     TEXT,
    phone_number         VARCHAR(30),
    email_address        VARCHAR(255),
    is_verified          BOOLEAN     NOT NULL DEFAULT FALSE,
    is_primary           BOOLEAN     NOT NULL DEFAULT FALSE,
    verified_at          TIMESTAMPTZ,
    created_by           UUID        NOT NULL,
    updated_by           UUID        NOT NULL,
    deleted_by           UUID,
    created_at           TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at           TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at           TIMESTAMPTZ,
    UNIQUE (tenant_id, user_id, mfa_type)
);

-- API Keys
CREATE TABLE iam.api_keys (
    api_key_id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id           UUID         NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id           UUID         NOT NULL REFERENCES core.branches(branch_id),
    user_id             UUID         REFERENCES iam.users(user_id),
    key_name            VARCHAR(200) NOT NULL,
    key_prefix          VARCHAR(20)  NOT NULL,
    key_hash            TEXT         NOT NULL UNIQUE,
    scopes              JSONB        NOT NULL DEFAULT '[]',
    allowed_ips         JSONB,
    expires_at          TIMESTAMPTZ,
    last_used_at        TIMESTAMPTZ,
    is_active           BOOLEAN      NOT NULL DEFAULT TRUE,
    created_by          UUID         NOT NULL,
    updated_by          UUID         NOT NULL,
    deleted_by          UUID,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    deleted_at          TIMESTAMPTZ
);

-- Password Policy
CREATE TABLE iam.password_policies (
    password_policy_id  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id           UUID         NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id           UUID         NOT NULL REFERENCES core.branches(branch_id),
    min_length          SMALLINT     NOT NULL DEFAULT 8,
    max_length          SMALLINT     NOT NULL DEFAULT 128,
    require_uppercase   BOOLEAN      NOT NULL DEFAULT TRUE,
    require_lowercase   BOOLEAN      NOT NULL DEFAULT TRUE,
    require_digits      BOOLEAN      NOT NULL DEFAULT TRUE,
    require_special     BOOLEAN      NOT NULL DEFAULT TRUE,
    history_count       SMALLINT     NOT NULL DEFAULT 5,
    max_age_days        SMALLINT     NOT NULL DEFAULT 90,
    max_failed_attempts SMALLINT     NOT NULL DEFAULT 5,
    lockout_duration_minutes SMALLINT NOT NULL DEFAULT 30,
    is_active           BOOLEAN      NOT NULL DEFAULT TRUE,
    created_by          UUID         NOT NULL,
    updated_by          UUID         NOT NULL,
    deleted_by          UUID,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    deleted_at          TIMESTAMPTZ,
    UNIQUE (tenant_id)
);

-- SSO Configurations
CREATE TABLE iam.sso_configurations (
    sso_configuration_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id            UUID        NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id            UUID        NOT NULL REFERENCES core.branches(branch_id),
    sso_type             VARCHAR(20) NOT NULL CHECK (sso_type IN ('saml','oidc','oauth2')),
    provider_name        VARCHAR(100) NOT NULL,
    client_id            TEXT,
    client_secret_encrypted TEXT,
    metadata_url         TEXT,
    callback_url         TEXT,
    is_active            BOOLEAN     NOT NULL DEFAULT TRUE,
    config_json          JSONB,
    created_by           UUID        NOT NULL,
    updated_by           UUID        NOT NULL,
    deleted_by           UUID,
    created_at           TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at           TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at           TIMESTAMPTZ,
    UNIQUE (tenant_id, sso_type, provider_name)
);

-- Auth Audit Trail
CREATE TABLE iam.auth_audit_logs (
    auth_audit_log_id   UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id           UUID         NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id           UUID         NOT NULL REFERENCES core.branches(branch_id),
    user_id             UUID         REFERENCES iam.users(user_id),
    event_type          VARCHAR(100) NOT NULL,
    event_status        VARCHAR(20)  NOT NULL CHECK (event_status IN ('success','failure','blocked')),
    ip_address          INET,
    user_agent          TEXT,
    session_id          UUID,
    failure_reason      VARCHAR(255),
    metadata            JSONB,
    created_by          UUID         NOT NULL,
    updated_by          UUID         NOT NULL,
    deleted_by          UUID,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    deleted_at          TIMESTAMPTZ
) PARTITION BY RANGE (created_at);

-- Partition auth_audit_logs by month (create for current year)
CREATE TABLE iam.auth_audit_logs_2026_01 PARTITION OF iam.auth_audit_logs
    FOR VALUES FROM ('2026-01-01') TO ('2026-02-01');
CREATE TABLE iam.auth_audit_logs_2026_02 PARTITION OF iam.auth_audit_logs
    FOR VALUES FROM ('2026-02-01') TO ('2026-03-01');
CREATE TABLE iam.auth_audit_logs_2026_03 PARTITION OF iam.auth_audit_logs
    FOR VALUES FROM ('2026-03-01') TO ('2026-04-01');
CREATE TABLE iam.auth_audit_logs_2026_04 PARTITION OF iam.auth_audit_logs
    FOR VALUES FROM ('2026-04-01') TO ('2026-05-01');
CREATE TABLE iam.auth_audit_logs_2026_05 PARTITION OF iam.auth_audit_logs
    FOR VALUES FROM ('2026-05-01') TO ('2026-06-01');
CREATE TABLE iam.auth_audit_logs_2026_06 PARTITION OF iam.auth_audit_logs
    FOR VALUES FROM ('2026-06-01') TO ('2026-07-01');
CREATE TABLE iam.auth_audit_logs_2026_07 PARTITION OF iam.auth_audit_logs
    FOR VALUES FROM ('2026-07-01') TO ('2026-08-01');
CREATE TABLE iam.auth_audit_logs_2026_08 PARTITION OF iam.auth_audit_logs
    FOR VALUES FROM ('2026-08-01') TO ('2026-09-01');
CREATE TABLE iam.auth_audit_logs_2026_09 PARTITION OF iam.auth_audit_logs
    FOR VALUES FROM ('2026-09-01') TO ('2026-10-01');
CREATE TABLE iam.auth_audit_logs_2026_10 PARTITION OF iam.auth_audit_logs
    FOR VALUES FROM ('2026-10-01') TO ('2026-11-01');
CREATE TABLE iam.auth_audit_logs_2026_11 PARTITION OF iam.auth_audit_logs
    FOR VALUES FROM ('2026-11-01') TO ('2026-12-01');
CREATE TABLE iam.auth_audit_logs_2026_12 PARTITION OF iam.auth_audit_logs
    FOR VALUES FROM ('2026-12-01') TO ('2027-01-01');

-- =============================================================================
-- INDEXES — Core & IAM
-- =============================================================================

CREATE INDEX idx_organizations_tenant ON core.organizations(tenant_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_branches_tenant ON core.branches(tenant_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_branches_org ON core.branches(organization_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_fiscal_years_tenant_current ON core.fiscal_years(tenant_id, is_current) WHERE deleted_at IS NULL;
CREATE INDEX idx_financial_periods_fy ON core.financial_periods(fiscal_year_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_doc_sequences_type ON core.document_sequences(tenant_id, branch_id, document_type) WHERE deleted_at IS NULL;
CREATE INDEX idx_exchange_rates_date ON core.exchange_rates(tenant_id, rate_date, from_currency_code, to_currency_code);

CREATE INDEX idx_users_tenant_email ON iam.users(tenant_id, email) WHERE deleted_at IS NULL;
CREATE INDEX idx_users_tenant_username ON iam.users(tenant_id, username) WHERE deleted_at IS NULL;
CREATE INDEX idx_user_roles_user ON iam.user_roles(user_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_user_roles_role ON iam.user_roles(role_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_role_permissions_role ON iam.role_permissions(role_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_sessions_token ON iam.user_sessions(session_token) WHERE deleted_at IS NULL;
CREATE INDEX idx_sessions_user ON iam.user_sessions(user_id, is_active) WHERE deleted_at IS NULL;
CREATE INDEX idx_api_keys_hash ON iam.api_keys(key_hash) WHERE deleted_at IS NULL;
CREATE INDEX idx_auth_logs_user ON iam.auth_audit_logs(user_id, created_at);
CREATE INDEX idx_auth_logs_tenant ON iam.auth_audit_logs(tenant_id, created_at);

-- =============================================================================
-- MINIMAL DUMMY DATA — Core & IAM
-- =============================================================================

DO $$
DECLARE
    v_tenant_id   UUID := 'a0000000-0000-0000-0000-000000000001';
    v_branch_id   UUID := 'b0000000-0000-0000-0000-000000000001';
    v_org_id      UUID := 'c0000000-0000-0000-0000-000000000001';
    v_system_user UUID := '00000000-0000-0000-0000-000000000001';
    v_fy_id       UUID := 'f0000000-0000-0000-0000-000000000001';
    v_role_id     UUID := 'r0000000-0000-0000-0000-000000000001';
    v_user_id     UUID := 'u0000000-0000-0000-0000-000000000001';
BEGIN
    INSERT INTO core.tenants (tenant_id, tenant_code, tenant_name, tenant_slug, plan_tier, created_by, updated_by)
    VALUES (v_tenant_id, 'DEMO', 'Demo Corp', 'demo-corp', 'enterprise', v_system_user, v_system_user)
    ON CONFLICT DO NOTHING;

    INSERT INTO core.organizations (organization_id, tenant_id, branch_id, org_code, org_name, legal_name, base_currency_code, created_by, updated_by)
    VALUES (v_org_id, v_tenant_id, v_branch_id, 'DEMO-ORG', 'Demo Organization', 'Demo Corp Pvt Ltd', 'INR', v_system_user, v_system_user)
    ON CONFLICT DO NOTHING;

    INSERT INTO core.branches (branch_id, tenant_id, organization_id, branch_code, branch_name, branch_type, country_code, created_by, updated_by)
    VALUES (v_branch_id, v_tenant_id, v_org_id, 'HO', 'Head Office', 'head_office', 'IN', v_system_user, v_system_user)
    ON CONFLICT DO NOTHING;

    INSERT INTO core.fiscal_years (fiscal_year_id, tenant_id, branch_id, fiscal_year_code, fiscal_year_name, start_date, end_date, is_current, created_by, updated_by)
    VALUES (v_fy_id, v_tenant_id, v_branch_id, 'FY2026', 'FY 2025-26', '2025-04-01', '2026-03-31', TRUE, v_system_user, v_system_user)
    ON CONFLICT DO NOTHING;

    INSERT INTO core.currencies (tenant_id, branch_id, currency_code, currency_name, currency_symbol, is_base_currency, created_by, updated_by)
    VALUES
        (v_tenant_id, v_branch_id, 'INR', 'Indian Rupee', '₹', TRUE, v_system_user, v_system_user),
        (v_tenant_id, v_branch_id, 'USD', 'US Dollar', '$', FALSE, v_system_user, v_system_user),
        (v_tenant_id, v_branch_id, 'EUR', 'Euro', '€', FALSE, v_system_user, v_system_user)
    ON CONFLICT DO NOTHING;

    INSERT INTO iam.roles (role_id, tenant_id, branch_id, role_code, role_name, is_system_role, created_by, updated_by)
    VALUES
        (v_role_id, v_tenant_id, v_branch_id, 'SUPER_ADMIN', 'Super Administrator', TRUE, v_system_user, v_system_user),
        (gen_random_uuid(), v_tenant_id, v_branch_id, 'ORG_ADMIN', 'Organization Administrator', TRUE, v_system_user, v_system_user),
        (gen_random_uuid(), v_tenant_id, v_branch_id, 'ACCOUNTANT', 'Accountant', FALSE, v_system_user, v_system_user),
        (gen_random_uuid(), v_tenant_id, v_branch_id, 'HR_ADMIN', 'HR Administrator', FALSE, v_system_user, v_system_user),
        (gen_random_uuid(), v_tenant_id, v_branch_id, 'SALES_REP', 'Sales Representative', FALSE, v_system_user, v_system_user),
        (gen_random_uuid(), v_tenant_id, v_branch_id, 'EMPLOYEE', 'Employee (Self-Service)', FALSE, v_system_user, v_system_user)
    ON CONFLICT DO NOTHING;

    INSERT INTO iam.users (user_id, tenant_id, branch_id, username, email, password_hash, full_name, is_active, is_email_verified, created_by, updated_by)
    VALUES (v_user_id, v_tenant_id, v_branch_id, 'admin', 'admin@democorp.com', '$2b$12$placeholder_hash', 'System Administrator', TRUE, TRUE, v_system_user, v_system_user)
    ON CONFLICT DO NOTHING;

    INSERT INTO iam.user_roles (tenant_id, branch_id, user_id, role_id, assigned_by, created_by, updated_by)
    VALUES (v_tenant_id, v_branch_id, v_user_id, v_role_id, v_system_user, v_system_user, v_system_user)
    ON CONFLICT DO NOTHING;

    INSERT INTO iam.password_policies (tenant_id, branch_id, min_length, require_uppercase, require_lowercase, require_digits, require_special, max_age_days, created_by, updated_by)
    VALUES (v_tenant_id, v_branch_id, 10, TRUE, TRUE, TRUE, TRUE, 90, v_system_user, v_system_user)
    ON CONFLICT DO NOTHING;
END $$;
