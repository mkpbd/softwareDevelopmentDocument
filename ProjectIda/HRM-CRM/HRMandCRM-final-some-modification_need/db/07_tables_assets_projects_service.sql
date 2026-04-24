-- =============================================================================
-- tables.sql — Steps 15–17: Asset Management, Project Management, Service
-- =============================================================================

-- =============================================================================
-- STEP 15: ASSET MANAGEMENT
-- =============================================================================

-- Asset Categories
CREATE TABLE assets.asset_categories (
    asset_category_id   UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id           UUID         NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id           UUID         NOT NULL REFERENCES core.branches(branch_id),
    parent_category_id  UUID         REFERENCES assets.asset_categories(asset_category_id),
    category_code       VARCHAR(50)  NOT NULL,
    category_name       VARCHAR(255) NOT NULL,
    useful_life_years   SMALLINT     NOT NULL DEFAULT 5,
    depreciation_method VARCHAR(30)  NOT NULL DEFAULT 'straight_line',
    depreciation_rate   NUMERIC(8,4) NOT NULL DEFAULT 0,
    salvage_percentage  NUMERIC(8,4) NOT NULL DEFAULT 0,
    asset_account_id    UUID         REFERENCES finance.chart_of_accounts(account_id),
    depreciation_account_id UUID     REFERENCES finance.chart_of_accounts(account_id),
    accumulated_dep_account_id UUID  REFERENCES finance.chart_of_accounts(account_id),
    is_active           BOOLEAN      NOT NULL DEFAULT TRUE,
    created_by          UUID         NOT NULL,
    updated_by          UUID         NOT NULL,
    deleted_by          UUID,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    deleted_at          TIMESTAMPTZ,
    UNIQUE (tenant_id, category_code)
);

-- Asset Register
CREATE TABLE assets.assets (
    asset_id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id           UUID         NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id           UUID         NOT NULL REFERENCES core.branches(branch_id),
    asset_number        VARCHAR(50)  NOT NULL,
    asset_name          VARCHAR(255) NOT NULL,
    asset_description   TEXT,
    asset_category_id   UUID         NOT NULL REFERENCES assets.asset_categories(asset_category_id),
    asset_tag           VARCHAR(100),
    barcode             VARCHAR(100),
    serial_number       VARCHAR(200),
    purchase_date       DATE         NOT NULL,
    purchase_value      NUMERIC(20,2) NOT NULL CHECK (purchase_value >= 0),
    salvage_value       NUMERIC(20,2) NOT NULL DEFAULT 0 CHECK (salvage_value >= 0),
    current_book_value  NUMERIC(20,2) NOT NULL DEFAULT 0,
    useful_life_months  INTEGER      NOT NULL DEFAULT 60,
    depreciation_method VARCHAR(30)  NOT NULL DEFAULT 'straight_line',
    depreciation_rate   NUMERIC(8,4) NOT NULL DEFAULT 0,
    depreciation_start_date DATE,
    fully_depreciated_at DATE,
    warehouse_id        UUID         REFERENCES inventory.warehouses(warehouse_id),
    location_description VARCHAR(255),
    assigned_to         UUID         REFERENCES hr.employees(employee_id),
    assigned_at         DATE,
    insurance_policy_number VARCHAR(100),
    insurance_expiry    DATE,
    vendor_id           UUID         REFERENCES purchase.suppliers(supplier_id),
    purchase_order_id   UUID         REFERENCES purchase.purchase_orders(purchase_order_id),
    status              VARCHAR(30)  NOT NULL DEFAULT 'active' CHECK (status IN ('active','inactive','under_maintenance','disposed','written_off','transferred')),
    condition           VARCHAR(20)  NOT NULL DEFAULT 'good' CHECK (condition IN ('excellent','good','fair','poor','damaged')),
    last_maintenance_date DATE,
    next_maintenance_date DATE,
    image_url           TEXT,
    created_by          UUID         NOT NULL,
    updated_by          UUID         NOT NULL,
    deleted_by          UUID,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    deleted_at          TIMESTAMPTZ,
    UNIQUE (tenant_id, asset_number)
);

