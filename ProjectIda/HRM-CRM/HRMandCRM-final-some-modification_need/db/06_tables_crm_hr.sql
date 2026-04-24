-- =============================================================================
-- tables.sql — Steps 11–14: CRM, HR, Time & Attendance, Payroll
-- =============================================================================

-- =============================================================================
-- STEP 11: CRM
-- =============================================================================

-- Leads
CREATE TABLE crm.leads (
    lead_id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id           UUID         NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id           UUID         NOT NULL REFERENCES core.branches(branch_id),
    lead_number         VARCHAR(50)  NOT NULL,
    first_name          VARCHAR(100) NOT NULL,
    last_name           VARCHAR(100),
    company_name        VARCHAR(255),
    designation         VARCHAR(200),
    email               VARCHAR(255),
    phone               VARCHAR(30),
    mobile              VARCHAR(30),
    website             VARCHAR(255),
    lead_source         VARCHAR(100) CHECK (lead_source IN ('website','referral','cold_call','social_media','email_campaign','exhibition','partner','other')),
    lead_status         VARCHAR(50)  NOT NULL DEFAULT 'new' CHECK (lead_status IN ('new','contacted','qualified','unqualified','converted','lost','nurturing')),
    lead_score          SMALLINT     NOT NULL DEFAULT 0 CHECK (lead_score BETWEEN 0 AND 100),
    industry            VARCHAR(100),
    annual_revenue      NUMERIC(20,2),
    employee_count      INTEGER,
    country_code        VARCHAR(10),
    city                VARCHAR(100),
    notes               TEXT,
    assigned_to         UUID         REFERENCES iam.users(user_id),
    last_contacted_at   TIMESTAMPTZ,
    qualified_at        TIMESTAMPTZ,
    converted_at        TIMESTAMPTZ,
    lost_reason         VARCHAR(255),
    created_by          UUID         NOT NULL,
    updated_by          UUID         NOT NULL,
    deleted_by          UUID,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    deleted_at          TIMESTAMPTZ,
    UNIQUE (tenant_id, branch_id, lead_number)
);

-- Contacts
CREATE TABLE crm.contacts (
    contact_id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id           UUID         NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id           UUID         NOT NULL REFERENCES core.branches(branch_id),
    first_name          VARCHAR(100) NOT NULL,
    last_name           VARCHAR(100),
    salutation          VARCHAR(20),
    designation         VARCHAR(200),
    department          VARCHAR(100),
    email               VARCHAR(255),
    phone               VARCHAR(30),
    mobile              VARCHAR(30),
    linkedin_url        TEXT,
    customer_id         UUID         REFERENCES sales.customers(customer_id),
    lead_id             UUID         REFERENCES crm.leads(lead_id),
    is_primary_contact  BOOLEAN      NOT NULL DEFAULT FALSE,
    notes               TEXT,
    created_by          UUID         NOT NULL,
    updated_by          UUID         NOT NULL,
    deleted_by          UUID,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    deleted_at          TIMESTAMPTZ
);

-- Opportunities / Deals
CREATE TABLE crm.opportunities (
    opportunity_id      UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id           UUID         NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id           UUID         NOT NULL REFERENCES core.branches(branch_id),
    opportunity_number  VARCHAR(50)  NOT NULL,
    opportunity_name    VARCHAR(255) NOT NULL,
    customer_id         UUID         REFERENCES sales.customers(customer_id),
    lead_id             UUID         REFERENCES crm.leads(lead_id),
    contact_id          UUID         REFERENCES crm.contacts(contact_id),
    stage               VARCHAR(50)  NOT NULL DEFAULT 'prospecting' CHECK (stage IN ('prospecting','qualification','needs_analysis','value_proposition','proposal','negotiation','closed_won','closed_lost')),
    probability_percent SMALLINT     NOT NULL DEFAULT 0 CHECK (probability_percent BETWEEN 0 AND 100),
    expected_revenue    NUMERIC(20,2) NOT NULL DEFAULT 0,
    currency_code       VARCHAR(10)  NOT NULL DEFAULT 'INR',
    expected_close_date DATE,
    actual_close_date   DATE,
    lost_reason         VARCHAR(255),
    campaign_id         UUID,
    assigned_to         UUID         REFERENCES iam.users(user_id),
    notes               TEXT,
    created_by          UUID         NOT NULL,
    updated_by          UUID         NOT NULL,
    deleted_by          UUID,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    deleted_at          TIMESTAMPTZ,
    UNIQUE (tenant_id, branch_id, opportunity_number)
);

-- Activities (calls, meetings, tasks)
CREATE TABLE crm.activities (
    activity_id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id           UUID         NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id           UUID         NOT NULL REFERENCES core.branches(branch_id),
    activity_type       VARCHAR(30)  NOT NULL CHECK (activity_type IN ('call','meeting','email','task','demo','follow_up','site_visit')),
    subject             VARCHAR(255) NOT NULL,
    description         TEXT,
    status              VARCHAR(20)  NOT NULL DEFAULT 'open' CHECK (status IN ('open','in_progress','completed','cancelled')),
    priority            VARCHAR(20)  NOT NULL DEFAULT 'normal' CHECK (priority IN ('low','normal','high')),
    scheduled_at        TIMESTAMPTZ,
    duration_minutes    SMALLINT,
    completed_at        TIMESTAMPTZ,
    outcome             TEXT,
    related_entity_type VARCHAR(50),
    related_entity_id   UUID,
    assigned_to         UUID         REFERENCES iam.users(user_id),
    lead_id             UUID         REFERENCES crm.leads(lead_id),
    opportunity_id      UUID         REFERENCES crm.opportunities(opportunity_id),
    contact_id          UUID         REFERENCES crm.contacts(contact_id),
    customer_id         UUID         REFERENCES sales.customers(customer_id),
    created_by          UUID         NOT NULL,
    updated_by          UUID         NOT NULL,
    deleted_by          UUID,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    deleted_at          TIMESTAMPTZ
);

