-- =====================================================================
-- Module 09: Quality Management
-- =====================================================================

SET search_path = app, core, public;

-- =============== SCHEMA ===============

CREATE TABLE IF NOT EXISTS app.qa_plans (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  company_id      uuid NOT NULL REFERENCES app.companies(id),
  code            citext NOT NULL,
  name            text NOT NULL,
  item_id         uuid,
  stage           text NOT NULL CHECK (stage IN ('incoming','in_process','outgoing','final')),
  sampling_method text NOT NULL DEFAULT 'none' CHECK (sampling_method IN ('none','random','aql','100pct')),
  aql_value       numeric(5,2),
  active          boolean NOT NULL DEFAULT true,
  created_at      timestamptz NOT NULL DEFAULT now(),
  updated_at      timestamptz NOT NULL DEFAULT now(),
  created_by      uuid, updated_by uuid, version int NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, company_id, code)
);

CREATE TABLE IF NOT EXISTS app.qa_checkpoints (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  qa_plan_id      uuid NOT NULL REFERENCES app.qa_plans(id) ON DELETE CASCADE,
  seq_no          smallint NOT NULL,
  parameter       text NOT NULL,
  param_type      text NOT NULL CHECK (param_type IN ('numeric','text','boolean','enum')),
  spec_min        numeric(19,6),
  spec_max        numeric(19,6),
  target_value    text,
  uom_code        text,
  is_critical     boolean NOT NULL DEFAULT false,
  UNIQUE (qa_plan_id, seq_no)
);

CREATE TABLE IF NOT EXISTS app.inspections (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  company_id      uuid NOT NULL REFERENCES app.companies(id),
  inspection_number text NOT NULL,
  inspection_date date NOT NULL,
  qa_plan_id      uuid REFERENCES app.qa_plans(id),
  reference_type  text CHECK (reference_type IN (NULL,'grn','work_order','delivery','batch')),
  reference_id    uuid,
  item_id         uuid,
  batch_id        uuid REFERENCES app.batches(id),
  sample_size     numeric(19,6),
  qty_inspected   numeric(19,6),
  qty_passed      numeric(19,6) NOT NULL DEFAULT 0,
  qty_failed      numeric(19,6) NOT NULL DEFAULT 0,
  status          text NOT NULL DEFAULT 'pending'
                  CHECK (status IN ('pending','passed','failed','waived','partial')),
  inspector_id    uuid,
  notes           text,
  created_at      timestamptz NOT NULL DEFAULT now(),
  updated_at      timestamptz NOT NULL DEFAULT now(),
  created_by      uuid, updated_by uuid, version int NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, company_id, inspection_number)
);

CREATE TABLE IF NOT EXISTS app.inspection_results (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  inspection_id   uuid NOT NULL REFERENCES app.inspections(id) ON DELETE CASCADE,
  checkpoint_id   uuid NOT NULL REFERENCES app.qa_checkpoints(id),
  measured_value  text,
  measured_numeric numeric(19,6),
  is_pass         boolean NOT NULL,
  notes           text
);

CREATE TABLE IF NOT EXISTS app.ncr (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  company_id      uuid NOT NULL REFERENCES app.companies(id),
  ncr_number      text NOT NULL,
  raised_date     date NOT NULL,
  reference_type  text CHECK (reference_type IN (NULL,'inspection','customer_complaint','internal_audit','supplier_audit')),
  reference_id    uuid,
  item_id         uuid,
  qty_affected    numeric(19,6),
  defect_category text NOT NULL,
  description     text NOT NULL,
  severity        text NOT NULL CHECK (severity IN ('minor','major','critical')),
  disposition     text CHECK (disposition IN (NULL,'rework','scrap','return_to_supplier','use_as_is','accept_deviation')),
  status          text NOT NULL DEFAULT 'open'
                  CHECK (status IN ('open','investigating','resolved','closed')),
  root_cause      text,
  closed_at       timestamptz,
  created_at      timestamptz NOT NULL DEFAULT now(),
  updated_at      timestamptz NOT NULL DEFAULT now(),
  created_by      uuid, updated_by uuid, version int NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, company_id, ncr_number)
);

CREATE TABLE IF NOT EXISTS app.capa (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  capa_number     text NOT NULL,
  ncr_id          uuid REFERENCES app.ncr(id),
  action_type     text NOT NULL CHECK (action_type IN ('corrective','preventive','both')),
  description     text NOT NULL,
  owner_id        uuid,
  due_date        date,
  completed_at    timestamptz,
  effectiveness   text CHECK (effectiveness IN (NULL,'effective','partial','ineffective')),
  status          text NOT NULL DEFAULT 'open'
                  CHECK (status IN ('open','in_progress','completed','verified','closed')),
  created_at      timestamptz NOT NULL DEFAULT now(),
  updated_at      timestamptz NOT NULL DEFAULT now(),
  created_by      uuid, updated_by uuid, version int NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, capa_number)
);

