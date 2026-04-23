-- =====================================================================
-- STEP 20: Subscription & Recurring Billing
-- =====================================================================

CREATE TABLE subscription.plan (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    code            TEXT NOT NULL,
    name            TEXT NOT NULL,
    description     TEXT,
    billing_cycle   TEXT CHECK (billing_cycle IN ('monthly','quarterly','half_yearly','yearly','weekly','custom')),
    cycle_days      INT,
    currency_code   CHAR(3) DEFAULT 'INR',
    base_price      core.money_amt NOT NULL,
    setup_fee       core.money_amt DEFAULT 0,
    trial_days      INT DEFAULT 0,
    is_metered      BOOLEAN DEFAULT FALSE,
    features        JSONB,
    is_active       BOOLEAN DEFAULT TRUE,
    UNIQUE (tenant_id, code)
);

CREATE TABLE subscription.plan_price_tier (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    plan_id         UUID NOT NULL REFERENCES subscription.plan(id) ON DELETE CASCADE,
    usage_from      NUMERIC(19,4) DEFAULT 0,
    usage_to        NUMERIC(19,4),
    unit_price      core.money_amt NOT NULL,
    flat_fee        core.money_amt DEFAULT 0
);

CREATE TABLE subscription.subscription (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    company_id      UUID NOT NULL,
    doc_no          TEXT NOT NULL,
    customer_id     UUID NOT NULL REFERENCES sales.customer(id),
    plan_id         UUID NOT NULL REFERENCES subscription.plan(id),
    start_date      DATE NOT NULL,
    end_date        DATE,
    trial_end_date  DATE,
    current_period_start DATE,
    current_period_end   DATE,
    next_billing_date DATE,
    billing_cycle   TEXT,
    status          TEXT DEFAULT 'active' CHECK (status IN ('trialing','active','past_due','paused','cancelled','expired','pending')),
    cancellation_date DATE,
    cancellation_reason TEXT,
    auto_renew      BOOLEAN DEFAULT TRUE,
    payment_method  JSONB,
    quantity        core.qty_amt DEFAULT 1,
    unit_price      core.money_amt,
    currency_code   CHAR(3),
    metadata        JSONB,
    created_at      TIMESTAMPTZ DEFAULT NOW(),
    updated_at      TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE (company_id, doc_no)
);

