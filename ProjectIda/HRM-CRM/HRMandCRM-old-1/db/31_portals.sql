-- =====================================================================
-- STEP 31: Portals (Customer / Vendor / Manager / Exec / Investor)
-- =====================================================================

CREATE TABLE portal.portal_def (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    code            TEXT NOT NULL,
    name            TEXT NOT NULL,
    portal_type     TEXT CHECK (portal_type IN ('customer','vendor','manager','executive','investor','partner','employee_self_service')),
    subdomain       TEXT UNIQUE,
    custom_domain   TEXT,
    branding        JSONB,
    theme           JSONB,
    is_active       BOOLEAN DEFAULT TRUE,
    UNIQUE (tenant_id, code)
);

CREATE TABLE portal.portal_user (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    portal_id       UUID NOT NULL REFERENCES portal.portal_def(id) ON DELETE CASCADE,
    user_id         UUID REFERENCES iam.user(id),
    linked_type     TEXT CHECK (linked_type IN ('customer_contact','vendor_contact','employee','investor','partner')),
    linked_id       UUID NOT NULL,
    email           core.email_t NOT NULL,
    status          TEXT DEFAULT 'active' CHECK (status IN ('active','suspended','invited','expired')),
    invited_at      TIMESTAMPTZ,
    first_login_at  TIMESTAMPTZ,
    UNIQUE (portal_id, email)
);

CREATE TABLE portal.portal_session (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    portal_user_id  UUID NOT NULL REFERENCES portal.portal_user(id) ON DELETE CASCADE,
    token_hash      TEXT UNIQUE NOT NULL,
    issued_at       TIMESTAMPTZ DEFAULT NOW(),
    expires_at      TIMESTAMPTZ,
    ip_address      INET,
    user_agent      TEXT
);

CREATE TABLE portal.portal_access_rule (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    portal_id       UUID NOT NULL REFERENCES portal.portal_def(id) ON DELETE CASCADE,
    resource        TEXT NOT NULL,
    action          TEXT NOT NULL,
    allowed         BOOLEAN DEFAULT TRUE,
    conditions      JSONB
);

CREATE TABLE portal.portal_menu (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    portal_id       UUID NOT NULL REFERENCES portal.portal_def(id) ON DELETE CASCADE,
    parent_id       UUID REFERENCES portal.portal_menu(id),
    code            TEXT NOT NULL,
    label           TEXT NOT NULL,
    icon            TEXT,
    path            TEXT,
    sequence_no     INT,
    required_permission TEXT
);

-- Customer portal: invoices, orders, tickets
CREATE TABLE portal.customer_portal_view (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    customer_id     UUID NOT NULL REFERENCES sales.customer(id),
    view_config     JSONB
);

-- Vendor portal: PO, GRN, invoices
CREATE TABLE portal.vendor_portal_submission (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    supplier_id     UUID NOT NULL REFERENCES purchase.supplier(id),
    submission_type TEXT CHECK (submission_type IN ('invoice','quote','confirmation','shipment','kyc_update')),
    reference_id    UUID,
    payload         JSONB,
    document_ids    UUID[],
    status          TEXT DEFAULT 'submitted' CHECK (status IN ('submitted','under_review','accepted','rejected','returned')),
    submitted_at    TIMESTAMPTZ DEFAULT NOW(),
    reviewed_by     UUID,
    reviewed_at     TIMESTAMPTZ,
    comments        TEXT
);

CREATE TABLE portal.white_label_config (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    portal_id       UUID NOT NULL REFERENCES portal.portal_def(id) ON DELETE CASCADE,
    logo_url        TEXT,
    favicon_url     TEXT,
    primary_color   TEXT,
    secondary_color TEXT,
    custom_css      TEXT,
    email_from_name TEXT,
    email_from_address TEXT,
    support_email   TEXT,
    support_phone   TEXT,
    footer_html     TEXT
);

-- =====================================================================
-- INDEXES
-- =====================================================================
CREATE INDEX idx_portal_user_linked    ON portal.portal_user(linked_type, linked_id);
CREATE INDEX idx_portal_session_user   ON portal.portal_session(portal_user_id);
CREATE INDEX idx_vendor_submission     ON portal.vendor_portal_submission(supplier_id, status);
