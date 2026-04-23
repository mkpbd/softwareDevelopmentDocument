-- =====================================================================
-- STEP 30: Mobile Strategy
-- =====================================================================

CREATE TABLE mobile.app (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID,
    code            TEXT NOT NULL,
    name            TEXT NOT NULL,
    platform        TEXT CHECK (platform IN ('android','ios','web','react_native','flutter')),
    package_id      TEXT,
    latest_version  TEXT,
    min_supported_version TEXT,
    force_update_below TEXT,
    release_notes   TEXT,
    config          JSONB,
    is_active       BOOLEAN DEFAULT TRUE,
    UNIQUE (tenant_id, code, platform)
);

CREATE TABLE mobile.device (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    user_id         UUID NOT NULL REFERENCES iam.user(id) ON DELETE CASCADE,
    device_id       TEXT NOT NULL,
    platform        TEXT,
    os_version      TEXT,
    app_version     TEXT,
    model           TEXT,
    fcm_token       TEXT,
    apns_token      TEXT,
    language        TEXT,
    timezone        TEXT,
    last_active_at  TIMESTAMPTZ DEFAULT NOW(),
    is_trusted      BOOLEAN DEFAULT FALSE,
    is_active       BOOLEAN DEFAULT TRUE,
    UNIQUE (user_id, device_id)
);

CREATE TABLE mobile.offline_sync_queue (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    device_id       UUID REFERENCES mobile.device(id),
    user_id         UUID,
    entity_type     TEXT NOT NULL,
    entity_id       UUID,
    local_id        TEXT,                         -- client-side id before sync
    action          TEXT CHECK (action IN ('create','update','delete')),
    payload         JSONB,
    status          TEXT DEFAULT 'pending' CHECK (status IN ('pending','syncing','synced','failed','conflict')),
    attempts        INT DEFAULT 0,
    created_at      TIMESTAMPTZ DEFAULT NOW(),
    synced_at       TIMESTAMPTZ,
    conflict_detail JSONB,
    error           TEXT
);

CREATE TABLE mobile.field_sales_order (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    company_id      UUID NOT NULL,
    sales_order_id  UUID REFERENCES sales.sales_order(id),
    sales_rep_id    UUID,
    captured_at     TIMESTAMPTZ DEFAULT NOW(),
    geo_location    POINT,
    customer_signature_url TEXT,
    photos          JSONB,
    offline_captured BOOLEAN DEFAULT FALSE,
    device_id       UUID
);

CREATE TABLE mobile.field_attendance (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    employee_id     UUID NOT NULL REFERENCES hr.employee(id),
    punch_time      TIMESTAMPTZ NOT NULL,
    punch_type      TEXT,
    geo_location    POINT,
    is_within_geofence BOOLEAN,
    geofence_id     UUID,
    selfie_url      TEXT,
    device_id       UUID,
    sync_status     TEXT DEFAULT 'synced'
);

CREATE TABLE mobile.geofence (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    name            TEXT NOT NULL,
    center          POINT NOT NULL,
    radius_meters   INT NOT NULL,
    branch_id       UUID,
    site_type       TEXT,
    is_active       BOOLEAN DEFAULT TRUE
);

CREATE TABLE mobile.mobile_payment (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    device_id       UUID,
    amount          core.money_amt NOT NULL,
    currency_code   CHAR(3),
    payment_mode    TEXT,
    gateway_txn_id  TEXT,
    status          TEXT,
    reference_doc_type TEXT,
    reference_doc_id UUID,
    created_at      TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE mobile.analytics_event (
    id              BIGSERIAL,
    tenant_id       UUID,
    user_id         UUID,
    device_id       UUID,
    event_name      TEXT NOT NULL,
    properties      JSONB,
    session_id      TEXT,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    PRIMARY KEY (id, created_at)
) PARTITION BY RANGE (created_at);
CREATE TABLE mobile.analytics_event_default PARTITION OF mobile.analytics_event DEFAULT;

-- =====================================================================
-- INDEXES
-- =====================================================================
CREATE INDEX idx_device_user           ON mobile.device(user_id, is_active);
CREATE INDEX idx_device_fcm            ON mobile.device(fcm_token) WHERE fcm_token IS NOT NULL;
CREATE INDEX idx_sync_queue_status     ON mobile.offline_sync_queue(status, created_at);
CREATE INDEX idx_field_attendance_emp  ON mobile.field_attendance(employee_id, punch_time DESC);
CREATE INDEX idx_analytics_event_user  ON mobile.analytics_event(user_id, created_at DESC);
CREATE INDEX idx_analytics_event_name  ON mobile.analytics_event(event_name, created_at DESC);
