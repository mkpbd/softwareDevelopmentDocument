-- =====================================================================
-- Module 12: HR (Employee master, Org structure, Recruitment, Onboarding,
-- Performance, Training, Benefits, Documents)
-- =====================================================================

SET search_path = app, core, public;

-- =============== SCHEMA ===============

CREATE TABLE IF NOT EXISTS app.departments (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  company_id      uuid NOT NULL REFERENCES app.companies(id),
  parent_id       uuid REFERENCES app.departments(id),
  code            citext NOT NULL,
  name            text NOT NULL,
  manager_id      uuid,
  cost_center_id  uuid REFERENCES app.cost_centers(id),
  active          boolean NOT NULL DEFAULT true,
  created_at      timestamptz NOT NULL DEFAULT now(),
  updated_at      timestamptz NOT NULL DEFAULT now(),
  created_by      uuid, updated_by uuid, version int NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, company_id, code)
);

CREATE TABLE IF NOT EXISTS app.grades (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  code            citext NOT NULL,
  name            text NOT NULL,
  level_no        smallint NOT NULL,
  min_ctc         numeric(19,4),
  max_ctc         numeric(19,4),
  active          boolean NOT NULL DEFAULT true,
  created_at      timestamptz NOT NULL DEFAULT now(),
  updated_at      timestamptz NOT NULL DEFAULT now(),
  created_by      uuid, updated_by uuid, version int NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, code)
);

CREATE TABLE IF NOT EXISTS app.positions (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  company_id      uuid NOT NULL REFERENCES app.companies(id),
  department_id   uuid REFERENCES app.departments(id),
  grade_id        uuid REFERENCES app.grades(id),
  code            citext NOT NULL,
  title           text NOT NULL,
  description     text,
  headcount_budget int NOT NULL DEFAULT 1,
  active          boolean NOT NULL DEFAULT true,
  created_at      timestamptz NOT NULL DEFAULT now(),
  updated_at      timestamptz NOT NULL DEFAULT now(),
  created_by      uuid, updated_by uuid, version int NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, company_id, code)
);

CREATE TABLE IF NOT EXISTS app.employees (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  company_id      uuid NOT NULL REFERENCES app.companies(id),
  employee_code   citext NOT NULL,
  first_name      text NOT NULL,
  middle_name     text,
  last_name       text,
  full_name       text GENERATED ALWAYS AS (
                    trim(COALESCE(first_name,'')||' '||COALESCE(middle_name,'')||' '||COALESCE(last_name,''))
                  ) STORED,
  gender          text CHECK (gender IN ('M','F','O','U')),
  dob             date,
  personal_email  citext,
  work_email      citext,
  personal_phone  text,
  work_phone      text,
  marital_status  text CHECK (marital_status IN (NULL,'single','married','divorced','widowed')),
  blood_group     text,
  nationality     text DEFAULT 'IN',
  date_of_joining date NOT NULL,
  probation_end_date date,
  confirmation_date date,
  date_of_leaving date,
  department_id   uuid REFERENCES app.departments(id),
  position_id     uuid REFERENCES app.positions(id),
  grade_id        uuid REFERENCES app.grades(id),
  branch_id       uuid REFERENCES app.branches(id),
  manager_id      uuid REFERENCES app.employees(id),
  employment_type text NOT NULL DEFAULT 'permanent'
                  CHECK (employment_type IN ('permanent','contract','intern','consultant','temporary','apprentice')),
  work_location   text,
  status          text NOT NULL DEFAULT 'active'
                  CHECK (status IN ('active','on_leave','notice_period','exited','terminated','suspended')),
  user_id         uuid REFERENCES app.users(id),
  pan             text,
  aadhaar_last4   text,
  uan             text,
  pf_number       text,
  esi_number      text,
  bank_account_number_masked text,
  bank_ifsc       text,
  bank_name       text,
  emergency_contact jsonb,
  address         jsonb,
  metadata        jsonb NOT NULL DEFAULT '{}'::jsonb,
  created_at      timestamptz NOT NULL DEFAULT now(),
  updated_at      timestamptz NOT NULL DEFAULT now(),
  created_by      uuid, updated_by uuid, version int NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, company_id, employee_code),
  UNIQUE (tenant_id, work_email)
);

