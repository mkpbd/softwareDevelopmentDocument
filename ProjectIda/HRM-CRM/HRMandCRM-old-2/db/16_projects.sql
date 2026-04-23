-- =====================================================================
-- Module 16: Project Management
-- Projects, tasks, milestones, resources, budgeting, billing, WIP
-- =====================================================================

SET search_path = app, core, public;

-- =============== SCHEMA ===============

CREATE TABLE IF NOT EXISTS app.projects (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  company_id      uuid NOT NULL REFERENCES app.companies(id),
  project_code    citext NOT NULL,
  name            text NOT NULL,
  description     text,
  customer_id     uuid REFERENCES app.customers(id),
  project_type    text NOT NULL DEFAULT 'external'
                  CHECK (project_type IN ('internal','external','capex','r_and_d')),
  billing_type    text CHECK (billing_type IN (NULL,'time_material','fixed_price','milestone','retainer','none')),
  manager_id      uuid REFERENCES app.employees(id),
  start_date      date,
  end_date        date,
  actual_start    date, actual_end date,
  budget_amount   numeric(19,4) NOT NULL DEFAULT 0,
  budget_hours    numeric(10,2) NOT NULL DEFAULT 0,
  currency_code   char(3) NOT NULL DEFAULT 'INR',
  status          text NOT NULL DEFAULT 'planning'
                  CHECK (status IN ('planning','active','on_hold','completed','cancelled','closed')),
  progress_pct    numeric(5,2) NOT NULL DEFAULT 0,
  cost_center_id  uuid REFERENCES app.cost_centers(id),
  metadata        jsonb NOT NULL DEFAULT '{}'::jsonb,
  created_at      timestamptz NOT NULL DEFAULT now(),
  updated_at      timestamptz NOT NULL DEFAULT now(),
  created_by      uuid, updated_by uuid, version int NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, company_id, project_code)
);

CREATE TABLE IF NOT EXISTS app.milestones (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  project_id      uuid NOT NULL REFERENCES app.projects(id) ON DELETE CASCADE,
  seq_no          smallint NOT NULL,
  name            text NOT NULL,
  due_date        date,
  billing_amount  numeric(19,4),
  billed          boolean NOT NULL DEFAULT false,
  completed_at    timestamptz,
  status          text NOT NULL DEFAULT 'pending'
                  CHECK (status IN ('pending','in_progress','completed','missed','cancelled')),
  UNIQUE (project_id, seq_no)
);

CREATE TABLE IF NOT EXISTS app.tasks (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  project_id      uuid NOT NULL REFERENCES app.projects(id) ON DELETE CASCADE,
  parent_id       uuid REFERENCES app.tasks(id),
  code            text,
  name            text NOT NULL,
  description     text,
  assignee_id     uuid REFERENCES app.employees(id),
  start_date      date, end_date date,
  estimated_hours numeric(10,2),
  actual_hours    numeric(10,2) NOT NULL DEFAULT 0,
  priority        text NOT NULL DEFAULT 'normal' CHECK (priority IN ('low','normal','high','urgent')),
  status          text NOT NULL DEFAULT 'todo'
                  CHECK (status IN ('todo','in_progress','review','blocked','done','cancelled')),
  progress_pct    numeric(5,2) NOT NULL DEFAULT 0,
  depends_on      uuid[] NOT NULL DEFAULT '{}',
  tags            text[] NOT NULL DEFAULT '{}',
  created_at      timestamptz NOT NULL DEFAULT now(),
  updated_at      timestamptz NOT NULL DEFAULT now(),
  created_by      uuid, updated_by uuid, version int NOT NULL DEFAULT 1
);

CREATE TABLE IF NOT EXISTS app.project_resources (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  project_id      uuid NOT NULL REFERENCES app.projects(id) ON DELETE CASCADE,
  employee_id     uuid NOT NULL REFERENCES app.employees(id),
  role            text,
  allocation_pct  numeric(5,2) NOT NULL DEFAULT 100,
  bill_rate       numeric(19,4),
  cost_rate       numeric(19,4),
  start_date      date NOT NULL,
  end_date        date,
  UNIQUE (project_id, employee_id, start_date)
);

CREATE TABLE IF NOT EXISTS app.project_billing_events (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  project_id      uuid NOT NULL REFERENCES app.projects(id) ON DELETE CASCADE,
  milestone_id    uuid REFERENCES app.milestones(id),
  event_date      date NOT NULL,
  amount          numeric(19,4) NOT NULL,
  description     text,
  sales_invoice_id uuid REFERENCES app.sales_invoices(id),
  status          text NOT NULL DEFAULT 'pending'
                  CHECK (status IN ('pending','invoiced','paid','cancelled'))
);

CREATE TABLE IF NOT EXISTS app.project_wip (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  project_id      uuid NOT NULL REFERENCES app.projects(id) ON DELETE CASCADE,
  as_of_date      date NOT NULL,
  revenue_earned  numeric(19,4) NOT NULL DEFAULT 0,
  revenue_billed  numeric(19,4) NOT NULL DEFAULT 0,
  wip_amount      numeric(19,4) NOT NULL DEFAULT 0,
  unearned_revenue numeric(19,4) NOT NULL DEFAULT 0,
  costs_incurred  numeric(19,4) NOT NULL DEFAULT 0,
  UNIQUE (project_id, as_of_date)
);

