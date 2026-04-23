-- =====================================================================
-- STEP 23: Notifications & Communications
-- =====================================================================

CREATE TABLE notify.template (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    code            TEXT NOT NULL,
    name            TEXT NOT NULL,
    channel         TEXT NOT NULL CHECK (channel IN ('email','sms','push','in_app','whatsapp','slack','teams','webhook')),
    locale          TEXT DEFAULT 'en-IN',
    subject         TEXT,
    body            TEXT NOT NULL,
    variables       JSONB,
    engine          TEXT DEFAULT 'handlebars',
    is_active       BOOLEAN DEFAULT TRUE,
    version         INT DEFAULT 1,
    UNIQUE (tenant_id, code, locale, version)
);

CREATE TABLE notify.rule (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    code            TEXT NOT NULL,
    name            TEXT NOT NULL,
    event_type      TEXT NOT NULL,
    entity_type     TEXT,
    channels        TEXT[] NOT NULL,
    recipients      JSONB,                        -- {users:[],roles:[],emails:[]}
    template_id     UUID REFERENCES notify.template(id),
    condition       JSONB,
    schedule        JSONB,                        -- for digests
    is_active       BOOLEAN DEFAULT TRUE,
    UNIQUE (tenant_id, code)
);

CREATE TABLE notify.user_preference (
    user_id         UUID NOT NULL REFERENCES iam.user(id) ON DELETE CASCADE,
    category        TEXT NOT NULL,
    channel         TEXT NOT NULL,
    enabled         BOOLEAN DEFAULT TRUE,
    quiet_hours     JSONB,
    PRIMARY KEY (user_id, category, channel)
);

CREATE TABLE notify.message (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    channel         TEXT NOT NULL,
    template_id     UUID,
    rule_id         UUID,
    recipient_type  TEXT,
    recipient_id    UUID,
    recipient_address TEXT NOT NULL,              -- email/phone/token
    subject         TEXT,
    body            TEXT,
    body_html       TEXT,
    variables       JSONB,
    priority        TEXT DEFAULT 'normal',
    status          TEXT DEFAULT 'queued' CHECK (status IN ('queued','sending','sent','delivered','failed','bounced','opened','clicked','unsubscribed')),
    provider        TEXT,
    provider_message_id TEXT,
    attempts        INT DEFAULT 0,
    last_attempt_at TIMESTAMPTZ,
    next_retry_at   TIMESTAMPTZ,
    sent_at         TIMESTAMPTZ,
    delivered_at    TIMESTAMPTZ,
    error           TEXT,
    created_at      TIMESTAMPTZ DEFAULT NOW()
) PARTITION BY RANGE (created_at);
CREATE TABLE notify.message_default PARTITION OF notify.message DEFAULT;

CREATE TABLE notify.in_app (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    user_id         UUID NOT NULL REFERENCES iam.user(id),
    title           TEXT NOT NULL,
    body            TEXT,
    link            TEXT,
    icon            TEXT,
    category        TEXT,
    priority        TEXT,
    is_read         BOOLEAN DEFAULT FALSE,
    read_at         TIMESTAMPTZ,
    created_at      TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE notify.push_subscription (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id         UUID NOT NULL REFERENCES iam.user(id) ON DELETE CASCADE,
    platform        TEXT CHECK (platform IN ('fcm','apns','web_push')),
    endpoint        TEXT NOT NULL,
    token           TEXT NOT NULL,
    keys            JSONB,
    device_id       TEXT,
    is_active       BOOLEAN DEFAULT TRUE,
    created_at      TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE notify.webhook_endpoint (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    url             TEXT NOT NULL,
    secret          TEXT,
    events          TEXT[],
    is_active       BOOLEAN DEFAULT TRUE,
    headers         JSONB,
    created_at      TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE notify.webhook_delivery (
    id              BIGSERIAL PRIMARY KEY,
    endpoint_id     UUID NOT NULL REFERENCES notify.webhook_endpoint(id),
    event_type      TEXT NOT NULL,
    payload         JSONB NOT NULL,
    response_status INT,
    response_body   TEXT,
    attempts        INT DEFAULT 0,
    status          TEXT DEFAULT 'pending',
    created_at      TIMESTAMPTZ DEFAULT NOW(),
    delivered_at    TIMESTAMPTZ
);

-- =====================================================================
-- INDEXES
-- =====================================================================
CREATE INDEX idx_message_status        ON notify.message(status, next_retry_at);
CREATE INDEX idx_message_recipient     ON notify.message(recipient_type, recipient_id);
CREATE INDEX idx_in_app_user_unread    ON notify.in_app(user_id) WHERE is_read = FALSE;
CREATE INDEX idx_webhook_endpoint_events ON notify.webhook_endpoint USING gin (events);
CREATE INDEX idx_webhook_delivery_status ON notify.webhook_delivery(status, attempts);

-- =====================================================================
-- FUNCTIONS
-- =====================================================================
CREATE OR REPLACE FUNCTION notify.fn_enqueue(
    p_tenant UUID, p_channel TEXT, p_template_code TEXT, p_locale TEXT,
    p_recipient_type TEXT, p_recipient_id UUID, p_recipient_address TEXT, p_vars JSONB
) RETURNS UUID AS $$
DECLARE
    v_tpl notify.template%ROWTYPE;
    v_id UUID;
BEGIN
    SELECT * INTO v_tpl FROM notify.template
     WHERE tenant_id = p_tenant AND code = p_template_code AND locale = p_locale AND is_active
     ORDER BY version DESC LIMIT 1;
    IF NOT FOUND THEN RAISE EXCEPTION 'Template % not found', p_template_code; END IF;

    INSERT INTO notify.message(tenant_id, channel, template_id, recipient_type, recipient_id,
        recipient_address, subject, body, variables, status)
    VALUES (p_tenant, p_channel, v_tpl.id, p_recipient_type, p_recipient_id,
        p_recipient_address, v_tpl.subject, v_tpl.body, p_vars, 'queued')
    RETURNING id INTO v_id;
    RETURN v_id;
END; $$ LANGUAGE plpgsql;
