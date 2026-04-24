-- =============================================================================
-- tables.sql — Steps 18–32: Logistics, POS, Billing, Documents,
--              Workflow, Notifications, Integration, Data, Reporting,
--              BI/AI, Security, Observability, Mobile, Portals, Canteen
-- =============================================================================

-- =============================================================================
-- STEP 18: LOGISTICS & WAREHOUSE
-- =============================================================================

-- Shipping Carriers
CREATE TABLE logistics.shipping_carriers (
    shipping_carrier_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id           UUID         NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id           UUID         NOT NULL REFERENCES core.branches(branch_id),
    carrier_code        VARCHAR(50)  NOT NULL,
    carrier_name        VARCHAR(255) NOT NULL,
    carrier_type        VARCHAR(20)  NOT NULL DEFAULT 'courier' CHECK (carrier_type IN ('courier','freight','3pl','own_fleet')),
    tracking_url_template TEXT,
    is_active           BOOLEAN      NOT NULL DEFAULT TRUE,
    created_by          UUID         NOT NULL,
    updated_by          UUID         NOT NULL,
    deleted_by          UUID,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    deleted_at          TIMESTAMPTZ,
    UNIQUE (tenant_id, carrier_code)
);

-- Shipments
CREATE TABLE logistics.shipments (
    shipment_id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id           UUID         NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id           UUID         NOT NULL REFERENCES core.branches(branch_id),
    shipment_number     VARCHAR(50)  NOT NULL,
    shipment_type       VARCHAR(20)  NOT NULL DEFAULT 'outbound' CHECK (shipment_type IN ('outbound','inbound','transfer','return')),
    source_document_type VARCHAR(100),
    source_document_id  UUID,
    origin_warehouse_id UUID         REFERENCES inventory.warehouses(warehouse_id),
    destination_address JSONB,
    shipping_carrier_id UUID         REFERENCES logistics.shipping_carriers(shipping_carrier_id),
    tracking_number     VARCHAR(100),
    estimated_delivery_date DATE,
    actual_delivery_date DATE,
    freight_cost        NUMERIC(20,2) NOT NULL DEFAULT 0,
    insurance_cost      NUMERIC(20,2) NOT NULL DEFAULT 0,
    weight_kg           NUMERIC(10,3),
    volume_cbm          NUMERIC(10,3),
    status              VARCHAR(20)  NOT NULL DEFAULT 'pending' CHECK (status IN ('pending','booked','picked_up','in_transit','out_for_delivery','delivered','returned','failed')),
    proof_of_delivery   TEXT,
    pod_signed_by       VARCHAR(255),
    pod_signed_at       TIMESTAMPTZ,
    created_by          UUID         NOT NULL,
    updated_by          UUID         NOT NULL,
    deleted_by          UUID,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    deleted_at          TIMESTAMPTZ,
    UNIQUE (tenant_id, branch_id, shipment_number)
);

-- Shipment Track Events
CREATE TABLE logistics.shipment_tracking_events (
    tracking_event_id   UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id           UUID         NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id           UUID         NOT NULL REFERENCES core.branches(branch_id),
    shipment_id         UUID         NOT NULL REFERENCES logistics.shipments(shipment_id),
    event_timestamp     TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    event_status        VARCHAR(100) NOT NULL,
    event_location      VARCHAR(255),
    description         TEXT,
    created_by          UUID         NOT NULL,
    updated_by          UUID         NOT NULL,
    deleted_by          UUID,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    deleted_at          TIMESTAMPTZ
);

-- =============================================================================
-- STEP 19: POINT OF SALE
-- =============================================================================

-- POS Terminals
CREATE TABLE pos.pos_terminals (
    pos_terminal_id     UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id           UUID         NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id           UUID         NOT NULL REFERENCES core.branches(branch_id),
    terminal_code       VARCHAR(50)  NOT NULL,
    terminal_name       VARCHAR(200) NOT NULL,
    warehouse_id        UUID         NOT NULL REFERENCES inventory.warehouses(warehouse_id),
    price_list_id       UUID         REFERENCES sales.price_lists(price_list_id),
    is_active           BOOLEAN      NOT NULL DEFAULT TRUE,
    created_by          UUID         NOT NULL,
    updated_by          UUID         NOT NULL,
    deleted_by          UUID,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    deleted_at          TIMESTAMPTZ,
    UNIQUE (tenant_id, terminal_code)
);