CREATE TABLE IF NOT EXISTS app.project_issues (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  project_id      uuid NOT NULL REFERENCES app.projects(id) ON DELETE CASCADE,
  title           text NOT NULL,
  description     text,
  severity        text NOT NULL DEFAULT 'medium' CHECK (severity IN ('low','medium','high','critical')),
  status          text NOT NULL DEFAULT 'open'
                  CHECK (status IN ('open','in_progress','resolved','closed','wont_fix')),
  assigned_to     uuid REFERENCES app.employees(id),
  raised_at       timestamptz NOT NULL DEFAULT now(),
  resolved_at     timestamptz,
  resolution      text
);

CREATE TABLE IF NOT EXISTS app.project_risks (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  project_id      uuid NOT NULL REFERENCES app.projects(id) ON DELETE CASCADE,
  description     text NOT NULL,
  probability     text CHECK (probability IN (NULL,'low','medium','high')),
  impact          text CHECK (impact IN (NULL,'low','medium','high','critical')),
  mitigation      text,
  owner_id        uuid REFERENCES app.employees(id),
  status          text NOT NULL DEFAULT 'open' CHECK (status IN ('open','mitigated','accepted','closed')),
  identified_at   timestamptz NOT NULL DEFAULT now()
);

-- =============== INDEXES ===============
CREATE INDEX IF NOT EXISTS idx_proj_status     ON app.projects(tenant_id, status);
CREATE INDEX IF NOT EXISTS idx_proj_customer   ON app.projects(customer_id);
CREATE INDEX IF NOT EXISTS idx_proj_manager    ON app.projects(manager_id);
CREATE INDEX IF NOT EXISTS idx_proj_dates      ON app.projects(start_date, end_date);
CREATE INDEX IF NOT EXISTS idx_ms_project      ON app.milestones(project_id, seq_no);
CREATE INDEX IF NOT EXISTS idx_ms_due          ON app.milestones(due_date) WHERE status IN ('pending','in_progress');
CREATE INDEX IF NOT EXISTS idx_task_project    ON app.tasks(project_id, status);
CREATE INDEX IF NOT EXISTS idx_task_assignee   ON app.tasks(assignee_id, status) WHERE status NOT IN ('done','cancelled');
CREATE INDEX IF NOT EXISTS idx_task_parent     ON app.tasks(parent_id);
CREATE INDEX IF NOT EXISTS idx_res_project_emp ON app.project_resources(project_id, employee_id);
CREATE INDEX IF NOT EXISTS idx_billev_project  ON app.project_billing_events(project_id, status);
CREATE INDEX IF NOT EXISTS idx_wip_proj_date   ON app.project_wip(project_id, as_of_date DESC);

-- =============== RLS + TRIGGERS ===============
SELECT core.enable_tenant_rls('app.projects');
SELECT core.enable_tenant_rls('app.milestones');
SELECT core.enable_tenant_rls('app.tasks');
SELECT core.enable_tenant_rls('app.project_resources');
SELECT core.enable_tenant_rls('app.project_billing_events');
SELECT core.enable_tenant_rls('app.project_wip');
SELECT core.enable_tenant_rls('app.project_issues');
SELECT core.enable_tenant_rls('app.project_risks');

SELECT core.attach_standard_triggers('app.projects');
SELECT core.attach_standard_triggers('app.tasks');

-- =============== FUNCTIONS / VIEWS ===============

-- Compute project profitability snapshot
CREATE OR REPLACE FUNCTION app.project_profitability(p_project_id uuid)
RETURNS TABLE(revenue numeric, cost numeric, margin numeric, margin_pct numeric)
LANGUAGE sql STABLE AS $$
  WITH rev AS (
    SELECT COALESCE(SUM(pbe.amount),0) AS revenue
      FROM app.project_billing_events pbe WHERE pbe.project_id = p_project_id AND pbe.status IN ('invoiced','paid')
  ), labor AS (
    SELECT COALESCE(SUM(te.hours * pr.cost_rate),0) AS cost
      FROM app.timesheet_entries te
      JOIN app.timesheets t ON t.id = te.timesheet_id
      JOIN app.project_resources pr ON pr.project_id = te.project_id AND pr.employee_id = t.employee_id
     WHERE te.project_id = p_project_id
  )
  SELECT rev.revenue, labor.cost,
         rev.revenue - labor.cost AS margin,
         round((rev.revenue - labor.cost) / NULLIF(rev.revenue,0) * 100, 2) AS margin_pct
    FROM rev, labor
$$;

CREATE OR REPLACE VIEW app.v_project_dashboard AS
SELECT p.tenant_id, p.id, p.project_code, p.name, p.status, p.progress_pct,
       p.budget_amount, p.budget_hours,
       COUNT(t.*) task_count,
       COUNT(t.*) FILTER (WHERE t.status='done') tasks_done,
       SUM(t.actual_hours) AS hours_logged
  FROM app.projects p
  LEFT JOIN app.tasks t ON t.project_id = p.id
 GROUP BY p.tenant_id, p.id, p.project_code, p.name, p.status, p.progress_pct,
          p.budget_amount, p.budget_hours;
