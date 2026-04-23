-- =====================================================================
-- STEP 12: HR
-- =====================================================================

CREATE TABLE hr.department (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    company_id      UUID NOT NULL REFERENCES core.company(id),
    parent_id       UUID REFERENCES hr.department(id),
    code            TEXT NOT NULL,
    name            TEXT NOT NULL,
    head_employee_id UUID,
    cost_center_id  UUID REFERENCES finance.cost_center(id),
    is_active       BOOLEAN DEFAULT TRUE,
    UNIQUE (company_id, code)
);

CREATE TABLE hr.designation (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    code            TEXT NOT NULL,
    name            TEXT NOT NULL,
    UNIQUE (tenant_id, code)
);

CREATE TABLE hr.grade (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    code            TEXT NOT NULL,
    name            TEXT NOT NULL,
    band            TEXT,
    min_salary      core.money_amt,
    max_salary      core.money_amt,
    sequence_no     INT,
    UNIQUE (tenant_id, code)
);

CREATE TABLE hr.position (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    company_id      UUID NOT NULL,
    code            TEXT NOT NULL,
    name            TEXT NOT NULL,
    designation_id  UUID REFERENCES hr.designation(id),
    department_id   UUID REFERENCES hr.department(id),
    grade_id        UUID REFERENCES hr.grade(id),
    reports_to_position_id UUID REFERENCES hr.position(id),
    headcount_budgeted INT DEFAULT 1,
    is_active       BOOLEAN DEFAULT TRUE,
    UNIQUE (company_id, code)
);

CREATE TABLE hr.employee (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL REFERENCES core.tenant(id) ON DELETE CASCADE,
    company_id      UUID NOT NULL REFERENCES core.company(id),
    branch_id       UUID REFERENCES core.branch(id),
    employee_no     TEXT NOT NULL,
    user_id         UUID REFERENCES iam.user(id),
    first_name      TEXT NOT NULL,
    middle_name     TEXT,
    last_name       TEXT NOT NULL,
    full_name       TEXT GENERATED ALWAYS AS (TRIM(coalesce(first_name,'')||' '||coalesce(middle_name,'')||' '||coalesce(last_name,''))) STORED,
    preferred_name  TEXT,
    gender          core.gender,
    date_of_birth   DATE,
    marital_status  TEXT,
    blood_group     TEXT,
    nationality     TEXT,
    personal_email  core.email_t,
    work_email      core.email_t,
    personal_mobile core.phone_t,
    work_mobile     core.phone_t,
    emergency_contact JSONB,
    permanent_address JSONB,
    current_address JSONB,
    photo_url       TEXT,
    department_id   UUID REFERENCES hr.department(id),
    designation_id  UUID REFERENCES hr.designation(id),
    grade_id        UUID REFERENCES hr.grade(id),
    position_id     UUID REFERENCES hr.position(id),
    reports_to_id   UUID REFERENCES hr.employee(id),
    employment_type TEXT CHECK (employment_type IN ('permanent','contract','intern','consultant','trainee','part_time')),
    employment_status TEXT DEFAULT 'active'
        CHECK (employment_status IN ('active','on_leave','notice_period','terminated','resigned','retired','deceased','absconded')),
    joining_date    DATE NOT NULL,
    confirmation_date DATE,
    probation_end_date DATE,
    notice_period_days INT,
    last_working_day DATE,
    retirement_date DATE,
    pan_no          TEXT,
    aadhaar_no      TEXT,
    passport_no     TEXT,
    uan_no          TEXT,                         -- UAN for PF
    pf_no           TEXT,
    esi_no          TEXT,
    bank_details    JSONB,
    attributes      JSONB DEFAULT '{}'::jsonb,
    tags            TEXT[],
    created_at      TIMESTAMPTZ DEFAULT NOW(),
    updated_at      TIMESTAMPTZ DEFAULT NOW(),
    deleted_at      TIMESTAMPTZ,
    UNIQUE (company_id, employee_no)
);

