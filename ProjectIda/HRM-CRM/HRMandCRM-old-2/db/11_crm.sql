-- =====================================================================
-- Module 11: CRM
-- Leads, Opportunities, Accounts, Contacts, Activities, Tickets, KB, NPS
-- =====================================================================

SET search_path = app, core, public;

-- =============== SCHEMA ===============

CREATE TABLE IF NOT EXISTS app.crm_accounts (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  company_id      uuid NOT NULL REFERENCES app.companies(id),
  code            citext NOT NULL,
  name            text NOT NULL,
  industry        text,
  website         text,
  phone           text,
  annual_revenue  numeric(19,4),
  employee_count  int,
  customer_id     uuid REFERENCES app.customers(id),       -- link once converted
  owner_user_id   uuid REFERENCES app.users(id),
  territory_id    uuid,
  billing_address jsonb,
  status          text NOT NULL DEFAULT 'prospect'
                  CHECK (status IN ('prospect','customer','churned','partner','competitor')),
  tags            text[] NOT NULL DEFAULT '{}',
  metadata        jsonb NOT NULL DEFAULT '{}'::jsonb,
  created_at      timestamptz NOT NULL DEFAULT now(),
  updated_at      timestamptz NOT NULL DEFAULT now(),
  created_by      uuid, updated_by uuid, version int NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, company_id, code)
);

CREATE TABLE IF NOT EXISTS app.crm_contacts (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  account_id      uuid REFERENCES app.crm_accounts(id) ON DELETE SET NULL,
  first_name      text,
  last_name       text,
  full_name       text GENERATED ALWAYS AS (COALESCE(first_name,'')||' '||COALESCE(last_name,'')) STORED,
  designation     text,
  department      text,
  email           citext,
  phone           text,
  mobile          text,
  linkedin_url    text,
  is_primary      boolean NOT NULL DEFAULT false,
  do_not_contact  boolean NOT NULL DEFAULT false,
  tags            text[] NOT NULL DEFAULT '{}',
  metadata        jsonb NOT NULL DEFAULT '{}'::jsonb,
  created_at      timestamptz NOT NULL DEFAULT now(),
  updated_at      timestamptz NOT NULL DEFAULT now(),
  created_by      uuid, updated_by uuid, version int NOT NULL DEFAULT 1
);

CREATE TABLE IF NOT EXISTS app.leads (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  company_id      uuid NOT NULL REFERENCES app.companies(id),
  lead_number     text NOT NULL,
  first_name      text,
  last_name       text,
  company_name    text,
  email           citext,
  phone           text,
  source          text,                                   -- web,referral,event,cold_call
  campaign_id     uuid,
  status          text NOT NULL DEFAULT 'new'
                  CHECK (status IN ('new','contacted','qualified','unqualified','converted','lost')),
  score           smallint NOT NULL DEFAULT 0,
  owner_user_id   uuid REFERENCES app.users(id),
  industry        text,
  budget          numeric(19,4),
  timeline        text,
  converted_account_id uuid REFERENCES app.crm_accounts(id),
  converted_contact_id uuid REFERENCES app.crm_contacts(id),
  converted_opportunity_id uuid,
  converted_at    timestamptz,
  notes           text,
  metadata        jsonb NOT NULL DEFAULT '{}'::jsonb,
  created_at      timestamptz NOT NULL DEFAULT now(),
  updated_at      timestamptz NOT NULL DEFAULT now(),
  created_by      uuid, updated_by uuid, version int NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, company_id, lead_number)
);

CREATE TABLE IF NOT EXISTS app.pipelines (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  code            citext NOT NULL,
  name            text NOT NULL,
  active          boolean NOT NULL DEFAULT true,
  created_at      timestamptz NOT NULL DEFAULT now(),
  updated_at      timestamptz NOT NULL DEFAULT now(),
  created_by      uuid, updated_by uuid, version int NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, code)
);

CREATE TABLE IF NOT EXISTS app.pipeline_stages (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  pipeline_id     uuid NOT NULL REFERENCES app.pipelines(id) ON DELETE CASCADE,
  seq_no          smallint NOT NULL,
  code            citext NOT NULL,
  name            text NOT NULL,
  probability_pct numeric(5,2) NOT NULL DEFAULT 0,
  is_won          boolean NOT NULL DEFAULT false,
  is_lost         boolean NOT NULL DEFAULT false,
  UNIQUE (pipeline_id, seq_no)
);