ALTER TABLE app.departments ADD CONSTRAINT fk_dept_manager
  FOREIGN KEY (manager_id) REFERENCES app.employees(id);

CREATE TABLE IF NOT EXISTS app.employee_documents (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  employee_id     uuid NOT NULL REFERENCES app.employees(id) ON DELETE CASCADE,
  doc_type        text NOT NULL,                   -- 'pan','aadhaar','offer_letter','contract',...
  document_id     uuid REFERENCES app.documents(id),
  issue_date      date, expiry_date date,
  verified        boolean NOT NULL DEFAULT false,
  verified_by     uuid, verified_at timestamptz,
  notes           text,
  created_at      timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS app.skills (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  code            citext NOT NULL,
  name            text NOT NULL,
  category        text,
  active          boolean NOT NULL DEFAULT true,
  UNIQUE (tenant_id, code)
);

CREATE TABLE IF NOT EXISTS app.employee_skills (
  tenant_id       uuid NOT NULL,
  employee_id     uuid NOT NULL REFERENCES app.employees(id) ON DELETE CASCADE,
  skill_id        uuid NOT NULL REFERENCES app.skills(id),
  proficiency     smallint NOT NULL CHECK (proficiency BETWEEN 1 AND 5),
  years_experience numeric(4,1),
  certified       boolean NOT NULL DEFAULT false,
  created_at      timestamptz NOT NULL DEFAULT now(),
  PRIMARY KEY (employee_id, skill_id)
);

CREATE TABLE IF NOT EXISTS app.job_requisitions (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  company_id      uuid NOT NULL REFERENCES app.companies(id),
  req_number      text NOT NULL,
  position_id     uuid REFERENCES app.positions(id),
  department_id   uuid REFERENCES app.departments(id),
  openings        int NOT NULL DEFAULT 1,
  urgency         text CHECK (urgency IN (NULL,'low','normal','high','critical')),
  description     text,
  requirements    text,
  status          text NOT NULL DEFAULT 'draft'
                  CHECK (status IN ('draft','open','on_hold','filled','cancelled','closed')),
  opened_at       timestamptz, closed_at timestamptz,
  hiring_manager_id uuid REFERENCES app.employees(id),
  recruiter_id    uuid REFERENCES app.employees(id),
  created_at      timestamptz NOT NULL DEFAULT now(),
  updated_at      timestamptz NOT NULL DEFAULT now(),
  created_by      uuid, updated_by uuid, version int NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, company_id, req_number)
);

CREATE TABLE IF NOT EXISTS app.candidates (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  first_name      text, last_name text,
  email           citext, phone text,
  current_company text, current_ctc numeric(19,4), expected_ctc numeric(19,4),
  notice_period_days int,
  source          text,
  resume_document_id uuid REFERENCES app.documents(id),
  status          text NOT NULL DEFAULT 'new'
                  CHECK (status IN ('new','screening','shortlisted','rejected','hired','dropped','on_hold')),
  created_at      timestamptz NOT NULL DEFAULT now(),
  updated_at      timestamptz NOT NULL DEFAULT now(),
  created_by      uuid, updated_by uuid, version int NOT NULL DEFAULT 1
);

CREATE TABLE IF NOT EXISTS app.applications (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  requisition_id  uuid NOT NULL REFERENCES app.job_requisitions(id) ON DELETE CASCADE,
  candidate_id    uuid NOT NULL REFERENCES app.candidates(id) ON DELETE CASCADE,
  stage           text NOT NULL DEFAULT 'applied'
                  CHECK (stage IN ('applied','screening','interview','offer','hired','rejected','withdrawn')),
  rating          smallint CHECK (rating IS NULL OR rating BETWEEN 1 AND 5),
  applied_at      timestamptz NOT NULL DEFAULT now(),
  offered_at      timestamptz,
  offer_ctc       numeric(19,4),
  UNIQUE (requisition_id, candidate_id)
);