-- POS Shifts
CREATE TABLE pos.pos_shifts (
    pos_shift_id        UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id           UUID         NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id           UUID         NOT NULL REFERENCES core.branches(branch_id),
    pos_terminal_id     UUID         NOT NULL REFERENCES pos.pos_terminals(pos_terminal_id),
    cashier_user_id     UUID         NOT NULL REFERENCES iam.users(user_id),
    opening_cash        NUMERIC(20,2) NOT NULL DEFAULT 0,
    closing_cash        NUMERIC(20,2),
    expected_cash       NUMERIC(20,2),
    cash_difference     NUMERIC(20,2),
    total_sales         NUMERIC(20,2) NOT NULL DEFAULT 0,
    total_returns       NUMERIC(20,2) NOT NULL DEFAULT 0,
    opened_at           TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    closed_at           TIMESTAMPTZ,
    status              VARCHAR(20)  NOT NULL DEFAULT 'open' CHECK (status IN ('open','closed')),
    notes               TEXT,
    created_by          UUID         NOT NULL,
    updated_by          UUID         NOT NULL,
    deleted_by          UUID,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    deleted_at          TIMESTAMPTZ
);

-- POS Transactions
CREATE TABLE pos.pos_transactions (
    pos_transaction_id  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id           UUID         NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id           UUID         NOT NULL REFERENCES core.branches(branch_id),
    transaction_number  VARCHAR(50)  NOT NULL,
    pos_shift_id        UUID         NOT NULL REFERENCES pos.pos_shifts(pos_shift_id),
    pos_terminal_id     UUID         NOT NULL REFERENCES pos.pos_terminals(pos_terminal_id),
    transaction_type    VARCHAR(20)  NOT NULL DEFAULT 'sale' CHECK (transaction_type IN ('sale','return','exchange','void')),
    customer_id         UUID         REFERENCES sales.customers(customer_id),
    cashier_user_id     UUID         NOT NULL REFERENCES iam.users(user_id),
    subtotal            NUMERIC(20,2) NOT NULL DEFAULT 0,
    discount_amount     NUMERIC(20,2) NOT NULL DEFAULT 0,
    tax_amount          NUMERIC(20,2) NOT NULL DEFAULT 0,
    total_amount        NUMERIC(20,2) NOT NULL DEFAULT 0,
    loyalty_points_earned NUMERIC(10,2) NOT NULL DEFAULT 0,
    loyalty_points_redeemed NUMERIC(10,2) NOT NULL DEFAULT 0,
    status              VARCHAR(20)  NOT NULL DEFAULT 'completed' CHECK (status IN ('pending','completed','voided','refunded')),
    journal_entry_id    UUID         REFERENCES finance.journal_entries(journal_entry_id),
    sales_invoice_id    UUID         REFERENCES sales.sales_invoices(sales_invoice_id),
    created_by          UUID         NOT NULL,
    updated_by          UUID         NOT NULL,
    deleted_by          UUID,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    deleted_at          TIMESTAMPTZ,
    UNIQUE (tenant_id, branch_id, transaction_number)
);

-- POS Payment Splits
CREATE TABLE pos.pos_payment_splits (
    payment_split_id    UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id           UUID         NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id           UUID         NOT NULL REFERENCES core.branches(branch_id),
    pos_transaction_id  UUID         NOT NULL REFERENCES pos.pos_transactions(pos_transaction_id),
    payment_method      VARCHAR(30)  NOT NULL CHECK (payment_method IN ('cash','card','upi','wallet','loyalty','gift_card','credit','cheque','emi')),
    amount              NUMERIC(20,2) NOT NULL CHECK (amount > 0),
    reference_number    VARCHAR(100),
    created_by          UUID         NOT NULL,
    updated_by          UUID         NOT NULL,
    deleted_by          UUID,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    deleted_at          TIMESTAMPTZ
);

-- =============================================================================
-- STEP 20: SUBSCRIPTION & RECURRING BILLING
-- =============================================================================

