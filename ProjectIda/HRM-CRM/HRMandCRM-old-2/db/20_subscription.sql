-- =====================================================================
-- Module 20: Subscription & Recurring Billing
-- Plans (product-facing), subscriptions, usage, dunning, lifecycle events
-- =====================================================================

SET search_path = app, core, public;

-- =============== SCHEMA ===============

CREATE TABLE IF NOT EXISTS app.subscription_products (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  code            citext NOT NULL,
  name            text NOT NULL,
  description     text,
  category        text,
  active          boolean NOT NULL DEFAULT true,
  metadata        jsonb NOT NULL DEFAULT '{}'::jsonb,
  created_at      timestamptz NOT NULL DEFAULT now(),
  updated_at      timestamptz NOT NULL DEFAULT now(),
  created_by      uuid, updated_by uuid, version int NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, code)
);

CREATE TABLE IF NOT EXISTS app.subscription_plans (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  product_id      uuid REFERENCES app.subscription_products(id),
  code            citext NOT NULL,
  name            text NOT NULL,
  billing_frequency text NOT NULL CHECK (billing_frequency IN ('monthly','quarterly','half_yearly','yearly','weekly','daily','custom')),
  frequency_count smallint NOT NULL DEFAULT 1,
  pricing_model   text NOT NULL CHECK (pricing_model IN ('flat','per_unit','tiered','volume','stairstep','usage','freemium')),
  base_price      numeric(19,4) NOT NULL DEFAULT 0,
  currency_code   char(3) NOT NULL DEFAULT 'INR',
  trial_days      smallint NOT NULL DEFAULT 0,
  setup_fee       numeric(19,4) NOT NULL DEFAULT 0,
  usage_unit      text,
  tiers           jsonb,                     -- [{"from":0,"to":100,"price":10},...]
  tax_rate        numeric(5,2) NOT NULL DEFAULT 0,
  active          boolean NOT NULL DEFAULT true,
  created_at      timestamptz NOT NULL DEFAULT now(),
  updated_at      timestamptz NOT NULL DEFAULT now(),
  created_by      uuid, updated_by uuid, version int NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, code)
);

CREATE TABLE IF NOT EXISTS app.customer_subscriptions (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  company_id      uuid NOT NULL REFERENCES app.companies(id),
  subscription_number text NOT NULL,
  customer_id     uuid NOT NULL REFERENCES app.customers(id),
  plan_id         uuid NOT NULL REFERENCES app.subscription_plans(id),
  quantity        numeric(19,6) NOT NULL DEFAULT 1,
  currency_code   char(3) NOT NULL DEFAULT 'INR',
  start_date      date NOT NULL,
  end_date        date,
  trial_ends_at   timestamptz,
  current_period_start date NOT NULL,
  current_period_end   date NOT NULL,
  next_bill_date  date,
  last_bill_date  date,
  payment_method  text CHECK (payment_method IN (NULL,'card','upi','mandate','invoice','ach')),
  auto_renew      boolean NOT NULL DEFAULT true,
  status          text NOT NULL DEFAULT 'active'
                  CHECK (status IN ('trial','active','paused','past_due','cancelled','expired','failed')),
  cancel_at_period_end boolean NOT NULL DEFAULT false,
  cancelled_at    timestamptz,
  cancel_reason   text,
  notes           text,
  metadata        jsonb NOT NULL DEFAULT '{}'::jsonb,
  created_at      timestamptz NOT NULL DEFAULT now(),
  updated_at      timestamptz NOT NULL DEFAULT now(),
  created_by      uuid, updated_by uuid, version int NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, company_id, subscription_number),
  CHECK (current_period_end >= current_period_start)
);

CREATE TABLE IF NOT EXISTS app.subscription_addons (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  subscription_id uuid NOT NULL REFERENCES app.customer_subscriptions(id) ON DELETE CASCADE,
  addon_plan_id   uuid NOT NULL REFERENCES app.subscription_plans(id),
  quantity        numeric(19,6) NOT NULL DEFAULT 1,
  effective_from  date NOT NULL,
  effective_to    date,
  UNIQUE (subscription_id, addon_plan_id, effective_from)
);

CREATE TABLE IF NOT EXISTS app.usage_records (
  id              uuid NOT NULL DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  subscription_id uuid NOT NULL,
  usage_unit      text NOT NULL,
  quantity        numeric(19,6) NOT NULL CHECK (quantity >= 0),
  recorded_at     timestamptz NOT NULL DEFAULT now(),
  external_id     text,
  invoiced        boolean NOT NULL DEFAULT false,
  invoiced_at     timestamptz,
  PRIMARY KEY (id, recorded_at)
) PARTITION BY RANGE (recorded_at);

