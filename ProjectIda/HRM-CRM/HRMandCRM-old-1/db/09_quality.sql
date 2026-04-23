-- =====================================================================
-- STEP 9: Quality Management
-- =====================================================================

CREATE TABLE quality.qa_plan (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    company_id      UUID NOT NULL,
    code            TEXT NOT NULL,
    name            TEXT NOT NULL,
    applicable_to   TEXT NOT NULL CHECK (applicable_to IN ('incoming','in_process','outgoing','all')),
    item_id         UUID REFERENCES inventory.item(id),
    item_category_id UUID REFERENCES inventory.item_category(id),
    supplier_id     UUID REFERENCES purchase.supplier(id),
    sampling_plan_id UUID,
    is_active       BOOLEAN DEFAULT TRUE,
    UNIQUE (company_id, code)
);

CREATE TABLE quality.qa_parameter (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    qa_plan_id      UUID NOT NULL REFERENCES quality.qa_plan(id) ON DELETE CASCADE,
    sequence_no     INT NOT NULL,
    name            TEXT NOT NULL,
    data_type       TEXT CHECK (data_type IN ('numeric','boolean','text','enum','attribute')),
    uom             TEXT,
    min_value       NUMERIC,
    max_value       NUMERIC,
    target_value    NUMERIC,
    tolerance       NUMERIC,
    allowed_values  TEXT[],
    is_critical     BOOLEAN DEFAULT FALSE,
    UNIQUE (qa_plan_id, sequence_no)
);

CREATE TABLE quality.sampling_plan (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    code            TEXT NOT NULL,
    name            TEXT NOT NULL,
    method          TEXT CHECK (method IN ('fixed','percentage','aql','custom')),
    sample_size     INT,
    sample_pct      NUMERIC(5,2),
    aql_level       TEXT,
    UNIQUE (tenant_id, code)
);

CREATE TABLE quality.inspection (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    company_id      UUID NOT NULL,
    doc_no          TEXT NOT NULL,
    inspection_type TEXT NOT NULL CHECK (inspection_type IN ('incoming','in_process','outgoing','rework')),
    qa_plan_id      UUID REFERENCES quality.qa_plan(id),
    reference_doc_type TEXT NOT NULL,             -- grn/work_order/delivery_note
    reference_doc_id UUID NOT NULL,
    item_id         UUID NOT NULL REFERENCES inventory.item(id),
    batch_no        TEXT,
    lot_qty         core.qty_amt,
    sample_qty      core.qty_amt,
    inspected_by    UUID REFERENCES iam.user(id),
    inspection_date TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    result          TEXT CHECK (result IN ('pass','fail','conditional_pass','pending')),
    status          TEXT DEFAULT 'draft' CHECK (status IN ('draft','in_progress','completed','cancelled')),
    remarks         TEXT,
    UNIQUE (company_id, doc_no)
);

CREATE TABLE quality.inspection_result (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    inspection_id   UUID NOT NULL REFERENCES quality.inspection(id) ON DELETE CASCADE,
    parameter_id    UUID NOT NULL REFERENCES quality.qa_parameter(id),
    value_numeric   NUMERIC,
    value_text      TEXT,
    value_boolean   BOOLEAN,
    status          TEXT CHECK (status IN ('pass','fail','out_of_spec')),
    remarks         TEXT
);

CREATE TABLE quality.defect (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    code            TEXT NOT NULL,
    name            TEXT NOT NULL,
    category        TEXT,
    severity        TEXT CHECK (severity IN ('critical','major','minor','cosmetic')),
    root_cause_guidance TEXT,
    UNIQUE (tenant_id, code)
);

CREATE TABLE quality.defect_entry (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    inspection_id   UUID REFERENCES quality.inspection(id),
    defect_id       UUID NOT NULL REFERENCES quality.defect(id),
    qty_affected    core.qty_amt,
    disposition     TEXT CHECK (disposition IN ('rework','scrap','use_as_is','return_to_supplier','quarantine')),
    notes           TEXT
);