-- Subscription Plans
CREATE TABLE billing.subscription_plans (
    subscription_plan_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id            UUID        NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id            UUID        NOT NULL REFERENCES core.branches(branch_id),
    plan_code            VARCHAR(50) NOT NULL,
    plan_name            VARCHAR(255) NOT NULL,
    billing_frequency    VARCHAR(20) NOT NULL CHECK (billing_frequency IN ('monthly','quarterly','half_yearly','yearly','usage')),
    price                NUMERIC(20,2) NOT NULL DEFAULT 0,
    currency_code        VARCHAR(10) NOT NULL DEFAULT 'INR',
    trial_days           SMALLINT    NOT NULL DEFAULT 0,
    features             JSONB,
    is_active            BOOLEAN     NOT NULL DEFAULT TRUE,
    created_by           UUID        NOT NULL,
    updated_by           UUID        NOT NULL,
    deleted_by           UUID,
    created_at           TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at           TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at           TIMESTAMPTZ,
    UNIQUE (tenant_id, plan_code)
);

-- Customer Subscriptions
CREATE TABLE billing.customer_subscriptions (
    subscription_id     UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id           UUID         NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id           UUID         NOT NULL REFERENCES core.branches(branch_id),
    subscription_number VARCHAR(50)  NOT NULL,
    customer_id         UUID         NOT NULL REFERENCES sales.customers(customer_id),
    subscription_plan_id UUID        NOT NULL REFERENCES billing.subscription_plans(subscription_plan_id),
    status              VARCHAR(20)  NOT NULL DEFAULT 'trial' CHECK (status IN ('trial','active','past_due','suspended','cancelled','expired')),
    start_date          DATE         NOT NULL,
    end_date            DATE,
    trial_end_date      DATE,
    next_billing_date   DATE,
    current_period_start DATE,
    current_period_end  DATE,
    quantity            NUMERIC(10,2) NOT NULL DEFAULT 1,
    unit_price          NUMERIC(20,2) NOT NULL DEFAULT 0,
    discount_percentage NUMERIC(8,4) NOT NULL DEFAULT 0,
    cancelled_at        TIMESTAMPTZ,
    cancellation_reason TEXT,
    dunning_count       SMALLINT     NOT NULL DEFAULT 0,
    created_by          UUID         NOT NULL,
    updated_by          UUID         NOT NULL,
    deleted_by          UUID,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    deleted_at          TIMESTAMPTZ,
    UNIQUE (tenant_id, branch_id, subscription_number)
);

-- =============================================================================
-- STEP 21: DOCUMENT MANAGEMENT
-- =============================================================================

-- Document Categories
CREATE TABLE docs.document_categories (
    document_category_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id            UUID        NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id            UUID        NOT NULL REFERENCES core.branches(branch_id),
    parent_category_id   UUID        REFERENCES docs.document_categories(document_category_id),
    category_code        VARCHAR(50) NOT NULL,
    category_name        VARCHAR(255) NOT NULL,
    retention_months     INTEGER     NOT NULL DEFAULT 84,
    is_active            BOOLEAN     NOT NULL DEFAULT TRUE,
    created_by           UUID        NOT NULL,
    updated_by           UUID        NOT NULL,
    deleted_by           UUID,
    created_at           TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at           TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at           TIMESTAMPTZ,
    UNIQUE (tenant_id, category_code)
);

-- Documents
CREATE TABLE docs.documents (
    document_id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id           UUID         NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id           UUID         NOT NULL REFERENCES core.branches(branch_id),
    document_category_id UUID        REFERENCES docs.document_categories(document_category_id),
    document_code       VARCHAR(100),
    document_name       VARCHAR(255) NOT NULL,
    file_name           VARCHAR(500) NOT NULL,
    file_url            TEXT         NOT NULL,
    file_size_bytes     BIGINT,
    mime_type           VARCHAR(100),
    version_number      INTEGER      NOT NULL DEFAULT 1,
    is_latest_version   BOOLEAN      NOT NULL DEFAULT TRUE,
    parent_document_id  UUID         REFERENCES docs.documents(document_id),
    related_entity_type VARCHAR(100),
    related_entity_id   UUID,
    tags                JSONB,
    is_encrypted        BOOLEAN      NOT NULL DEFAULT FALSE,
    requires_signature  BOOLEAN      NOT NULL DEFAULT FALSE,
    signature_status    VARCHAR(20)  CHECK (signature_status IN ('pending','signed','rejected','expired')),
    expires_at          TIMESTAMPTZ,
    retention_until     DATE,
    ocr_text            TEXT,
    checksum            VARCHAR(100),
    virus_scan_status   VARCHAR(20)  NOT NULL DEFAULT 'pending' CHECK (virus_scan_status IN ('pending','clean','infected','failed')),
    uploaded_by         UUID         NOT NULL REFERENCES iam.users(user_id),
    created_by          UUID         NOT NULL,
    updated_by          UUID         NOT NULL,
    deleted_by          UUID,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    deleted_at          TIMESTAMPTZ
);

