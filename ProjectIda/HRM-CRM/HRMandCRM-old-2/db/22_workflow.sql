-- =====================================================================
-- Module 22: Workflow & Automation
-- Covers PRD Step 22 (approval workflows, rules, scheduled jobs, SLAs)
-- =====================================================================

SET search_path = app, core, public;

-- =============== SCHEMA ===============

CREATE TABLE IF NOT EXISTS app.workflow_definitions (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  code            citext NOT NULL,
  name            text NOT NULL,
  entity_type     text NOT NULL,                -- 'sales_order','purchase_order','supplier_invoice'
  trigger_event   text NOT NULL CHECK (trigger_event IN ('on_submit','on_create','on_update','on_threshold','manual')),
  condition_expr  text,                         -- JSONLogic or SQL-safe DSL
  active          boolean NOT NULL DEFAULT true,
  definition      jsonb NOT NULL,               -- full state graph
  version_no      int NOT NULL DEFAULT 1,
  created_at      timestamptz NOT NULL DEFAULT now(),
  updated_at      timestamptz NOT NULL DEFAULT now(),
  created_by      uuid, updated_by uuid, version int NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, code, version_no)
);

CREATE TABLE IF NOT EXISTS app.approval_matrices (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  code            citext NOT NULL,
  name            text NOT NULL,
  entity_type     text NOT NULL,
  description     text,
  active          boolean NOT NULL DEFAULT true,
  created_at      timestamptz NOT NULL DEFAULT now(),
  updated_at      timestamptz NOT NULL DEFAULT now(),
  created_by      uuid, updated_by uuid, version int NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, code)
);

CREATE TABLE IF NOT EXISTS app.approval_matrix_rules (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  matrix_id       uuid NOT NULL REFERENCES app.approval_matrices(id) ON DELETE CASCADE,
  priority        int NOT NULL,
  condition_expr  jsonb NOT NULL,                -- e.g. {"amount_gte": 100000}
  approver_type   text NOT NULL CHECK (approver_type IN ('user','role','manager','dynamic')),
  approver_ref    text NOT NULL,                  -- user_id / role_code / expression
  level_no        smallint NOT NULL DEFAULT 1,
  is_parallel     boolean NOT NULL DEFAULT false,
  sla_hours       smallint,
  created_at      timestamptz NOT NULL DEFAULT now(),
  updated_at      timestamptz NOT NULL DEFAULT now(),
  created_by      uuid, updated_by uuid, version int NOT NULL DEFAULT 1
);

CREATE TABLE IF NOT EXISTS app.workflow_instances (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  workflow_id     uuid REFERENCES app.workflow_definitions(id),
  entity_type     text NOT NULL,
  entity_id       uuid NOT NULL,
  state           text NOT NULL DEFAULT 'running'
                  CHECK (state IN ('running','paused','completed','failed','cancelled')),
  current_step    smallint NOT NULL DEFAULT 1,
  context         jsonb NOT NULL DEFAULT '{}'::jsonb,
  started_at      timestamptz NOT NULL DEFAULT now(),
  completed_at    timestamptz,
  sla_breach_at   timestamptz,
  created_by      uuid
);

CREATE TABLE IF NOT EXISTS app.workflow_tasks (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  instance_id     uuid NOT NULL REFERENCES app.workflow_instances(id) ON DELETE CASCADE,
  step_no         smallint NOT NULL,
  level_no        smallint NOT NULL DEFAULT 1,
  task_type       text NOT NULL CHECK (task_type IN ('approval','review','action','notify')),
  assignee_user_id uuid REFERENCES app.users(id),
  assignee_role   text,
  status          text NOT NULL DEFAULT 'pending'
                  CHECK (status IN ('pending','in_progress','approved','rejected','delegated','skipped','expired')),
  action_by       uuid REFERENCES app.users(id),
  action_at       timestamptz,
  comments        text,
  due_at          timestamptz,
  escalated_to    uuid REFERENCES app.users(id),
  created_at      timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS app.business_rules (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  code            citext NOT NULL,
  entity_type     text NOT NULL,
  trigger_event   text NOT NULL CHECK (trigger_event IN ('on_insert','on_update','on_delete','scheduled')),
  condition_expr  jsonb NOT NULL,
  action_expr     jsonb NOT NULL,
  active          boolean NOT NULL DEFAULT true,
  priority        int NOT NULL DEFAULT 100,
  created_at      timestamptz NOT NULL DEFAULT now(),
  updated_at      timestamptz NOT NULL DEFAULT now(),
  created_by      uuid, updated_by uuid, version int NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, code)
);