-- Email/SMS/WhatsApp Campaigns
CREATE TABLE crm.campaigns (
    campaign_id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id           UUID         NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id           UUID         NOT NULL REFERENCES core.branches(branch_id),
    campaign_code       VARCHAR(50)  NOT NULL,
    campaign_name       VARCHAR(255) NOT NULL,
    campaign_type       VARCHAR(30)  NOT NULL CHECK (campaign_type IN ('email','sms','whatsapp','push','multi_channel')),
    status              VARCHAR(20)  NOT NULL DEFAULT 'draft' CHECK (status IN ('draft','scheduled','running','completed','cancelled','paused')),
    target_audience     JSONB,
    template_id         UUID,
    scheduled_at        TIMESTAMPTZ,
    started_at          TIMESTAMPTZ,
    completed_at        TIMESTAMPTZ,
    total_recipients    INTEGER      NOT NULL DEFAULT 0,
    sent_count          INTEGER      NOT NULL DEFAULT 0,
    delivered_count     INTEGER      NOT NULL DEFAULT 0,
    opened_count        INTEGER      NOT NULL DEFAULT 0,
    clicked_count       INTEGER      NOT NULL DEFAULT 0,
    bounced_count       INTEGER      NOT NULL DEFAULT 0,
    unsubscribed_count  INTEGER      NOT NULL DEFAULT 0,
    budget              NUMERIC(20,2) NOT NULL DEFAULT 0,
    actual_spend        NUMERIC(20,2) NOT NULL DEFAULT 0,
    created_by          UUID         NOT NULL,
    updated_by          UUID         NOT NULL,
    deleted_by          UUID,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    deleted_at          TIMESTAMPTZ,
    UNIQUE (tenant_id, campaign_code)
);

-- Cases / Support Tickets
CREATE TABLE crm.support_cases (
    support_case_id     UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id           UUID         NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id           UUID         NOT NULL REFERENCES core.branches(branch_id),
    case_number         VARCHAR(50)  NOT NULL,
    subject             VARCHAR(255) NOT NULL,
    description         TEXT,
    case_type           VARCHAR(50)  NOT NULL DEFAULT 'complaint' CHECK (case_type IN ('complaint','query','request','feedback','return','warranty')),
    priority            VARCHAR(20)  NOT NULL DEFAULT 'normal' CHECK (priority IN ('low','normal','high','urgent','critical')),
    status              VARCHAR(30)  NOT NULL DEFAULT 'open' CHECK (status IN ('open','assigned','in_progress','pending_customer','resolved','closed','escalated')),
    customer_id         UUID         NOT NULL REFERENCES sales.customers(customer_id),
    contact_id          UUID         REFERENCES crm.contacts(contact_id),
    assigned_to         UUID         REFERENCES iam.users(user_id),
    sla_policy_id       UUID,
    sla_due_at          TIMESTAMPTZ,
    first_response_at   TIMESTAMPTZ,
    resolved_at         TIMESTAMPTZ,
    closed_at           TIMESTAMPTZ,
    resolution_notes    TEXT,
    customer_satisfaction_score SMALLINT CHECK (customer_satisfaction_score BETWEEN 1 AND 5),
    source              VARCHAR(50)  CHECK (source IN ('email','phone','chat','portal','whatsapp','in_person')),
    created_by          UUID         NOT NULL,
    updated_by          UUID         NOT NULL,
    deleted_by          UUID,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    deleted_at          TIMESTAMPTZ,
    UNIQUE (tenant_id, branch_id, case_number)
);

-- Loyalty Programs
CREATE TABLE crm.loyalty_programs (
    loyalty_program_id  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id           UUID         NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id           UUID         NOT NULL REFERENCES core.branches(branch_id),
    program_code        VARCHAR(50)  NOT NULL,
    program_name        VARCHAR(255) NOT NULL,
    points_per_amount   NUMERIC(10,4) NOT NULL DEFAULT 1,
    points_redemption_value NUMERIC(10,4) NOT NULL DEFAULT 0.01,
    min_redemption_points INTEGER    NOT NULL DEFAULT 100,
    expiry_months       SMALLINT     NOT NULL DEFAULT 12,
    is_active           BOOLEAN      NOT NULL DEFAULT TRUE,
    created_by          UUID         NOT NULL,
    updated_by          UUID         NOT NULL,
    deleted_by          UUID,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    deleted_at          TIMESTAMPTZ,
    UNIQUE (tenant_id, program_code)
);

-- Customer Loyalty Balances
CREATE TABLE crm.customer_loyalty_balances (
    loyalty_balance_id  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id           UUID         NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id           UUID         NOT NULL REFERENCES core.branches(branch_id),
    customer_id         UUID         NOT NULL REFERENCES sales.customers(customer_id),
    loyalty_program_id  UUID         NOT NULL REFERENCES crm.loyalty_programs(loyalty_program_id),
    points_earned       NUMERIC(20,2) NOT NULL DEFAULT 0,
    points_redeemed     NUMERIC(20,2) NOT NULL DEFAULT 0,
    points_expired      NUMERIC(20,2) NOT NULL DEFAULT 0,
    points_balance      NUMERIC(20,2) GENERATED ALWAYS AS (points_earned - points_redeemed - points_expired) STORED,
    tier_name           VARCHAR(50)  NOT NULL DEFAULT 'standard',
    created_by          UUID         NOT NULL,
    updated_by          UUID         NOT NULL,
    deleted_by          UUID,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    deleted_at          TIMESTAMPTZ,
    UNIQUE (tenant_id, customer_id, loyalty_program_id)
);

-- NPS / CSAT Surveys
CREATE TABLE crm.survey_responses (
    survey_response_id  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id           UUID         NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id           UUID         NOT NULL REFERENCES core.branches(branch_id),
    survey_type         VARCHAR(20)  NOT NULL CHECK (survey_type IN ('nps','csat','ces','custom')),
    customer_id         UUID         REFERENCES sales.customers(customer_id),
    related_entity_type VARCHAR(100),
    related_entity_id   UUID,
    score               SMALLINT     NOT NULL,
    feedback_text       TEXT,
    responded_at        TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    channel             VARCHAR(50)  CHECK (channel IN ('email','sms','portal','app','in_person')),
    created_by          UUID         NOT NULL,
    updated_by          UUID         NOT NULL,
    deleted_by          UUID,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    deleted_at          TIMESTAMPTZ
);

-- Territory Management
CREATE TABLE crm.territories (
    territory_id        UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id           UUID         NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id           UUID         NOT NULL REFERENCES core.branches(branch_id),
    parent_territory_id UUID         REFERENCES crm.territories(territory_id),
    territory_code      VARCHAR(50)  NOT NULL,
    territory_name      VARCHAR(255) NOT NULL,
    territory_type      VARCHAR(30)  NOT NULL DEFAULT 'region' CHECK (territory_type IN ('country','region','state','district','zone','city')),
    assigned_to         UUID         REFERENCES iam.users(user_id),
    is_active           BOOLEAN      NOT NULL DEFAULT TRUE,
    created_by          UUID         NOT NULL,
    updated_by          UUID         NOT NULL,
    deleted_by          UUID,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    deleted_at          TIMESTAMPTZ,
    UNIQUE (tenant_id, territory_code)
);