CREATE TABLE subscription.subscription_change (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    subscription_id UUID NOT NULL REFERENCES subscription.subscription(id) ON DELETE CASCADE,
    change_type     TEXT CHECK (change_type IN ('upgrade','downgrade','quantity','pause','resume','renew','cancel','plan_change')),
    effective_date  DATE NOT NULL,
    old_plan_id     UUID,
    new_plan_id     UUID,
    old_qty         core.qty_amt,
    new_qty         core.qty_amt,
    prorate_amount  core.money_amt,
    notes           TEXT,
    created_at      TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE subscription.usage_record (
    id              BIGSERIAL,
    subscription_id UUID NOT NULL,
    recorded_at     TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    metric          TEXT NOT NULL,
    quantity        NUMERIC(19,4) NOT NULL,
    idempotency_key TEXT UNIQUE,
    period_start    DATE,
    period_end      DATE,
    PRIMARY KEY (id, recorded_at)
) PARTITION BY RANGE (recorded_at);
CREATE TABLE subscription.usage_record_default PARTITION OF subscription.usage_record DEFAULT;

CREATE TABLE subscription.invoice_schedule (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    subscription_id UUID NOT NULL REFERENCES subscription.subscription(id) ON DELETE CASCADE,
    billing_date    DATE NOT NULL,
    amount          core.money_amt NOT NULL,
    period_start    DATE,
    period_end      DATE,
    invoice_id      UUID REFERENCES sales.sales_invoice(id),
    status          TEXT DEFAULT 'scheduled' CHECK (status IN ('scheduled','invoiced','paid','failed','skipped')),
    attempts        INT DEFAULT 0,
    last_attempt_at TIMESTAMPTZ,
    next_retry_at   TIMESTAMPTZ
);

CREATE TABLE subscription.dunning_step (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    step_no         INT NOT NULL,
    days_after_fail INT NOT NULL,
    action          TEXT CHECK (action IN ('email','sms','call','suspend','cancel')),
    template_id     UUID,
    UNIQUE (tenant_id, step_no)
);

CREATE TABLE subscription.churn_event (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    subscription_id UUID NOT NULL REFERENCES subscription.subscription(id),
    churn_date      DATE NOT NULL,
    churn_type      TEXT CHECK (churn_type IN ('voluntary','involuntary','upgrade_exit','downgrade')),
    mrr_lost        core.money_amt,
    reason          TEXT
);

-- =====================================================================
-- INDEXES
-- =====================================================================
CREATE INDEX idx_subscription_customer ON subscription.subscription(customer_id, status);
CREATE INDEX idx_subscription_next_bill ON subscription.subscription(next_billing_date) WHERE status='active';
CREATE INDEX idx_usage_sub_time        ON subscription.usage_record(subscription_id, recorded_at DESC);
CREATE INDEX idx_invoice_schedule_due  ON subscription.invoice_schedule(billing_date) WHERE status='scheduled';

-- =====================================================================
-- FUNCTIONS
-- =====================================================================

-- Advance subscription to next period and generate invoice schedule
CREATE OR REPLACE FUNCTION subscription.fn_advance_cycle(p_sub UUID)
RETURNS VOID AS $$
DECLARE
    v_sub subscription.subscription%ROWTYPE;
    v_period INTERVAL;
BEGIN
    SELECT * INTO v_sub FROM subscription.subscription WHERE id = p_sub FOR UPDATE;
    v_period := CASE v_sub.billing_cycle
        WHEN 'monthly' THEN INTERVAL '1 month'
        WHEN 'quarterly' THEN INTERVAL '3 months'
        WHEN 'half_yearly' THEN INTERVAL '6 months'
        WHEN 'yearly' THEN INTERVAL '1 year'
        WHEN 'weekly' THEN INTERVAL '1 week'
        ELSE INTERVAL '1 month' END;

    UPDATE subscription.subscription
       SET current_period_start = current_period_end,
           current_period_end   = current_period_end + v_period,
           next_billing_date    = current_period_end + v_period
     WHERE id = p_sub;

    INSERT INTO subscription.invoice_schedule(subscription_id, billing_date, amount,
        period_start, period_end, status)
    VALUES (p_sub, (v_sub.current_period_end + v_period)::date,
        v_sub.unit_price * v_sub.quantity, v_sub.current_period_end::date,
        (v_sub.current_period_end + v_period - INTERVAL '1 day')::date, 'scheduled');
END;
$$ LANGUAGE plpgsql;

-- MRR
CREATE OR REPLACE FUNCTION subscription.fn_mrr(p_company UUID, p_month DATE DEFAULT CURRENT_DATE)
RETURNS core.money_amt AS $$
    SELECT COALESCE(SUM(
        CASE s.billing_cycle
            WHEN 'monthly' THEN s.unit_price * s.quantity
            WHEN 'quarterly' THEN s.unit_price * s.quantity / 3
            WHEN 'half_yearly' THEN s.unit_price * s.quantity / 6
            WHEN 'yearly' THEN s.unit_price * s.quantity / 12
            ELSE 0 END
    ),0)
      FROM subscription.subscription s
     WHERE s.company_id = p_company AND s.status='active'
       AND s.start_date <= p_month AND (s.end_date IS NULL OR s.end_date >= p_month);
$$ LANGUAGE sql STABLE;

-- =====================================================================
-- VIEWS
-- =====================================================================
CREATE OR REPLACE VIEW subscription.v_active_subscriptions AS
SELECT s.*, c.display_name AS customer_name, p.name AS plan_name
  FROM subscription.subscription s
  JOIN sales.customer c ON c.id = s.customer_id
  JOIN subscription.plan p ON p.id = s.plan_id
 WHERE s.status IN ('active','trialing','past_due');

CREATE OR REPLACE VIEW subscription.v_churn_rate AS
SELECT date_trunc('month', churn_date) AS month,
       COUNT(*) AS churned, SUM(mrr_lost) AS mrr_lost
  FROM subscription.churn_event GROUP BY 1;
