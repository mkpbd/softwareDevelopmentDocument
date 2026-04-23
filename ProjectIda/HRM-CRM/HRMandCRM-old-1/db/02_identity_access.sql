-- =====================================================================
-- STEP 2: Identity & Access Management
-- =====================================================================

CREATE TABLE iam.user (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL REFERENCES core.tenant(id) ON DELETE CASCADE,
    username        CITEXT NOT NULL,
    email           core.email_t NOT NULL,
    mobile          core.phone_t,
    password_hash   TEXT,
    password_algo   TEXT NOT NULL DEFAULT 'argon2id',
    password_changed_at TIMESTAMPTZ,
    force_password_change BOOLEAN NOT NULL DEFAULT FALSE,
    first_name      TEXT,
    last_name       TEXT,
    display_name    TEXT,
    avatar_url      TEXT,
    locale          TEXT DEFAULT 'en-IN',
    timezone        TEXT DEFAULT 'Asia/Kolkata',
    status          TEXT NOT NULL DEFAULT 'active'
        CHECK (status IN ('active','suspended','locked','pending_verification','deactivated')),
    is_service_account BOOLEAN NOT NULL DEFAULT FALSE,
    last_login_at   TIMESTAMPTZ,
    last_login_ip   INET,
    failed_attempts INT NOT NULL DEFAULT 0,
    lock_until      TIMESTAMPTZ,
    email_verified_at TIMESTAMPTZ,
    mobile_verified_at TIMESTAMPTZ,
    mfa_enabled     BOOLEAN NOT NULL DEFAULT FALSE,
    attributes      JSONB DEFAULT '{}'::jsonb,   -- ABAC attributes
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at      TIMESTAMPTZ,
    UNIQUE (tenant_id, username),
    UNIQUE (tenant_id, email)
);

CREATE TABLE iam.role (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL REFERENCES core.tenant(id) ON DELETE CASCADE,
    code            TEXT NOT NULL,
    name            TEXT NOT NULL,
    description     TEXT,
    is_system       BOOLEAN NOT NULL DEFAULT FALSE,
    is_active       BOOLEAN NOT NULL DEFAULT TRUE,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE (tenant_id, code)
);

CREATE TABLE iam.permission (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    code            TEXT NOT NULL UNIQUE,         -- 'sales.invoice.create'
    module          TEXT NOT NULL,
    resource        TEXT NOT NULL,
    action          TEXT NOT NULL,                -- create/read/update/delete/approve/post/...
    description     TEXT
);

CREATE TABLE iam.role_permission (
    role_id         UUID NOT NULL REFERENCES iam.role(id) ON DELETE CASCADE,
    permission_id   UUID NOT NULL REFERENCES iam.permission(id) ON DELETE CASCADE,
    conditions      JSONB,                        -- ABAC extra filters
    PRIMARY KEY (role_id, permission_id)
);

CREATE TABLE iam.user_role (
    user_id         UUID NOT NULL REFERENCES iam.user(id) ON DELETE CASCADE,
    role_id         UUID NOT NULL REFERENCES iam.role(id) ON DELETE CASCADE,
    company_id      UUID REFERENCES core.company(id) ON DELETE CASCADE,
    branch_id       UUID REFERENCES core.branch(id) ON DELETE CASCADE,
    valid_from      DATE,
    valid_to        DATE,
    assigned_by     UUID,
    assigned_at     TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    PRIMARY KEY (user_id, role_id, COALESCE(company_id, '00000000-0000-0000-0000-000000000000'::uuid),
                 COALESCE(branch_id,  '00000000-0000-0000-0000-000000000000'::uuid))
);

-- Direct permission override (grant/deny at user level)
CREATE TABLE iam.user_permission (
    user_id         UUID NOT NULL REFERENCES iam.user(id) ON DELETE CASCADE,
    permission_id   UUID NOT NULL REFERENCES iam.permission(id) ON DELETE CASCADE,
    grant_type      TEXT NOT NULL CHECK (grant_type IN ('grant','deny')),
    conditions      JSONB,
    PRIMARY KEY (user_id, permission_id)
);