-- =============================================================================
-- STEP 12: HR
-- =============================================================================

-- Departments
CREATE TABLE hr.departments (
    department_id       UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id           UUID         NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id           UUID         NOT NULL REFERENCES core.branches(branch_id),
    parent_department_id UUID        REFERENCES hr.departments(department_id),
    department_code     VARCHAR(50)  NOT NULL,
    department_name     VARCHAR(255) NOT NULL,
    cost_center_id      UUID         REFERENCES finance.cost_centers(cost_center_id),
    is_active           BOOLEAN      NOT NULL DEFAULT TRUE,
    created_by          UUID         NOT NULL,
    updated_by          UUID         NOT NULL,
    deleted_by          UUID,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    deleted_at          TIMESTAMPTZ,
    UNIQUE (tenant_id, department_code)
);

-- Designations / Positions
CREATE TABLE hr.designations (
    designation_id      UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id           UUID         NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id           UUID         NOT NULL REFERENCES core.branches(branch_id),
    designation_code    VARCHAR(50)  NOT NULL,
    designation_name    VARCHAR(255) NOT NULL,
    grade               VARCHAR(20),
    band                VARCHAR(20),
    department_id       UUID         REFERENCES hr.departments(department_id),
    is_active           BOOLEAN      NOT NULL DEFAULT TRUE,
    created_by          UUID         NOT NULL,
    updated_by          UUID         NOT NULL,
    deleted_by          UUID,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    deleted_at          TIMESTAMPTZ,
    UNIQUE (tenant_id, designation_code)
);

-- Employees
CREATE TABLE hr.employees (
    employee_id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id           UUID         NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id           UUID         NOT NULL REFERENCES core.branches(branch_id),
    employee_number     VARCHAR(50)  NOT NULL,
    first_name          VARCHAR(100) NOT NULL,
    middle_name         VARCHAR(100),
    last_name           VARCHAR(100) NOT NULL,
    date_of_birth       DATE,
    gender              VARCHAR(10)  CHECK (gender IN ('male','female','other','prefer_not_to_say')),
    blood_group         VARCHAR(5),
    personal_email      VARCHAR(255),
    work_email          VARCHAR(255),
    personal_phone      VARCHAR(30),
    work_phone          VARCHAR(30),
    emergency_contact_name  VARCHAR(200),
    emergency_contact_phone VARCHAR(30),
    marital_status      VARCHAR(20)  CHECK (marital_status IN ('single','married','divorced','widowed')),
    nationality         VARCHAR(100),
    pan_number          VARCHAR(20),
    aadhaar_number      VARCHAR(20),
    pf_number           VARCHAR(50),
    esi_number          VARCHAR(50),
    uan_number          VARCHAR(20),
    passport_number     VARCHAR(30),
    passport_expiry     DATE,
    department_id       UUID         REFERENCES hr.departments(department_id),
    designation_id      UUID         REFERENCES hr.designations(designation_id),
    reporting_to        UUID         REFERENCES hr.employees(employee_id),
    employment_type     VARCHAR(30)  NOT NULL DEFAULT 'permanent' CHECK (employment_type IN ('permanent','contract','probation','intern','temporary','consultant')),
    date_of_joining     DATE         NOT NULL,
    probation_end_date  DATE,
    confirmation_date   DATE,
    date_of_leaving     DATE,
    exit_reason         VARCHAR(100),
    work_location       VARCHAR(100),
    is_active           BOOLEAN      NOT NULL DEFAULT TRUE,
    photo_url           TEXT,
    user_id             UUID         REFERENCES iam.users(user_id),
    created_by          UUID         NOT NULL,
    updated_by          UUID         NOT NULL,
    deleted_by          UUID,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    deleted_at          TIMESTAMPTZ,
    UNIQUE (tenant_id, employee_number),
    UNIQUE (tenant_id, pan_number)
);

-- Employee Bank Accounts
CREATE TABLE hr.employee_bank_accounts (
    employee_bank_account_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id                UUID        NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id                UUID        NOT NULL REFERENCES core.branches(branch_id),
    employee_id              UUID        NOT NULL REFERENCES hr.employees(employee_id),
    bank_name                VARCHAR(255) NOT NULL,
    account_number           VARCHAR(100) NOT NULL,
    ifsc_code                VARCHAR(20) NOT NULL,
    account_type             VARCHAR(20) NOT NULL DEFAULT 'savings' CHECK (account_type IN ('savings','current')),
    is_primary               BOOLEAN     NOT NULL DEFAULT FALSE,
    is_verified              BOOLEAN     NOT NULL DEFAULT FALSE,
    created_by               UUID        NOT NULL,
    updated_by               UUID        NOT NULL,
    deleted_by               UUID,
    created_at               TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at               TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at               TIMESTAMPTZ,
    UNIQUE (tenant_id, employee_id, account_number)
);

-- Job Postings (ATS)
CREATE TABLE hr.job_postings (
    job_posting_id      UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id           UUID         NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id           UUID         NOT NULL REFERENCES core.branches(branch_id),
    job_code            VARCHAR(50)  NOT NULL,
    job_title           VARCHAR(255) NOT NULL,
    department_id       UUID         REFERENCES hr.departments(department_id),
    designation_id      UUID         REFERENCES hr.designations(designation_id),
    employment_type     VARCHAR(30)  NOT NULL DEFAULT 'permanent',
    positions_count     SMALLINT     NOT NULL DEFAULT 1,
    filled_count        SMALLINT     NOT NULL DEFAULT 0,
    location            VARCHAR(255),
    min_experience_years SMALLINT   NOT NULL DEFAULT 0,
    max_experience_years SMALLINT,
    min_ctc             NUMERIC(20,2),
    max_ctc             NUMERIC(20,2),
    job_description     TEXT,
    requirements        TEXT,
    status              VARCHAR(20)  NOT NULL DEFAULT 'draft' CHECK (status IN ('draft','published','on_hold','closed','cancelled')),
    published_at        TIMESTAMPTZ,
    closing_date        DATE,
    hiring_manager_id   UUID         REFERENCES hr.employees(employee_id),
    created_by          UUID         NOT NULL,
    updated_by          UUID         NOT NULL,
    deleted_by          UUID,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    deleted_at          TIMESTAMPTZ,
    UNIQUE (tenant_id, branch_id, job_code)
);