CREATE TABLE IF NOT EXISTS app.usage_records_2026 PARTITION OF app.usage_records
  FOR VALUES FROM ('2026-01-01') TO ('2027-01-01');
CREATE TABLE IF NOT EXISTS app.usage_records_default PARTITION OF app.usage_records DEFAULT;

CREATE TABLE IF NOT EXISTS app.recurring_billing_runs (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  run_date        date NOT NULL,
  status          text NOT NULL DEFAULT 'running' CHECK (status IN ('running','completed','failed','cancelled')),
  subscriptions_processed int NOT NULL DEFAULT 0,
  invoices_created int NOT NULL DEFAULT 0,
  total_billed    numeric(19,4) NOT NULL DEFAULT 0,
  errors_count    int NOT NULL DEFAULT 0,
  started_at      timestamptz NOT NULL DEFAULT now(),
  completed_at    timestamptz
);

CREATE TABLE IF NOT EXISTS app.dunning_attempts (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  subscription_id uuid NOT NULL REFERENCES app.customer_subscriptions(id) ON DELETE CASCADE,
  sales_invoice_id uuid REFERENCES app.sales_invoices(id),
  attempt_no      int NOT NULL,
  attempted_at    timestamptz NOT NULL DEFAULT now(),
  outcome         text NOT NULL CHECK (outcome IN ('success','failed','retry','abandoned')),
  payment_method  text,
  failure_reason  text,
  next_retry_at   timestamptz
);

CREATE TABLE IF NOT EXISTS app.subscription_events (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  subscription_id uuid NOT NULL REFERENCES app.customer_subscriptions(id) ON DELETE CASCADE,
  event_type      text NOT NULL CHECK (event_type IN (
                    'created','activated','upgraded','downgraded','paused','resumed',
                    'renewed','expired','cancelled','reactivated','trial_started','trial_ended','payment_failed','payment_succeeded')),
  old_state       jsonb,
  new_state       jsonb,
  actor_user_id   uuid,
  occurred_at     timestamptz NOT NULL DEFAULT now(),
  metadata        jsonb
);

-- =============== INDEXES ===============
CREATE INDEX IF NOT EXISTS idx_subprod_tenant     ON app.subscription_products(tenant_id) WHERE active;
CREATE INDEX IF NOT EXISTS idx_subplan_active     ON app.subscription_plans(tenant_id) WHERE active;
CREATE INDEX IF NOT EXISTS idx_csub_customer      ON app.customer_subscriptions(customer_id, status);
CREATE INDEX IF NOT EXISTS idx_csub_status        ON app.customer_subscriptions(tenant_id, status);
CREATE INDEX IF NOT EXISTS idx_csub_nextbill      ON app.customer_subscriptions(next_bill_date) WHERE status IN ('active','past_due');
CREATE INDEX IF NOT EXISTS idx_csub_plan          ON app.customer_subscriptions(plan_id);
CREATE INDEX IF NOT EXISTS idx_addon_sub          ON app.subscription_addons(subscription_id);
CREATE INDEX IF NOT EXISTS idx_usage_sub_date     ON app.usage_records(subscription_id, recorded_at DESC);
CREATE INDEX IF NOT EXISTS idx_usage_uninvoiced   ON app.usage_records(subscription_id) WHERE NOT invoiced;
CREATE INDEX IF NOT EXISTS idx_dunning_sub        ON app.dunning_attempts(subscription_id, attempted_at DESC);
CREATE INDEX IF NOT EXISTS idx_subev_sub          ON app.subscription_events(subscription_id, occurred_at DESC);

-- =============== RLS + TRIGGERS ===============
SELECT core.enable_tenant_rls('app.subscription_products');
SELECT core.enable_tenant_rls('app.subscription_plans');
SELECT core.enable_tenant_rls('app.customer_subscriptions');
SELECT core.enable_tenant_rls('app.subscription_addons');
SELECT core.enable_tenant_rls('app.usage_records');
SELECT core.enable_tenant_rls('app.recurring_billing_runs');
SELECT core.enable_tenant_rls('app.dunning_attempts');
SELECT core.enable_tenant_rls('app.subscription_events');

SELECT core.attach_standard_triggers('app.subscription_products');
SELECT core.attach_standard_triggers('app.subscription_plans');
SELECT core.attach_standard_triggers('app.customer_subscriptions');

-- =============== FUNCTIONS ===============

-- Advance current period and compute next bill date
CREATE OR REPLACE FUNCTION app.advance_subscription_period(p_subscription_id uuid)
RETURNS void
LANGUAGE plpgsql AS $$
DECLARE
  s app.customer_subscriptions%ROWTYPE;
  p app.subscription_plans%ROWTYPE;
  v_ival interval;
