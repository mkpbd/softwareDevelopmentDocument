-- =====================================================================
-- STEP 24: Integration Platform
-- =====================================================================

CREATE TABLE integration.integration (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    code            TEXT NOT NULL,
    name            TEXT NOT NULL,
    provider        TEXT NOT NULL,                -- shopify/quickbooks/tally/amazon/stripe/razorpay/...
    category        TEXT CHECK (category IN ('payment','bank','ecommerce','accounting','crm','shipping','tax_portal','sms','email','edi','ipaas')),
    base_url        TEXT,
    auth_type       TEXT CHECK (auth_type IN ('oauth2','api_key','basic','jwt','cert','hmac')),
    credentials_enc BYTEA,
    config          JSONB,
    is_active       BOOLEAN DEFAULT TRUE,
    last_sync_at    TIMESTAMPTZ,
    UNIQUE (tenant_id, code)
);

CREATE TABLE integration.api_endpoint (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID,
    path            TEXT NOT NULL,
    method          TEXT NOT NULL CHECK (method IN ('GET','POST','PUT','PATCH','DELETE')),
    protocol        TEXT DEFAULT 'rest' CHECK (protocol IN ('rest','graphql','grpc','soap')),
    handler         TEXT NOT NULL,
    auth_required   BOOLEAN DEFAULT TRUE,
    rate_limit_per_min INT,
    required_scopes TEXT[],
    is_public       BOOLEAN DEFAULT FALSE,
    deprecated_at   TIMESTAMPTZ,
    version         TEXT DEFAULT 'v1',
    UNIQUE (path, method, version)
);

CREATE TABLE integration.api_request_log (
    id              BIGSERIAL,
    tenant_id       UUID,
    user_id         UUID,
    api_key_id      UUID,
    endpoint        TEXT,
    method          TEXT,
    status_code     INT,
    duration_ms     INT,
    ip_address      INET,
    user_agent      TEXT,
    request_size    INT,
    response_size   INT,
    error           TEXT,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    PRIMARY KEY (id, created_at)
) PARTITION BY RANGE (created_at);
CREATE TABLE integration.api_request_log_default PARTITION OF integration.api_request_log DEFAULT;

CREATE TABLE integration.webhook_in (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    source          TEXT NOT NULL,                -- stripe/github/zapier/...
    path_token      TEXT NOT NULL UNIQUE,
    secret          TEXT,
    expected_signature_header TEXT,
    is_active       BOOLEAN DEFAULT TRUE,
    handler         TEXT
);

CREATE TABLE integration.webhook_event (
    id              BIGSERIAL PRIMARY KEY,
    webhook_in_id   UUID,
    received_at     TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    event_type      TEXT,
    payload         JSONB NOT NULL,
    signature_valid BOOLEAN,
    processed       BOOLEAN DEFAULT FALSE,
    processed_at    TIMESTAMPTZ,
    error           TEXT
);

CREATE TABLE integration.event_stream (
    id              BIGSERIAL,
    tenant_id       UUID NOT NULL,
    event_type      TEXT NOT NULL,
    entity_type     TEXT,
    entity_id       UUID,
    payload         JSONB NOT NULL,
    producer        TEXT,
    occurred_at     TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    PRIMARY KEY (id, occurred_at)
) PARTITION BY RANGE (occurred_at);
CREATE TABLE integration.event_stream_default PARTITION OF integration.event_stream DEFAULT;

CREATE TABLE integration.payment_gateway_txn (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    company_id      UUID NOT NULL,
    integration_id  UUID REFERENCES integration.integration(id),
    gateway         TEXT NOT NULL,
    gateway_txn_id  TEXT NOT NULL,
    order_ref       TEXT,
    amount          core.money_amt NOT NULL,
    currency_code   CHAR(3) NOT NULL,
    status          TEXT CHECK (status IN ('initiated','authorized','captured','failed','refunded','disputed','cancelled')),
    method          TEXT,
    customer_id     UUID,
    invoice_id      UUID,
    payment_receipt_id UUID,
    fee             core.money_amt,
    tax_on_fee      core.money_amt,
    raw_response    JSONB,
    created_at      TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE (gateway, gateway_txn_id)
);

CREATE TABLE integration.bank_feed (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    bank_account_id UUID NOT NULL REFERENCES finance.account(id),
    provider        TEXT,
    feed_type       TEXT CHECK (feed_type IN ('direct','aggregator','manual')),
    last_sync_at    TIMESTAMPTZ,
    is_active       BOOLEAN DEFAULT TRUE
);

CREATE TABLE integration.sync_state (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    integration_id  UUID NOT NULL REFERENCES integration.integration(id),
    entity_type     TEXT NOT NULL,
    external_id     TEXT NOT NULL,
    internal_id     UUID,
    last_synced_at  TIMESTAMPTZ DEFAULT NOW(),
    checksum        TEXT,
    status          TEXT DEFAULT 'synced',
    error           TEXT,
    UNIQUE (integration_id, entity_type, external_id)
);

CREATE TABLE integration.sync_conflict (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    sync_state_id   UUID NOT NULL REFERENCES integration.sync_state(id),
    conflict_type   TEXT,
    local_value     JSONB,
    remote_value    JSONB,
    resolution      TEXT CHECK (resolution IN ('pending','local_wins','remote_wins','merged','ignored')),
    resolved_by     UUID,
    resolved_at     TIMESTAMPTZ
);

CREATE TABLE integration.edi_document (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    doc_type        TEXT NOT NULL,                -- 850/810/856/...
    direction       TEXT CHECK (direction IN ('inbound','outbound')),
    partner         TEXT,
    raw_content     TEXT,
    parsed_data     JSONB,
    status          TEXT,
    reference_doc_type TEXT,
    reference_doc_id UUID,
    created_at      TIMESTAMPTZ DEFAULT NOW()
);

-- =====================================================================
-- INDEXES
-- =====================================================================
CREATE INDEX idx_api_log_endpoint_time ON integration.api_request_log(endpoint, created_at DESC);
CREATE INDEX idx_api_log_tenant        ON integration.api_request_log(tenant_id, created_at DESC);
CREATE INDEX idx_webhook_event_processed ON integration.webhook_event(processed, received_at);
CREATE INDEX idx_event_stream_type     ON integration.event_stream(event_type, occurred_at DESC);
CREATE INDEX idx_gw_txn_status         ON integration.payment_gateway_txn(status, created_at DESC);
CREATE INDEX idx_sync_state_lookup     ON integration.sync_state(integration_id, entity_type, external_id);