-- Job Applications
CREATE TABLE hr.job_applications (
    job_application_id  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id           UUID         NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id           UUID         NOT NULL REFERENCES core.branches(branch_id),
    application_number  VARCHAR(50)  NOT NULL,
    job_posting_id      UUID         NOT NULL REFERENCES hr.job_postings(job_posting_id),
    applicant_name      VARCHAR(255) NOT NULL,
    applicant_email     VARCHAR(255) NOT NULL,
    applicant_phone     VARCHAR(30),
    resume_url          TEXT,
    current_employer    VARCHAR(255),
    current_ctc         NUMERIC(20,2),
    expected_ctc        NUMERIC(20,2),
    notice_period_days  SMALLINT,
    source              VARCHAR(50)  CHECK (source IN ('portal','linkedin','referral','naukri','indeed','direct','consultancy','other')),
    referral_employee_id UUID        REFERENCES hr.employees(employee_id),
    stage               VARCHAR(30)  NOT NULL DEFAULT 'applied' CHECK (stage IN ('applied','screening','interview_1','interview_2','interview_3','technical','hr','offer','offered','joined','rejected','withdrawn')),
    rejection_reason    VARCHAR(255),
    offered_ctc         NUMERIC(20,2),
    expected_joining_date DATE,
    created_by          UUID         NOT NULL,
    updated_by          UUID         NOT NULL,
    deleted_by          UUID,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    deleted_at          TIMESTAMPTZ,
    UNIQUE (tenant_id, branch_id, application_number)
);

-- Performance Goals
CREATE TABLE hr.performance_goals (
    performance_goal_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id           UUID         NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id           UUID         NOT NULL REFERENCES core.branches(branch_id),
    employee_id         UUID         NOT NULL REFERENCES hr.employees(employee_id),
    goal_title          VARCHAR(255) NOT NULL,
    goal_description    TEXT,
    goal_type           VARCHAR(20)  NOT NULL DEFAULT 'kpi' CHECK (goal_type IN ('kpi','okr','behavioral','developmental')),
    fiscal_year_id      UUID         NOT NULL REFERENCES core.fiscal_years(fiscal_year_id),
    target_value        NUMERIC(20,4),
    actual_value        NUMERIC(20,4),
    weight_percentage   NUMERIC(8,4) NOT NULL DEFAULT 0,
    status              VARCHAR(20)  NOT NULL DEFAULT 'draft' CHECK (status IN ('draft','approved','in_progress','completed','cancelled')),
    created_by          UUID         NOT NULL,
    updated_by          UUID         NOT NULL,
    deleted_by          UUID,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    deleted_at          TIMESTAMPTZ
);

-- Performance Appraisals
CREATE TABLE hr.performance_appraisals (
    performance_appraisal_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id                UUID        NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id                UUID        NOT NULL REFERENCES core.branches(branch_id),
    employee_id              UUID        NOT NULL REFERENCES hr.employees(employee_id),
    appraiser_id             UUID        NOT NULL REFERENCES hr.employees(employee_id),
    fiscal_year_id           UUID        NOT NULL REFERENCES core.fiscal_years(fiscal_year_id),
    appraisal_type           VARCHAR(30) NOT NULL DEFAULT 'annual' CHECK (appraisal_type IN ('annual','mid_year','quarterly','probation','360')),
    self_rating              NUMERIC(4,2) CHECK (self_rating BETWEEN 0 AND 5),
    manager_rating           NUMERIC(4,2) CHECK (manager_rating BETWEEN 0 AND 5),
    final_rating             NUMERIC(4,2) CHECK (final_rating BETWEEN 0 AND 5),
    overall_comments         TEXT,
    status                   VARCHAR(20) NOT NULL DEFAULT 'pending' CHECK (status IN ('pending','self_review','manager_review','hr_review','completed','cancelled')),
    submitted_at             TIMESTAMPTZ,
    completed_at             TIMESTAMPTZ,
    created_by               UUID        NOT NULL,
    updated_by               UUID        NOT NULL,
    deleted_by               UUID,
    created_at               TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at               TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at               TIMESTAMPTZ,
    UNIQUE (tenant_id, employee_id, fiscal_year_id, appraisal_type)
);

-- Employee Documents
CREATE TABLE hr.employee_documents (
    employee_document_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id            UUID        NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id            UUID        NOT NULL REFERENCES core.branches(branch_id),
    employee_id          UUID        NOT NULL REFERENCES hr.employees(employee_id),
    document_type        VARCHAR(100) NOT NULL CHECK (document_type IN ('offer_letter','appointment_letter','id_proof','address_proof','educational_certificate','experience_letter','salary_slip','nda','pf_form','form_16','resignation','relieving_letter','other')),
    document_name        VARCHAR(255) NOT NULL,
    file_url             TEXT        NOT NULL,
    file_size_bytes      INTEGER,
    is_verified          BOOLEAN     NOT NULL DEFAULT FALSE,
    verified_by          UUID,
    verified_at          TIMESTAMPTZ,
    expiry_date          DATE,
    notes                TEXT,
    created_by           UUID        NOT NULL,
    updated_by           UUID        NOT NULL,
    deleted_by           UUID,
    created_at           TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at           TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at           TIMESTAMPTZ
);

-- =============================================================================
-- STEP 13: TIME & ATTENDANCE
-- =============================================================================

-- Shifts
CREATE TABLE attendance.shifts (
    shift_id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id           UUID         NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id           UUID         NOT NULL REFERENCES core.branches(branch_id),
    shift_code          VARCHAR(50)  NOT NULL,
    shift_name          VARCHAR(200) NOT NULL,
    shift_type          VARCHAR(20)  NOT NULL DEFAULT 'fixed' CHECK (shift_type IN ('fixed','flexible','rotational','night')),
    start_time          TIME         NOT NULL,
    end_time            TIME         NOT NULL,
    total_hours         NUMERIC(5,2) NOT NULL,
    break_duration_minutes SMALLINT  NOT NULL DEFAULT 0,
    is_overnight        BOOLEAN      NOT NULL DEFAULT FALSE,
    grace_period_minutes SMALLINT   NOT NULL DEFAULT 10,
    is_active           BOOLEAN      NOT NULL DEFAULT TRUE,
    created_by          UUID         NOT NULL,
    updated_by          UUID         NOT NULL,
    deleted_by          UUID,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    deleted_at          TIMESTAMPTZ,
    UNIQUE (tenant_id, shift_code)
);