CREATE TABLE quality.ncr (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    company_id      UUID NOT NULL,
    doc_no          TEXT NOT NULL,
    raised_date     DATE NOT NULL DEFAULT CURRENT_DATE,
    raised_by       UUID REFERENCES iam.user(id),
    source_module   TEXT,
    reference_doc_type TEXT,
    reference_doc_id UUID,
    item_id         UUID REFERENCES inventory.item(id),
    supplier_id     UUID REFERENCES purchase.supplier(id),
    description     TEXT NOT NULL,
    severity        TEXT,
    status          TEXT DEFAULT 'open' CHECK (status IN ('open','investigating','action_taken','closed','cancelled')),
    closed_at       TIMESTAMPTZ,
    UNIQUE (company_id, doc_no)
);

CREATE TABLE quality.capa (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    ncr_id          UUID REFERENCES quality.ncr(id),
    capa_type       TEXT CHECK (capa_type IN ('corrective','preventive','both')),
    root_cause      TEXT,
    action_plan     TEXT,
    owner_user_id   UUID REFERENCES iam.user(id),
    target_date     DATE,
    completion_date DATE,
    effectiveness_review TEXT,
    status          TEXT DEFAULT 'open' CHECK (status IN ('open','in_progress','completed','verified','closed'))
);

CREATE TABLE quality.calibration (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    asset_id        UUID,
    equipment_code  TEXT NOT NULL,
    equipment_name  TEXT NOT NULL,
    calibration_date DATE NOT NULL,
    next_due        DATE,
    performed_by    TEXT,
    certificate_no  TEXT,
    result          TEXT CHECK (result IN ('pass','fail','adjusted')),
    document_id     UUID
);

-- =====================================================================
-- INDEXES
-- =====================================================================
CREATE INDEX idx_qa_plan_item          ON quality.qa_plan(item_id);
CREATE INDEX idx_inspection_ref        ON quality.inspection(reference_doc_type, reference_doc_id);
CREATE INDEX idx_inspection_result     ON quality.inspection(company_id, result, inspection_date DESC);
CREATE INDEX idx_ncr_status            ON quality.ncr(company_id, status);
CREATE INDEX idx_capa_owner            ON quality.capa(owner_user_id, status);
CREATE INDEX idx_calibration_due       ON quality.calibration(next_due) WHERE next_due IS NOT NULL;

-- =====================================================================
-- FUNCTIONS
-- =====================================================================
CREATE OR REPLACE FUNCTION quality.fn_evaluate_inspection(p_inspection UUID)
RETURNS TEXT AS $$
DECLARE v_result TEXT := 'pass';
BEGIN
    -- Any critical param failed → fail; else any failed → conditional; all pass → pass
    IF EXISTS (SELECT 1 FROM quality.inspection_result ir
               JOIN quality.qa_parameter p ON p.id = ir.parameter_id
              WHERE ir.inspection_id = p_inspection AND ir.status = 'fail' AND p.is_critical) THEN
        v_result := 'fail';
    ELSIF EXISTS (SELECT 1 FROM quality.inspection_result
                  WHERE inspection_id = p_inspection AND status IN ('fail','out_of_spec')) THEN
        v_result := 'conditional_pass';
    END IF;
    UPDATE quality.inspection SET result = v_result, status = 'completed' WHERE id = p_inspection;
    RETURN v_result;
END;
$$ LANGUAGE plpgsql;

-- =====================================================================
-- VIEWS
-- =====================================================================
CREATE OR REPLACE VIEW quality.v_inspection_pass_rate AS
SELECT company_id, item_id, date_trunc('month', inspection_date) AS month,
       COUNT(*) FILTER (WHERE result='pass')::NUMERIC / NULLIF(COUNT(*),0) AS pass_rate
  FROM quality.inspection GROUP BY 1,2,3;

-- =====================================================================
-- TRIGGERS
-- =====================================================================
CREATE TRIGGER trg_ncr_audit AFTER INSERT OR UPDATE OR DELETE ON quality.ncr
    FOR EACH ROW EXECUTE FUNCTION audit.fn_row_audit();
