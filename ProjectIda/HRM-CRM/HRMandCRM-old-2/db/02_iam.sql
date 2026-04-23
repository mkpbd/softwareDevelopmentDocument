-- =====================================================================
-- Module 02: Identity & Access Management
-- Covers PRD Step 2
-- =====================================================================

SET search_path = app, core, public;

-- =============== SCHEMA ===============

CREATE TABLE IF NOT EXISTS app.users (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  email           citext NOT NULL,
  phone           text,
  display_name    text NOT NULL,
  first_name      text,
  last_name       text,
  password_hash   text,                   -- bcrypt/argon2; NULL for SSO-only
  password_updated_at timestamptz,
  status          text NOT NULL DEFAULT 'active'
                  CHECK (status IN ('active','invited','suspended','locked','deleted')),
  locale          char(5) NOT NULL DEFAULT 'en-IN',
  timezone        text   NOT NULL DEFAULT 'Asia/Kolkata',
  avatar_url      text,
  last_login_at   timestamptz,
  failed_attempts smallint NOT NULL DEFAULT 0,
  locked_until    timestamptz,
  mfa_enabled     boolean NOT NULL DEFAULT false,
  employee_id     uuid,                   -- set once HR module onboarded
  attributes      jsonb NOT NULL DEFAULT '{}'::jsonb,   -- ABAC attrs
  created_at      timestamptz NOT NULL DEFAULT now(),
  updated_at      timestamptz NOT NULL DEFAULT now(),
  created_by      uuid, updated_by uuid, version int NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, email)
);

CREATE TABLE IF NOT EXISTS app.roles (
  id            uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id     uuid NOT NULL,
  code          citext NOT NULL,
  name          text NOT NULL,
  description   text,
  is_system     boolean NOT NULL DEFAULT false,
  created_at    timestamptz NOT NULL DEFAULT now(),
  updated_at    timestamptz NOT NULL DEFAULT now(),
  created_by    uuid, updated_by uuid, version int NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, code)
);

