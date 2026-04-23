-- =====================================================================
-- STEP 15: Asset Management
-- =====================================================================

CREATE TABLE asset.asset_category (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    parent_id       UUID REFERENCES asset.asset_category(id),
    code            TEXT NOT NULL,
    name            TEXT NOT NULL,
    default_depr_method TEXT CHECK (default_depr_method IN ('straight_line','wdv','units_of_prod','sum_of_years','none')),
    default_useful_life_years NUMERIC(5,2),
    default_residual_pct NUMERIC(5,2) DEFAULT 0,
    gl_asset_account_id UUID REFERENCES finance.account(id),
    gl_accum_depr_account_id UUID REFERENCES finance.account(id),
    gl_depr_expense_account_id UUID REFERENCES finance.account(id),
    UNIQUE (tenant_id, code)
);

CREATE TABLE asset.asset (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    company_id      UUID NOT NULL,
    branch_id       UUID,
    asset_no        TEXT NOT NULL,
    name            TEXT NOT NULL,
    description     TEXT,
    category_id     UUID REFERENCES asset.asset_category(id),
    serial_no       TEXT,
    barcode         TEXT,
    purchase_date   DATE,
    supplier_id     UUID REFERENCES purchase.supplier(id),
    purchase_invoice_id UUID REFERENCES purchase.purchase_invoice(id),
    purchase_cost   core.money_amt NOT NULL,
    additional_cost core.money_amt DEFAULT 0,
    total_cost      core.money_amt GENERATED ALWAYS AS (purchase_cost + additional_cost) STORED,
    residual_value  core.money_amt DEFAULT 0,
    useful_life_years NUMERIC(5,2),
    depr_method     TEXT,
    depr_start_date DATE,
    accumulated_depr core.money_amt DEFAULT 0,
    book_value      core.money_amt,
    status          TEXT DEFAULT 'in_use' CHECK (status IN ('in_storage','in_use','under_maintenance','retired','sold','scrapped','lost','written_off')),
    location_id     UUID,
    assigned_to_employee_id UUID REFERENCES hr.employee(id),
    custodian_id    UUID REFERENCES hr.employee(id),
    insurance_policy_no TEXT,
    insurance_expiry DATE,
    warranty_expiry DATE,
    condition       TEXT CHECK (condition IN ('new','excellent','good','fair','poor')),
    photo_url       TEXT,
    attributes      JSONB DEFAULT '{}'::jsonb,
    tags            TEXT[],
    created_at      TIMESTAMPTZ DEFAULT NOW(),
    updated_at      TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE (company_id, asset_no)
);

CREATE TABLE asset.depreciation_book (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    code            TEXT NOT NULL,
    name            TEXT NOT NULL,                -- 'Book-Companies Act', 'Book-IT Act'
    regime          TEXT,
    UNIQUE (tenant_id, code)
);

CREATE TABLE asset.asset_depreciation (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    asset_id        UUID NOT NULL REFERENCES asset.asset(id) ON DELETE CASCADE,
    book_id         UUID NOT NULL REFERENCES asset.depreciation_book(id),
    depr_method     TEXT NOT NULL,
    useful_life_years NUMERIC(5,2),
    rate_pct        NUMERIC(5,2),
    residual_value  core.money_amt,
    UNIQUE (asset_id, book_id)
);

CREATE TABLE asset.asset_custody (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    asset_id        UUID NOT NULL REFERENCES asset.asset(id) ON DELETE CASCADE,
    assigned_to_employee_id UUID REFERENCES hr.employee(id),
    location_id     UUID,
    from_date       DATE NOT NULL,
    to_date         DATE,
    condition_at_handover TEXT,
    document_id     UUID,
    notes           TEXT
);

CREATE TABLE asset.maintenance_schedule (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    asset_id        UUID NOT NULL REFERENCES asset.asset(id) ON DELETE CASCADE,
    schedule_type   TEXT CHECK (schedule_type IN ('calendar','usage','condition')),
    frequency_days  INT,
    usage_threshold NUMERIC(12,2),
    next_due_date   DATE,
    vendor_id       UUID REFERENCES purchase.supplier(id),
    checklist       JSONB,
    is_active       BOOLEAN DEFAULT TRUE
);