-- Depreciation Entries
CREATE TABLE assets.depreciation_entries (
    depreciation_entry_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id             UUID        NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id             UUID        NOT NULL REFERENCES core.branches(branch_id),
    asset_id              UUID        NOT NULL REFERENCES assets.assets(asset_id),
    financial_period_id   UUID        NOT NULL REFERENCES core.financial_periods(financial_period_id),
    depreciation_date     DATE        NOT NULL,
    opening_book_value    NUMERIC(20,2) NOT NULL,
    depreciation_amount   NUMERIC(20,2) NOT NULL CHECK (depreciation_amount >= 0),
    closing_book_value    NUMERIC(20,2) NOT NULL,
    journal_entry_id      UUID        REFERENCES finance.journal_entries(journal_entry_id),
    created_by            UUID        NOT NULL,
    updated_by            UUID        NOT NULL,
    deleted_by            UUID,
    created_at            TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at            TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at            TIMESTAMPTZ,
    UNIQUE (tenant_id, asset_id, financial_period_id)
);

-- Asset Maintenance
CREATE TABLE assets.asset_maintenance_records (
    maintenance_record_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id             UUID        NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id             UUID        NOT NULL REFERENCES core.branches(branch_id),
    asset_id              UUID        NOT NULL REFERENCES assets.assets(asset_id),
    maintenance_type      VARCHAR(30) NOT NULL CHECK (maintenance_type IN ('preventive','breakdown','calibration','inspection','upgrade')),
    maintenance_date      DATE        NOT NULL,
    next_due_date         DATE,
    performed_by          VARCHAR(255),
    vendor_id             UUID        REFERENCES purchase.suppliers(supplier_id),
    description           TEXT,
    cost                  NUMERIC(20,2) NOT NULL DEFAULT 0,
    status                VARCHAR(20) NOT NULL DEFAULT 'completed' CHECK (status IN ('scheduled','in_progress','completed','cancelled')),
    downtime_hours        NUMERIC(10,2) NOT NULL DEFAULT 0,
    journal_entry_id      UUID        REFERENCES finance.journal_entries(journal_entry_id),
    created_by            UUID        NOT NULL,
    updated_by            UUID        NOT NULL,
    deleted_by            UUID,
    created_at            TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at            TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at            TIMESTAMPTZ
);

-- Asset Disposals
CREATE TABLE assets.asset_disposals (
    asset_disposal_id   UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id           UUID         NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id           UUID         NOT NULL REFERENCES core.branches(branch_id),
    asset_id            UUID         NOT NULL REFERENCES assets.assets(asset_id),
    disposal_date       DATE         NOT NULL,
    disposal_type       VARCHAR(30)  NOT NULL CHECK (disposal_type IN ('sale','scrap','write_off','donation','trade_in')),
    disposal_value      NUMERIC(20,2) NOT NULL DEFAULT 0,
    book_value_at_disposal NUMERIC(20,2) NOT NULL,
    gain_loss           NUMERIC(20,2) GENERATED ALWAYS AS (disposal_value - book_value_at_disposal) STORED,
    buyer_name          VARCHAR(255),
    notes               TEXT,
    journal_entry_id    UUID         REFERENCES finance.journal_entries(journal_entry_id),
    created_by          UUID         NOT NULL,
    updated_by          UUID         NOT NULL,
    deleted_by          UUID,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    deleted_at          TIMESTAMPTZ
);

-- =============================================================================
-- STEP 16: PROJECT MANAGEMENT
-- =============================================================================

-- Projects
CREATE TABLE projects.projects (
    project_id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id           UUID         NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id           UUID         NOT NULL REFERENCES core.branches(branch_id),
    project_code        VARCHAR(50)  NOT NULL,
    project_name        VARCHAR(255) NOT NULL,
    project_description TEXT,
    customer_id         UUID         REFERENCES sales.customers(customer_id),
    project_type        VARCHAR(30)  NOT NULL DEFAULT 'fixed_price' CHECK (project_type IN ('fixed_price','time_material','milestone','retainer')),
    billing_type        VARCHAR(30)  NOT NULL DEFAULT 'fixed_price' CHECK (billing_type IN ('fixed_price','time_material','milestone')),
    status              VARCHAR(20)  NOT NULL DEFAULT 'planning' CHECK (status IN ('planning','active','on_hold','completed','cancelled','archived')),
    priority            VARCHAR(20)  NOT NULL DEFAULT 'normal' CHECK (priority IN ('low','normal','high','critical')),
    planned_start_date  DATE         NOT NULL,
    planned_end_date    DATE         NOT NULL,
    actual_start_date   DATE,
    actual_end_date     DATE,
    project_manager_id  UUID         REFERENCES hr.employees(employee_id),
    cost_center_id      UUID         REFERENCES finance.cost_centers(cost_center_id),
    budget_amount       NUMERIC(20,2) NOT NULL DEFAULT 0,
    contract_amount     NUMERIC(20,2) NOT NULL DEFAULT 0,
    actual_cost         NUMERIC(20,2) NOT NULL DEFAULT 0,
    billed_amount       NUMERIC(20,2) NOT NULL DEFAULT 0,
    completion_percentage SMALLINT   NOT NULL DEFAULT 0 CHECK (completion_percentage BETWEEN 0 AND 100),
    currency_code       VARCHAR(10)  NOT NULL DEFAULT 'INR',
    created_by          UUID         NOT NULL,
    updated_by          UUID         NOT NULL,
    deleted_by          UUID,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    deleted_at          TIMESTAMPTZ,
    UNIQUE (tenant_id, project_code)
);