-- =============================================================================
-- STEP 22: WORKFLOW & AUTOMATION
-- =============================================================================

-- Workflow Definitions
CREATE TABLE workflow.workflow_definitions (
    workflow_definition_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id              UUID        NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id              UUID        NOT NULL REFERENCES core.branches(branch_id),
    workflow_code          VARCHAR(100) NOT NULL,
    workflow_name          VARCHAR(255) NOT NULL,
    entity_type            VARCHAR(100) NOT NULL,
    trigger_event          VARCHAR(100) NOT NULL,
    definition_json        JSONB       NOT NULL DEFAULT '{}',
    version                INTEGER     NOT NULL DEFAULT 1,
    is_active              BOOLEAN     NOT NULL DEFAULT TRUE,
    created_by             UUID        NOT NULL,
    updated_by             UUID        NOT NULL,
    deleted_by             UUID,
    created_at             TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at             TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at             TIMESTAMPTZ,
    UNIQUE (tenant_id, workflow_code, version)
);

-- Approval Matrices
CREATE TABLE workflow.approval_matrices (
    approval_matrix_id  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id           UUID         NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id           UUID         NOT NULL REFERENCES core.branches(branch_id),
    matrix_name         VARCHAR(255) NOT NULL,
    entity_type         VARCHAR(100) NOT NULL,
    min_amount          NUMERIC(20,2),
    max_amount          NUMERIC(20,2),
    approver_level      SMALLINT     NOT NULL DEFAULT 1,
    approver_type       VARCHAR(20)  NOT NULL DEFAULT 'user' CHECK (approver_type IN ('user','role','department_head','reporting_manager')),
    approver_id         UUID,
    approver_role_id    UUID         REFERENCES iam.roles(role_id),
    is_sequential       BOOLEAN      NOT NULL DEFAULT TRUE,
    is_active           BOOLEAN      NOT NULL DEFAULT TRUE,
    created_by          UUID         NOT NULL,
    updated_by          UUID         NOT NULL,
    deleted_by          UUID,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    deleted_at          TIMESTAMPTZ
);

-- Workflow Instances
CREATE TABLE workflow.workflow_instances (
    workflow_instance_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id            UUID        NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id            UUID        NOT NULL REFERENCES core.branches(branch_id),
    workflow_definition_id UUID      NOT NULL REFERENCES workflow.workflow_definitions(workflow_definition_id),
    entity_type          VARCHAR(100) NOT NULL,
    entity_id            UUID        NOT NULL,
    entity_number        VARCHAR(100),
    current_step         VARCHAR(100),
    status               VARCHAR(20) NOT NULL DEFAULT 'running' CHECK (status IN ('running','completed','cancelled','failed','on_hold')),
    initiated_by         UUID        NOT NULL REFERENCES iam.users(user_id),
    started_at           TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    completed_at         TIMESTAMPTZ,
    context_data         JSONB,
    created_by           UUID        NOT NULL,
    updated_by           UUID        NOT NULL,
    deleted_by           UUID,
    created_at           TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at           TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at           TIMESTAMPTZ
);

-- Workflow Tasks (pending approvals)
CREATE TABLE workflow.workflow_tasks (
    workflow_task_id    UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id           UUID         NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id           UUID         NOT NULL REFERENCES core.branches(branch_id),
    workflow_instance_id UUID        NOT NULL REFERENCES workflow.workflow_instances(workflow_instance_id),
    step_name           VARCHAR(100) NOT NULL,
    assigned_to         UUID         NOT NULL REFERENCES iam.users(user_id),
    due_at              TIMESTAMPTZ,
    action_taken        VARCHAR(20)  CHECK (action_taken IN ('approved','rejected','returned','delegated')),
    action_taken_at     TIMESTAMPTZ,
    comments            TEXT,
    status              VARCHAR(20)  NOT NULL DEFAULT 'pending' CHECK (status IN ('pending','completed','expired','cancelled')),
    created_by          UUID         NOT NULL,
    updated_by          UUID         NOT NULL,
    deleted_by          UUID,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    deleted_at          TIMESTAMPTZ
);