CREATE TABLE asset.maintenance_work_order (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    asset_id        UUID NOT NULL REFERENCES asset.asset(id),
    doc_no          TEXT NOT NULL,
    mw_type         TEXT CHECK (mw_type IN ('preventive','corrective','breakdown','condition_based')),
    reported_date   DATE NOT NULL,
    started_at      TIMESTAMPTZ,
    completed_at    TIMESTAMPTZ,
    assigned_to     UUID REFERENCES iam.user(id),
    vendor_id       UUID REFERENCES purchase.supplier(id),
    problem         TEXT,
    action_taken    TEXT,
    cost            core.money_amt,
    downtime_hours  NUMERIC(8,2),
    status          TEXT DEFAULT 'open' CHECK (status IN ('open','assigned','in_progress','completed','cancelled')),
    UNIQUE (tenant_id, doc_no)
);

CREATE TABLE asset.maintenance_cost (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    maintenance_wo_id UUID NOT NULL REFERENCES asset.maintenance_work_order(id) ON DELETE CASCADE,
    cost_type       TEXT CHECK (cost_type IN ('labor','parts','external','other')),
    description     TEXT,
    amount          core.money_amt NOT NULL,
    reference_type  TEXT,
    reference_id    UUID
);

CREATE TABLE asset.asset_relocation (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    asset_id        UUID NOT NULL REFERENCES asset.asset(id) ON DELETE CASCADE,
    from_location   TEXT,
    to_location     TEXT,
    moved_at        TIMESTAMPTZ DEFAULT NOW(),
    moved_by        UUID,
    reason          TEXT
);

CREATE TABLE asset.asset_disposal (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    asset_id        UUID NOT NULL REFERENCES asset.asset(id) ON DELETE CASCADE,
    disposal_date   DATE NOT NULL,
    disposal_method TEXT CHECK (disposal_method IN ('sale','scrap','donation','trade_in','lost','stolen','write_off')),
    buyer           TEXT,
    sale_amount     core.money_amt DEFAULT 0,
    gain_loss       core.money_amt,
    je_id           UUID REFERENCES finance.journal_entry(id),
    approved_by     UUID,
    notes           TEXT
);

CREATE TABLE asset.asset_condition_assessment (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    asset_id        UUID NOT NULL REFERENCES asset.asset(id) ON DELETE CASCADE,
    assessed_date   DATE NOT NULL,
    assessed_by     UUID,
    condition       TEXT CHECK (condition IN ('new','excellent','good','fair','poor','unusable')),
    notes           TEXT
);

-- =====================================================================
-- INDEXES
-- =====================================================================
CREATE INDEX idx_asset_category        ON asset.asset(category_id);
CREATE INDEX idx_asset_status          ON asset.asset(company_id, status);
CREATE INDEX idx_asset_assigned        ON asset.asset(assigned_to_employee_id);
CREATE INDEX idx_asset_serial          ON asset.asset(serial_no) WHERE serial_no IS NOT NULL;
CREATE INDEX idx_maint_due             ON asset.maintenance_schedule(next_due_date) WHERE is_active;
CREATE INDEX idx_maint_wo_asset        ON asset.maintenance_work_order(asset_id, status);

-- =====================================================================
-- FUNCTIONS
-- =====================================================================

-- Compute monthly depreciation (straight-line)
CREATE OR REPLACE FUNCTION asset.fn_calc_depreciation(p_asset UUID, p_period DATE)
RETURNS core.money_amt AS $$
DECLARE
    v_a asset.asset%ROWTYPE;
    v_depreciable core.money_amt;
    v_monthly core.money_amt;
BEGIN
    SELECT * INTO v_a FROM asset.asset WHERE id = p_asset;
    IF v_a.depr_method IS NULL OR v_a.useful_life_years IS NULL OR v_a.useful_life_years = 0 THEN
        RETURN 0;
    END IF;
    v_depreciable := v_a.total_cost - COALESCE(v_a.residual_value,0);
    IF v_a.depr_method = 'straight_line' THEN
        v_monthly := v_depreciable / (v_a.useful_life_years * 12);
    ELSIF v_a.depr_method = 'wdv' THEN
        v_monthly := (v_a.total_cost - v_a.accumulated_depr) * (1.0/(v_a.useful_life_years * 12));
    ELSE
        v_monthly := 0;
    END IF;
    RETURN ROUND(v_monthly, 2);
