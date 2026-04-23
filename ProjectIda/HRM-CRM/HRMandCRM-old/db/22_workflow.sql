-- =====================================================================
-- STEP 22: Workflow & Automation
-- =====================================================================

CREATE TABLE workflow.workflow_def (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    code            TEXT NOT NULL,
    name            TEXT NOT NULL,
    entity_type     TEXT NOT NULL,                -- sales_invoice/purchase_order/leave_application/...
    version         INT DEFAULT 1,
    definition      JSONB NOT NULL,               -- BPMN-like JSON
    trigger_event   TEXT,                         -- on_create/on_update/on_submit/on_schedule
    is_active       BOOLEAN DEFAULT TRUE,
    created_by      UUID,
    created_at      TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE (tenant_id, code, version)
);

CREATE TABLE workflow.workflow_instance (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    workflow_def_id UUID NOT NULL REFERENCES workflow.workflow_def(id),
    entity_type     TEXT NOT NULL,
    entity_id       UUID NOT NULL,
    current_step    TEXT,
    status          TEXT DEFAULT 'running' CHECK (status IN ('running','waiting','completed','rejected','cancelled','failed','suspended')),
    context         JSONB,
    started_by      UUID,
    started_at      TIMESTAMPTZ DEFAULT NOW(),
    completed_at    TIMESTAMPTZ
);

CREATE TABLE workflow.workflow_task (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    instance_id     UUID NOT NULL REFERENCES workflow.workflow_instance(id) ON DELETE CASCADE,
    step_code       TEXT NOT NULL,
    task_type       TEXT CHECK (task_type IN ('approval','review','input','notification','script','sub_process','gateway','timer')),
    assignee_type   TEXT CHECK (assignee_type IN ('user','role','group','dynamic')),
    assignee_id     UUID,
    title           TEXT,
    description     TEXT,
    form_data       JSONB,
    status          TEXT DEFAULT 'pending' CHECK (status IN ('pending','claimed','completed','rejected','expired','cancelled','delegated')),
    priority        TEXT,
    due_at          TIMESTAMPTZ,
    claimed_at      TIMESTAMPTZ,
    completed_at    TIMESTAMPTZ,
    outcome         TEXT,
    comment         TEXT,
    created_at      TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE workflow.approval_matrix (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    entity_type     TEXT NOT NULL,
    conditions      JSONB NOT NULL,               -- {amount_gt:100000,dept:'SALES'}
    level_no        INT NOT NULL,
    approver_type   TEXT CHECK (approver_type IN ('user','role','manager','position','dynamic')),
    approver_ref    UUID,
    approver_rule   JSONB,
    is_mandatory    BOOLEAN DEFAULT TRUE,
    UNIQUE (tenant_id, entity_type, level_no, conditions)
);

CREATE TABLE workflow.approval_log (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    entity_type     TEXT NOT NULL,
    entity_id       UUID NOT NULL,
    level_no        INT,
    approver_user_id UUID,
    action          TEXT CHECK (action IN ('approved','rejected','returned','delegated','escalated')),
    comment         TEXT,
    acted_at        TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE workflow.business_rule (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    code            TEXT NOT NULL,
    name            TEXT NOT NULL,
    entity_type     TEXT,
    trigger_on      TEXT CHECK (trigger_on IN ('before_insert','after_insert','before_update','after_update','before_delete','after_delete','on_field_change')),
    condition       JSONB,
    action          JSONB,
    is_active       BOOLEAN DEFAULT TRUE,
    priority        INT DEFAULT 100,
    UNIQUE (tenant_id, code)
);

CREATE TABLE workflow.scheduled_job (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    code            TEXT NOT NULL,
    name            TEXT NOT NULL,
    cron_expression TEXT NOT NULL,
    job_type        TEXT,
    handler         TEXT NOT NULL,                -- queue/function name
    parameters      JSONB,
    last_run_at     TIMESTAMPTZ,
    last_run_status TEXT,
    next_run_at     TIMESTAMPTZ,
    is_active       BOOLEAN DEFAULT TRUE,
    UNIQUE (tenant_id, code)
);

CREATE TABLE workflow.job_execution (
    id              BIGSERIAL PRIMARY KEY,
    job_id          UUID NOT NULL REFERENCES workflow.scheduled_job(id),
    started_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    ended_at        TIMESTAMPTZ,
    status          TEXT,
    error           TEXT,
    output          JSONB
);

CREATE TABLE workflow.reminder (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    entity_type     TEXT NOT NULL,
    entity_id       UUID NOT NULL,
    remind_at       TIMESTAMPTZ NOT NULL,
    channel         TEXT,
    message         TEXT,
    recipient_user_id UUID,
    escalation_to_user_id UUID,
    escalation_after_min INT,
    status          TEXT DEFAULT 'pending' CHECK (status IN ('pending','sent','acknowledged','escalated','cancelled'))
);

-- =====================================================================
-- INDEXES
-- =====================================================================
CREATE INDEX idx_wf_instance_entity    ON workflow.workflow_instance(entity_type, entity_id);
CREATE INDEX idx_wf_instance_status    ON workflow.workflow_instance(tenant_id, status);
CREATE INDEX idx_wf_task_assignee      ON workflow.workflow_task(assignee_type, assignee_id, status);
CREATE INDEX idx_wf_task_due           ON workflow.workflow_task(due_at) WHERE status IN ('pending','claimed');
CREATE INDEX idx_approval_log_entity   ON workflow.approval_log(entity_type, entity_id);
CREATE INDEX idx_scheduled_job_next    ON workflow.scheduled_job(next_run_at) WHERE is_active;
CREATE INDEX idx_reminder_remind_at    ON workflow.reminder(remind_at) WHERE status = 'pending';

-- =====================================================================
-- FUNCTIONS
-- =====================================================================
CREATE OR REPLACE FUNCTION workflow.fn_start_workflow(
    p_def UUID, p_entity_type TEXT, p_entity_id UUID, p_user UUID, p_context JSONB DEFAULT '{}'::jsonb
) RETURNS UUID AS $$
DECLARE v_id UUID;
BEGIN
    INSERT INTO workflow.workflow_instance(tenant_id, workflow_def_id, entity_type, entity_id,
        current_step, status, context, started_by)
    SELECT tenant_id, id, p_entity_type, p_entity_id, 'start', 'running', p_context, p_user
      FROM workflow.workflow_def WHERE id = p_def
    RETURNING id INTO v_id;
    RETURN v_id;
END; $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION workflow.fn_complete_task(p_task UUID, p_outcome TEXT, p_user UUID, p_comment TEXT DEFAULT NULL)
RETURNS VOID AS $$
BEGIN
    UPDATE workflow.workflow_task
       SET status = CASE p_outcome
            WHEN 'approve' THEN 'completed'
            WHEN 'reject' THEN 'rejected'
            ELSE 'completed' END,
           completed_at = NOW(), outcome = p_outcome, comment = p_comment
     WHERE id = p_task;
END; $$ LANGUAGE plpgsql;

-- =====================================================================
-- VIEWS
-- =====================================================================
CREATE OR REPLACE VIEW workflow.v_pending_tasks AS
SELECT wt.*, wi.entity_type, wi.entity_id
  FROM workflow.workflow_task wt JOIN workflow.workflow_instance wi ON wi.id = wt.instance_id
 WHERE wt.status IN ('pending','claimed');

CREATE OR REPLACE VIEW workflow.v_overdue_tasks AS
SELECT * FROM workflow.workflow_task
 WHERE due_at < NOW() AND status IN ('pending','claimed');