-- =============================================================================
-- STEP 23: NOTIFICATIONS & COMMUNICATIONS
-- =============================================================================

-- Notification Templates
CREATE TABLE notify.notification_templates (
    notification_template_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id                UUID        NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id                UUID        NOT NULL REFERENCES core.branches(branch_id),
    template_code            VARCHAR(100) NOT NULL,
    template_name            VARCHAR(255) NOT NULL,
    channel                  VARCHAR(20) NOT NULL CHECK (channel IN ('email','sms','push','in_app','whatsapp','slack','teams')),
    subject_template         TEXT,
    body_template            TEXT        NOT NULL,
    variables                JSONB,
    is_active                BOOLEAN     NOT NULL DEFAULT TRUE,
    created_by               UUID        NOT NULL,
    updated_by               UUID        NOT NULL,
    deleted_by               UUID,
    created_at               TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at               TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at               TIMESTAMPTZ,
    UNIQUE (tenant_id, template_code, channel)
);

-- Notifications (outbox)
CREATE TABLE notify.notifications (
    notification_id     UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id           UUID         NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id           UUID         NOT NULL REFERENCES core.branches(branch_id),
    recipient_user_id   UUID         REFERENCES iam.users(user_id),
    recipient_address   TEXT,
    channel             VARCHAR(20)  NOT NULL CHECK (channel IN ('email','sms','push','in_app','whatsapp','slack','teams')),
    notification_template_id UUID    REFERENCES notify.notification_templates(notification_template_id),
    subject             TEXT,
    body                TEXT         NOT NULL,
    related_entity_type VARCHAR(100),
    related_entity_id   UUID,
    status              VARCHAR(20)  NOT NULL DEFAULT 'pending' CHECK (status IN ('pending','sent','delivered','failed','cancelled')),
    retry_count         SMALLINT     NOT NULL DEFAULT 0,
    scheduled_at        TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    sent_at             TIMESTAMPTZ,
    delivered_at        TIMESTAMPTZ,
    failure_reason      TEXT,
    is_read             BOOLEAN      NOT NULL DEFAULT FALSE,
    read_at             TIMESTAMPTZ,
    created_by          UUID         NOT NULL,
    updated_by          UUID         NOT NULL,
    deleted_by          UUID,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    deleted_at          TIMESTAMPTZ
) PARTITION BY RANGE (created_at);

CREATE TABLE notify.notifications_2026 PARTITION OF notify.notifications
    FOR VALUES FROM ('2026-01-01') TO ('2027-01-01');

-- =============================================================================
-- STEP 24: INTEGRATION PLATFORM
-- =============================================================================

-- Webhook Registrations
CREATE TABLE integration.webhooks (
    webhook_id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id           UUID         NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id           UUID         NOT NULL REFERENCES core.branches(branch_id),
    webhook_name        VARCHAR(255) NOT NULL,
    endpoint_url        TEXT         NOT NULL,
    events              JSONB        NOT NULL DEFAULT '[]',
    secret_hash         TEXT,
    is_active           BOOLEAN      NOT NULL DEFAULT TRUE,
    retry_count         SMALLINT     NOT NULL DEFAULT 3,
    timeout_seconds     SMALLINT     NOT NULL DEFAULT 30,
    last_triggered_at   TIMESTAMPTZ,
    created_by          UUID         NOT NULL,
    updated_by          UUID         NOT NULL,
    deleted_by          UUID,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    deleted_at          TIMESTAMPTZ
);

-- Webhook Delivery Logs
CREATE TABLE integration.webhook_delivery_logs (
    delivery_log_id     UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id           UUID         NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id           UUID         NOT NULL REFERENCES core.branches(branch_id),
    webhook_id          UUID         NOT NULL REFERENCES integration.webhooks(webhook_id),
    event_type          VARCHAR(100) NOT NULL,
    payload             JSONB        NOT NULL,
    response_status     SMALLINT,
    response_body       TEXT,
    duration_ms         INTEGER,
    status              VARCHAR(20)  NOT NULL CHECK (status IN ('success','failed','retrying')),
    attempt_number      SMALLINT     NOT NULL DEFAULT 1,
    delivered_at        TIMESTAMPTZ,
    created_by          UUID         NOT NULL,
    updated_by          UUID         NOT NULL,
    deleted_by          UUID,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    deleted_at          TIMESTAMPTZ
) PARTITION BY RANGE (created_at);

