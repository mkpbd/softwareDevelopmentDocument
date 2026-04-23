-- =====================================================================
-- STEP 11: CRM
-- =====================================================================

CREATE TABLE crm.territory (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    parent_id       UUID REFERENCES crm.territory(id),
    code            TEXT NOT NULL,
    name            TEXT NOT NULL,
    manager_user_id UUID REFERENCES iam.user(id),
    country_code    CHAR(2),
    region          TEXT,
    city            TEXT,
    is_active       BOOLEAN DEFAULT TRUE,
    UNIQUE (tenant_id, code)
);

CREATE TABLE crm.segment (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    code            TEXT NOT NULL,
    name            TEXT NOT NULL,
    criteria        JSONB,
    is_dynamic      BOOLEAN DEFAULT FALSE,
    UNIQUE (tenant_id, code)
);

CREATE TABLE crm.lead_source (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    code            TEXT NOT NULL,
    name            TEXT NOT NULL,
    UNIQUE (tenant_id, code)
);

CREATE TABLE crm.lead (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    company_id      UUID NOT NULL,
    lead_no         TEXT NOT NULL,
    first_name      TEXT,
    last_name       TEXT,
    company_name    TEXT,
    designation     TEXT,
    email           core.email_t,
    phone           core.phone_t,
    mobile          core.phone_t,
    website         TEXT,
    industry        TEXT,
    lead_source_id  UUID REFERENCES crm.lead_source(id),
    campaign_id     UUID,
    territory_id    UUID REFERENCES crm.territory(id),
    owner_user_id   UUID REFERENCES iam.user(id),
    status          TEXT DEFAULT 'new' CHECK (status IN ('new','contacted','qualified','unqualified','converted','junk')),
    score           INT DEFAULT 0,
    estimated_value core.money_amt,
    currency_code   CHAR(3),
    address         JSONB,
    notes           TEXT,
    tags            TEXT[],
    converted_customer_id UUID REFERENCES sales.customer(id),
    converted_opportunity_id UUID,
    created_at      TIMESTAMPTZ DEFAULT NOW(),
    updated_at      TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE (company_id, lead_no)
);

CREATE TABLE crm.lead_score_rule (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    name            TEXT NOT NULL,
    criteria        JSONB NOT NULL,
    score_delta     INT NOT NULL,
    is_active       BOOLEAN DEFAULT TRUE
);

CREATE TABLE crm.account (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    company_id      UUID NOT NULL,
    code            TEXT NOT NULL,
    name            TEXT NOT NULL,
    customer_id     UUID REFERENCES sales.customer(id),
    parent_account_id UUID REFERENCES crm.account(id),
    account_type    TEXT,
    industry        TEXT,
    annual_revenue  core.money_amt,
    employees       INT,
    territory_id    UUID REFERENCES crm.territory(id),
    owner_user_id   UUID REFERENCES iam.user(id),
    tier            TEXT CHECK (tier IN ('platinum','gold','silver','bronze','prospect')),
    attributes      JSONB DEFAULT '{}'::jsonb,
    status          core.status_generic DEFAULT 'active',
    UNIQUE (company_id, code)
);

