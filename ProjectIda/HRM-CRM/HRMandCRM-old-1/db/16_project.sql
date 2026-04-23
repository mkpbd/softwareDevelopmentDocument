-- =====================================================================
-- STEP 16: Project Management
-- =====================================================================

CREATE TABLE project.project (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    company_id      UUID NOT NULL,
    code            TEXT NOT NULL,
    name            TEXT NOT NULL,
    description     TEXT,
    client_id       UUID REFERENCES sales.customer(id),
    project_manager_id UUID REFERENCES hr.employee(id),
    start_date      DATE,
    end_date        DATE,
    planned_end_date DATE,
    billing_type    TEXT CHECK (billing_type IN ('time_material','fixed_price','milestone','retainer','non_billable')),
    currency_code   CHAR(3) DEFAULT 'INR',
    budget_cost     core.money_amt,
    budget_revenue  core.money_amt,
    actual_cost     core.money_amt DEFAULT 0,
    actual_revenue  core.money_amt DEFAULT 0,
    status          TEXT DEFAULT 'planning' CHECK (status IN ('planning','active','on_hold','completed','cancelled','closed')),
    priority        TEXT CHECK (priority IN ('low','medium','high','critical')),
    cost_center_id  UUID REFERENCES finance.cost_center(id),
    parent_project_id UUID REFERENCES project.project(id),
    attributes      JSONB,
    created_at      TIMESTAMPTZ DEFAULT NOW(),
    updated_at      TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE (company_id, code)
);

CREATE TABLE project.milestone (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    project_id      UUID NOT NULL REFERENCES project.project(id) ON DELETE CASCADE,
    code            TEXT NOT NULL,
    name            TEXT NOT NULL,
    due_date        DATE,
    completion_pct  NUMERIC(5,2) DEFAULT 0,
    billing_amount  core.money_amt,
    is_invoiced     BOOLEAN DEFAULT FALSE,
    invoice_id      UUID REFERENCES sales.sales_invoice(id),
    status          TEXT DEFAULT 'pending',
    UNIQUE (project_id, code)
);