CREATE TABLE integration.webhook_delivery_logs_2026 PARTITION OF integration.webhook_delivery_logs
    FOR VALUES FROM ('2026-01-01') TO ('2027-01-01');

-- Integration Connectors
CREATE TABLE integration.integration_connectors (
    connector_id        UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id           UUID         NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id           UUID         NOT NULL REFERENCES core.branches(branch_id),
    connector_type      VARCHAR(50)  NOT NULL CHECK (connector_type IN ('payment_gateway','bank_feed','gst_portal','ecommerce','accounting','erp','custom')),
    connector_name      VARCHAR(255) NOT NULL,
    config_encrypted    JSONB,
    is_active           BOOLEAN      NOT NULL DEFAULT TRUE,
    last_sync_at        TIMESTAMPTZ,
    last_sync_status    VARCHAR(20)  CHECK (last_sync_status IN ('success','failed','partial')),
    created_by          UUID         NOT NULL,
    updated_by          UUID         NOT NULL,
    deleted_by          UUID,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    deleted_at          TIMESTAMPTZ
);

-- =============================================================================
-- STEP 26: REPORTING & ANALYTICS
-- =============================================================================

-- Dashboards
CREATE TABLE reporting.dashboards (
    dashboard_id        UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id           UUID         NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id           UUID         NOT NULL REFERENCES core.branches(branch_id),
    dashboard_code      VARCHAR(50)  NOT NULL,
    dashboard_name      VARCHAR(255) NOT NULL,
    dashboard_type      VARCHAR(20)  NOT NULL DEFAULT 'custom' CHECK (dashboard_type IN ('system','custom','executive','operational')),
    layout_json         JSONB,
    is_public           BOOLEAN      NOT NULL DEFAULT FALSE,
    owner_user_id       UUID         NOT NULL REFERENCES iam.users(user_id),
    is_active           BOOLEAN      NOT NULL DEFAULT TRUE,
    created_by          UUID         NOT NULL,
    updated_by          UUID         NOT NULL,
    deleted_by          UUID,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    deleted_at          TIMESTAMPTZ,
    UNIQUE (tenant_id, dashboard_code)
);

-- Report Definitions
CREATE TABLE reporting.report_definitions (
    report_definition_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id            UUID        NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id            UUID        NOT NULL REFERENCES core.branches(branch_id),
    report_code          VARCHAR(50) NOT NULL,
    report_name          VARCHAR(255) NOT NULL,
    report_type          VARCHAR(30) NOT NULL DEFAULT 'tabular' CHECK (report_type IN ('tabular','pivot','chart','summary','financial')),
    category             VARCHAR(50),
    query_definition     JSONB,
    is_system_report     BOOLEAN     NOT NULL DEFAULT FALSE,
    is_active            BOOLEAN     NOT NULL DEFAULT TRUE,
    created_by           UUID        NOT NULL,
    updated_by           UUID        NOT NULL,
    deleted_by           UUID,
    created_at           TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at           TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at           TIMESTAMPTZ,
    UNIQUE (tenant_id, report_code)
);

-- =============================================================================
-- STEP 28: SECURITY & DATA PROTECTION
-- =============================================================================

-- Data Access Logs (for audit/PII access)
CREATE TABLE security.data_access_logs (
    data_access_log_id  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id           UUID         NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id           UUID         NOT NULL REFERENCES core.branches(branch_id),
    user_id             UUID         REFERENCES iam.users(user_id),
    entity_type         VARCHAR(100) NOT NULL,
    entity_id           UUID,
    action              VARCHAR(30)  NOT NULL CHECK (action IN ('read','create','update','delete','export','print')),
    ip_address          INET,
    user_agent          TEXT,
    is_pii_access       BOOLEAN      NOT NULL DEFAULT FALSE,
    changed_fields      JSONB,
    old_values          JSONB,
    new_values          JSONB,
    created_by          UUID         NOT NULL,
    updated_by          UUID         NOT NULL,
    deleted_by          UUID,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    deleted_at          TIMESTAMPTZ
) PARTITION BY RANGE (created_at);