BEGIN
  SELECT * INTO s FROM app.customer_subscriptions WHERE id = p_subscription_id;
  SELECT * INTO p FROM app.subscription_plans      WHERE id = s.plan_id;

  v_ival := CASE p.billing_frequency
    WHEN 'daily'       THEN (p.frequency_count ||' day')::interval
    WHEN 'weekly'      THEN (p.frequency_count ||' week')::interval
    WHEN 'monthly'     THEN (p.frequency_count ||' month')::interval
    WHEN 'quarterly'   THEN (p.frequency_count * 3 ||' month')::interval
    WHEN 'half_yearly' THEN (p.frequency_count * 6 ||' month')::interval
    WHEN 'yearly'      THEN (p.frequency_count ||' year')::interval
    ELSE interval '1 month'
  END;

  UPDATE app.customer_subscriptions
     SET current_period_start = current_period_end + 1,
         current_period_end   = (current_period_end + 1 + v_ival - interval '1 day')::date,
         last_bill_date       = current_period_end,
         next_bill_date       = (current_period_end + 1 + v_ival)::date,
         updated_at           = now()
   WHERE id = p_subscription_id;
END $$;

-- Prorate calculation for mid-cycle change
CREATE OR REPLACE FUNCTION app.prorate_amount(
  p_amount numeric, p_period_start date, p_period_end date, p_effective date
) RETURNS numeric
LANGUAGE sql IMMUTABLE AS $$
  SELECT round(p_amount *
    GREATEST(0, (p_period_end - GREATEST(p_effective, p_period_start) + 1))::numeric
    / NULLIF((p_period_end - p_period_start + 1),0), 4)
$$;

-- Record subscription lifecycle event + fire webhook
CREATE OR REPLACE PROCEDURE app.record_subscription_event(
  p_subscription_id uuid, p_event_type text,
  p_old jsonb DEFAULT NULL, p_new jsonb DEFAULT NULL
)
LANGUAGE plpgsql AS $$
BEGIN
  INSERT INTO app.subscription_events(tenant_id,subscription_id,event_type,old_state,new_state,actor_user_id)
  VALUES (core.require_tenant(), p_subscription_id, p_event_type, p_old, p_new, core.current_user_id());

  PERFORM app.emit_webhook_event('subscription.'||p_event_type,
    jsonb_build_object('subscription_id', p_subscription_id, 'old', p_old, 'new', p_new));
END $$;

-- Churn rate (month-over-month)
CREATE OR REPLACE FUNCTION app.churn_rate(p_months int DEFAULT 1)
RETURNS TABLE(month date, active_start int, churned int, churn_pct numeric)
LANGUAGE sql STABLE AS $$
  WITH monthly AS (
    SELECT date_trunc('month', cancelled_at)::date AS m, COUNT(*) AS cnt
      FROM app.customer_subscriptions
     WHERE cancelled_at IS NOT NULL
       AND cancelled_at >= now() - (p_months||' months')::interval
     GROUP BY 1
  ), base AS (
    SELECT date_trunc('month', now())::date AS m,
           COUNT(*) FILTER (WHERE status='active')::int AS active_count
      FROM app.customer_subscriptions
  )
  SELECT m.m, base.active_count, m.cnt::int,
         round(m.cnt::numeric / NULLIF(base.active_count,0) * 100, 2)
    FROM monthly m CROSS JOIN base
   ORDER BY m.m
$$;

-- =============== VIEWS ===============
CREATE OR REPLACE VIEW app.v_mrr AS
SELECT cs.tenant_id,
       date_trunc('month', CURRENT_DATE)::date AS month,
       SUM(CASE sp.billing_frequency
             WHEN 'monthly' THEN sp.base_price * cs.quantity
             WHEN 'quarterly' THEN sp.base_price * cs.quantity / 3
             WHEN 'yearly' THEN sp.base_price * cs.quantity / 12
             ELSE sp.base_price * cs.quantity
           END) AS mrr
  FROM app.customer_subscriptions cs
  JOIN app.subscription_plans sp ON sp.id = cs.plan_id
 WHERE cs.status IN ('active','trial','past_due')
 GROUP BY cs.tenant_id;

CREATE OR REPLACE VIEW app.v_billing_due AS
SELECT tenant_id, id AS subscription_id, subscription_number, customer_id,
       next_bill_date, status
  FROM app.customer_subscriptions
 WHERE status IN ('active','past_due')
   AND next_bill_date <= CURRENT_DATE + interval '7 days'
 ORDER BY next_bill_date;
