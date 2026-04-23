-- =====================================================================
-- Module 31: Portals
-- Customer, vendor, manager, executive, investor portals + white-label
-- ACLs mapping portal users to business entities (customer/supplier/etc.)
-- =====================================================================

SET search_path = app, core, public;

-- =============== SCHEMA ===============

CREATE TABLE IF NOT EXISTS app.portals (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  code            citext NOT NULL,
  name            text NOT NULL,
  portal_type     text NOT NULL CHECK (portal_type IN ('customer','vendor','partner','manager','executive','investor','ess','franchisee')),
  host            text,                                -- portal.acme.com
  custom_domain   text,
  is_white_label  boolean NOT NULL DEFAULT false,
  login_mode      text NOT NULL DEFAULT 'email_password'
                  CHECK (login_mode IN ('email_password','magic_link','sso','otp','invite_only')),
  sso_provider_id uuid REFERENCES app.sso_providers(id),
  default_locale  char(5) NOT NULL DEFAULT 'en-IN',
  active          boolean NOT NULL DEFAULT true,
  config          jsonb NOT NULL DEFAULT '{}'::jsonb,
  created_at      timestamptz NOT NULL DEFAULT now(),
  updated_at      timestamptz NOT NULL DEFAULT now(),
  created_by      uuid, updated_by uuid, version int NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, code)
);

CREATE TABLE IF NOT EXISTS app.portal_users (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  portal_id       uuid NOT NULL REFERENCES app.portals(id) ON DELETE CASCADE,
  email           citext NOT NULL,
  display_name    text NOT NULL,
  phone           text,
  password_hash   text,
  status          text NOT NULL DEFAULT 'invited'
                  CHECK (status IN ('invited','active','suspended','locked','deleted')),
  mfa_enabled     boolean NOT NULL DEFAULT false,
  locale          char(5),
  timezone        text,
  last_login_at   timestamptz,
  invited_at      timestamptz,
  invited_by      uuid,
  invite_token_hash text,
  invite_expires_at timestamptz,
  linked_user_id  uuid REFERENCES app.users(id),
  created_at      timestamptz NOT NULL DEFAULT now(),
  updated_at      timestamptz NOT NULL DEFAULT now(),
  created_by      uuid, updated_by uuid, version int NOT NULL DEFAULT 1,
  UNIQUE (portal_id, email)
);

-- Polymorphic entity link: a portal user may represent a customer contact,
-- vendor contact, employee (ESS), investor, etc. Multiple scopes allowed.
CREATE TABLE IF NOT EXISTS app.portal_user_scopes (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  portal_user_id  uuid NOT NULL REFERENCES app.portal_users(id) ON DELETE CASCADE,
  scope_type      text NOT NULL CHECK (scope_type IN ('customer','supplier','employee','contact','investor','branch','company','project')),
  scope_id        uuid NOT NULL,
  permissions     text[] NOT NULL DEFAULT '{}',        -- ['view_invoices','pay','download']
  is_primary      boolean NOT NULL DEFAULT false,
  added_at        timestamptz NOT NULL DEFAULT now(),
  expires_at      timestamptz,
  added_by        uuid,
  UNIQUE (portal_user_id, scope_type, scope_id)
);

CREATE TABLE IF NOT EXISTS app.portal_roles (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  portal_id       uuid NOT NULL REFERENCES app.portals(id) ON DELETE CASCADE,
  code            citext NOT NULL,
  name            text NOT NULL,
  permissions     text[] NOT NULL DEFAULT '{}',
  is_default      boolean NOT NULL DEFAULT false,
  UNIQUE (portal_id, code)
);

CREATE TABLE IF NOT EXISTS app.portal_user_roles (
  tenant_id       uuid NOT NULL,
  portal_user_id  uuid NOT NULL REFERENCES app.portal_users(id) ON DELETE CASCADE,
  portal_role_id  uuid NOT NULL REFERENCES app.portal_roles(id) ON DELETE CASCADE,
  granted_at      timestamptz NOT NULL DEFAULT now(),
  granted_by      uuid,
  PRIMARY KEY (portal_user_id, portal_role_id)
);