-- Holiday Calendars
CREATE TABLE attendance.holiday_calendars (
    holiday_calendar_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id           UUID         NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id           UUID         NOT NULL REFERENCES core.branches(branch_id),
    calendar_name       VARCHAR(255) NOT NULL,
    country_code        VARCHAR(10)  NOT NULL DEFAULT 'IN',
    state_code          VARCHAR(20),
    fiscal_year_id      UUID         NOT NULL REFERENCES core.fiscal_years(fiscal_year_id),
    is_default          BOOLEAN      NOT NULL DEFAULT FALSE,
    created_by          UUID         NOT NULL,
    updated_by          UUID         NOT NULL,
    deleted_by          UUID,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    deleted_at          TIMESTAMPTZ
);

-- Holidays
CREATE TABLE attendance.holidays (
    holiday_id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id           UUID         NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id           UUID         NOT NULL REFERENCES core.branches(branch_id),
    holiday_calendar_id UUID         NOT NULL REFERENCES attendance.holiday_calendars(holiday_calendar_id),
    holiday_date        DATE         NOT NULL,
    holiday_name        VARCHAR(255) NOT NULL,
    holiday_type        VARCHAR(30)  NOT NULL DEFAULT 'national' CHECK (holiday_type IN ('national','state','optional','restricted','company')),
    is_optional         BOOLEAN      NOT NULL DEFAULT FALSE,
    created_by          UUID         NOT NULL,
    updated_by          UUID         NOT NULL,
    deleted_by          UUID,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    deleted_at          TIMESTAMPTZ,
    UNIQUE (tenant_id, holiday_calendar_id, holiday_date)
);

-- Leave Types
CREATE TABLE attendance.leave_types (
    leave_type_id       UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id           UUID         NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id           UUID         NOT NULL REFERENCES core.branches(branch_id),
    leave_code          VARCHAR(20)  NOT NULL,
    leave_name          VARCHAR(200) NOT NULL,
    is_paid             BOOLEAN      NOT NULL DEFAULT TRUE,
    accrual_frequency   VARCHAR(20)  NOT NULL DEFAULT 'yearly' CHECK (accrual_frequency IN ('yearly','monthly','quarterly','on_join')),
    accrual_days        NUMERIC(5,2) NOT NULL DEFAULT 0,
    max_carry_forward   NUMERIC(5,2) NOT NULL DEFAULT 0,
    max_encashment_days NUMERIC(5,2) NOT NULL DEFAULT 0,
    requires_approval   BOOLEAN      NOT NULL DEFAULT TRUE,
    min_notice_days     SMALLINT     NOT NULL DEFAULT 0,
    is_active           BOOLEAN      NOT NULL DEFAULT TRUE,
    created_by          UUID         NOT NULL,
    updated_by          UUID         NOT NULL,
    deleted_by          UUID,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    deleted_at          TIMESTAMPTZ,
    UNIQUE (tenant_id, leave_code)
);

-- Leave Balances
CREATE TABLE attendance.leave_balances (
    leave_balance_id    UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id           UUID         NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id           UUID         NOT NULL REFERENCES core.branches(branch_id),
    employee_id         UUID         NOT NULL REFERENCES hr.employees(employee_id),
    leave_type_id       UUID         NOT NULL REFERENCES attendance.leave_types(leave_type_id),
    fiscal_year_id      UUID         NOT NULL REFERENCES core.fiscal_years(fiscal_year_id),
    opening_balance     NUMERIC(7,2) NOT NULL DEFAULT 0,
    accrued             NUMERIC(7,2) NOT NULL DEFAULT 0,
    taken               NUMERIC(7,2) NOT NULL DEFAULT 0,
    adjusted            NUMERIC(7,2) NOT NULL DEFAULT 0,
    carried_forward     NUMERIC(7,2) NOT NULL DEFAULT 0,
    balance             NUMERIC(7,2) GENERATED ALWAYS AS (opening_balance + accrued + adjusted + carried_forward - taken) STORED,
    created_by          UUID         NOT NULL,
    updated_by          UUID         NOT NULL,
    deleted_by          UUID,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    deleted_at          TIMESTAMPTZ,
    UNIQUE (tenant_id, employee_id, leave_type_id, fiscal_year_id)
);

-- Leave Applications
CREATE TABLE attendance.leave_applications (
    leave_application_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id            UUID        NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id            UUID        NOT NULL REFERENCES core.branches(branch_id),
    application_number   VARCHAR(50) NOT NULL,
    employee_id          UUID        NOT NULL REFERENCES hr.employees(employee_id),
    leave_type_id        UUID        NOT NULL REFERENCES attendance.leave_types(leave_type_id),
    from_date            DATE        NOT NULL,
    to_date              DATE        NOT NULL,
    number_of_days       NUMERIC(5,2) NOT NULL,
    reason               TEXT,
    status               VARCHAR(20) NOT NULL DEFAULT 'pending' CHECK (status IN ('pending','approved','rejected','cancelled','withdrawn')),
    applied_at           TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    reviewed_by          UUID        REFERENCES iam.users(user_id),
    reviewed_at          TIMESTAMPTZ,
    rejection_reason     TEXT,
    created_by           UUID        NOT NULL,
    updated_by           UUID        NOT NULL,
    deleted_by           UUID,
    created_at           TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at           TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at           TIMESTAMPTZ,
    UNIQUE (tenant_id, branch_id, application_number)
);

-- Attendance Records
CREATE TABLE attendance.attendance_records (
    attendance_record_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id            UUID        NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id            UUID        NOT NULL REFERENCES core.branches(branch_id),
    employee_id          UUID        NOT NULL REFERENCES hr.employees(employee_id),
    attendance_date      DATE        NOT NULL,
    shift_id             UUID        REFERENCES attendance.shifts(shift_id),
    planned_in_time      TIME,
    planned_out_time     TIME,
    actual_in_time       TIMESTAMPTZ,
    actual_out_time      TIMESTAMPTZ,
    punch_source         VARCHAR(20) NOT NULL DEFAULT 'manual' CHECK (punch_source IN ('biometric','geo','web','mobile','manual','rfid')),
    working_hours        NUMERIC(5,2) NOT NULL DEFAULT 0,
    overtime_hours       NUMERIC(5,2) NOT NULL DEFAULT 0,
    late_by_minutes      SMALLINT    NOT NULL DEFAULT 0,
    early_exit_minutes   SMALLINT    NOT NULL DEFAULT 0,
    status               VARCHAR(20) NOT NULL DEFAULT 'present' CHECK (status IN ('present','absent','half_day','week_off','holiday','leave','on_duty','work_from_home')),
    is_regularized       BOOLEAN     NOT NULL DEFAULT FALSE,
    regularization_reason TEXT,
    regularized_by       UUID        REFERENCES iam.users(user_id),
    created_by           UUID        NOT NULL,
    updated_by           UUID        NOT NULL,
    deleted_by           UUID,
    created_at           TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at           TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at           TIMESTAMPTZ,
    UNIQUE (tenant_id, employee_id, attendance_date)
) PARTITION BY RANGE (attendance_date);