CREATE TABLE IF NOT EXISTS app.calibrations (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  asset_id        uuid,
  equipment_name  text NOT NULL,
  last_cal_date   date,
  next_cal_date   date NOT NULL,
  frequency_days  int NOT NULL DEFAULT 365,
  standard_used   text,
  status          text NOT NULL DEFAULT 'ok' CHECK (status IN ('ok','due','overdue','out_of_service')),
  notes           text,
  created_at      timestamptz NOT NULL DEFAULT now(),
  updated_at      timestamptz NOT NULL DEFAULT now(),
  created_by      uuid, updated_by uuid, version int NOT NULL DEFAULT 1
);

-- =============== INDEXES ===============
CREATE INDEX IF NOT EXISTS idx_qaplans_item  ON app.qa_plans(tenant_id, item_id) WHERE active;
CREATE INDEX IF NOT EXISTS idx_insp_ref      ON app.inspections(reference_type, reference_id);
CREATE INDEX IF NOT EXISTS idx_insp_status   ON app.inspections(tenant_id, status, inspection_date DESC);
CREATE INDEX IF NOT EXISTS idx_ir_insp       ON app.inspection_results(inspection_id);
CREATE INDEX IF NOT EXISTS idx_ncr_status    ON app.ncr(tenant_id, status, severity);
CREATE INDEX IF NOT EXISTS idx_ncr_ref       ON app.ncr(reference_type, reference_id);
CREATE INDEX IF NOT EXISTS idx_capa_status   ON app.capa(tenant_id, status, due_date);
CREATE INDEX IF NOT EXISTS idx_cal_due       ON app.calibrations(tenant_id, next_cal_date) WHERE status IN ('ok','due','overdue');

-- =============== RLS + TRIGGERS ===============
SELECT core.enable_tenant_rls('app.qa_plans');
SELECT core.enable_tenant_rls('app.qa_checkpoints');
SELECT core.enable_tenant_rls('app.inspections');
SELECT core.enable_tenant_rls('app.inspection_results');
SELECT core.enable_tenant_rls('app.ncr');
SELECT core.enable_tenant_rls('app.capa');
SELECT core.enable_tenant_rls('app.calibrations');

SELECT core.attach_standard_triggers('app.qa_plans');
SELECT core.attach_standard_triggers('app.inspections');
SELECT core.attach_standard_triggers('app.ncr');
SELECT core.attach_standard_triggers('app.capa');
SELECT core.attach_standard_triggers('app.calibrations');

-- =============== FUNCTIONS ===============

-- Auto-roll inspection status based on results
CREATE OR REPLACE FUNCTION app.evaluate_inspection(p_inspection_id uuid)
RETURNS text
LANGUAGE plpgsql AS $$
DECLARE v_fail int; v_total int; v_critical_fail int;
BEGIN
  SELECT COUNT(*) FILTER (WHERE NOT is_pass),
         COUNT(*),
         COUNT(*) FILTER (WHERE NOT ir.is_pass AND c.is_critical)
    INTO v_fail, v_total, v_critical_fail
    FROM app.inspection_results ir
    JOIN app.qa_checkpoints c ON c.id = ir.checkpoint_id
   WHERE ir.inspection_id = p_inspection_id;

  UPDATE app.inspections
     SET status = CASE
       WHEN v_total = 0 THEN 'pending'
       WHEN v_critical_fail > 0 OR v_fail > v_total*0.1 THEN 'failed'
       WHEN v_fail = 0 THEN 'passed'
       ELSE 'partial' END,
       updated_at = now()
   WHERE id = p_inspection_id
   RETURNING status INTO v_fail;   -- reuse var
  RETURN (SELECT status FROM app.inspections WHERE id = p_inspection_id);
END $$;

-- =============== VIEWS ===============
CREATE OR REPLACE VIEW app.v_ncr_open AS
SELECT tenant_id, severity, COUNT(*) AS open_count,
       AVG(CURRENT_DATE - raised_date) AS avg_age_days
  FROM app.ncr WHERE status <> 'closed'
 GROUP BY tenant_id, severity;

CREATE OR REPLACE VIEW app.v_calibration_due AS
SELECT tenant_id, equipment_name, next_cal_date,
       next_cal_date - CURRENT_DATE AS days_until_due, status
  FROM app.calibrations
 WHERE next_cal_date <= CURRENT_DATE + interval '30 days' AND status <> 'out_of_service';