-- Project Tasks
CREATE TABLE projects.project_tasks (
    task_id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id           UUID         NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id           UUID         NOT NULL REFERENCES core.branches(branch_id),
    project_id          UUID         NOT NULL REFERENCES projects.projects(project_id),
    parent_task_id      UUID         REFERENCES projects.project_tasks(task_id),
    task_number         VARCHAR(50)  NOT NULL,
    task_name           VARCHAR(255) NOT NULL,
    task_description    TEXT,
    task_type           VARCHAR(20)  NOT NULL DEFAULT 'task' CHECK (task_type IN ('milestone','task','subtask','bug','issue')),
    priority            VARCHAR(20)  NOT NULL DEFAULT 'normal' CHECK (priority IN ('low','normal','high','critical')),
    status              VARCHAR(20)  NOT NULL DEFAULT 'open' CHECK (status IN ('open','in_progress','completed','cancelled','blocked','review')),
    assigned_to         UUID         REFERENCES hr.employees(employee_id),
    planned_start_date  DATE,
    planned_end_date    DATE,
    actual_start_date   DATE,
    actual_end_date     DATE,
    estimated_hours     NUMERIC(10,2) NOT NULL DEFAULT 0,
    actual_hours        NUMERIC(10,2) NOT NULL DEFAULT 0,
    completion_percentage SMALLINT   NOT NULL DEFAULT 0 CHECK (completion_percentage BETWEEN 0 AND 100),
    is_billable         BOOLEAN      NOT NULL DEFAULT TRUE,
    created_by          UUID         NOT NULL,
    updated_by          UUID         NOT NULL,
    deleted_by          UUID,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    deleted_at          TIMESTAMPTZ,
    UNIQUE (tenant_id, project_id, task_number)
);

-- Project Resources
CREATE TABLE projects.project_resources (
    project_resource_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id           UUID         NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id           UUID         NOT NULL REFERENCES core.branches(branch_id),
    project_id          UUID         NOT NULL REFERENCES projects.projects(project_id),
    employee_id         UUID         NOT NULL REFERENCES hr.employees(employee_id),
    role_in_project     VARCHAR(100),
    allocation_percentage SMALLINT   NOT NULL DEFAULT 100 CHECK (allocation_percentage BETWEEN 0 AND 100),
    start_date          DATE         NOT NULL,
    end_date            DATE,
    hourly_rate         NUMERIC(20,4) NOT NULL DEFAULT 0,
    is_active           BOOLEAN      NOT NULL DEFAULT TRUE,
    created_by          UUID         NOT NULL,
    updated_by          UUID         NOT NULL,
    deleted_by          UUID,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    deleted_at          TIMESTAMPTZ,
    UNIQUE (tenant_id, project_id, employee_id)
);

-- Project Time Logs
CREATE TABLE projects.project_time_logs (
    time_log_id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id           UUID         NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id           UUID         NOT NULL REFERENCES core.branches(branch_id),
    project_id          UUID         NOT NULL REFERENCES projects.projects(project_id),
    task_id             UUID         REFERENCES projects.project_tasks(task_id),
    employee_id         UUID         NOT NULL REFERENCES hr.employees(employee_id),
    log_date            DATE         NOT NULL,
    hours_logged        NUMERIC(7,2) NOT NULL CHECK (hours_logged > 0),
    description         TEXT,
    is_billable         BOOLEAN      NOT NULL DEFAULT TRUE,
    billing_rate        NUMERIC(20,4) NOT NULL DEFAULT 0,
    status              VARCHAR(20)  NOT NULL DEFAULT 'draft' CHECK (status IN ('draft','submitted','approved','rejected','billed')),
    timesheet_id        UUID         REFERENCES attendance.timesheets(timesheet_id),
    created_by          UUID         NOT NULL,
    updated_by          UUID         NOT NULL,
    deleted_by          UUID,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    deleted_at          TIMESTAMPTZ
);