CREATE TABLE IF NOT EXISTS app.interviews (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  application_id  uuid NOT NULL REFERENCES app.applications(id) ON DELETE CASCADE,
  round_no        smallint NOT NULL,
  interviewer_id  uuid REFERENCES app.employees(id),
  scheduled_at    timestamptz NOT NULL,
  mode            text CHECK (mode IN ('in_person','phone','video','panel','assessment')),
  status          text NOT NULL DEFAULT 'scheduled'
                  CHECK (status IN ('scheduled','completed','cancelled','rescheduled','no_show')),
  rating          smallint,
  feedback        text,
  recommendation  text CHECK (recommendation IN (NULL,'strong_yes','yes','neutral','no','strong_no')),
  UNIQUE (application_id, round_no)
);

CREATE TABLE IF NOT EXISTS app.onboarding_tasks (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  employee_id     uuid NOT NULL REFERENCES app.employees(id) ON DELETE CASCADE,
  task_name       text NOT NULL,
  owner_id        uuid REFERENCES app.employees(id),
  due_date        date,
  completed_at    timestamptz,
  status          text NOT NULL DEFAULT 'pending' CHECK (status IN ('pending','in_progress','completed','skipped'))
);

CREATE TABLE IF NOT EXISTS app.offboarding (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  employee_id     uuid NOT NULL REFERENCES app.employees(id) ON DELETE CASCADE,
  resignation_date date NOT NULL,
  notice_served_date date,
  last_working_date date,
  reason          text,
  rehire_eligible boolean,
  exit_interview_notes text,
  fnf_settled_at  timestamptz,
  fnf_amount      numeric(19,4),
  status          text NOT NULL DEFAULT 'in_progress'
                  CHECK (status IN ('in_progress','fnf_pending','completed','cancelled')),
  created_at      timestamptz NOT NULL DEFAULT now(),
  updated_at      timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS app.performance_cycles (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  code            citext NOT NULL,
  name            text NOT NULL,
  period_start    date NOT NULL,
  period_end      date NOT NULL,
  status          text NOT NULL DEFAULT 'draft'
                  CHECK (status IN ('draft','active','self_review','manager_review','calibration','completed')),
  UNIQUE (tenant_id, code)
);

CREATE TABLE IF NOT EXISTS app.performance_reviews (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  cycle_id        uuid NOT NULL REFERENCES app.performance_cycles(id),
  employee_id     uuid NOT NULL REFERENCES app.employees(id),
  reviewer_id     uuid REFERENCES app.employees(id),
  self_rating     numeric(3,2),
  manager_rating  numeric(3,2),
  final_rating    numeric(3,2),
  comments        text,
  status          text NOT NULL DEFAULT 'pending'
                  CHECK (status IN ('pending','self_submitted','manager_submitted','finalized','acknowledged')),
  UNIQUE (cycle_id, employee_id)
);

CREATE TABLE IF NOT EXISTS app.goals (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  employee_id     uuid NOT NULL REFERENCES app.employees(id) ON DELETE CASCADE,
  cycle_id        uuid REFERENCES app.performance_cycles(id),
  goal_type       text NOT NULL DEFAULT 'okr' CHECK (goal_type IN ('okr','kpi','smart','project')),
  title           text NOT NULL,
  description     text,
  target          text,
  weight_pct      numeric(5,2) CHECK (weight_pct BETWEEN 0 AND 100),
  progress_pct    numeric(5,2) NOT NULL DEFAULT 0,
  status          text NOT NULL DEFAULT 'draft'
                  CHECK (status IN ('draft','active','at_risk','on_track','achieved','missed','cancelled')),
  due_date        date,
  created_at      timestamptz NOT NULL DEFAULT now(),
  updated_at      timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS app.training_programs (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  code            citext NOT NULL,
  name            text NOT NULL,
  category        text,
  delivery_mode   text CHECK (delivery_mode IN ('classroom','online','blended','on_job')),
  duration_hours  numeric(6,1),
  provider        text,
  active          boolean NOT NULL DEFAULT true,
  UNIQUE (tenant_id, code)
);

CREATE TABLE IF NOT EXISTS app.training_enrollments (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  program_id      uuid NOT NULL REFERENCES app.training_programs(id),
  employee_id     uuid NOT NULL REFERENCES app.employees(id) ON DELETE CASCADE,
  enrolled_at     timestamptz NOT NULL DEFAULT now(),
  completed_at    timestamptz,
  score           numeric(5,2),
  status          text NOT NULL DEFAULT 'enrolled'
                  CHECK (status IN ('enrolled','in_progress','completed','failed','dropped'))
);

CREATE TABLE IF NOT EXISTS app.certifications (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  employee_id     uuid NOT NULL REFERENCES app.employees(id) ON DELETE CASCADE,
  name            text NOT NULL,
  issuer          text,
  issued_on       date,
  expires_on      date,
  document_id     uuid REFERENCES app.documents(id),
  created_at      timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS app.disciplinary_actions (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  employee_id     uuid NOT NULL REFERENCES app.employees(id) ON DELETE CASCADE,
  action_date     date NOT NULL,
  action_type     text NOT NULL CHECK (action_type IN ('verbal_warning','written_warning','suspension','pip','termination','other')),
  reason          text NOT NULL,
  taken_by        uuid REFERENCES app.employees(id),
  notes           text,
  created_at      timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS app.employee_benefits (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  employee_id     uuid NOT NULL REFERENCES app.employees(id) ON DELETE CASCADE,
  benefit_type    text NOT NULL,
  start_date      date NOT NULL,
  end_date        date,
  employer_amount numeric(19,4),
  employee_amount numeric(19,4),
  metadata        jsonb
);

CREATE TABLE IF NOT EXISTS app.employee_transitions (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  employee_id     uuid NOT NULL REFERENCES app.employees(id) ON DELETE CASCADE,
  transition_type text NOT NULL CHECK (transition_type IN ('promotion','transfer','grade_change','dept_change','manager_change','compensation_change')),
  effective_date  date NOT NULL,
  old_value       jsonb,
  new_value       jsonb,
  reason          text,
  approved_by     uuid,
  created_at      timestamptz NOT NULL DEFAULT now()
);

-- =============== INDEXES ===============
CREATE INDEX IF NOT EXISTS idx_dept_parent       ON app.departments(parent_id);
CREATE INDEX IF NOT EXISTS idx_positions_dept    ON app.positions(department_id) WHERE active;
CREATE INDEX IF NOT EXISTS idx_emp_status        ON app.employees(tenant_id, status);
CREATE INDEX IF NOT EXISTS idx_emp_manager       ON app.employees(manager_id);
CREATE INDEX IF NOT EXISTS idx_emp_dept          ON app.employees(department_id) WHERE status='active';
CREATE INDEX IF NOT EXISTS idx_emp_user          ON app.employees(user_id) WHERE user_id IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_emp_name_trgm     ON app.employees USING gin (full_name gin_trgm_ops);
CREATE INDEX IF NOT EXISTS idx_emp_doj           ON app.employees(date_of_joining);
CREATE INDEX IF NOT EXISTS idx_empdoc_emp        ON app.employee_documents(employee_id);
CREATE INDEX IF NOT EXISTS idx_empskill_skill    ON app.employee_skills(skill_id);
CREATE INDEX IF NOT EXISTS idx_req_status        ON app.job_requisitions(tenant_id, status);
CREATE INDEX IF NOT EXISTS idx_cand_email        ON app.candidates(tenant_id, email);
CREATE INDEX IF NOT EXISTS idx_app_req_stage     ON app.applications(requisition_id, stage);
CREATE INDEX IF NOT EXISTS idx_interview_app     ON app.interviews(application_id);
CREATE INDEX IF NOT EXISTS idx_obt_emp_status    ON app.onboarding_tasks(employee_id, status);
CREATE INDEX IF NOT EXISTS idx_off_emp           ON app.offboarding(employee_id);
CREATE INDEX IF NOT EXISTS idx_goals_emp         ON app.goals(employee_id, status);
CREATE INDEX IF NOT EXISTS idx_rev_cycle_emp     ON app.performance_reviews(cycle_id, employee_id);
CREATE INDEX IF NOT EXISTS idx_trainenr_emp      ON app.training_enrollments(employee_id, status);
CREATE INDEX IF NOT EXISTS idx_cert_expiry       ON app.certifications(expires_on) WHERE expires_on IS NOT NULL;

-- =============== RLS + TRIGGERS ===============
SELECT core.enable_tenant_rls('app.departments');
SELECT core.enable_tenant_rls('app.grades');
SELECT core.enable_tenant_rls('app.positions');
SELECT core.enable_tenant_rls('app.employees');
SELECT core.enable_tenant_rls('app.employee_documents');
SELECT core.enable_tenant_rls('app.skills');
SELECT core.enable_tenant_rls('app.employee_skills');
SELECT core.enable_tenant_rls('app.job_requisitions');
SELECT core.enable_tenant_rls('app.candidates');
SELECT core.enable_tenant_rls('app.applications');
SELECT core.enable_tenant_rls('app.interviews');
SELECT core.enable_tenant_rls('app.onboarding_tasks');
SELECT core.enable_tenant_rls('app.offboarding');
SELECT core.enable_tenant_rls('app.performance_cycles');
SELECT core.enable_tenant_rls('app.performance_reviews');
SELECT core.enable_tenant_rls('app.goals');
SELECT core.enable_tenant_rls('app.training_programs');
SELECT core.enable_tenant_rls('app.training_enrollments');
SELECT core.enable_tenant_rls('app.certifications');
SELECT core.enable_tenant_rls('app.disciplinary_actions');
SELECT core.enable_tenant_rls('app.employee_benefits');
SELECT core.enable_tenant_rls('app.employee_transitions');

SELECT core.attach_standard_triggers('app.departments');
SELECT core.attach_standard_triggers('app.grades');
SELECT core.attach_standard_triggers('app.positions');
SELECT core.attach_standard_triggers('app.employees');
SELECT core.attach_standard_triggers('app.job_requisitions');
SELECT core.attach_standard_triggers('app.candidates');
SELECT core.attach_standard_triggers('app.offboarding');
SELECT core.attach_standard_triggers('app.performance_reviews');
SELECT core.attach_standard_triggers('app.goals');

-- =============== FUNCTIONS / VIEWS ===============

-- Reporting tree (subordinates transitively)
CREATE OR REPLACE FUNCTION app.subordinates(p_manager_id uuid)
RETURNS TABLE(employee_id uuid, depth int)
LANGUAGE sql STABLE AS $$
  WITH RECURSIVE tree AS (
    SELECT id AS employee_id, 1 AS depth
      FROM app.employees WHERE manager_id = p_manager_id AND status='active'
    UNION ALL
    SELECT e.id, t.depth + 1
      FROM app.employees e JOIN tree t ON e.manager_id = t.employee_id
     WHERE e.status='active' AND t.depth < 12
  )
  SELECT * FROM tree
$$;

CREATE OR REPLACE VIEW app.v_headcount AS
SELECT e.tenant_id, e.company_id, d.name AS department, e.employment_type,
       COUNT(*) AS headcount
  FROM app.employees e
  LEFT JOIN app.departments d ON d.id = e.department_id
 WHERE e.status = 'active'
 GROUP BY e.tenant_id, e.company_id, d.name, e.employment_type;

CREATE OR REPLACE VIEW app.v_recruitment_funnel AS
SELECT r.tenant_id, r.id req_id, r.req_number,
       COUNT(a.*) FILTER (WHERE a.stage='applied')    applied,
       COUNT(a.*) FILTER (WHERE a.stage='screening')  screening,
       COUNT(a.*) FILTER (WHERE a.stage='interview')  interviewing,
       COUNT(a.*) FILTER (WHERE a.stage='offer')      offered,
       COUNT(a.*) FILTER (WHERE a.stage='hired')      hired,
       COUNT(a.*) FILTER (WHERE a.stage='rejected')   rejected
  FROM app.job_requisitions r
  LEFT JOIN app.applications a ON a.requisition_id = r.id
 GROUP BY r.tenant_id, r.id, r.req_number;