CREATE TABLE crm.contact (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    account_id      UUID REFERENCES crm.account(id),
    customer_id     UUID REFERENCES sales.customer(id),
    first_name      TEXT,
    last_name       TEXT,
    full_name       TEXT GENERATED ALWAYS AS (TRIM(coalesce(first_name,'')||' '||coalesce(last_name,''))) STORED,
    designation     TEXT,
    department      TEXT,
    email           core.email_t,
    phone           core.phone_t,
    mobile          core.phone_t,
    linkedin        TEXT,
    birthdate       DATE,
    is_primary      BOOLEAN DEFAULT FALSE,
    do_not_email    BOOLEAN DEFAULT FALSE,
    do_not_call     BOOLEAN DEFAULT FALSE,
    tags            TEXT[],
    created_at      TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE crm.pipeline (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    code            TEXT NOT NULL,
    name            TEXT NOT NULL,
    UNIQUE (tenant_id, code)
);

CREATE TABLE crm.pipeline_stage (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    pipeline_id     UUID NOT NULL REFERENCES crm.pipeline(id) ON DELETE CASCADE,
    sequence_no     INT NOT NULL,
    code            TEXT NOT NULL,
    name            TEXT NOT NULL,
    probability_pct NUMERIC(5,2) NOT NULL DEFAULT 0,
    is_won          BOOLEAN DEFAULT FALSE,
    is_lost         BOOLEAN DEFAULT FALSE,
    UNIQUE (pipeline_id, sequence_no)
);

CREATE TABLE crm.opportunity (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    company_id      UUID NOT NULL,
    doc_no          TEXT NOT NULL,
    name            TEXT NOT NULL,
    account_id      UUID REFERENCES crm.account(id),
    contact_id      UUID REFERENCES crm.contact(id),
    lead_id         UUID REFERENCES crm.lead(id),
    pipeline_id     UUID NOT NULL REFERENCES crm.pipeline(id),
    stage_id        UUID NOT NULL REFERENCES crm.pipeline_stage(id),
    owner_user_id   UUID REFERENCES iam.user(id),
    amount          core.money_amt,
    currency_code   CHAR(3),
    probability_pct NUMERIC(5,2),
    expected_close_date DATE,
    actual_close_date DATE,
    status          TEXT DEFAULT 'open' CHECK (status IN ('open','won','lost','abandoned')),
    lost_reason     TEXT,
    competitor      TEXT,
    source          TEXT,
    description     TEXT,
    created_at      TIMESTAMPTZ DEFAULT NOW(),
    updated_at      TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE (company_id, doc_no)
);

CREATE TABLE crm.activity (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    activity_type   TEXT NOT NULL CHECK (activity_type IN ('call','meeting','email','task','visit','demo','note')),
    subject         TEXT NOT NULL,
    description     TEXT,
    related_to_type TEXT,                         -- lead/account/opportunity/contact/customer
    related_to_id   UUID,
    owner_user_id   UUID REFERENCES iam.user(id),
    start_at        TIMESTAMPTZ,
    end_at          TIMESTAMPTZ,
    duration_min    INT,
    status          TEXT DEFAULT 'planned' CHECK (status IN ('planned','in_progress','completed','cancelled','overdue')),
    outcome         TEXT,
    priority        TEXT CHECK (priority IN ('low','medium','high','urgent')),
    created_at      TIMESTAMPTZ DEFAULT NOW()
);

-- Case / ticket
CREATE TABLE crm.case (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    company_id      UUID NOT NULL,
    doc_no          TEXT NOT NULL,
    subject         TEXT NOT NULL,
    description     TEXT,
    customer_id     UUID REFERENCES sales.customer(id),
    contact_id      UUID REFERENCES crm.contact(id),
    channel         TEXT CHECK (channel IN ('email','phone','chat','portal','whatsapp','social')),
    category        TEXT,
    priority        TEXT DEFAULT 'medium' CHECK (priority IN ('low','medium','high','urgent')),
    severity        TEXT,
    status          TEXT DEFAULT 'open' CHECK (status IN ('open','in_progress','pending_customer','resolved','closed','reopened')),
    assigned_to     UUID REFERENCES iam.user(id),
    sla_id          UUID,
    first_response_at TIMESTAMPTZ,
    resolved_at     TIMESTAMPTZ,
    closed_at       TIMESTAMPTZ,
    resolution      TEXT,
    csat_score      INT CHECK (csat_score BETWEEN 1 AND 5),
    nps_score       INT CHECK (nps_score BETWEEN 0 AND 10),
    created_at      TIMESTAMPTZ DEFAULT NOW(),
    updated_at      TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE (company_id, doc_no)
);

CREATE TABLE crm.case_comment (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    case_id         UUID NOT NULL REFERENCES crm.case(id) ON DELETE CASCADE,
    author_user_id  UUID,
    is_internal     BOOLEAN DEFAULT FALSE,
    body            TEXT NOT NULL,
    attachments     JSONB,
    created_at      TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE crm.sla (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    code            TEXT NOT NULL,
    name            TEXT NOT NULL,
    priority        TEXT,
    first_response_min INT,
    resolution_min  INT,
    business_hours  JSONB,
    UNIQUE (tenant_id, code)
);

CREATE TABLE crm.knowledge_article (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    title           TEXT NOT NULL,
    slug            TEXT NOT NULL,
    body            TEXT NOT NULL,
    category        TEXT,
    tags            TEXT[],
    status          TEXT DEFAULT 'draft' CHECK (status IN ('draft','published','archived')),
    views           BIGINT DEFAULT 0,
    helpful_yes     INT DEFAULT 0,
    helpful_no      INT DEFAULT 0,
    search_tsv      tsvector,
    published_at    TIMESTAMPTZ,
    author_user_id  UUID,
    UNIQUE (tenant_id, slug)
);

CREATE TABLE crm.campaign (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    code            TEXT NOT NULL,
    name            TEXT NOT NULL,
    channel         TEXT CHECK (channel IN ('email','sms','whatsapp','push','social','mixed')),
    start_date      DATE,
    end_date        DATE,
    budget          core.money_amt,
    target_segment_id UUID REFERENCES crm.segment(id),
    template        JSONB,
    status          TEXT DEFAULT 'draft' CHECK (status IN ('draft','scheduled','running','completed','paused','cancelled')),
    UNIQUE (tenant_id, code)
);

CREATE TABLE crm.campaign_recipient (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    campaign_id     UUID NOT NULL REFERENCES crm.campaign(id) ON DELETE CASCADE,
    recipient_type  TEXT,                         -- lead/contact/customer
    recipient_id    UUID NOT NULL,
    sent_at         TIMESTAMPTZ,
    opened_at       TIMESTAMPTZ,
    clicked_at      TIMESTAMPTZ,
    converted_at    TIMESTAMPTZ,
    bounce_reason   TEXT,
    status          TEXT DEFAULT 'pending'
);

CREATE TABLE crm.loyalty_program (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    code            TEXT NOT NULL,
    name            TEXT NOT NULL,
    currency_code   CHAR(3),
    points_per_currency NUMERIC(10,4),
    currency_per_point NUMERIC(10,4),
    expiry_days     INT,
    is_active       BOOLEAN DEFAULT TRUE,
    UNIQUE (tenant_id, code)
);

CREATE TABLE crm.loyalty_transaction (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    program_id      UUID NOT NULL REFERENCES crm.loyalty_program(id),
    customer_id     UUID NOT NULL REFERENCES sales.customer(id),
    txn_type        TEXT CHECK (txn_type IN ('earn','redeem','adjust','expire')),
    points          NUMERIC(19,4) NOT NULL,
    reference_type  TEXT,
    reference_id    UUID,
    expires_at      TIMESTAMPTZ,
    created_at      TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE crm.survey (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    code            TEXT NOT NULL,
    name            TEXT NOT NULL,
    survey_type     TEXT CHECK (survey_type IN ('nps','csat','ces','custom')),
    questions       JSONB NOT NULL,
    UNIQUE (tenant_id, code)
);

CREATE TABLE crm.survey_response (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    survey_id       UUID NOT NULL REFERENCES crm.survey(id),
    customer_id     UUID REFERENCES sales.customer(id),
    contact_id      UUID,
    reference_type  TEXT,
    reference_id    UUID,
    score           INT,
    answers         JSONB,
    submitted_at    TIMESTAMPTZ DEFAULT NOW()
);

-- =====================================================================
-- INDEXES
-- =====================================================================
CREATE INDEX idx_lead_status           ON crm.lead(company_id, status);
CREATE INDEX idx_lead_owner            ON crm.lead(owner_user_id, status);
CREATE INDEX idx_lead_email            ON crm.lead(email);
CREATE INDEX idx_lead_score            ON crm.lead(score DESC) WHERE status NOT IN ('converted','junk');
CREATE INDEX idx_opportunity_stage     ON crm.opportunity(pipeline_id, stage_id);
CREATE INDEX idx_opportunity_owner     ON crm.opportunity(owner_user_id, status);
CREATE INDEX idx_opportunity_close     ON crm.opportunity(expected_close_date) WHERE status='open';
CREATE INDEX idx_activity_owner        ON crm.activity(owner_user_id, start_at);
CREATE INDEX idx_activity_related      ON crm.activity(related_to_type, related_to_id);
CREATE INDEX idx_case_status           ON crm.case(company_id, status, priority);
CREATE INDEX idx_case_assigned         ON crm.case(assigned_to, status);
CREATE INDEX idx_case_customer         ON crm.case(customer_id, created_at DESC);
CREATE INDEX idx_article_tsv           ON crm.knowledge_article USING gin (search_tsv);
CREATE INDEX idx_campaign_recipient    ON crm.campaign_recipient(campaign_id, status);
CREATE INDEX idx_loyalty_customer      ON crm.loyalty_transaction(customer_id, created_at DESC);

-- =====================================================================
-- FUNCTIONS
-- =====================================================================

-- Lead → customer + opportunity conversion
CREATE OR REPLACE FUNCTION crm.fn_convert_lead(p_lead UUID, p_user UUID, p_create_opp BOOLEAN DEFAULT TRUE)
RETURNS TABLE (customer_id UUID, opportunity_id UUID) AS $$
DECLARE
    v_lead crm.lead%ROWTYPE;
    v_cust UUID;
    v_opp  UUID;
BEGIN
    SELECT * INTO v_lead FROM crm.lead WHERE id = p_lead FOR UPDATE;
    IF v_lead.status = 'converted' THEN
        RAISE EXCEPTION 'Lead already converted';
    END IF;

    INSERT INTO sales.customer(tenant_id, company_id, code, legal_name, display_name,
        email, phone, sales_rep_id, territory_id, currency_code)
    VALUES (v_lead.tenant_id, v_lead.company_id,
        'C-'||nextval('sales_customer_code_seq'),
        COALESCE(v_lead.company_name, v_lead.first_name||' '||v_lead.last_name),
        COALESCE(v_lead.company_name, v_lead.first_name||' '||v_lead.last_name),
        v_lead.email, v_lead.phone, v_lead.owner_user_id,
        v_lead.territory_id, COALESCE(v_lead.currency_code,'INR'))
    RETURNING id INTO v_cust;

    IF p_create_opp THEN
        INSERT INTO crm.opportunity(tenant_id, company_id, doc_no, name,
            pipeline_id, stage_id, owner_user_id, amount, currency_code, expected_close_date, lead_id)
        SELECT v_lead.tenant_id, v_lead.company_id,
            core.fn_next_doc_number(v_lead.tenant_id,'opportunity'),
            COALESCE(v_lead.company_name,'Opportunity')||' - '||COALESCE(v_lead.first_name,''),
            (SELECT id FROM crm.pipeline WHERE tenant_id = v_lead.tenant_id LIMIT 1),
            (SELECT id FROM crm.pipeline_stage WHERE sequence_no=1
               AND pipeline_id=(SELECT id FROM crm.pipeline WHERE tenant_id=v_lead.tenant_id LIMIT 1) LIMIT 1),
            v_lead.owner_user_id, v_lead.estimated_value, v_lead.currency_code,
            CURRENT_DATE + INTERVAL '30 days', v_lead.id
        RETURNING id INTO v_opp;
    END IF;

    UPDATE crm.lead SET status='converted', converted_customer_id = v_cust,
           converted_opportunity_id = v_opp WHERE id = p_lead;

    RETURN QUERY SELECT v_cust, v_opp;
END;
$$ LANGUAGE plpgsql;

-- Create customer code sequence
CREATE SEQUENCE IF NOT EXISTS sales_customer_code_seq;

-- Lead scoring
CREATE OR REPLACE FUNCTION crm.fn_rescore_lead(p_lead UUID)
RETURNS INT AS $$
DECLARE
    v_score INT := 0;
    v_rule  RECORD;
    v_lead  crm.lead%ROWTYPE;
BEGIN
    SELECT * INTO v_lead FROM crm.lead WHERE id = p_lead;
    FOR v_rule IN SELECT * FROM crm.lead_score_rule WHERE tenant_id = v_lead.tenant_id AND is_active LOOP
        -- Simplified: match criteria in JSONB
        IF v_lead.industry = v_rule.criteria->>'industry'
           OR v_lead.lead_source_id::text = v_rule.criteria->>'lead_source_id' THEN
            v_score := v_score + v_rule.score_delta;
        END IF;
    END LOOP;
    UPDATE crm.lead SET score = v_score WHERE id = p_lead;
    RETURN v_score;
END;
$$ LANGUAGE plpgsql;

-- Customer lifetime value
CREATE OR REPLACE FUNCTION crm.fn_clv(p_customer UUID)
RETURNS core.money_amt AS $$
    SELECT COALESCE(SUM(total),0)
      FROM sales.sales_invoice
     WHERE customer_id = p_customer AND status = 'posted';
$$ LANGUAGE sql STABLE;

-- =====================================================================
-- VIEWS
-- =====================================================================
CREATE OR REPLACE VIEW crm.v_sales_pipeline AS
SELECT ps.pipeline_id, ps.code AS stage, ps.sequence_no,
       COUNT(o.id) AS deals, SUM(o.amount) AS pipeline_value,
       SUM(o.amount * o.probability_pct/100) AS weighted_value
  FROM crm.pipeline_stage ps
  LEFT JOIN crm.opportunity o ON o.stage_id = ps.id AND o.status='open'
 GROUP BY ps.pipeline_id, ps.code, ps.sequence_no
 ORDER BY ps.sequence_no;

CREATE OR REPLACE VIEW crm.v_case_sla_breach AS
SELECT c.*, s.first_response_min, s.resolution_min,
       CASE WHEN c.first_response_at IS NULL AND
            EXTRACT(EPOCH FROM NOW() - c.created_at)/60 > s.first_response_min THEN TRUE ELSE FALSE END AS fr_breached,
       CASE WHEN c.resolved_at IS NULL AND
            EXTRACT(EPOCH FROM NOW() - c.created_at)/60 > s.resolution_min THEN TRUE ELSE FALSE END AS res_breached
  FROM crm.case c LEFT JOIN crm.sla s ON s.id = c.sla_id
 WHERE c.status NOT IN ('resolved','closed');

CREATE OR REPLACE VIEW crm.v_customer_360 AS
SELECT c.id, c.display_name,
       (SELECT COUNT(*) FROM sales.sales_invoice WHERE customer_id=c.id) AS invoices,
       (SELECT SUM(total) FROM sales.sales_invoice WHERE customer_id=c.id AND status='posted') AS lifetime_value,
       (SELECT COUNT(*) FROM crm.case WHERE customer_id=c.id AND status NOT IN ('closed','resolved')) AS open_cases,
       (SELECT AVG(score) FROM crm.survey_response WHERE customer_id=c.id) AS avg_nps
  FROM sales.customer c WHERE c.deleted_at IS NULL;

-- =====================================================================
-- TRIGGERS
-- =====================================================================
CREATE OR REPLACE FUNCTION crm.fn_article_tsv() RETURNS TRIGGER AS $$
BEGIN
    NEW.search_tsv := to_tsvector('english', coalesce(NEW.title,'')||' '||coalesce(NEW.body,'')||' '||coalesce(array_to_string(NEW.tags,' '),''));
    RETURN NEW;
END; $$ LANGUAGE plpgsql;
CREATE TRIGGER trg_article_tsv BEFORE INSERT OR UPDATE ON crm.knowledge_article
    FOR EACH ROW EXECUTE FUNCTION crm.fn_article_tsv();

CREATE TRIGGER trg_lead_audit AFTER INSERT OR UPDATE OR DELETE ON crm.lead
    FOR EACH ROW EXECUTE FUNCTION audit.fn_row_audit();
CREATE TRIGGER trg_opp_audit AFTER INSERT OR UPDATE OR DELETE ON crm.opportunity
    FOR EACH ROW EXECUTE FUNCTION audit.fn_row_audit();
CREATE TRIGGER trg_case_audit AFTER INSERT OR UPDATE OR DELETE ON crm.case
    FOR EACH ROW EXECUTE FUNCTION audit.fn_row_audit();