-- Project Issues / Risk Register
CREATE TABLE projects.project_issues (
    project_issue_id    UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id           UUID         NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id           UUID         NOT NULL REFERENCES core.branches(branch_id),
    project_id          UUID         NOT NULL REFERENCES projects.projects(project_id),
    issue_number        VARCHAR(50)  NOT NULL,
    issue_type          VARCHAR(20)  NOT NULL DEFAULT 'issue' CHECK (issue_type IN ('issue','risk','change_request','dependency')),
    title               VARCHAR(255) NOT NULL,
    description         TEXT,
    impact              VARCHAR(20)  NOT NULL DEFAULT 'medium' CHECK (impact IN ('low','medium','high','critical')),
    probability         VARCHAR(20)  DEFAULT 'medium' CHECK (probability IN ('low','medium','high')),
    status              VARCHAR(20)  NOT NULL DEFAULT 'open' CHECK (status IN ('open','in_progress','resolved','closed','accepted')),
    reported_by         UUID         NOT NULL REFERENCES hr.employees(employee_id),
    assigned_to         UUID         REFERENCES hr.employees(employee_id),
    due_date            DATE,
    resolved_at         TIMESTAMPTZ,
    mitigation_plan     TEXT,
    created_by          UUID         NOT NULL,
    updated_by          UUID         NOT NULL,
    deleted_by          UUID,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    deleted_at          TIMESTAMPTZ,
    UNIQUE (tenant_id, project_id, issue_number)
);

-- =============================================================================
-- STEP 17: SERVICE & FIELD OPERATIONS
-- =============================================================================

-- Service Contracts / AMC
CREATE TABLE service.service_contracts (
    service_contract_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id           UUID         NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id           UUID         NOT NULL REFERENCES core.branches(branch_id),
    contract_number     VARCHAR(50)  NOT NULL,
    contract_type       VARCHAR(30)  NOT NULL DEFAULT 'amc' CHECK (contract_type IN ('amc','warranty','one_time','rental','pms')),
    customer_id         UUID         NOT NULL REFERENCES sales.customers(customer_id),
    start_date          DATE         NOT NULL,
    end_date            DATE         NOT NULL,
    contract_value      NUMERIC(20,2) NOT NULL DEFAULT 0,
    billing_frequency   VARCHAR(20)  NOT NULL DEFAULT 'yearly' CHECK (billing_frequency IN ('monthly','quarterly','half_yearly','yearly','one_time')),
    status              VARCHAR(20)  NOT NULL DEFAULT 'active' CHECK (status IN ('draft','active','expired','cancelled','suspended')),
    auto_renew          BOOLEAN      NOT NULL DEFAULT FALSE,
    renewal_notice_days SMALLINT     NOT NULL DEFAULT 30,
    notes               TEXT,
    created_by          UUID         NOT NULL,
    updated_by          UUID         NOT NULL,
    deleted_by          UUID,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    deleted_at          TIMESTAMPTZ,
    UNIQUE (tenant_id, branch_id, contract_number)
);

-- Service Tickets
CREATE TABLE service.service_tickets (
    service_ticket_id   UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id           UUID         NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id           UUID         NOT NULL REFERENCES core.branches(branch_id),
    ticket_number       VARCHAR(50)  NOT NULL,
    ticket_type         VARCHAR(30)  NOT NULL DEFAULT 'breakdown' CHECK (ticket_type IN ('breakdown','preventive','installation','inspection','warranty','complaint')),
    priority            VARCHAR(20)  NOT NULL DEFAULT 'normal' CHECK (priority IN ('low','normal','high','critical')),
    customer_id         UUID         NOT NULL REFERENCES sales.customers(customer_id),
    service_contract_id UUID         REFERENCES service.service_contracts(service_contract_id),
    item_id             UUID         REFERENCES inventory.items(item_id),
    serial_number_id    UUID         REFERENCES inventory.serial_numbers(serial_number_id),
    complaint_description TEXT       NOT NULL,
    assigned_technician_id UUID      REFERENCES hr.employees(employee_id),
    scheduled_at        TIMESTAMPTZ,
    started_at          TIMESTAMPTZ,
    completed_at        TIMESTAMPTZ,
    sla_due_at          TIMESTAMPTZ,
    resolution_notes    TEXT,
    status              VARCHAR(20)  NOT NULL DEFAULT 'open' CHECK (status IN ('open','assigned','in_transit','in_progress','completed','billed','cancelled')),
    customer_signature  TEXT,
    customer_rating     SMALLINT     CHECK (customer_rating BETWEEN 1 AND 5),
    created_by          UUID         NOT NULL,
    updated_by          UUID         NOT NULL,
    deleted_by          UUID,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    deleted_at          TIMESTAMPTZ,
    UNIQUE (tenant_id, branch_id, ticket_number)
);