CREATE TABLE project.task (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    project_id      UUID NOT NULL REFERENCES project.project(id) ON DELETE CASCADE,
    parent_task_id  UUID REFERENCES project.task(id),
    milestone_id    UUID REFERENCES project.milestone(id),
    code            TEXT,
    name            TEXT NOT NULL,
    description     TEXT,
    assignee_user_id UUID REFERENCES iam.user(id),
    reporter_user_id UUID,
    status          TEXT DEFAULT 'todo' CHECK (status IN ('todo','in_progress','review','done','blocked','cancelled')),
    priority        TEXT,
    estimated_hours NUMERIC(8,2),
    actual_hours    NUMERIC(8,2) DEFAULT 0,
    start_date      DATE,
    due_date        DATE,
    completion_pct  NUMERIC(5,2) DEFAULT 0,
    is_billable     BOOLEAN DEFAULT FALSE,
    tags            TEXT[],
    created_at      TIMESTAMPTZ DEFAULT NOW(),
    updated_at      TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE project.task_dependency (
    predecessor_id  UUID NOT NULL REFERENCES project.task(id) ON DELETE CASCADE,
    successor_id    UUID NOT NULL REFERENCES project.task(id) ON DELETE CASCADE,
    dep_type        TEXT DEFAULT 'fs' CHECK (dep_type IN ('fs','ss','ff','sf')),
    lag_days        INT DEFAULT 0,
    PRIMARY KEY (predecessor_id, successor_id)
);

CREATE TABLE project.resource_allocation (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    project_id      UUID NOT NULL REFERENCES project.project(id) ON DELETE CASCADE,
    employee_id     UUID REFERENCES hr.employee(id),
    role            TEXT,
    allocation_pct  NUMERIC(5,2),
    rate_per_hour   core.money_amt,
    from_date       DATE,
    to_date         DATE
);

CREATE TABLE project.cost_entry (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    project_id      UUID NOT NULL REFERENCES project.project(id),
    task_id         UUID REFERENCES project.task(id),
    cost_type       TEXT CHECK (cost_type IN ('labor','material','expense','subcontract','overhead')),
    entry_date      DATE NOT NULL,
    description     TEXT,
    qty             core.qty_amt,
    unit_cost       core.money_amt,
    amount          core.money_amt NOT NULL,
    source_doc_type TEXT,
    source_doc_id   UUID,
    is_billable     BOOLEAN DEFAULT FALSE,
    billed          BOOLEAN DEFAULT FALSE
);

CREATE TABLE project.issue (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    project_id      UUID NOT NULL REFERENCES project.project(id) ON DELETE CASCADE,
    code            TEXT,
    title           TEXT NOT NULL,
    description     TEXT,
    severity        TEXT,
    priority        TEXT,
    status          TEXT DEFAULT 'open',
    reported_by     UUID,
    assigned_to     UUID,
    resolution      TEXT,
    reported_at     TIMESTAMPTZ DEFAULT NOW(),
    resolved_at     TIMESTAMPTZ
);

CREATE TABLE project.risk (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    project_id      UUID NOT NULL REFERENCES project.project(id) ON DELETE CASCADE,
    description     TEXT NOT NULL,
    probability     TEXT CHECK (probability IN ('low','medium','high')),
    impact          TEXT CHECK (impact IN ('low','medium','high','severe')),
    mitigation_plan TEXT,
    owner_user_id   UUID,
    status          TEXT DEFAULT 'open'
);

-- =====================================================================
-- INDEXES
-- =====================================================================
CREATE INDEX idx_project_manager       ON project.project(project_manager_id);
CREATE INDEX idx_project_client        ON project.project(client_id);
CREATE INDEX idx_project_status        ON project.project(company_id, status);
CREATE INDEX idx_task_project          ON project.task(project_id, status);
CREATE INDEX idx_task_assignee         ON project.task(assignee_user_id, status);
CREATE INDEX idx_task_due              ON project.task(due_date) WHERE status NOT IN ('done','cancelled');
CREATE INDEX idx_cost_entry_project    ON project.cost_entry(project_id, entry_date);

-- =====================================================================
-- FUNCTIONS
-- =====================================================================

-- Project P&L
CREATE OR REPLACE FUNCTION project.fn_project_pnl(p_project UUID)
RETURNS TABLE (budget_revenue core.money_amt, actual_revenue core.money_amt,
               budget_cost core.money_amt, actual_cost core.money_amt,
               margin core.money_amt, margin_pct NUMERIC) AS $$
    SELECT p.budget_revenue, p.actual_revenue, p.budget_cost, p.actual_cost,
           (p.actual_revenue - p.actual_cost),
           ROUND((p.actual_revenue - p.actual_cost)/NULLIF(p.actual_revenue,0)*100, 2)
      FROM project.project p WHERE p.id = p_project;
$$ LANGUAGE sql STABLE;

-- Rollup timesheet hours to task/project
CREATE OR REPLACE FUNCTION project.fn_rollup_timesheet(p_project UUID)
RETURNS VOID AS $$
BEGIN
    UPDATE project.task t SET actual_hours = sub.hrs
      FROM (SELECT task_id, SUM(hours) hrs FROM attendance.timesheet_entry GROUP BY task_id) sub
     WHERE t.id = sub.task_id AND t.project_id = p_project;

    UPDATE project.project SET actual_cost = (
        SELECT COALESCE(SUM(amount),0) FROM project.cost_entry WHERE project_id = p_project
    ) WHERE id = p_project;
END; $$ LANGUAGE plpgsql;

-- =====================================================================
-- VIEWS
-- =====================================================================
CREATE OR REPLACE VIEW project.v_wip AS
SELECT p.id, p.code, p.name, p.budget_cost, p.actual_cost,
       (SELECT COALESCE(SUM(amount),0) FROM project.cost_entry
         WHERE project_id = p.id AND is_billable AND NOT billed) AS wip_unbilled
  FROM project.project p WHERE p.status = 'active';

CREATE OR REPLACE VIEW project.v_task_gantt AS
SELECT t.id, t.project_id, t.name, t.start_date, t.due_date, t.completion_pct,
       t.assignee_user_id, array_agg(td.predecessor_id) AS dependencies
  FROM project.task t
  LEFT JOIN project.task_dependency td ON td.successor_id = t.id
 GROUP BY t.id;