CREATE TABLE IF NOT EXISTS app.permissions (
  id            uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  code          citext NOT NULL UNIQUE,           -- global; e.g. 'sales.invoice.create'
  module        text NOT NULL,
  action        text NOT NULL,
  description   text,
  created_at    timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS app.role_permissions (
  tenant_id     uuid NOT NULL,
  role_id       uuid NOT NULL REFERENCES app.roles(id) ON DELETE CASCADE,
  permission_id uuid NOT NULL REFERENCES app.permissions(id) ON DELETE CASCADE,
  granted_at    timestamptz NOT NULL DEFAULT now(),
  granted_by    uuid,
  PRIMARY KEY (role_id, permission_id)
);

CREATE TABLE IF NOT EXISTS app.user_roles (
  tenant_id     uuid NOT NULL,
  user_id       uuid NOT NULL REFERENCES app.users(id) ON DELETE CASCADE,
  role_id       uuid NOT NULL REFERENCES app.roles(id) ON DELETE CASCADE,
  scope_branch_id uuid REFERENCES app.branches(id) ON DELETE CASCADE,
  granted_at    timestamptz NOT NULL DEFAULT now(),
  granted_by    uuid,
  expires_at    timestamptz,
  PRIMARY KEY (user_id, role_id, COALESCE(scope_branch_id, '00000000-0000-0000-0000-000000000000'::uuid))
);

CREATE TABLE IF NOT EXISTS app.user_branches (
  tenant_id     uuid NOT NULL,
  user_id       uuid NOT NULL REFERENCES app.users(id) ON DELETE CASCADE,
  branch_id     uuid NOT NULL REFERENCES app.branches(id) ON DELETE CASCADE,
  is_primary    boolean NOT NULL DEFAULT false,
  granted_at    timestamptz NOT NULL DEFAULT now(),
  PRIMARY KEY (user_id, branch_id)
);

CREATE TABLE IF NOT EXISTS app.sessions (
  id            uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id     uuid NOT NULL,
  user_id       uuid NOT NULL REFERENCES app.users(id) ON DELETE CASCADE,
  token_hash    text NOT NULL UNIQUE,
  refresh_hash  text UNIQUE,
  ip_address    inet,
  user_agent    text,
  device_fingerprint text,
  issued_at     timestamptz NOT NULL DEFAULT now(),
  expires_at    timestamptz NOT NULL,
  revoked_at    timestamptz,
  last_seen_at  timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS app.mfa_devices (
  id            uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id     uuid NOT NULL,
  user_id       uuid NOT NULL REFERENCES app.users(id) ON DELETE CASCADE,
  method        text NOT NULL CHECK (method IN ('totp','sms','email','push','webauthn')),
  secret_ciphertext bytea,            -- encrypted (pgcrypto); app-layer also ok
  label         text,
  verified      boolean NOT NULL DEFAULT false,
  created_at    timestamptz NOT NULL DEFAULT now(),
  last_used_at  timestamptz,
  UNIQUE (user_id, method, label)
);

CREATE TABLE IF NOT EXISTS app.sso_providers (
  id            uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id     uuid NOT NULL,
  code          citext NOT NULL,
  protocol      text NOT NULL CHECK (protocol IN ('saml','oidc','oauth2')),
  metadata      jsonb NOT NULL DEFAULT '{}'::jsonb,
  active        boolean NOT NULL DEFAULT true,
  created_at    timestamptz NOT NULL DEFAULT now(),
  updated_at    timestamptz NOT NULL DEFAULT now(),
  created_by    uuid, updated_by uuid, version int NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, code)
);

CREATE TABLE IF NOT EXISTS app.api_keys (
  id            uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id     uuid NOT NULL,
  user_id       uuid REFERENCES app.users(id) ON DELETE CASCADE,
  name          text NOT NULL,
  key_prefix    text NOT NULL,
  key_hash      text NOT NULL UNIQUE,
  scopes        text[] NOT NULL DEFAULT '{}',
  expires_at    timestamptz,
  last_used_at  timestamptz,
  revoked_at    timestamptz,
  created_at    timestamptz NOT NULL DEFAULT now(),
  created_by    uuid
);

CREATE TABLE IF NOT EXISTS app.service_accounts (
  id            uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id     uuid NOT NULL,
  code          citext NOT NULL,
  description   text,
  active        boolean NOT NULL DEFAULT true,
  created_at    timestamptz NOT NULL DEFAULT now(),
  updated_at    timestamptz NOT NULL DEFAULT now(),
  created_by    uuid, updated_by uuid, version int NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, code)
);

CREATE TABLE IF NOT EXISTS app.password_policies (
  tenant_id        uuid PRIMARY KEY,
  min_length       smallint NOT NULL DEFAULT 10,
  require_upper    boolean  NOT NULL DEFAULT true,
  require_lower    boolean  NOT NULL DEFAULT true,
  require_digit    boolean  NOT NULL DEFAULT true,
  require_symbol   boolean  NOT NULL DEFAULT true,
  history_count    smallint NOT NULL DEFAULT 5,
  max_age_days     smallint NOT NULL DEFAULT 90,
  lockout_attempts smallint NOT NULL DEFAULT 5,
  lockout_minutes  smallint NOT NULL DEFAULT 15,
  updated_at       timestamptz NOT NULL DEFAULT now(),
  updated_by       uuid
);

CREATE TABLE IF NOT EXISTS audit.auth_events (
  id            bigserial PRIMARY KEY,
  tenant_id     uuid,
  user_id       uuid,
  event_type    text NOT NULL,     -- login_success, login_fail, mfa_challenge, pwd_reset, etc.
  ip_address    inet,
  user_agent    text,
  metadata      jsonb,
  occurred_at   timestamptz NOT NULL DEFAULT now()
);

-- =============== INDEXES ===============
CREATE INDEX IF NOT EXISTS idx_users_tenant_status ON app.users(tenant_id, status);
CREATE INDEX IF NOT EXISTS idx_users_email_lower   ON app.users(tenant_id, email);
CREATE INDEX IF NOT EXISTS idx_users_employee      ON app.users(employee_id) WHERE employee_id IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_users_attrs_gin     ON app.users USING gin (attributes jsonb_path_ops);