CREATE TABLE IF NOT EXISTS ops.scheduled_jobs (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid,
  job_code        citext NOT NULL,
  job_type        text NOT NULL,
  cron_expr       text NOT NULL,
  payload         jsonb NOT NULL DEFAULT '{}'::jsonb,
  active          boolean NOT NULL DEFAULT true,
  last_run_at     timestamptz,
  last_status     text CHECK (last_status IN (NULL,'success','failed','running')),
  last_error      text,
  next_run_at     timestamptz,
  created_at      timestamptz NOT NULL DEFAULT now(),
  updated_at      timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS ops.job_runs (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  job_id          uuid REFERENCES ops.scheduled_jobs(id) ON DELETE SET NULL,
  job_code        text NOT NULL,
  tenant_id       uuid,
  started_at      timestamptz NOT NULL DEFAULT now(),
  completed_at    timestamptz,
  status          text NOT NULL DEFAULT 'running' CHECK (status IN ('running','success','failed','cancelled')),
  rows_processed  int,
  error           text,
  metadata        jsonb
);

-- =============== INDEXES ===============
CREATE INDEX IF NOT EXISTS idx_wd_entity          ON app.workflow_definitions(tenant_id, entity_type) WHERE active;
CREATE INDEX IF NOT EXISTS idx_am_entity          ON app.approval_matrices(tenant_id, entity_type) WHERE active;
CREATE INDEX IF NOT EXISTS idx_amr_matrix         ON app.approval_matrix_rules(matrix_id, priority);
CREATE INDEX IF NOT EXISTS idx_wi_entity          ON app.workflow_instances(tenant_id, entity_type, entity_id);
CREATE INDEX IF NOT EXISTS idx_wi_state           ON app.workflow_instances(tenant_id, state) WHERE state IN ('running','paused');
CREATE INDEX IF NOT EXISTS idx_wt_assignee_pending ON app.workflow_tasks(assignee_user_id, status) WHERE status = 'pending';
CREATE INDEX IF NOT EXISTS idx_wt_instance        ON app.workflow_tasks(instance_id, step_no);
CREATE INDEX IF NOT EXISTS idx_wt_due             ON app.workflow_tasks(due_at) WHERE status='pending';
CREATE INDEX IF NOT EXISTS idx_br_entity_event    ON app.business_rules(tenant_id, entity_type, trigger_event) WHERE active;
CREATE INDEX IF NOT EXISTS idx_sj_next_run        ON ops.scheduled_jobs(next_run_at) WHERE active;
CREATE INDEX IF NOT EXISTS idx_jr_job_started     ON ops.job_runs(job_code, started_at DESC);

-- =============== RLS ===============
SELECT core.enable_tenant_rls('app.workflow_definitions');
SELECT core.enable_tenant_rls('app.approval_matrices');
SELECT core.enable_tenant_rls('app.approval_matrix_rules');
SELECT core.enable_tenant_rls('app.workflow_instances');
SELECT core.enable_tenant_rls('app.workflow_tasks');
SELECT core.enable_tenant_rls('app.business_rules');

-- =============== TRIGGERS ===============
SELECT core.attach_standard_triggers('app.workflow_definitions');
SELECT core.attach_standard_triggers('app.approval_matrices');
SELECT core.attach_standard_triggers('app.approval_matrix_rules');
SELECT core.attach_standard_triggers('app.business_rules');

-- =============== FUNCTIONS ===============

-- Start a workflow instance for an entity
CREATE OR REPLACE FUNCTION app.start_workflow(
  p_entity_type text, p_entity_id uuid, p_context jsonb DEFAULT '{}'::jsonb
) RETURNS uuid
LANGUAGE plpgsql AS $$
DECLARE
  v_def app.workflow_definitions%ROWTYPE;
  v_id  uuid := gen_random_uuid();
BEGIN
  SELECT * INTO v_def
    FROM app.workflow_definitions
   WHERE tenant_id = core.require_tenant()
     AND entity_type = p_entity_type AND active
   ORDER BY version_no DESC LIMIT 1;

  INSERT INTO app.workflow_instances(id,tenant_id,workflow_id,entity_type,entity_id,context,created_by)
  VALUES (v_id, core.require_tenant(), v_def.id, p_entity_type, p_entity_id, p_context, core.current_user_id());
  RETURN v_id;
END $$;

-- Create approval tasks for an instance from matrix rules
CREATE OR REPLACE FUNCTION app.create_approval_tasks(
  p_instance_id uuid, p_matrix_code text, p_context jsonb
) RETURNS int
LANGUAGE plpgsql AS $$
DECLARE
  v_matrix_id uuid;
  v_count int := 0;
  r record;
  v_assignee uuid;
BEGIN
  SELECT id INTO v_matrix_id FROM app.approval_matrices
   WHERE tenant_id = core.require_tenant() AND code = p_matrix_code AND active;

  FOR r IN
    SELECT * FROM app.approval_matrix_rules
     WHERE matrix_id = v_matrix_id
     ORDER BY priority
  LOOP
    -- Evaluate rule condition (simple JSON ops: amount_gte, amount_lte, equals)
    CONTINUE WHEN NOT app.eval_condition(r.condition_expr, p_context);

    v_assignee := CASE r.approver_type
      WHEN 'user' THEN r.approver_ref::uuid
      WHEN 'role' THEN (SELECT user_id FROM app.user_roles ur
                          JOIN app.roles ro ON ro.id = ur.role_id
                         WHERE ro.code = r.approver_ref LIMIT 1)
      ELSE NULL
    END;

    INSERT INTO app.workflow_tasks(tenant_id, instance_id, step_no, level_no, task_type,
           assignee_user_id, assignee_role, due_at, status)
    VALUES (core.require_tenant(), p_instance_id, v_count+1, r.level_no, 'approval',
            v_assignee,
            CASE r.approver_type WHEN 'role' THEN r.approver_ref ELSE NULL END,
            CASE WHEN r.sla_hours IS NOT NULL THEN now() + (r.sla_hours||' hours')::interval END,
            'pending');
    v_count := v_count + 1;
  END LOOP;

  RETURN v_count;
END $$;

-- Simple condition evaluator for common operators
CREATE OR REPLACE FUNCTION app.eval_condition(p_cond jsonb, p_ctx jsonb)
RETURNS boolean
LANGUAGE plpgsql IMMUTABLE AS $$
DECLARE
  k text; v jsonb; ctx_val numeric;
BEGIN
  IF p_cond IS NULL OR p_cond = '{}'::jsonb THEN RETURN true; END IF;
  FOR k, v IN SELECT * FROM jsonb_each(p_cond) LOOP
    IF k LIKE '%_gte' THEN
      ctx_val := (p_ctx ->> replace(k,'_gte',''))::numeric;
      IF ctx_val IS NULL OR ctx_val < (v)::text::numeric THEN RETURN false; END IF;
    ELSIF k LIKE '%_lte' THEN
      ctx_val := (p_ctx ->> replace(k,'_lte',''))::numeric;
      IF ctx_val IS NULL OR ctx_val > (v)::text::numeric THEN RETURN false; END IF;
    ELSIF k LIKE '%_eq' THEN
      IF p_ctx ->> replace(k,'_eq','') IS DISTINCT FROM v#>>'{}' THEN RETURN false; END IF;
    END IF;
  END LOOP;
  RETURN true;
END $$;

-- Approve or reject a workflow task
CREATE OR REPLACE PROCEDURE app.act_on_task(
  p_task_id uuid, p_action text, p_comments text DEFAULT NULL
)
LANGUAGE plpgsql AS $$
DECLARE
  v_task app.workflow_tasks%ROWTYPE;
  v_pending int;
BEGIN
  IF p_action NOT IN ('approve','reject','delegate','skip') THEN
    RAISE EXCEPTION 'invalid action %', p_action;
  END IF;

  UPDATE app.workflow_tasks
     SET status = CASE p_action
            WHEN 'approve' THEN 'approved'
            WHEN 'reject'  THEN 'rejected'
            WHEN 'skip'    THEN 'skipped'
            WHEN 'delegate' THEN 'delegated' END,
         action_by = core.current_user_id(),
         action_at = now(),
         comments  = p_comments
   WHERE id = p_task_id AND status IN ('pending','in_progress')
   RETURNING * INTO v_task;

  IF NOT FOUND THEN RAISE EXCEPTION 'task not actionable'; END IF;

  IF p_action = 'reject' THEN
    UPDATE app.workflow_instances SET state='failed', completed_at=now()
     WHERE id = v_task.instance_id;
    RETURN;
  END IF;

  SELECT COUNT(*) INTO v_pending
    FROM app.workflow_tasks
   WHERE instance_id = v_task.instance_id AND status = 'pending';

  IF v_pending = 0 THEN
    UPDATE app.workflow_instances SET state='completed', completed_at=now()
     WHERE id = v_task.instance_id;
  END IF;
END $$;

-- Escalate overdue tasks (cron)
CREATE OR REPLACE FUNCTION app.escalate_overdue_tasks()
RETURNS int
LANGUAGE plpgsql AS $$
DECLARE v_count int;
BEGIN
  UPDATE app.workflow_tasks wt
     SET escalated_to = (
           SELECT ur.user_id FROM app.user_roles ur
             JOIN app.roles r ON r.id = ur.role_id
            WHERE r.code = 'manager' LIMIT 1
         )
   WHERE wt.status = 'pending' AND wt.due_at < now() AND wt.escalated_to IS NULL;
  GET DIAGNOSTICS v_count = ROW_COUNT;
  RETURN v_count;
END $$;

-- =============== VIEWS ===============
CREATE OR REPLACE VIEW app.v_pending_approvals AS
SELECT wt.tenant_id, wt.id task_id, wt.instance_id,
       wi.entity_type, wi.entity_id, wt.assignee_user_id,
       wt.step_no, wt.level_no, wt.due_at,
       EXTRACT(EPOCH FROM (wt.due_at - now()))/3600 AS hours_remaining
  FROM app.workflow_tasks wt
  JOIN app.workflow_instances wi ON wi.id = wt.instance_id
 WHERE wt.status = 'pending';

CREATE OR REPLACE VIEW app.v_workflow_sla AS
SELECT wi.tenant_id, wi.entity_type,
       COUNT(*)                                                   AS total,
       COUNT(*) FILTER (WHERE wi.state='completed')                AS completed,
       COUNT(*) FILTER (WHERE wi.sla_breach_at < now())            AS breached,
       AVG(EXTRACT(EPOCH FROM (wi.completed_at - wi.started_at))/3600)
                                                                  AS avg_cycle_hours
  FROM app.workflow_instances wi
 GROUP BY wi.tenant_id, wi.entity_type;