CREATE TABLE IF NOT EXISTS app.opportunities (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  company_id      uuid NOT NULL REFERENCES app.companies(id),
  opp_number      text NOT NULL,
  name            text NOT NULL,
  account_id      uuid REFERENCES app.crm_accounts(id),
  contact_id      uuid REFERENCES app.crm_contacts(id),
  pipeline_id     uuid NOT NULL REFERENCES app.pipelines(id),
  stage_id        uuid NOT NULL REFERENCES app.pipeline_stages(id),
  owner_user_id   uuid REFERENCES app.users(id),
  amount          numeric(19,4) NOT NULL DEFAULT 0,
  currency_code   char(3) NOT NULL DEFAULT 'INR',
  probability_pct numeric(5,2) NOT NULL DEFAULT 0,
  expected_close  date,
  actual_close    date,
  status          text NOT NULL DEFAULT 'open'
                  CHECK (status IN ('open','won','lost','abandoned')),
  lost_reason     text,
  tags            text[] NOT NULL DEFAULT '{}',
  metadata        jsonb NOT NULL DEFAULT '{}'::jsonb,
  created_at      timestamptz NOT NULL DEFAULT now(),
  updated_at      timestamptz NOT NULL DEFAULT now(),
  created_by      uuid, updated_by uuid, version int NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, company_id, opp_number)
);

ALTER TABLE app.leads ADD CONSTRAINT fk_lead_opp
  FOREIGN KEY (converted_opportunity_id) REFERENCES app.opportunities(id);

CREATE TABLE IF NOT EXISTS app.crm_activities (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  activity_type   text NOT NULL CHECK (activity_type IN ('call','meeting','email','task','note','sms','whatsapp')),
  subject         text NOT NULL,
  description     text,
  owner_user_id   uuid REFERENCES app.users(id),
  due_at          timestamptz,
  completed_at    timestamptz,
  status          text NOT NULL DEFAULT 'open' CHECK (status IN ('open','completed','cancelled')),
  related_type    text CHECK (related_type IN (NULL,'lead','opportunity','account','contact','customer','ticket')),
  related_id      uuid,
  outcome         text,
  duration_min    int,
  created_at      timestamptz NOT NULL DEFAULT now(),
  updated_at      timestamptz NOT NULL DEFAULT now(),
  created_by      uuid, updated_by uuid, version int NOT NULL DEFAULT 1
);

CREATE TABLE IF NOT EXISTS app.campaigns (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  code            citext NOT NULL,
  name            text NOT NULL,
  channel         text NOT NULL CHECK (channel IN ('email','sms','whatsapp','social','event','mixed')),
  start_date      date, end_date date,
  budget          numeric(19,4),
  status          text NOT NULL DEFAULT 'draft' CHECK (status IN ('draft','active','paused','completed','cancelled')),
  target_segment_id uuid,
  metrics         jsonb NOT NULL DEFAULT '{}'::jsonb,       -- sent, opened, clicked
  created_at      timestamptz NOT NULL DEFAULT now(),
  updated_at      timestamptz NOT NULL DEFAULT now(),
  created_by      uuid, updated_by uuid, version int NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, code)
);

CREATE TABLE IF NOT EXISTS app.customer_segments (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  code            citext NOT NULL,
  name            text NOT NULL,
  definition      jsonb NOT NULL DEFAULT '{}'::jsonb,       -- criteria as JSON
  dynamic         boolean NOT NULL DEFAULT true,
  created_at      timestamptz NOT NULL DEFAULT now(),
  updated_at      timestamptz NOT NULL DEFAULT now(),
  created_by      uuid, updated_by uuid, version int NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, code)
);