-- Branch access control (explicit allow list)
CREATE TABLE iam.user_branch_access (
    user_id         UUID NOT NULL REFERENCES iam.user(id) ON DELETE CASCADE,
    branch_id       UUID NOT NULL REFERENCES core.branch(id) ON DELETE CASCADE,
    access_level    TEXT NOT NULL DEFAULT 'read' CHECK (access_level IN ('read','write','admin')),
    PRIMARY KEY (user_id, branch_id)
);

-- Sessions
CREATE TABLE iam.session (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id         UUID NOT NULL REFERENCES iam.user(id) ON DELETE CASCADE,
    tenant_id       UUID NOT NULL REFERENCES core.tenant(id) ON DELETE CASCADE,
    refresh_token_hash TEXT NOT NULL UNIQUE,
    issued_at       TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    expires_at      TIMESTAMPTZ NOT NULL,
    revoked_at      TIMESTAMPTZ,
    ip_address      INET,
    user_agent      TEXT,
    device_id       TEXT,
    last_seen_at    TIMESTAMPTZ
);

-- MFA
CREATE TABLE iam.mfa_factor (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id         UUID NOT NULL REFERENCES iam.user(id) ON DELETE CASCADE,
    factor_type     TEXT NOT NULL CHECK (factor_type IN ('totp','sms','email','push','webauthn')),
    secret_enc      BYTEA,
    phone           core.phone_t,
    email           core.email_t,
    label           TEXT,
    is_primary      BOOLEAN NOT NULL DEFAULT FALSE,
    verified_at     TIMESTAMPTZ,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- SSO providers
CREATE TABLE iam.sso_provider (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL REFERENCES core.tenant(id) ON DELETE CASCADE,
    name            TEXT NOT NULL,
    protocol        TEXT NOT NULL CHECK (protocol IN ('saml','oidc','oauth2')),
    metadata        JSONB NOT NULL,
    client_id       TEXT,
    client_secret_enc BYTEA,
    is_active       BOOLEAN NOT NULL DEFAULT TRUE,
    UNIQUE (tenant_id, name)
);

CREATE TABLE iam.sso_identity (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id         UUID NOT NULL REFERENCES iam.user(id) ON DELETE CASCADE,
    provider_id     UUID NOT NULL REFERENCES iam.sso_provider(id) ON DELETE CASCADE,
    external_subject TEXT NOT NULL,
    raw_claims      JSONB,
    linked_at       TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE (provider_id, external_subject)
);

-- API keys / personal access tokens
CREATE TABLE iam.api_key (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL REFERENCES core.tenant(id) ON DELETE CASCADE,
    user_id         UUID REFERENCES iam.user(id) ON DELETE CASCADE,
    name            TEXT NOT NULL,
    key_prefix      TEXT NOT NULL,                -- first 8 chars for display
    key_hash        TEXT NOT NULL UNIQUE,
    scopes          TEXT[] NOT NULL DEFAULT '{}',
    last_used_at    TIMESTAMPTZ,
    expires_at      TIMESTAMPTZ,
    revoked_at      TIMESTAMPTZ,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Password policy
CREATE TABLE iam.password_policy (
    tenant_id       UUID PRIMARY KEY REFERENCES core.tenant(id) ON DELETE CASCADE,
    min_length      INT NOT NULL DEFAULT 12,
    require_upper   BOOLEAN NOT NULL DEFAULT TRUE,
    require_lower   BOOLEAN NOT NULL DEFAULT TRUE,
    require_digit   BOOLEAN NOT NULL DEFAULT TRUE,
    require_symbol  BOOLEAN NOT NULL DEFAULT TRUE,
    max_age_days    INT DEFAULT 90,
    history_count   INT NOT NULL DEFAULT 5,
    max_failed_attempts INT NOT NULL DEFAULT 5,
    lockout_minutes INT NOT NULL DEFAULT 15
);

CREATE TABLE iam.password_history (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id         UUID NOT NULL REFERENCES iam.user(id) ON DELETE CASCADE,
    password_hash   TEXT NOT NULL,
    set_at          TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Impersonation
CREATE TABLE iam.impersonation_log (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    admin_user_id   UUID NOT NULL REFERENCES iam.user(id),
    target_user_id  UUID NOT NULL REFERENCES iam.user(id),
    reason          TEXT,
    started_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    ended_at        TIMESTAMPTZ,
    ip_address      INET
);

-- Auth event log
CREATE TABLE iam.auth_event (
    id              BIGSERIAL PRIMARY KEY,
    tenant_id       UUID,
    user_id         UUID,
    event_type      TEXT NOT NULL,                -- login_success/login_failed/logout/pwd_reset/...
    ip_address      INET,
    user_agent      TEXT,
    metadata        JSONB,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
) PARTITION BY RANGE (created_at);
CREATE TABLE iam.auth_event_default PARTITION OF iam.auth_event DEFAULT;

-- =====================================================================
-- INDEXES
-- =====================================================================
CREATE INDEX idx_user_tenant_status    ON iam.user(tenant_id, status) WHERE deleted_at IS NULL;
CREATE INDEX idx_user_email_trgm       ON iam.user USING gin (email gin_trgm_ops);
CREATE INDEX idx_user_attrs            ON iam.user USING gin (attributes);
CREATE INDEX idx_session_user          ON iam.session(user_id) WHERE revoked_at IS NULL;
CREATE INDEX idx_session_expiry        ON iam.session(expires_at) WHERE revoked_at IS NULL;
CREATE INDEX idx_api_key_tenant        ON iam.api_key(tenant_id) WHERE revoked_at IS NULL;
CREATE INDEX idx_user_role_company     ON iam.user_role(company_id, branch_id);
CREATE INDEX idx_role_tenant           ON iam.role(tenant_id) WHERE is_active;
CREATE INDEX idx_auth_event_tenant_time ON iam.auth_event(tenant_id, created_at DESC);
CREATE INDEX idx_auth_event_user_time   ON iam.auth_event(user_id, created_at DESC);

-- =====================================================================
-- FUNCTIONS
-- =====================================================================

-- Effective permissions for a user (considers roles + direct grants + denies)
CREATE OR REPLACE FUNCTION iam.fn_user_permissions(p_user_id UUID)
RETURNS TABLE (permission_code TEXT, source TEXT) AS $$
BEGIN
    RETURN QUERY
    WITH role_perms AS (
        SELECT p.code, 'role:'||r.code AS src
          FROM iam.user_role ur
          JOIN iam.role r ON r.id = ur.role_id AND r.is_active
          JOIN iam.role_permission rp ON rp.role_id = r.id
          JOIN iam.permission p ON p.id = rp.permission_id
         WHERE ur.user_id = p_user_id
           AND (ur.valid_from IS NULL OR ur.valid_from <= CURRENT_DATE)
           AND (ur.valid_to   IS NULL OR ur.valid_to   >= CURRENT_DATE)
    ),
    user_grants AS (
        SELECT p.code, 'user:grant' AS src
          FROM iam.user_permission up
          JOIN iam.permission p ON p.id = up.permission_id
         WHERE up.user_id = p_user_id AND up.grant_type = 'grant'
    ),
    user_denies AS (
        SELECT p.code FROM iam.user_permission up
          JOIN iam.permission p ON p.id = up.permission_id
         WHERE up.user_id = p_user_id AND up.grant_type = 'deny'
    )
    SELECT DISTINCT c.code, c.src
      FROM (SELECT * FROM role_perms UNION SELECT * FROM user_grants) c
     WHERE c.code NOT IN (SELECT code FROM user_denies);
END;
$$ LANGUAGE plpgsql STABLE SECURITY DEFINER;

-- Check permission
CREATE OR REPLACE FUNCTION iam.fn_has_permission(p_user_id UUID, p_code TEXT)
RETURNS BOOLEAN AS $$
    SELECT EXISTS (SELECT 1 FROM iam.fn_user_permissions(p_user_id) WHERE permission_code = p_code);
$$ LANGUAGE sql STABLE;

-- Login (password verify + lockout + audit)
CREATE OR REPLACE FUNCTION iam.fn_login(
    p_tenant UUID, p_username TEXT, p_password_hash TEXT, p_ip INET, p_ua TEXT
) RETURNS UUID AS $$
DECLARE
    v_user iam.user%ROWTYPE;
    v_policy iam.password_policy%ROWTYPE;
BEGIN
    SELECT * INTO v_user FROM iam.user
     WHERE tenant_id = p_tenant AND username = p_username AND deleted_at IS NULL;
    IF NOT FOUND THEN
        INSERT INTO iam.auth_event(tenant_id, event_type, ip_address, user_agent, metadata)
        VALUES (p_tenant, 'login_failed_unknown_user', p_ip, p_ua, jsonb_build_object('username', p_username));
        RAISE EXCEPTION 'Invalid credentials';
    END IF;

    IF v_user.lock_until IS NOT NULL AND v_user.lock_until > NOW() THEN
        RAISE EXCEPTION 'Account locked until %', v_user.lock_until;
    END IF;

    IF v_user.password_hash <> p_password_hash THEN
        SELECT * INTO v_policy FROM iam.password_policy WHERE tenant_id = p_tenant;
        UPDATE iam.user
           SET failed_attempts = failed_attempts + 1,
               lock_until = CASE WHEN failed_attempts + 1 >= COALESCE(v_policy.max_failed_attempts,5)
                                  THEN NOW() + (COALESCE(v_policy.lockout_minutes,15) || ' minutes')::interval
                                 ELSE lock_until END
         WHERE id = v_user.id;
        INSERT INTO iam.auth_event(tenant_id, user_id, event_type, ip_address, user_agent)
        VALUES (p_tenant, v_user.id, 'login_failed', p_ip, p_ua);
        RAISE EXCEPTION 'Invalid credentials';
    END IF;

    UPDATE iam.user
       SET failed_attempts = 0, lock_until = NULL, last_login_at = NOW(), last_login_ip = p_ip
     WHERE id = v_user.id;
    INSERT INTO iam.auth_event(tenant_id, user_id, event_type, ip_address, user_agent)
    VALUES (p_tenant, v_user.id, 'login_success', p_ip, p_ua);
    RETURN v_user.id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- =====================================================================
-- VIEWS
-- =====================================================================
CREATE OR REPLACE VIEW iam.v_user_roles AS
SELECT u.id AS user_id, u.username, r.code AS role_code, r.name AS role_name,
       ur.company_id, ur.branch_id, ur.valid_from, ur.valid_to
  FROM iam.user u
  JOIN iam.user_role ur ON ur.user_id = u.id
  JOIN iam.role r ON r.id = ur.role_id
 WHERE u.deleted_at IS NULL;

CREATE OR REPLACE VIEW iam.v_active_sessions AS
SELECT s.*, u.username, u.email
  FROM iam.session s JOIN iam.user u ON u.id = s.user_id
 WHERE s.revoked_at IS NULL AND s.expires_at > NOW();

-- =====================================================================
-- TRIGGERS
-- =====================================================================
CREATE TRIGGER trg_user_updated   BEFORE UPDATE ON iam.user
    FOR EACH ROW EXECUTE FUNCTION core.fn_set_updated_at();
CREATE TRIGGER trg_role_updated   BEFORE UPDATE ON iam.role
    FOR EACH ROW EXECUTE FUNCTION core.fn_set_updated_at();

CREATE TRIGGER trg_user_audit AFTER INSERT OR UPDATE OR DELETE ON iam.user
    FOR EACH ROW EXECUTE FUNCTION audit.fn_row_audit();
CREATE TRIGGER trg_role_audit AFTER INSERT OR UPDATE OR DELETE ON iam.role
    FOR EACH ROW EXECUTE FUNCTION audit.fn_row_audit();

-- Prevent password reuse
CREATE OR REPLACE FUNCTION iam.fn_check_password_history()
RETURNS TRIGGER AS $$
DECLARE
    v_count INT;
    v_hist  INT;
BEGIN
    IF NEW.password_hash IS NOT NULL AND NEW.password_hash <> COALESCE(OLD.password_hash,'') THEN
        SELECT COALESCE(history_count,5) INTO v_hist
          FROM iam.password_policy WHERE tenant_id = NEW.tenant_id;
        SELECT COUNT(*) INTO v_count
          FROM (
            SELECT password_hash FROM iam.password_history
             WHERE user_id = NEW.id ORDER BY set_at DESC LIMIT v_hist
          ) h WHERE h.password_hash = NEW.password_hash;
        IF v_count > 0 THEN
            RAISE EXCEPTION 'Password was used recently, choose a different one';
        END IF;
        INSERT INTO iam.password_history(user_id, password_hash) VALUES (NEW.id, NEW.password_hash);
        NEW.password_changed_at = NOW();
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_user_password_history BEFORE UPDATE OF password_hash ON iam.user
    FOR EACH ROW EXECUTE FUNCTION iam.fn_check_password_history();