CREATE TABLE attendance.attendance_records_2026 PARTITION OF attendance.attendance_records
    FOR VALUES FROM ('2026-01-01') TO ('2027-01-01');
CREATE TABLE attendance.attendance_records_2025 PARTITION OF attendance.attendance_records
    FOR VALUES FROM ('2025-01-01') TO ('2026-01-01');

-- Timesheets
CREATE TABLE attendance.timesheets (
    timesheet_id        UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id           UUID         NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id           UUID         NOT NULL REFERENCES core.branches(branch_id),
    employee_id         UUID         NOT NULL REFERENCES hr.employees(employee_id),
    fiscal_year_id      UUID         NOT NULL REFERENCES core.fiscal_years(fiscal_year_id),
    week_start_date     DATE         NOT NULL,
    week_end_date       DATE         NOT NULL,
    total_hours         NUMERIC(7,2) NOT NULL DEFAULT 0,
    billable_hours      NUMERIC(7,2) NOT NULL DEFAULT 0,
    status              VARCHAR(20)  NOT NULL DEFAULT 'draft' CHECK (status IN ('draft','submitted','approved','rejected')),
    submitted_at        TIMESTAMPTZ,
    approved_by         UUID         REFERENCES iam.users(user_id),
    approved_at         TIMESTAMPTZ,
    created_by          UUID         NOT NULL,
    updated_by          UUID         NOT NULL,
    deleted_by          UUID,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    deleted_at          TIMESTAMPTZ,
    UNIQUE (tenant_id, employee_id, week_start_date)
);

-- =============================================================================
-- STEP 14: PAYROLL
-- =============================================================================

-- Salary Components
CREATE TABLE payroll.salary_components (
    salary_component_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id           UUID         NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id           UUID         NOT NULL REFERENCES core.branches(branch_id),
    component_code      VARCHAR(50)  NOT NULL,
    component_name      VARCHAR(200) NOT NULL,
    component_type      VARCHAR(20)  NOT NULL CHECK (component_type IN ('earning','deduction','statutory')),
    sub_type            VARCHAR(50),
    is_taxable          BOOLEAN      NOT NULL DEFAULT TRUE,
    is_pf_applicable    BOOLEAN      NOT NULL DEFAULT FALSE,
    is_esi_applicable   BOOLEAN      NOT NULL DEFAULT FALSE,
    is_fixed            BOOLEAN      NOT NULL DEFAULT TRUE,
    calculation_type    VARCHAR(30)  NOT NULL DEFAULT 'fixed' CHECK (calculation_type IN ('fixed','percentage_of_basic','percentage_of_ctc','formula')),
    calculation_value   NUMERIC(20,4) NOT NULL DEFAULT 0,
    formula_expression  TEXT,
    gl_account_id       UUID         REFERENCES finance.chart_of_accounts(account_id),
    is_active           BOOLEAN      NOT NULL DEFAULT TRUE,
    created_by          UUID         NOT NULL,
    updated_by          UUID         NOT NULL,
    deleted_by          UUID,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    deleted_at          TIMESTAMPTZ,
    UNIQUE (tenant_id, component_code)
);

-- Salary Structures
CREATE TABLE payroll.salary_structures (
    salary_structure_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id           UUID         NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id           UUID         NOT NULL REFERENCES core.branches(branch_id),
    structure_code      VARCHAR(50)  NOT NULL,
    structure_name      VARCHAR(200) NOT NULL,
    payroll_frequency   VARCHAR(20)  NOT NULL DEFAULT 'monthly' CHECK (payroll_frequency IN ('monthly','weekly','bi_weekly','daily')),
    currency_code       VARCHAR(10)  NOT NULL DEFAULT 'INR',
    is_active           BOOLEAN      NOT NULL DEFAULT TRUE,
    created_by          UUID         NOT NULL,
    updated_by          UUID         NOT NULL,
    deleted_by          UUID,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    deleted_at          TIMESTAMPTZ,
    UNIQUE (tenant_id, structure_code)
);

-- Salary Structure Components
CREATE TABLE payroll.salary_structure_components (
    ss_component_id     UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id           UUID         NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id           UUID         NOT NULL REFERENCES core.branches(branch_id),
    salary_structure_id UUID         NOT NULL REFERENCES payroll.salary_structures(salary_structure_id),
    salary_component_id UUID         NOT NULL REFERENCES payroll.salary_components(salary_component_id),
    calculation_type    VARCHAR(30)  NOT NULL DEFAULT 'fixed',
    amount_or_rate      NUMERIC(20,4) NOT NULL DEFAULT 0,
    sequence_number     SMALLINT     NOT NULL DEFAULT 1,
    created_by          UUID         NOT NULL,
    updated_by          UUID         NOT NULL,
    deleted_by          UUID,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    deleted_at          TIMESTAMPTZ,
    UNIQUE (tenant_id, salary_structure_id, salary_component_id)
);

-- Employee Salary Assignments
CREATE TABLE payroll.employee_salary_assignments (
    salary_assignment_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id            UUID        NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id            UUID        NOT NULL REFERENCES core.branches(branch_id),
    employee_id          UUID        NOT NULL REFERENCES hr.employees(employee_id),
    salary_structure_id  UUID        NOT NULL REFERENCES payroll.salary_structures(salary_structure_id),
    effective_from       DATE        NOT NULL,
    effective_until      DATE,
    ctc_amount           NUMERIC(20,2) NOT NULL,
    basic_amount         NUMERIC(20,2) NOT NULL,
    is_active            BOOLEAN     NOT NULL DEFAULT TRUE,
    created_by           UUID        NOT NULL,
    updated_by           UUID        NOT NULL,
    deleted_by           UUID,
    created_at           TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at           TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at           TIMESTAMPTZ
);