CREATE TABLE IF NOT EXISTS app.tickets (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  company_id      uuid NOT NULL REFERENCES app.companies(id),
  ticket_number   text NOT NULL,
  subject         text NOT NULL,
  description     text,
  customer_id     uuid REFERENCES app.customers(id),
  contact_id      uuid REFERENCES app.crm_contacts(id),
  channel         text NOT NULL CHECK (channel IN ('email','phone','chat','portal','whatsapp','social','walkin')),
  category        text,
  priority        text NOT NULL DEFAULT 'normal' CHECK (priority IN ('low','normal','high','urgent','critical')),
  severity        text CHECK (severity IN (NULL,'minor','major','critical','blocker')),
  status          text NOT NULL DEFAULT 'open'
                  CHECK (status IN ('open','acknowledged','in_progress','waiting_customer','resolved','closed','cancelled')),
  assigned_to     uuid REFERENCES app.users(id),
  sla_policy_id   uuid,
  sla_breach_at   timestamptz,
  first_response_at timestamptz,
  resolved_at     timestamptz,
  closed_at       timestamptz,
  source_ticket_id uuid REFERENCES app.tickets(id),
  tags            text[] NOT NULL DEFAULT '{}',
  metadata        jsonb NOT NULL DEFAULT '{}'::jsonb,
  created_at      timestamptz NOT NULL DEFAULT now(),
  updated_at      timestamptz NOT NULL DEFAULT now(),
  created_by      uuid, updated_by uuid, version int NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, company_id, ticket_number)
);

CREATE TABLE IF NOT EXISTS app.ticket_comments (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  ticket_id       uuid NOT NULL REFERENCES app.tickets(id) ON DELETE CASCADE,
  author_user_id  uuid REFERENCES app.users(id),
  author_contact_id uuid REFERENCES app.crm_contacts(id),
  is_internal     boolean NOT NULL DEFAULT false,
  body            text NOT NULL,
  created_at      timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS app.sla_policies (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  code            citext NOT NULL,
  name            text NOT NULL,
  applies_to      text NOT NULL DEFAULT 'ticket' CHECK (applies_to IN ('ticket','order','approval')),
  criteria        jsonb NOT NULL DEFAULT '{}'::jsonb,
  response_minutes int,
  resolution_minutes int,
  business_hours  jsonb,
  active          boolean NOT NULL DEFAULT true,
  created_at      timestamptz NOT NULL DEFAULT now(),
  updated_at      timestamptz NOT NULL DEFAULT now(),
  created_by      uuid, updated_by uuid, version int NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, code)
);

CREATE TABLE IF NOT EXISTS app.kb_articles (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  slug            citext NOT NULL,
  title           text NOT NULL,
  body_md         text NOT NULL,
  category        text,
  tags            text[] NOT NULL DEFAULT '{}',
  language        char(5) NOT NULL DEFAULT 'en-IN',
  status          text NOT NULL DEFAULT 'draft' CHECK (status IN ('draft','review','published','archived')),
  views           int NOT NULL DEFAULT 0,
  upvotes         int NOT NULL DEFAULT 0, downvotes int NOT NULL DEFAULT 0,
  published_at    timestamptz,
  created_at      timestamptz NOT NULL DEFAULT now(),
  updated_at      timestamptz NOT NULL DEFAULT now(),
  created_by      uuid, updated_by uuid, version int NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, slug)
);

CREATE TABLE IF NOT EXISTS app.nps_surveys (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  customer_id     uuid REFERENCES app.customers(id),
  contact_id      uuid REFERENCES app.crm_contacts(id),
  survey_type     text NOT NULL DEFAULT 'nps' CHECK (survey_type IN ('nps','csat','ces')),
  score           smallint,
  comment         text,
  related_ticket_id uuid REFERENCES app.tickets(id),
  related_order_id  uuid,
  submitted_at    timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS app.territories (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  parent_id       uuid REFERENCES app.territories(id),
  code            citext NOT NULL,
  name            text NOT NULL,
  region          text,
  owner_user_id   uuid REFERENCES app.users(id),
  active          boolean NOT NULL DEFAULT true,
  created_at      timestamptz NOT NULL DEFAULT now(),
  updated_at      timestamptz NOT NULL DEFAULT now(),
  created_by      uuid, updated_by uuid, version int NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, code)
);