CREATE INDEX IF NOT EXISTS idx_roles_tenant        ON app.roles(tenant_id);
CREATE INDEX IF NOT EXISTS idx_rp_role             ON app.role_permissions(role_id);
CREATE INDEX IF NOT EXISTS idx_ur_user             ON app.user_roles(user_id);
CREATE INDEX IF NOT EXISTS idx_ur_role             ON app.user_roles(role_id);
CREATE INDEX IF NOT EXISTS idx_ub_user             ON app.user_branches(user_id);

CREATE INDEX IF NOT EXISTS idx_sessions_user_active
    ON app.sessions(user_id, expires_at)
    WHERE revoked_at IS NULL;
CREATE INDEX IF NOT EXISTS idx_sessions_expiry     ON app.sessions(expires_at) WHERE revoked_at IS NULL;

CREATE INDEX IF NOT EXISTS idx_auth_events_tenant_time ON audit.auth_events(tenant_id, occurred_at DESC);
CREATE INDEX IF NOT EXISTS idx_auth_events_user_time   ON audit.auth_events(user_id, occurred_at DESC);
CREATE INDEX IF NOT EXISTS idx_api_keys_prefix         ON app.api_keys(key_prefix) WHERE revoked_at IS NULL;

-- =============== RLS ===============
SELECT core.enable_tenant_rls('app.users');
SELECT core.enable_tenant_rls('app.roles');
SELECT core.enable_tenant_rls('app.role_permissions');
SELECT core.enable_tenant_rls('app.user_roles');
SELECT core.enable_tenant_rls('app.user_branches');
SELECT core.enable_tenant_rls('app.sessions');
SELECT core.enable_tenant_rls('app.mfa_devices');
SELECT core.enable_tenant_rls('app.sso_providers');
SELECT core.enable_tenant_rls('app.api_keys');
SELECT core.enable_tenant_rls('app.service_accounts');
SELECT core.enable_tenant_rls('app.password_policies');

-- =============== TRIGGERS ===============
SELECT core.attach_standard_triggers('app.users');
SELECT core.attach_standard_triggers('app.roles');
SELECT core.attach_standard_triggers('app.sso_providers');
SELECT core.attach_standard_triggers('app.service_accounts');

-- =============== FUNCTIONS ===============

-- Check if user has a permission (optionally branch-scoped)
CREATE OR REPLACE FUNCTION app.user_has_permission(
  p_user_id uuid,
  p_perm_code text,
  p_branch_id uuid DEFAULT NULL
) RETURNS boolean
LANGUAGE sql
STABLE
AS $$
  SELECT EXISTS (
    SELECT 1
      FROM app.user_roles ur
      JOIN app.role_permissions rp ON rp.role_id = ur.role_id
      JOIN app.permissions p       ON p.id = rp.permission_id
     WHERE ur.user_id = p_user_id
       AND p.code = p_perm_code
       AND (ur.expires_at IS NULL OR ur.expires_at > now())
       AND (p_branch_id IS NULL OR ur.scope_branch_id IS NULL OR ur.scope_branch_id = p_branch_id)
  )
$$;

-- Verify password (hash compare; caller supplies plaintext only on login)
CREATE OR REPLACE FUNCTION app.verify_password(p_user_id uuid, p_plain text)
RETURNS boolean
LANGUAGE sql
STABLE
AS $$
  SELECT (password_hash = crypt(p_plain, password_hash))
    FROM app.users WHERE id = p_user_id AND status = 'active'
$$;

-- Register a login attempt; increments counter / locks on threshold
CREATE OR REPLACE FUNCTION app.register_login_attempt(
  p_user_id uuid, p_success boolean, p_ip inet, p_ua text
) RETURNS void
LANGUAGE plpgsql
AS $$
DECLARE
  v_tenant uuid; v_threshold smallint; v_lockout smallint;