CREATE TABLE IF NOT EXISTS app.portal_sessions (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  portal_user_id  uuid NOT NULL REFERENCES app.portal_users(id) ON DELETE CASCADE,
  token_hash      text NOT NULL UNIQUE,
  ip_address      inet,
  user_agent      text,
  issued_at       timestamptz NOT NULL DEFAULT now(),
  expires_at      timestamptz NOT NULL,
  revoked_at      timestamptz,
  last_seen_at    timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS app.portal_branding (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  portal_id       uuid NOT NULL REFERENCES app.portals(id) ON DELETE CASCADE,
  brand_name      text,
  logo_document_id uuid REFERENCES app.documents(id),
  favicon_document_id uuid REFERENCES app.documents(id),
  primary_color   text,
  secondary_color text,
  accent_color    text,
  font_family     text,
  custom_css      text,
  custom_js       text,
  email_from_name text,
  email_from_address citext,
  support_email   citext,
  support_phone   text,
  footer_html     text,
  login_hero_image_document_id uuid REFERENCES app.documents(id),
  updated_at      timestamptz NOT NULL DEFAULT now(),
  updated_by      uuid,
  UNIQUE (portal_id)
);

-- White-label / reseller configs (one tenant manages many sub-brands)
CREATE TABLE IF NOT EXISTS app.white_label_configs (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  label_code      citext NOT NULL,
  brand_name      text NOT NULL,
  domain          text,
  reseller_company text,
  enabled_modules text[] NOT NULL DEFAULT '{}',
  pricing_model   text CHECK (pricing_model IN (NULL,'flat','per_user','per_module','revenue_share')),
  branding_config jsonb,
  active          boolean NOT NULL DEFAULT true,
  created_at      timestamptz NOT NULL DEFAULT now(),
  updated_at      timestamptz NOT NULL DEFAULT now(),
  created_by      uuid, updated_by uuid, version int NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, label_code)
);

-- Portal audit (separate from core audit — visible to tenant admins)
CREATE TABLE IF NOT EXISTS audit.portal_access_log (
  id              bigserial PRIMARY KEY,
  tenant_id       uuid,
  portal_id       uuid,
  portal_user_id  uuid,
  action          text NOT NULL,
  resource_type   text,
  resource_id     text,
  ip_address      inet,
  user_agent      text,
  metadata        jsonb,
  occurred_at     timestamptz NOT NULL DEFAULT now()
);

-- =============== INDEXES ===============
CREATE INDEX IF NOT EXISTS idx_portals_tenant      ON app.portals(tenant_id, active);
CREATE INDEX IF NOT EXISTS idx_portals_host        ON app.portals(host) WHERE host IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_portals_domain      ON app.portals(custom_domain) WHERE custom_domain IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_pusers_email        ON app.portal_users(portal_id, email);
CREATE INDEX IF NOT EXISTS idx_pusers_status       ON app.portal_users(tenant_id, status);
CREATE INDEX IF NOT EXISTS idx_pusers_linked       ON app.portal_users(linked_user_id) WHERE linked_user_id IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_puscopes_scope      ON app.portal_user_scopes(scope_type, scope_id);
CREATE INDEX IF NOT EXISTS idx_puscopes_user       ON app.portal_user_scopes(portal_user_id);
CREATE INDEX IF NOT EXISTS idx_pur_user            ON app.portal_user_roles(portal_user_id);
CREATE INDEX IF NOT EXISTS idx_psess_active        ON app.portal_sessions(portal_user_id, expires_at) WHERE revoked_at IS NULL;
CREATE INDEX IF NOT EXISTS idx_psess_expiry        ON app.portal_sessions(expires_at) WHERE revoked_at IS NULL;
CREATE INDEX IF NOT EXISTS idx_wl_domain           ON app.white_label_configs(domain) WHERE active;
CREATE INDEX IF NOT EXISTS idx_palog_tenant_time   ON audit.portal_access_log(tenant_id, occurred_at DESC);
CREATE INDEX IF NOT EXISTS idx_palog_user_time     ON audit.portal_access_log(portal_user_id, occurred_at DESC);

-- =============== RLS + TRIGGERS ===============
SELECT core.enable_tenant_rls('app.portals');
SELECT core.enable_tenant_rls('app.portal_users');
SELECT core.enable_tenant_rls('app.portal_user_scopes');
SELECT core.enable_tenant_rls('app.portal_roles');
SELECT core.enable_tenant_rls('app.portal_user_roles');
SELECT core.enable_tenant_rls('app.portal_sessions');
SELECT core.enable_tenant_rls('app.portal_branding');
SELECT core.enable_tenant_rls('app.white_label_configs');

SELECT core.attach_standard_triggers('app.portals');
SELECT core.attach_standard_triggers('app.portal_users');
SELECT core.attach_standard_triggers('app.portal_branding');
SELECT core.attach_standard_triggers('app.white_label_configs');

-- =============== FUNCTIONS ===============