-- =============== INDEXES ===============
CREATE INDEX IF NOT EXISTS idx_acct_tenant_status ON app.crm_accounts(tenant_id, status);
CREATE INDEX IF NOT EXISTS idx_acct_name_trgm     ON app.crm_accounts USING gin (name gin_trgm_ops);
CREATE INDEX IF NOT EXISTS idx_contact_account    ON app.crm_contacts(account_id);
CREATE INDEX IF NOT EXISTS idx_contact_email      ON app.crm_contacts(tenant_id, email);
CREATE INDEX IF NOT EXISTS idx_lead_status        ON app.leads(tenant_id, status, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_lead_owner         ON app.leads(owner_user_id, status);
CREATE INDEX IF NOT EXISTS idx_lead_email         ON app.leads(tenant_id, email);
CREATE INDEX IF NOT EXISTS idx_opp_owner_stage    ON app.opportunities(owner_user_id, stage_id);
CREATE INDEX IF NOT EXISTS idx_opp_account        ON app.opportunities(account_id);
CREATE INDEX IF NOT EXISTS idx_opp_close          ON app.opportunities(tenant_id, expected_close) WHERE status='open';
CREATE INDEX IF NOT EXISTS idx_activity_related   ON app.crm_activities(related_type, related_id);
CREATE INDEX IF NOT EXISTS idx_activity_owner_due ON app.crm_activities(owner_user_id, due_at) WHERE status='open';
CREATE INDEX IF NOT EXISTS idx_campaign_status    ON app.campaigns(tenant_id, status);
CREATE INDEX IF NOT EXISTS idx_ticket_status      ON app.tickets(tenant_id, status, priority);
CREATE INDEX IF NOT EXISTS idx_ticket_customer    ON app.tickets(customer_id, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_ticket_assigned    ON app.tickets(assigned_to, status) WHERE status NOT IN ('resolved','closed','cancelled');
CREATE INDEX IF NOT EXISTS idx_ticket_sla_breach  ON app.tickets(sla_breach_at) WHERE status NOT IN ('resolved','closed');
CREATE INDEX IF NOT EXISTS idx_kb_fts             ON app.kb_articles USING gin (to_tsvector('simple', title||' '||body_md));
CREATE INDEX IF NOT EXISTS idx_kb_tags            ON app.kb_articles USING gin (tags);
CREATE INDEX IF NOT EXISTS idx_nps_customer       ON app.nps_surveys(customer_id, submitted_at DESC);
CREATE INDEX IF NOT EXISTS idx_territory_parent   ON app.territories(parent_id);

-- =============== RLS + TRIGGERS ===============
SELECT core.enable_tenant_rls('app.crm_accounts');
SELECT core.enable_tenant_rls('app.crm_contacts');
SELECT core.enable_tenant_rls('app.leads');
SELECT core.enable_tenant_rls('app.pipelines');
SELECT core.enable_tenant_rls('app.pipeline_stages');
SELECT core.enable_tenant_rls('app.opportunities');
SELECT core.enable_tenant_rls('app.crm_activities');
SELECT core.enable_tenant_rls('app.campaigns');
SELECT core.enable_tenant_rls('app.customer_segments');
SELECT core.enable_tenant_rls('app.tickets');
SELECT core.enable_tenant_rls('app.ticket_comments');
SELECT core.enable_tenant_rls('app.sla_policies');
SELECT core.enable_tenant_rls('app.kb_articles');
SELECT core.enable_tenant_rls('app.nps_surveys');
SELECT core.enable_tenant_rls('app.territories');

SELECT core.attach_standard_triggers('app.crm_accounts');
SELECT core.attach_standard_triggers('app.crm_contacts');
SELECT core.attach_standard_triggers('app.leads');
SELECT core.attach_standard_triggers('app.pipelines');
SELECT core.attach_standard_triggers('app.opportunities');
SELECT core.attach_standard_triggers('app.crm_activities');
SELECT core.attach_standard_triggers('app.campaigns');
SELECT core.attach_standard_triggers('app.customer_segments');
SELECT core.attach_standard_triggers('app.tickets');
SELECT core.attach_standard_triggers('app.sla_policies');
SELECT core.attach_standard_triggers('app.kb_articles');
SELECT core.attach_standard_triggers('app.territories');

-- =============== FUNCTIONS ===============

-- Convert lead → account + contact + (optional) opportunity
CREATE OR REPLACE PROCEDURE app.convert_lead(
  p_lead_id uuid,
  p_pipeline_id uuid DEFAULT NULL,
  p_opp_amount numeric DEFAULT NULL,
  p_opp_close date DEFAULT NULL
)
LANGUAGE plpgsql AS $$
DECLARE
  v_lead app.leads%ROWTYPE;
  v_account_id uuid := gen_random_uuid();
  v_contact_id uuid := gen_random_uuid();
  v_opp_id uuid;
  v_first_stage uuid;
BEGIN
  SELECT * INTO v_lead FROM app.leads WHERE id = p_lead_id;
  IF v_lead.status IN ('converted','lost') THEN
    RAISE EXCEPTION 'lead already %', v_lead.status;
  END IF;

  INSERT INTO app.crm_accounts(id,tenant_id,company_id,code,name,owner_user_id)
  VALUES (v_account_id, v_lead.tenant_id, v_lead.company_id,
          'ACC-'||substr(v_account_id::text,1,8),
          COALESCE(v_lead.company_name, v_lead.first_name||' '||v_lead.last_name),
          v_lead.owner_user_id);

  INSERT INTO app.crm_contacts(id,tenant_id,account_id,first_name,last_name,email,phone,is_primary)
  VALUES (v_contact_id, v_lead.tenant_id, v_account_id, v_lead.first_name, v_lead.last_name,
          v_lead.email, v_lead.phone, true);

  IF p_pipeline_id IS NOT NULL THEN
    SELECT id INTO v_first_stage FROM app.pipeline_stages
     WHERE pipeline_id = p_pipeline_id ORDER BY seq_no LIMIT 1;

    v_opp_id := gen_random_uuid();
    INSERT INTO app.opportunities(id,tenant_id,company_id,opp_number,name,
           account_id,contact_id,pipeline_id,stage_id,owner_user_id,
           amount,expected_close)
    VALUES (v_opp_id, v_lead.tenant_id, v_lead.company_id,
            core.next_doc_number('OPP'),
            COALESCE(v_lead.company_name,'Opp from lead '||v_lead.lead_number),
            v_account_id, v_contact_id, p_pipeline_id, v_first_stage, v_lead.owner_user_id,
            COALESCE(p_opp_amount, v_lead.budget, 0),
            p_opp_close);
  END IF;

  UPDATE app.leads
     SET status='converted', converted_account_id=v_account_id,
         converted_contact_id=v_contact_id, converted_opportunity_id=v_opp_id,
         converted_at=now()
   WHERE id = p_lead_id;
END $$;

-- NPS summary (promoters - detractors)
CREATE OR REPLACE FUNCTION app.nps_score(p_since interval DEFAULT interval '90 days')
RETURNS TABLE(tenant_id uuid, promoters int, passives int, detractors int, nps numeric)
LANGUAGE sql STABLE AS $$
  SELECT tenant_id,
         COUNT(*) FILTER (WHERE score >= 9)::int,
         COUNT(*) FILTER (WHERE score BETWEEN 7 AND 8)::int,
         COUNT(*) FILTER (WHERE score <= 6)::int,
         round(
           (COUNT(*) FILTER (WHERE score >= 9)::numeric
            - COUNT(*) FILTER (WHERE score <= 6)::numeric)
           / NULLIF(COUNT(*),0) * 100, 2)
    FROM app.nps_surveys
   WHERE survey_type='nps' AND submitted_at >= now() - p_since
   GROUP BY tenant_id
$$;

-- =============== VIEWS ===============
CREATE OR REPLACE VIEW app.v_sales_pipeline_value AS
SELECT o.tenant_id, o.pipeline_id, ps.name AS stage,
       COUNT(*) AS opp_count,
       SUM(o.amount) AS total_value,
       SUM(o.amount * o.probability_pct/100) AS weighted_value
  FROM app.opportunities o
  JOIN app.pipeline_stages ps ON ps.id = o.stage_id
 WHERE o.status = 'open'
 GROUP BY o.tenant_id, o.pipeline_id, ps.name, ps.seq_no
 ORDER BY ps.seq_no;

CREATE OR REPLACE VIEW app.v_ticket_sla AS
SELECT t.tenant_id, t.priority,
       COUNT(*) total,
       COUNT(*) FILTER (WHERE t.sla_breach_at < now() AND t.status NOT IN ('resolved','closed')) AS breached,
       AVG(EXTRACT(EPOCH FROM (t.first_response_at - t.created_at))/60) AS avg_first_response_min,
       AVG(EXTRACT(EPOCH FROM (t.resolved_at - t.created_at))/3600)     AS avg_resolution_hours
  FROM app.tickets t
 GROUP BY t.tenant_id, t.priority;