BEGIN
  SELECT tenant_id INTO v_tenant FROM app.users WHERE id = p_user_id;

  SELECT COALESCE(lockout_attempts,5), COALESCE(lockout_minutes,15)
    INTO v_threshold, v_lockout
    FROM app.password_policies WHERE tenant_id = v_tenant;

  IF p_success THEN
    UPDATE app.users
       SET last_login_at = now(),
           failed_attempts = 0,
           locked_until    = NULL
     WHERE id = p_user_id;
  ELSE
    UPDATE app.users
       SET failed_attempts = failed_attempts + 1,
           locked_until = CASE
             WHEN failed_attempts + 1 >= COALESCE(v_threshold,5)
             THEN now() + (COALESCE(v_lockout,15)||' minutes')::interval
             ELSE locked_until
           END,
           status = CASE
             WHEN failed_attempts + 1 >= COALESCE(v_threshold,5)
             THEN 'locked' ELSE status END
     WHERE id = p_user_id;
  END IF;

  INSERT INTO audit.auth_events(tenant_id,user_id,event_type,ip_address,user_agent)
  VALUES (v_tenant, p_user_id,
          CASE WHEN p_success THEN 'login_success' ELSE 'login_fail' END,
          p_ip, p_ua);
END $$;

-- Revoke all sessions for a user
CREATE OR REPLACE PROCEDURE app.revoke_user_sessions(p_user_id uuid, p_reason text DEFAULT NULL)
LANGUAGE sql
AS $$
  UPDATE app.sessions SET revoked_at = now() WHERE user_id = p_user_id AND revoked_at IS NULL;
$$;

-- =============== VIEWS ===============
CREATE OR REPLACE VIEW app.v_user_permissions AS
SELECT u.tenant_id, u.id AS user_id, u.email, p.code AS permission_code,
       ur.scope_branch_id, r.code AS role_code
  FROM app.users u
  JOIN app.user_roles ur ON ur.user_id = u.id AND (ur.expires_at IS NULL OR ur.expires_at > now())
  JOIN app.roles r       ON r.id = ur.role_id
  JOIN app.role_permissions rp ON rp.role_id = r.id
  JOIN app.permissions p ON p.id = rp.permission_id
 WHERE u.status = 'active';

CREATE OR REPLACE VIEW app.v_active_sessions AS
SELECT s.tenant_id, s.user_id, u.email, s.ip_address, s.user_agent,
       s.issued_at, s.expires_at, s.last_seen_at
  FROM app.sessions s
  JOIN app.users u ON u.id = s.user_id
 WHERE s.revoked_at IS NULL AND s.expires_at > now();

-- =============== SEED ===============

-- Canonical permission catalog (global, not tenant-scoped)
INSERT INTO app.permissions(code,module,action,description) VALUES
  ('org.manage',           'org',      'manage', 'Manage organization & company master'),
  ('iam.user.manage',      'iam',      'manage', 'Manage users'),
  ('iam.role.manage',      'iam',      'manage', 'Manage roles & permissions'),
  ('finance.je.post',      'finance',  'post',   'Post journal entries'),
  ('finance.je.view',      'finance',  'view',   'View journal entries'),
  ('finance.period.close', 'finance',  'close',  'Close fiscal periods'),
  ('sales.customer.manage','sales',    'manage', 'Manage customers'),
  ('sales.order.create',   'sales',    'create', 'Create sales orders'),
  ('sales.invoice.create', 'sales',    'create', 'Create sales invoices'),
  ('sales.invoice.approve','sales',    'approve','Approve sales invoices'),
  ('purchase.supplier.manage','purchase','manage','Manage suppliers'),
  ('purchase.po.create',   'purchase', 'create', 'Create purchase orders'),
  ('purchase.po.approve',  'purchase', 'approve','Approve purchase orders'),
  ('inventory.item.manage','inventory','manage', 'Manage item master'),
  ('inventory.stock.adjust','inventory','adjust','Adjust stock'),
  ('inventory.transfer.create','inventory','create','Create stock transfers'),
  ('documents.upload',     'documents','upload', 'Upload documents'),
  ('workflow.approve',     'workflow', 'approve','Act on approval tasks'),
  ('reports.view',         'reports',  'view',   'View reports')
ON CONFLICT (code) DO NOTHING;