END;
$$ LANGUAGE plpgsql STABLE;

-- Post monthly depreciation JE
CREATE OR REPLACE FUNCTION asset.fn_post_depreciation_run(p_company UUID, p_period DATE, p_user UUID)
RETURNS UUID AS $$
DECLARE
    v_je UUID;
    v_fp UUID;
    v_tenant UUID;
    v_total core.money_amt := 0;
    v_a RECORD;
BEGIN
    SELECT tenant_id INTO v_tenant FROM core.company WHERE id = p_company;
    v_fp := core.fn_get_fiscal_period(p_company, p_period);

    INSERT INTO finance.journal_entry(tenant_id, company_id, fiscal_period_id, doc_no, doc_date,
        posting_date, source_module, source_doc_type, currency_code, exchange_rate, status, narration)
    VALUES (v_tenant, p_company, v_fp, core.fn_next_doc_number(v_tenant,'journal_entry'),
        p_period, p_period, 'asset', 'depreciation_run', 'INR', 1, 'draft',
        'Depreciation for '||to_char(p_period,'Mon YYYY'))
    RETURNING id INTO v_je;

    FOR v_a IN SELECT * FROM asset.asset WHERE company_id = p_company AND status = 'in_use' LOOP
        DECLARE v_depr core.money_amt;
        BEGIN
            v_depr := asset.fn_calc_depreciation(v_a.id, p_period);
            IF v_depr > 0 THEN
                INSERT INTO finance.depreciation_schedule(tenant_id, asset_id, period_date,
                    depreciation, accumulated, book_value, posted_je_id, is_posted)
                VALUES (v_tenant, v_a.id, p_period, v_depr,
                    v_a.accumulated_depr + v_depr,
                    v_a.total_cost - (v_a.accumulated_depr + v_depr),
                    v_je, TRUE);
                UPDATE asset.asset SET accumulated_depr = accumulated_depr + v_depr,
                       book_value = total_cost - (accumulated_depr + v_depr)
                 WHERE id = v_a.id;
                v_total := v_total + v_depr;
            END IF;
        END;
    END LOOP;

    -- Simplified: one summary JE (real impl per category)
    IF v_total > 0 THEN
        INSERT INTO finance.journal_line(journal_entry_id, line_no, account_id, debit, credit, currency_code)
        SELECT v_je, 1, gl_depr_expense_account_id, v_total, 0, 'INR'
          FROM asset.asset_category WHERE tenant_id = v_tenant LIMIT 1;
        INSERT INTO finance.journal_line(journal_entry_id, line_no, account_id, debit, credit, currency_code)
        SELECT v_je, 2, gl_accum_depr_account_id, 0, v_total, 'INR'
          FROM asset.asset_category WHERE tenant_id = v_tenant LIMIT 1;
        PERFORM finance.fn_post_journal_entry(v_je, p_user);
    END IF;
    RETURN v_je;
END;
$$ LANGUAGE plpgsql;

-- =====================================================================
-- VIEWS
-- =====================================================================
CREATE OR REPLACE VIEW asset.v_asset_register AS
SELECT a.id, a.asset_no, a.name, ac.name AS category, a.purchase_date, a.total_cost,
       a.accumulated_depr, a.book_value, a.status, e.full_name AS assigned_to
  FROM asset.asset a
  LEFT JOIN asset.asset_category ac ON ac.id = a.category_id
  LEFT JOIN hr.employee e ON e.id = a.assigned_to_employee_id;

CREATE OR REPLACE VIEW asset.v_maintenance_overdue AS
SELECT ms.*, a.asset_no, a.name AS asset_name
  FROM asset.maintenance_schedule ms JOIN asset.asset a ON a.id = ms.asset_id
 WHERE ms.is_active AND ms.next_due_date < CURRENT_DATE;