-- Check whether a portal user has a permission within a given scope
CREATE OR REPLACE FUNCTION app.portal_user_can(
  p_portal_user_id uuid, p_scope_type text, p_scope_id uuid, p_permission text
) RETURNS boolean
LANGUAGE sql STABLE AS $$
  SELECT EXISTS (
    SELECT 1 FROM app.portal_user_scopes
     WHERE portal_user_id = p_portal_user_id
       AND scope_type = p_scope_type AND scope_id = p_scope_id
       AND (expires_at IS NULL OR expires_at > now())
       AND (p_permission = ANY(permissions) OR permissions @> ARRAY['*'])
  ) OR EXISTS (
    SELECT 1 FROM app.portal_user_roles pur
      JOIN app.portal_roles pr ON pr.id = pur.portal_role_id
     WHERE pur.portal_user_id = p_portal_user_id
       AND (p_permission = ANY(pr.permissions) OR pr.permissions @> ARRAY['*'])
  )
$$;

-- Invite portal user (generates token, returns it — show once only)
CREATE OR REPLACE FUNCTION app.invite_portal_user(
  p_portal_id uuid, p_email text, p_display_name text,
  p_scope_type text, p_scope_id uuid, p_permissions text[] DEFAULT ARRAY['view']
) RETURNS TABLE(portal_user_id uuid, invite_token text)
LANGUAGE plpgsql AS $$
DECLARE
  v_id uuid := gen_random_uuid();
  v_token text := encode(gen_random_bytes(24), 'base64');
  v_tenant uuid := core.require_tenant();
BEGIN
  INSERT INTO app.portal_users(id,tenant_id,portal_id,email,display_name,status,
         invited_at,invited_by,invite_token_hash,invite_expires_at)
  VALUES (v_id, v_tenant, p_portal_id, p_email, p_display_name, 'invited',
          now(), core.current_user_id(),
          encode(digest(v_token,'sha256'),'hex'),
          now() + interval '7 days');

  INSERT INTO app.portal_user_scopes(tenant_id,portal_user_id,scope_type,scope_id,permissions,is_primary)
  VALUES (v_tenant, v_id, p_scope_type, p_scope_id, p_permissions, true);

  portal_user_id := v_id;
  invite_token   := v_token;
  RETURN NEXT;
END $$;

-- Accept invite: set password, activate
CREATE OR REPLACE PROCEDURE app.accept_portal_invite(p_token text, p_password text)
LANGUAGE plpgsql AS $$
DECLARE
  v_hash text := encode(digest(p_token,'sha256'),'hex');
  v_user_id uuid;
BEGIN
  UPDATE app.portal_users
     SET password_hash = crypt(p_password, gen_salt('bf',12)),
         status='active',
         invite_token_hash = NULL,
         invite_expires_at = NULL,
         updated_at = now()
   WHERE invite_token_hash = v_hash
     AND invite_expires_at > now()
     AND status = 'invited'
   RETURNING id INTO v_user_id;

  IF v_user_id IS NULL THEN RAISE EXCEPTION 'invalid or expired invite'; END IF;
END $$;

-- Resolve portal by host (for multi-tenant request routing)
CREATE OR REPLACE FUNCTION app.resolve_portal(p_host text)
RETURNS TABLE(portal_id uuid, tenant_id uuid, portal_type text, white_label boolean)
LANGUAGE sql STABLE AS $$
  SELECT p.id, p.tenant_id, p.portal_type, p.is_white_label
    FROM app.portals p
   WHERE (p.host = p_host OR p.custom_domain = p_host) AND p.active
$$;

-- =============== VIEWS ===============
CREATE OR REPLACE VIEW app.v_portal_activity AS
SELECT pal.tenant_id, pal.portal_id, pal.portal_user_id,
       date_trunc('day', pal.occurred_at)::date AS day,
       COUNT(*) AS actions,
       COUNT(DISTINCT pal.resource_id) AS resources_touched
  FROM audit.portal_access_log pal
 GROUP BY 1,2,3,4;

CREATE OR REPLACE VIEW app.v_portal_user_summary AS
SELECT pu.tenant_id, pu.portal_id, pu.id AS portal_user_id, pu.email, pu.status,
       pu.last_login_at,
       COUNT(pus.*)                                   AS scope_count,
       array_agg(DISTINCT pus.scope_type)             AS scope_types
  FROM app.portal_users pu
  LEFT JOIN app.portal_user_scopes pus ON pus.portal_user_id = pu.id
 GROUP BY pu.tenant_id, pu.portal_id, pu.id, pu.email, pu.status, pu.last_login_at;