CREATE TABLE security.data_access_logs_2026 PARTITION OF security.data_access_logs
    FOR VALUES FROM ('2026-01-01') TO ('2027-01-01');

-- =============================================================================
-- STEP 29: PERFORMANCE & OBSERVABILITY
-- =============================================================================

-- System Health Checks
CREATE TABLE observability.system_health_checks (
    health_check_id     UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id           UUID         NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id           UUID         NOT NULL REFERENCES core.branches(branch_id),
    service_name        VARCHAR(100) NOT NULL,
    check_name          VARCHAR(100) NOT NULL,
    status              VARCHAR(20)  NOT NULL CHECK (status IN ('healthy','degraded','unhealthy','unknown')),
    response_time_ms    INTEGER,
    details             JSONB,
    checked_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    created_by          UUID         NOT NULL,
    updated_by          UUID         NOT NULL,
    deleted_by          UUID,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    deleted_at          TIMESTAMPTZ
) PARTITION BY RANGE (checked_at);

CREATE TABLE observability.system_health_checks_2026 PARTITION OF observability.system_health_checks
    FOR VALUES FROM ('2026-01-01') TO ('2027-01-01');

-- =============================================================================
-- STEP 32: CANTEEN & CAFETERIA MANAGEMENT
-- =============================================================================

-- Canteen Masters
CREATE TABLE canteen.canteens (
    canteen_id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id           UUID         NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id           UUID         NOT NULL REFERENCES core.branches(branch_id),
    canteen_code        VARCHAR(50)  NOT NULL,
    canteen_name        VARCHAR(255) NOT NULL,
    location            VARCHAR(255),
    capacity            SMALLINT,
    is_active           BOOLEAN      NOT NULL DEFAULT TRUE,
    created_by          UUID         NOT NULL,
    updated_by          UUID         NOT NULL,
    deleted_by          UUID,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    deleted_at          TIMESTAMPTZ,
    UNIQUE (tenant_id, canteen_code)
);

-- Meal Types
CREATE TABLE canteen.meal_types (
    meal_type_id        UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id           UUID         NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id           UUID         NOT NULL REFERENCES core.branches(branch_id),
    canteen_id          UUID         NOT NULL REFERENCES canteen.canteens(canteen_id),
    meal_code           VARCHAR(20)  NOT NULL,
    meal_name           VARCHAR(100) NOT NULL,
    meal_time           VARCHAR(20)  NOT NULL CHECK (meal_time IN ('breakfast','morning_tea','lunch','evening_tea','dinner','snack')),
    serving_start_time  TIME         NOT NULL,
    serving_end_time    TIME         NOT NULL,
    booking_cutoff_time TIME,
    employee_price      NUMERIC(10,2) NOT NULL DEFAULT 0,
    employer_subsidy    NUMERIC(10,2) NOT NULL DEFAULT 0,
    guest_price         NUMERIC(10,2) NOT NULL DEFAULT 0,
    is_active           BOOLEAN      NOT NULL DEFAULT TRUE,
    created_by          UUID         NOT NULL,
    updated_by          UUID         NOT NULL,
    deleted_by          UUID,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    deleted_at          TIMESTAMPTZ,
    UNIQUE (tenant_id, canteen_id, meal_code)
);

-- Canteen Menu
CREATE TABLE canteen.menu_items (
    menu_item_id        UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id           UUID         NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id           UUID         NOT NULL REFERENCES core.branches(branch_id),
    canteen_id          UUID         NOT NULL REFERENCES canteen.canteens(canteen_id),
    meal_type_id        UUID         NOT NULL REFERENCES canteen.meal_types(meal_type_id),
    item_name           VARCHAR(255) NOT NULL,
    item_description    TEXT,
    dietary_type        VARCHAR(20)  NOT NULL DEFAULT 'veg' CHECK (dietary_type IN ('veg','non_veg','vegan','jain','gluten_free')),
    calories            SMALLINT,
    price               NUMERIC(10,2) NOT NULL DEFAULT 0,
    is_available        BOOLEAN      NOT NULL DEFAULT TRUE,
    allergens           JSONB,
    created_by          UUID         NOT NULL,
    updated_by          UUID         NOT NULL,
    deleted_by          UUID,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    deleted_at          TIMESTAMPTZ
);