-- Parts Used on Service (service BOM)
CREATE TABLE service.service_parts_consumed (
    service_part_id     UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id           UUID         NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id           UUID         NOT NULL REFERENCES core.branches(branch_id),
    service_ticket_id   UUID         NOT NULL REFERENCES service.service_tickets(service_ticket_id),
    item_id             UUID         NOT NULL REFERENCES inventory.items(item_id),
    uom_id              UUID         NOT NULL REFERENCES inventory.units_of_measure(uom_id),
    quantity            NUMERIC(20,4) NOT NULL CHECK (quantity > 0),
    unit_price          NUMERIC(20,4) NOT NULL DEFAULT 0,
    is_billable         BOOLEAN      NOT NULL DEFAULT TRUE,
    warehouse_id        UUID         REFERENCES inventory.warehouses(warehouse_id),
    created_by          UUID         NOT NULL,
    updated_by          UUID         NOT NULL,
    deleted_by          UUID,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    deleted_at          TIMESTAMPTZ
);

-- Technician GPS Tracking
CREATE TABLE service.technician_location_logs (
    location_log_id     UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id           UUID         NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id           UUID         NOT NULL REFERENCES core.branches(branch_id),
    employee_id         UUID         NOT NULL REFERENCES hr.employees(employee_id),
    service_ticket_id   UUID         REFERENCES service.service_tickets(service_ticket_id),
    latitude            NUMERIC(11,8) NOT NULL,
    longitude           NUMERIC(11,8) NOT NULL,
    accuracy_meters     NUMERIC(8,2),
    logged_at           TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    created_by          UUID         NOT NULL,
    updated_by          UUID         NOT NULL,
    deleted_by          UUID,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    deleted_at          TIMESTAMPTZ
) PARTITION BY RANGE (logged_at);

CREATE TABLE service.technician_location_logs_2026 PARTITION OF service.technician_location_logs
    FOR VALUES FROM ('2026-01-01') TO ('2027-01-01');

-- =============================================================================
-- INDEXES — Assets, Projects, Service
-- =============================================================================

CREATE INDEX idx_assets_category ON assets.assets(tenant_id, asset_category_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_assets_status ON assets.assets(tenant_id, status) WHERE deleted_at IS NULL;
CREATE INDEX idx_assets_assigned ON assets.assets(assigned_to) WHERE deleted_at IS NULL;
CREATE INDEX idx_maintenance_asset ON assets.asset_maintenance_records(asset_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_dep_entries_asset ON assets.depreciation_entries(asset_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_projects_status ON projects.projects(tenant_id, status) WHERE deleted_at IS NULL;
CREATE INDEX idx_projects_manager ON projects.projects(project_manager_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_tasks_project ON projects.project_tasks(project_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_tasks_assigned ON projects.project_tasks(assigned_to) WHERE deleted_at IS NULL;
CREATE INDEX idx_time_logs_project ON projects.project_time_logs(project_id, log_date) WHERE deleted_at IS NULL;
CREATE INDEX idx_time_logs_emp ON projects.project_time_logs(employee_id, log_date) WHERE deleted_at IS NULL;
CREATE INDEX idx_service_tickets_status ON service.service_tickets(tenant_id, status) WHERE deleted_at IS NULL;
CREATE INDEX idx_service_tickets_tech ON service.service_tickets(assigned_technician_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_service_tickets_sla ON service.service_tickets(sla_due_at) WHERE status NOT IN ('completed','cancelled');
CREATE INDEX idx_location_logs_emp ON service.technician_location_logs(employee_id, logged_at);