CREATE TABLE hr.employee_history (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    employee_id     UUID NOT NULL REFERENCES hr.employee(id) ON DELETE CASCADE,
    change_type     TEXT NOT NULL,                -- join/transfer/promotion/grade_change/salary_change/exit
    effective_date  DATE NOT NULL,
    old_value       JSONB,
    new_value       JSONB,
    reason          TEXT,
    approved_by     UUID,
    created_at      TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE hr.skill (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    code            TEXT NOT NULL,
    name            TEXT NOT NULL,
    category        TEXT,
    UNIQUE (tenant_id, code)
);

CREATE TABLE hr.employee_skill (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    employee_id     UUID NOT NULL REFERENCES hr.employee(id) ON DELETE CASCADE,
    skill_id        UUID NOT NULL REFERENCES hr.skill(id),
    proficiency     TEXT CHECK (proficiency IN ('beginner','intermediate','advanced','expert')),
    years_experience NUMERIC(4,1),
    last_used_date  DATE,
    UNIQUE (employee_id, skill_id)
);

-- Recruitment
CREATE TABLE hr.job_requisition (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    company_id      UUID NOT NULL,
    doc_no          TEXT NOT NULL,
    position_id     UUID REFERENCES hr.position(id),
    department_id   UUID REFERENCES hr.department(id),
    vacancies       INT DEFAULT 1,
    status          TEXT DEFAULT 'open' CHECK (status IN ('open','approved','on_hold','filled','cancelled')),
    opening_date    DATE,
    target_hire_date DATE,
    budget_per_month core.money_amt,
    hiring_manager_id UUID REFERENCES hr.employee(id),
    UNIQUE (company_id, doc_no)
);

CREATE TABLE hr.candidate (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    first_name      TEXT,
    last_name       TEXT,
    email           core.email_t,
    phone           core.phone_t,
    resume_doc_id   UUID,
    current_company TEXT,
    current_ctc     core.money_amt,
    expected_ctc    core.money_amt,
    notice_days     INT,
    source          TEXT,
    attributes      JSONB,
    created_at      TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE hr.application (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    requisition_id  UUID NOT NULL REFERENCES hr.job_requisition(id),
    candidate_id    UUID NOT NULL REFERENCES hr.candidate(id),
    applied_at      TIMESTAMPTZ DEFAULT NOW(),
    stage           TEXT DEFAULT 'applied' CHECK (stage IN ('applied','screening','shortlisted','interview','assessment','offered','accepted','rejected','withdrawn','hired')),
    rating          NUMERIC(3,1),
    recruiter_id    UUID REFERENCES hr.employee(id),
    offer_ctc       core.money_amt,
    joined_employee_id UUID REFERENCES hr.employee(id),
    UNIQUE (requisition_id, candidate_id)
);

CREATE TABLE hr.interview (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    application_id  UUID NOT NULL REFERENCES hr.application(id) ON DELETE CASCADE,
    round_no        INT NOT NULL,
    interviewer_ids UUID[] NOT NULL,
    scheduled_at    TIMESTAMPTZ,
    mode            TEXT CHECK (mode IN ('in_person','phone','video')),
    feedback        TEXT,
    rating          NUMERIC(3,1),
    recommendation  TEXT CHECK (recommendation IN ('strong_hire','hire','maybe','no_hire','strong_no_hire')),
    status          TEXT DEFAULT 'scheduled'
);

-- Onboarding / offboarding
CREATE TABLE hr.onboarding_task (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    employee_id     UUID NOT NULL REFERENCES hr.employee(id) ON DELETE CASCADE,
    task_name       TEXT NOT NULL,
    owner_user_id   UUID,
    due_date        DATE,
    status          TEXT DEFAULT 'pending' CHECK (status IN ('pending','in_progress','completed','skipped')),
    completed_at    TIMESTAMPTZ
);

CREATE TABLE hr.exit (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    employee_id     UUID NOT NULL REFERENCES hr.employee(id) ON DELETE CASCADE,
    resignation_date DATE NOT NULL,
    last_working_day DATE,
    exit_type       TEXT CHECK (exit_type IN ('resignation','termination','retirement','abscond','death','contract_end')),
    reason          TEXT,
    rehire_eligible BOOLEAN,
    exit_interview  JSONB,
    fnf_status      TEXT DEFAULT 'pending',
    fnf_amount      core.money_amt,
    status          TEXT DEFAULT 'initiated' CHECK (status IN ('initiated','in_progress','cleared','settled','closed')),
    created_at      TIMESTAMPTZ DEFAULT NOW()
);

-- Performance
CREATE TABLE hr.goal (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    employee_id     UUID NOT NULL REFERENCES hr.employee(id),
    parent_goal_id  UUID REFERENCES hr.goal(id),
    period          TEXT,                         -- Q1-2026
    title           TEXT NOT NULL,
    description     TEXT,
    weight_pct      NUMERIC(5,2),
    target          NUMERIC,
    actual          NUMERIC,
    uom             TEXT,
    goal_type       TEXT CHECK (goal_type IN ('kpi','okr','mbo','project')),
    status          TEXT DEFAULT 'draft',
    score           NUMERIC(5,2)
);

CREATE TABLE hr.appraisal_cycle (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    company_id      UUID NOT NULL,
    name            TEXT NOT NULL,
    period_start    DATE NOT NULL,
    period_end      DATE NOT NULL,
    review_start    DATE,
    review_end      DATE,
    status          TEXT DEFAULT 'planned'
);

CREATE TABLE hr.appraisal (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    cycle_id        UUID NOT NULL REFERENCES hr.appraisal_cycle(id),
    employee_id     UUID NOT NULL REFERENCES hr.employee(id),
    manager_id      UUID REFERENCES hr.employee(id),
    self_rating     NUMERIC(3,2),
    manager_rating  NUMERIC(3,2),
    final_rating    NUMERIC(3,2),
    increment_pct   NUMERIC(5,2),
    bonus           core.money_amt,
    promotion_to_grade_id UUID,
    comments        TEXT,
    status          TEXT DEFAULT 'draft' CHECK (status IN ('draft','self_review','manager_review','hr_review','calibration','shared','accepted','closed')),
    UNIQUE (cycle_id, employee_id)
);

CREATE TABLE hr.appraisal_360 (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    appraisal_id    UUID NOT NULL REFERENCES hr.appraisal(id) ON DELETE CASCADE,
    reviewer_id     UUID REFERENCES hr.employee(id),
    relation        TEXT CHECK (relation IN ('peer','subordinate','manager','cross_functional','customer','self')),
    feedback        JSONB,
    submitted_at    TIMESTAMPTZ
);

-- Training
CREATE TABLE hr.training_course (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    code            TEXT NOT NULL,
    name            TEXT NOT NULL,
    description     TEXT,
    duration_hours  NUMERIC(6,2),
    delivery        TEXT CHECK (delivery IN ('online','classroom','hybrid','elearning')),
    provider        TEXT,
    UNIQUE (tenant_id, code)
);

CREATE TABLE hr.training_enrollment (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    course_id       UUID NOT NULL REFERENCES hr.training_course(id),
    employee_id     UUID NOT NULL REFERENCES hr.employee(id),
    enrollment_date DATE,
    completion_date DATE,
    score           NUMERIC(5,2),
    status          TEXT DEFAULT 'enrolled' CHECK (status IN ('enrolled','in_progress','completed','failed','cancelled')),
    certificate_url TEXT
);

CREATE TABLE hr.certification (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    employee_id     UUID NOT NULL REFERENCES hr.employee(id) ON DELETE CASCADE,
    name            TEXT NOT NULL,
    issuer          TEXT,
    issued_date     DATE,
    expiry_date     DATE,
    certificate_no  TEXT,
    document_id     UUID
);

CREATE TABLE hr.succession_plan (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    position_id     UUID NOT NULL REFERENCES hr.position(id),
    successor_employee_id UUID NOT NULL REFERENCES hr.employee(id),
    readiness       TEXT CHECK (readiness IN ('now','1_year','2_3_years','5_years')),
    notes           TEXT
);

CREATE TABLE hr.disciplinary_action (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    employee_id     UUID NOT NULL REFERENCES hr.employee(id),
    incident_date   DATE NOT NULL,
    action_type     TEXT CHECK (action_type IN ('verbal_warning','written_warning','suspension','pip','termination')),
    reason          TEXT NOT NULL,
    issued_by       UUID,
    document_id     UUID,
    resolved_at     DATE
);

CREATE TABLE hr.employee_document (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    employee_id     UUID NOT NULL REFERENCES hr.employee(id) ON DELETE CASCADE,
    doc_type        TEXT NOT NULL,                -- pan/aadhaar/passport/offer/relieving/...
    document_id     UUID,
    expiry_date     DATE,
    verified        BOOLEAN DEFAULT FALSE
);

CREATE TABLE hr.benefit (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    code            TEXT NOT NULL,
    name            TEXT NOT NULL,
    benefit_type    TEXT CHECK (benefit_type IN ('health_insurance','life_insurance','retirement','meal','transport','gym','other')),
    UNIQUE (tenant_id, code)
);

CREATE TABLE hr.employee_benefit (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    employee_id     UUID NOT NULL REFERENCES hr.employee(id) ON DELETE CASCADE,
    benefit_id      UUID NOT NULL REFERENCES hr.benefit(id),
    start_date      DATE,
    end_date        DATE,
    employer_share  core.money_amt,
    employee_share  core.money_amt,
    policy_no       TEXT
);

-- =====================================================================
-- INDEXES
-- =====================================================================
CREATE INDEX idx_employee_company       ON hr.employee(company_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_employee_dept          ON hr.employee(department_id);
CREATE INDEX idx_employee_reports_to    ON hr.employee(reports_to_id);
CREATE INDEX idx_employee_status        ON hr.employee(employment_status) WHERE deleted_at IS NULL;
CREATE INDEX idx_employee_name_trgm     ON hr.employee USING gin (full_name gin_trgm_ops);
CREATE INDEX idx_employee_user          ON hr.employee(user_id);
CREATE INDEX idx_application_req        ON hr.application(requisition_id, stage);
CREATE INDEX idx_goal_employee          ON hr.goal(employee_id, period);
CREATE INDEX idx_appraisal_cycle        ON hr.appraisal(cycle_id, employee_id);
CREATE INDEX idx_training_enroll_emp    ON hr.training_enrollment(employee_id);
CREATE INDEX idx_cert_expiry            ON hr.certification(expiry_date) WHERE expiry_date IS NOT NULL;

-- =====================================================================
-- FUNCTIONS
-- =====================================================================

-- Organizational hierarchy
CREATE OR REPLACE FUNCTION hr.fn_org_chart(p_root_employee UUID)
RETURNS TABLE (employee_id UUID, name TEXT, level INT, path TEXT[]) AS $$
WITH RECURSIVE h AS (
    SELECT id, full_name, 1 AS level, ARRAY[employee_no]::text[] AS path
      FROM hr.employee WHERE id = p_root_employee AND deleted_at IS NULL
    UNION ALL
    SELECT e.id, e.full_name, h.level+1, h.path || e.employee_no
      FROM hr.employee e JOIN h ON e.reports_to_id = h.id
     WHERE e.deleted_at IS NULL
)
SELECT * FROM h;
$$ LANGUAGE sql;

-- Headcount utilization
CREATE OR REPLACE FUNCTION hr.fn_headcount(p_department UUID, p_as_of DATE DEFAULT CURRENT_DATE)
RETURNS INT AS $$
    SELECT COUNT(*)::int FROM hr.employee
     WHERE department_id = p_department AND employment_status IN ('active','on_leave','notice_period')
       AND joining_date <= p_as_of AND (last_working_day IS NULL OR last_working_day >= p_as_of);
$$ LANGUAGE sql STABLE;

-- Exit: trigger FNF
CREATE OR REPLACE FUNCTION hr.fn_initiate_exit(p_employee UUID, p_reason TEXT, p_resign_date DATE)
RETURNS UUID AS $$
DECLARE v_exit UUID;
BEGIN
    INSERT INTO hr.exit(employee_id, resignation_date, exit_type, reason, status)
    VALUES (p_employee, p_resign_date, 'resignation', p_reason, 'initiated')
    RETURNING id INTO v_exit;
    UPDATE hr.employee SET employment_status = 'notice_period' WHERE id = p_employee;
    RETURN v_exit;
END; $$ LANGUAGE plpgsql;

-- =====================================================================
-- VIEWS
-- =====================================================================
CREATE OR REPLACE VIEW hr.v_active_employees AS
SELECT e.id, e.employee_no, e.full_name, d.name AS department, des.name AS designation,
       g.name AS grade, e.joining_date,
       EXTRACT(YEAR FROM age(e.joining_date)) AS tenure_years
  FROM hr.employee e
  LEFT JOIN hr.department d ON d.id = e.department_id
  LEFT JOIN hr.designation des ON des.id = e.designation_id
  LEFT JOIN hr.grade g ON g.id = e.grade_id
 WHERE e.employment_status = 'active' AND e.deleted_at IS NULL;

CREATE OR REPLACE VIEW hr.v_birthdays_this_month AS
SELECT id, full_name, personal_mobile, work_email, date_of_birth
  FROM hr.employee
 WHERE employment_status='active'
   AND EXTRACT(MONTH FROM date_of_birth) = EXTRACT(MONTH FROM CURRENT_DATE);

CREATE OR REPLACE VIEW hr.v_headcount_by_dept AS
SELECT d.id AS dept_id, d.name,
       COUNT(e.id) FILTER (WHERE e.employment_status='active') AS active,
       COUNT(e.id) FILTER (WHERE e.employment_status='notice_period') AS notice,
       COUNT(e.id) FILTER (WHERE e.employment_status='on_leave') AS on_leave
  FROM hr.department d LEFT JOIN hr.employee e ON e.department_id = d.id AND e.deleted_at IS NULL
 GROUP BY d.id, d.name;

-- =====================================================================
-- TRIGGERS
-- =====================================================================
CREATE TRIGGER trg_employee_updated BEFORE UPDATE ON hr.employee
    FOR EACH ROW EXECUTE FUNCTION core.fn_set_updated_at();
CREATE TRIGGER trg_employee_audit AFTER INSERT OR UPDATE OR DELETE ON hr.employee
    FOR EACH ROW EXECUTE FUNCTION audit.fn_row_audit();

-- Track employee changes into history
CREATE OR REPLACE FUNCTION hr.fn_employee_history() RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'UPDATE' THEN
        IF NEW.department_id IS DISTINCT FROM OLD.department_id THEN
            INSERT INTO hr.employee_history(employee_id, change_type, effective_date, old_value, new_value)
            VALUES (NEW.id,'transfer',CURRENT_DATE, jsonb_build_object('department_id',OLD.department_id), jsonb_build_object('department_id',NEW.department_id));
        END IF;
        IF NEW.grade_id IS DISTINCT FROM OLD.grade_id THEN
            INSERT INTO hr.employee_history(employee_id, change_type, effective_date, old_value, new_value)
            VALUES (NEW.id,'grade_change',CURRENT_DATE, jsonb_build_object('grade_id',OLD.grade_id), jsonb_build_object('grade_id',NEW.grade_id));
        END IF;
    END IF;
    RETURN NEW;
END; $$ LANGUAGE plpgsql;
CREATE TRIGGER trg_employee_history AFTER UPDATE ON hr.employee
    FOR EACH ROW EXECUTE FUNCTION hr.fn_employee_history();