-- Meal Bookings
CREATE TABLE canteen.meal_bookings (
    meal_booking_id     UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id           UUID         NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id           UUID         NOT NULL REFERENCES core.branches(branch_id),
    canteen_id          UUID         NOT NULL REFERENCES canteen.canteens(canteen_id),
    meal_type_id        UUID         NOT NULL REFERENCES canteen.meal_types(meal_type_id),
    employee_id         UUID         NOT NULL REFERENCES hr.employees(employee_id),
    booking_date        DATE         NOT NULL,
    booking_type        VARCHAR(20)  NOT NULL DEFAULT 'employee' CHECK (booking_type IN ('employee','guest','contractor')),
    guest_name          VARCHAR(255),
    guest_sponsored_by  UUID         REFERENCES hr.employees(employee_id),
    dietary_preference  VARCHAR(20),
    status              VARCHAR(20)  NOT NULL DEFAULT 'booked' CHECK (status IN ('booked','cancelled','consumed','no_show')),
    coupon_code         VARCHAR(50),
    amount_charged      NUMERIC(10,2) NOT NULL DEFAULT 0,
    employer_subsidy    NUMERIC(10,2) NOT NULL DEFAULT 0,
    consumed_at         TIMESTAMPTZ,
    cancelled_at        TIMESTAMPTZ,
    cancel_reason       VARCHAR(255),
    created_by          UUID         NOT NULL,
    updated_by          UUID         NOT NULL,
    deleted_by          UUID,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    deleted_at          TIMESTAMPTZ,
    UNIQUE (tenant_id, canteen_id, meal_type_id, employee_id, booking_date)
);

-- Canteen Feedback
CREATE TABLE canteen.meal_feedback (
    meal_feedback_id    UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id           UUID         NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id           UUID         NOT NULL REFERENCES core.branches(branch_id),
    meal_booking_id     UUID         NOT NULL REFERENCES canteen.meal_bookings(meal_booking_id),
    employee_id         UUID         NOT NULL REFERENCES hr.employees(employee_id),
    rating              SMALLINT     NOT NULL CHECK (rating BETWEEN 1 AND 5),
    taste_rating        SMALLINT     CHECK (taste_rating BETWEEN 1 AND 5),
    quality_rating      SMALLINT     CHECK (quality_rating BETWEEN 1 AND 5),
    hygiene_rating      SMALLINT     CHECK (hygiene_rating BETWEEN 1 AND 5),
    comments            TEXT,
    created_by          UUID         NOT NULL,
    updated_by          UUID         NOT NULL,
    deleted_by          UUID,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    deleted_at          TIMESTAMPTZ
);

-- =============================================================================
-- INDEXES — Platform tables
-- =============================================================================

CREATE INDEX idx_shipments_status ON logistics.shipments(tenant_id, status) WHERE deleted_at IS NULL;
CREATE INDEX idx_shipments_tracking ON logistics.shipments(tracking_number) WHERE tracking_number IS NOT NULL;
CREATE INDEX idx_pos_txn_shift ON pos.pos_transactions(pos_shift_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_pos_txn_date ON pos.pos_transactions(tenant_id, created_at) WHERE deleted_at IS NULL;
CREATE INDEX idx_subscriptions_customer ON billing.customer_subscriptions(customer_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_subscriptions_billing_date ON billing.customer_subscriptions(next_billing_date) WHERE status = 'active';
CREATE INDEX idx_documents_entity ON docs.documents(tenant_id, related_entity_type, related_entity_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_documents_category ON docs.documents(document_category_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_workflow_instances_entity ON workflow.workflow_instances(entity_type, entity_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_workflow_tasks_assigned ON workflow.workflow_tasks(assigned_to, status) WHERE deleted_at IS NULL;
CREATE INDEX idx_notifications_user ON notify.notifications(recipient_user_id, is_read) WHERE deleted_at IS NULL;
CREATE INDEX idx_notifications_scheduled ON notify.notifications(scheduled_at, status);
CREATE INDEX idx_webhooks_tenant ON integration.webhooks(tenant_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_data_access_entity ON security.data_access_logs(entity_type, entity_id, created_at);
CREATE INDEX idx_meal_bookings_date ON canteen.meal_bookings(tenant_id, booking_date) WHERE deleted_at IS NULL;
CREATE INDEX idx_meal_bookings_emp ON canteen.meal_bookings(employee_id, booking_date) WHERE deleted_at IS NULL;