-- Payroll Runs
CREATE TABLE payroll.payroll_runs (
    payroll_run_id      UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id           UUID         NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id           UUID         NOT NULL REFERENCES core.branches(branch_id),
    run_number          VARCHAR(50)  NOT NULL,
    payroll_month       SMALLINT     NOT NULL CHECK (payroll_month BETWEEN 1 AND 12),
    payroll_year        SMALLINT     NOT NULL,
    fiscal_year_id      UUID         NOT NULL REFERENCES core.fiscal_years(fiscal_year_id),
    financial_period_id UUID         NOT NULL REFERENCES core.financial_periods(financial_period_id),
    payment_date        DATE         NOT NULL,
    total_employees     INTEGER      NOT NULL DEFAULT 0,
    total_gross         NUMERIC(20,2) NOT NULL DEFAULT 0,
    total_deductions    NUMERIC(20,2) NOT NULL DEFAULT 0,
    total_net           NUMERIC(20,2) NOT NULL DEFAULT 0,
    total_employer_pf   NUMERIC(20,2) NOT NULL DEFAULT 0,
    total_employer_esi  NUMERIC(20,2) NOT NULL DEFAULT 0,
    status              VARCHAR(20)  NOT NULL DEFAULT 'draft' CHECK (status IN ('draft','processing','processed','approved','paid','cancelled')),
    processed_at        TIMESTAMPTZ,
    approved_at         TIMESTAMPTZ,
    approved_by         UUID,
    journal_entry_id    UUID         REFERENCES finance.journal_entries(journal_entry_id),
    created_by          UUID         NOT NULL,
    updated_by          UUID         NOT NULL,
    deleted_by          UUID,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    deleted_at          TIMESTAMPTZ,
    UNIQUE (tenant_id, branch_id, run_number),
    UNIQUE (tenant_id, branch_id, payroll_month, payroll_year)
);

-- Payslips
CREATE TABLE payroll.payslips (
    payslip_id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id           UUID         NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id           UUID         NOT NULL REFERENCES core.branches(branch_id),
    payroll_run_id      UUID         NOT NULL REFERENCES payroll.payroll_runs(payroll_run_id),
    employee_id         UUID         NOT NULL REFERENCES hr.employees(employee_id),
    payslip_number      VARCHAR(50)  NOT NULL,
    payroll_month       SMALLINT     NOT NULL,
    payroll_year        SMALLINT     NOT NULL,
    working_days        SMALLINT     NOT NULL DEFAULT 0,
    paid_days           NUMERIC(5,2) NOT NULL DEFAULT 0,
    present_days        NUMERIC(5,2) NOT NULL DEFAULT 0,
    absent_days         NUMERIC(5,2) NOT NULL DEFAULT 0,
    lop_days            NUMERIC(5,2) NOT NULL DEFAULT 0,
    gross_salary        NUMERIC(20,2) NOT NULL DEFAULT 0,
    total_deductions    NUMERIC(20,2) NOT NULL DEFAULT 0,
    net_salary          NUMERIC(20,2) NOT NULL DEFAULT 0,
    employee_pf         NUMERIC(20,2) NOT NULL DEFAULT 0,
    employer_pf         NUMERIC(20,2) NOT NULL DEFAULT 0,
    employee_esi        NUMERIC(20,2) NOT NULL DEFAULT 0,
    employer_esi        NUMERIC(20,2) NOT NULL DEFAULT 0,
    professional_tax    NUMERIC(20,2) NOT NULL DEFAULT 0,
    tds_amount          NUMERIC(20,2) NOT NULL DEFAULT 0,
    loan_deduction      NUMERIC(20,2) NOT NULL DEFAULT 0,
    bank_account_id     UUID         REFERENCES hr.employee_bank_accounts(employee_bank_account_id),
    payment_mode        VARCHAR(20)  NOT NULL DEFAULT 'bank_transfer' CHECK (payment_mode IN ('bank_transfer','cash','cheque')),
    payment_status      VARCHAR(20)  NOT NULL DEFAULT 'pending' CHECK (payment_status IN ('pending','paid','failed','hold')),
    paid_at             TIMESTAMPTZ,
    utr_number          VARCHAR(100),
    created_by          UUID         NOT NULL,
    updated_by          UUID         NOT NULL,
    deleted_by          UUID,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    deleted_at          TIMESTAMPTZ,
    UNIQUE (tenant_id, branch_id, payslip_number),
    UNIQUE (tenant_id, payroll_run_id, employee_id)
);

-- Payslip Line Items
CREATE TABLE payroll.payslip_line_items (
    payslip_line_id     UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id           UUID         NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id           UUID         NOT NULL REFERENCES core.branches(branch_id),
    payslip_id          UUID         NOT NULL REFERENCES payroll.payslips(payslip_id),
    salary_component_id UUID         NOT NULL REFERENCES payroll.salary_components(salary_component_id),
    component_type      VARCHAR(20)  NOT NULL,
    amount              NUMERIC(20,2) NOT NULL DEFAULT 0,
    created_by          UUID         NOT NULL,
    updated_by          UUID         NOT NULL,
    deleted_by          UUID,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    deleted_at          TIMESTAMPTZ
);

-- Employee Loans
CREATE TABLE payroll.employee_loans (
    employee_loan_id    UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id           UUID         NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id           UUID         NOT NULL REFERENCES core.branches(branch_id),
    loan_number         VARCHAR(50)  NOT NULL,
    employee_id         UUID         NOT NULL REFERENCES hr.employees(employee_id),
    loan_type           VARCHAR(50)  NOT NULL CHECK (loan_type IN ('salary_advance','personal_loan','vehicle_loan','housing_loan','other')),
    loan_amount         NUMERIC(20,2) NOT NULL CHECK (loan_amount > 0),
    outstanding_amount  NUMERIC(20,2) NOT NULL,
    emi_amount          NUMERIC(20,2) NOT NULL,
    tenure_months       SMALLINT     NOT NULL,
    disbursed_at        DATE,
    first_emi_date      DATE,
    status              VARCHAR(20)  NOT NULL DEFAULT 'applied' CHECK (status IN ('applied','approved','disbursed','active','closed','cancelled')),
    approved_by         UUID         REFERENCES iam.users(user_id),
    journal_entry_id    UUID         REFERENCES finance.journal_entries(journal_entry_id),
    created_by          UUID         NOT NULL,
    updated_by          UUID         NOT NULL,
    deleted_by          UUID,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    deleted_at          TIMESTAMPTZ,
    UNIQUE (tenant_id, branch_id, loan_number)
);

-- =============================================================================
-- INDEXES — CRM, HR, Attendance, Payroll
-- =============================================================================

CREATE INDEX idx_leads_assigned ON crm.leads(tenant_id, assigned_to) WHERE deleted_at IS NULL;
CREATE INDEX idx_leads_status ON crm.leads(tenant_id, lead_status) WHERE deleted_at IS NULL;
CREATE INDEX idx_opportunities_stage ON crm.opportunities(tenant_id, stage) WHERE deleted_at IS NULL;
CREATE INDEX idx_opportunities_close ON crm.opportunities(tenant_id, expected_close_date) WHERE deleted_at IS NULL;
CREATE INDEX idx_cases_status ON crm.support_cases(tenant_id, status) WHERE deleted_at IS NULL;
CREATE INDEX idx_cases_sla ON crm.support_cases(tenant_id, sla_due_at) WHERE status NOT IN ('resolved','closed');
CREATE INDEX idx_employees_dept ON hr.employees(tenant_id, department_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_employees_active ON hr.employees(tenant_id, is_active) WHERE deleted_at IS NULL;
CREATE INDEX idx_leave_apps_emp ON attendance.leave_applications(tenant_id, employee_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_leave_apps_status ON attendance.leave_applications(tenant_id, status) WHERE deleted_at IS NULL;
CREATE INDEX idx_attendance_emp_date ON attendance.attendance_records(employee_id, attendance_date);
CREATE INDEX idx_payroll_runs_period ON payroll.payroll_runs(tenant_id, payroll_year, payroll_month) WHERE deleted_at IS NULL;
CREATE INDEX idx_payslips_emp ON payroll.payslips(tenant_id, employee_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_payslips_run ON payroll.payslips(payroll_run_id) WHERE deleted_at IS NULL;

-- =============================================================================
-- MINIMAL DUMMY DATA — HR, Attendance, Payroll
-- =============================================================================

DO $$
DECLARE
    v_tenant_id   UUID := 'a0000000-0000-0000-0000-000000000001';
    v_branch_id   UUID := 'b0000000-0000-0000-0000-000000000001';
    v_system_user UUID := '00000000-0000-0000-0000-000000000001';
    v_dept_id     UUID := gen_random_uuid();
BEGIN
    INSERT INTO hr.departments (department_id, tenant_id, branch_id, department_code, department_name, created_by, updated_by)
    VALUES
        (v_dept_id, v_tenant_id, v_branch_id, 'MGMT', 'Management',          v_system_user, v_system_user),
        (gen_random_uuid(), v_tenant_id, v_branch_id, 'HR',   'Human Resources',     v_system_user, v_system_user),
        (gen_random_uuid(), v_tenant_id, v_branch_id, 'FIN',  'Finance & Accounts',  v_system_user, v_system_user),
        (gen_random_uuid(), v_tenant_id, v_branch_id, 'SALE', 'Sales',               v_system_user, v_system_user),
        (gen_random_uuid(), v_tenant_id, v_branch_id, 'OPS',  'Operations',          v_system_user, v_system_user),
        (gen_random_uuid(), v_tenant_id, v_branch_id, 'IT',   'Information Technology', v_system_user, v_system_user)
    ON CONFLICT DO NOTHING;

    INSERT INTO attendance.leave_types (tenant_id, branch_id, leave_code, leave_name, is_paid, accrual_frequency, accrual_days, max_carry_forward, created_by, updated_by)
    VALUES
        (v_tenant_id, v_branch_id, 'CL',  'Casual Leave',      TRUE,  'yearly',  12, 0,  v_system_user, v_system_user),
        (v_tenant_id, v_branch_id, 'SL',  'Sick Leave',        TRUE,  'yearly',  12, 0,  v_system_user, v_system_user),
        (v_tenant_id, v_branch_id, 'PL',  'Privilege Leave',   TRUE,  'yearly',  18, 30, v_system_user, v_system_user),
        (v_tenant_id, v_branch_id, 'ML',  'Maternity Leave',   TRUE,  'on_join', 182, 0, v_system_user, v_system_user),
        (v_tenant_id, v_branch_id, 'COP', 'Compensatory Off',  TRUE,  'monthly', 0,  5,  v_system_user, v_system_user),
        (v_tenant_id, v_branch_id, 'LWP', 'Leave Without Pay', FALSE, 'on_join', 0,  0,  v_system_user, v_system_user)
    ON CONFLICT DO NOTHING;

    INSERT INTO payroll.salary_components (tenant_id, branch_id, component_code, component_name, component_type, is_taxable, is_pf_applicable, calculation_type, created_by, updated_by)
    VALUES
        (v_tenant_id, v_branch_id, 'BASIC',   'Basic Salary',          'earning',   TRUE,  TRUE,  'percentage_of_ctc', v_system_user, v_system_user),
        (v_tenant_id, v_branch_id, 'HRA',     'House Rent Allowance',  'earning',   FALSE, FALSE, 'percentage_of_basic', v_system_user, v_system_user),
        (v_tenant_id, v_branch_id, 'SPEC',    'Special Allowance',     'earning',   TRUE,  FALSE, 'fixed', v_system_user, v_system_user),
        (v_tenant_id, v_branch_id, 'TRAVEL',  'Travel Allowance',      'earning',   FALSE, FALSE, 'fixed', v_system_user, v_system_user),
        (v_tenant_id, v_branch_id, 'EMP_PF',  'Employee PF',           'deduction', FALSE, FALSE, 'percentage_of_basic', v_system_user, v_system_user),
        (v_tenant_id, v_branch_id, 'EMP_ESI', 'Employee ESI',          'deduction', FALSE, FALSE, 'percentage_of_basic', v_system_user, v_system_user),
        (v_tenant_id, v_branch_id, 'PT',      'Professional Tax',      'statutory', FALSE, FALSE, 'fixed', v_system_user, v_system_user),
        (v_tenant_id, v_branch_id, 'TDS',     'TDS on Salary',         'deduction', FALSE, FALSE, 'formula', v_system_user, v_system_user)
    ON CONFLICT DO NOTHING;

    INSERT INTO attendance.shifts (tenant_id, branch_id, shift_code, shift_name, shift_type, start_time, end_time, total_hours, break_duration_minutes, created_by, updated_by)
    VALUES
        (v_tenant_id, v_branch_id, 'GEN',   'General Shift',  'fixed',     '09:00', '18:00', 9,   60, v_system_user, v_system_user),
        (v_tenant_id, v_branch_id, 'MORN',  'Morning Shift',  'rotational','06:00', '14:00', 8,   30, v_system_user, v_system_user),
        (v_tenant_id, v_branch_id, 'EVE',   'Evening Shift',  'rotational','14:00', '22:00', 8,   30, v_system_user, v_system_user),
        (v_tenant_id, v_branch_id, 'NIGHT', 'Night Shift',    'night',     '22:00', '06:00', 8,   30, v_system_user, v_system_user)
    ON CONFLICT DO NOTHING;
END $$;
