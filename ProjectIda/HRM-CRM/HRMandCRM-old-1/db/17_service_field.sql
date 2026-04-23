-- =====================================================================
-- STEP 17: Service & Field Operations
-- =====================================================================

CREATE TABLE service.service_contract (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    company_id      UUID NOT NULL,
    doc_no          TEXT NOT NULL,
    customer_id     UUID NOT NULL REFERENCES sales.customer(id),
    contract_type   TEXT CHECK (contract_type IN ('amc','warranty','lease','sla','one_time')),
    start_date      DATE NOT NULL,
    end_date        DATE NOT NULL,
    contract_value  core.money_amt,
    currency_code   CHAR(3),
    visits_included INT,
    visits_used     INT DEFAULT 0,
    auto_renew      BOOLEAN DEFAULT FALSE,
    status          TEXT DEFAULT 'active' CHECK (status IN ('active','expired','cancelled','suspended','renewed')),
    sla_id          UUID REFERENCES crm.sla(id),
    UNIQUE (company_id, doc_no)
);

CREATE TABLE service.covered_asset (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    service_contract_id UUID NOT NULL REFERENCES service.service_contract(id) ON DELETE CASCADE,
    item_id         UUID REFERENCES inventory.item(id),
    serial_no       TEXT,
    model_no        TEXT,
    warranty_start  DATE,
    warranty_end    DATE,
    location        JSONB
);

CREATE TABLE service.warranty (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    item_id         UUID REFERENCES inventory.item(id),
    serial_no       TEXT,
    customer_id     UUID REFERENCES sales.customer(id),
    start_date      DATE NOT NULL,
    end_date        DATE NOT NULL,
    warranty_type   TEXT CHECK (warranty_type IN ('standard','extended','third_party')),
    terms           TEXT,
    invoice_id      UUID REFERENCES sales.sales_invoice(id)
);

CREATE TABLE service.service_ticket (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    company_id      UUID NOT NULL,
    doc_no          TEXT NOT NULL,
    raised_date     TIMESTAMPTZ DEFAULT NOW(),
    customer_id     UUID REFERENCES sales.customer(id),
    contact_id      UUID REFERENCES crm.contact(id),
    service_contract_id UUID REFERENCES service.service_contract(id),
    item_id         UUID REFERENCES inventory.item(id),
    serial_no       TEXT,
    problem_description TEXT NOT NULL,
    priority        TEXT CHECK (priority IN ('low','medium','high','urgent')),
    severity        TEXT,
    channel         TEXT,
    location        JSONB,
    geo_location    POINT,
    sla_id          UUID REFERENCES crm.sla(id),
    sla_deadline    TIMESTAMPTZ,
    status          TEXT DEFAULT 'open' CHECK (status IN ('open','assigned','in_progress','pending_customer','pending_parts','resolved','closed','cancelled','reopened')),
    assigned_technician_id UUID REFERENCES hr.employee(id),
    scheduled_at    TIMESTAMPTZ,
    started_at      TIMESTAMPTZ,
    resolved_at     TIMESTAMPTZ,
    closed_at       TIMESTAMPTZ,
    resolution      TEXT,
    csat_score      INT,
    is_billable     BOOLEAN DEFAULT FALSE,
    total_billable_amount core.money_amt,
    UNIQUE (company_id, doc_no)
);

CREATE TABLE service.service_visit (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    ticket_id       UUID NOT NULL REFERENCES service.service_ticket(id) ON DELETE CASCADE,
    technician_id   UUID REFERENCES hr.employee(id),
    visit_type      TEXT CHECK (visit_type IN ('preventive','corrective','installation','inspection','callback')),
    scheduled_at    TIMESTAMPTZ,
    started_at      TIMESTAMPTZ,
    ended_at        TIMESTAMPTZ,
    geo_checkin     POINT,
    geo_checkout    POINT,
    travel_km       NUMERIC(8,2),
    labor_hours     NUMERIC(6,2),
    diagnosis       TEXT,
    action_taken    TEXT,
    customer_signature_url TEXT,
    photos          JSONB,
    status          TEXT DEFAULT 'scheduled' CHECK (status IN ('scheduled','en_route','on_site','completed','cancelled','no_show'))
);

CREATE TABLE service.parts_consumption (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    visit_id        UUID NOT NULL REFERENCES service.service_visit(id) ON DELETE CASCADE,
    item_id         UUID NOT NULL REFERENCES inventory.item(id),
    qty             core.qty_amt NOT NULL,
    unit_price      core.money_amt,
    is_under_warranty BOOLEAN DEFAULT FALSE,
    stock_entry_id  UUID REFERENCES inventory.stock_entry(id)
);

CREATE TABLE service.service_billing (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    ticket_id       UUID NOT NULL REFERENCES service.service_ticket(id),
    labor_charges   core.money_amt DEFAULT 0,
    parts_charges   core.money_amt DEFAULT 0,
    travel_charges  core.money_amt DEFAULT 0,
    other_charges   core.money_amt DEFAULT 0,
    total           core.money_amt,
    invoice_id      UUID REFERENCES sales.sales_invoice(id),
    billed_at       TIMESTAMPTZ
);

CREATE TABLE service.technician_availability (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    technician_id   UUID NOT NULL REFERENCES hr.employee(id),
    available_date  DATE NOT NULL,
    start_time      TIME,
    end_time        TIME,
    skills          TEXT[],
    max_tickets     INT,
    current_load    INT DEFAULT 0,
    UNIQUE (technician_id, available_date)
);

CREATE TABLE service.route (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    technician_id   UUID REFERENCES hr.employee(id),
    route_date      DATE NOT NULL,
    start_location  POINT,
    end_location    POINT,
    total_distance_km NUMERIC(8,2),
    estimated_duration_min INT,
    status          TEXT DEFAULT 'planned'
);

CREATE TABLE service.route_stop (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    route_id        UUID NOT NULL REFERENCES service.route(id) ON DELETE CASCADE,
    sequence_no     INT NOT NULL,
    ticket_id       UUID REFERENCES service.service_ticket(id),
    location        POINT,
    eta             TIMESTAMPTZ,
    actual_arrival  TIMESTAMPTZ,
    actual_departure TIMESTAMPTZ
);

CREATE TABLE service.gps_tracking (
    id              BIGSERIAL,
    technician_id   UUID NOT NULL,
    tracked_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    location        POINT NOT NULL,
    speed_kmph      NUMERIC(6,2),
    battery_pct     NUMERIC(5,2),
    PRIMARY KEY (id, tracked_at)
) PARTITION BY RANGE (tracked_at);
CREATE TABLE service.gps_tracking_default PARTITION OF service.gps_tracking DEFAULT;

-- =====================================================================
-- INDEXES
-- =====================================================================
CREATE INDEX idx_contract_customer     ON service.service_contract(customer_id, status);
CREATE INDEX idx_contract_expiry       ON service.service_contract(end_date) WHERE status = 'active';
CREATE INDEX idx_ticket_status         ON service.service_ticket(company_id, status, priority);
CREATE INDEX idx_ticket_technician     ON service.service_ticket(assigned_technician_id, status);
CREATE INDEX idx_ticket_sla            ON service.service_ticket(sla_deadline) WHERE status NOT IN ('resolved','closed');
CREATE INDEX idx_visit_ticket          ON service.service_visit(ticket_id);
CREATE INDEX idx_gps_tech_time         ON service.gps_tracking(technician_id, tracked_at DESC);

-- =====================================================================
-- FUNCTIONS
-- =====================================================================
CREATE OR REPLACE FUNCTION service.fn_assign_technician(p_ticket UUID, p_tech UUID)
RETURNS VOID AS $$
BEGIN
    UPDATE service.service_ticket
       SET assigned_technician_id = p_tech, status='assigned'
     WHERE id = p_ticket;
    UPDATE service.technician_availability
       SET current_load = current_load + 1
     WHERE technician_id = p_tech AND available_date = CURRENT_DATE;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION service.fn_sla_deadline(p_ticket UUID)
RETURNS TIMESTAMPTZ AS $$
    SELECT t.raised_date + (s.resolution_min || ' minutes')::interval
      FROM service.service_ticket t JOIN crm.sla s ON s.id = t.sla_id
     WHERE t.id = p_ticket;
$$ LANGUAGE sql STABLE;

-- =====================================================================
-- VIEWS
-- =====================================================================
CREATE OR REPLACE VIEW service.v_open_tickets AS
SELECT t.*, c.display_name AS customer_name, e.full_name AS technician_name
  FROM service.service_ticket t
  LEFT JOIN sales.customer c ON c.id = t.customer_id
  LEFT JOIN hr.employee e ON e.id = t.assigned_technician_id
 WHERE t.status NOT IN ('resolved','closed','cancelled');

CREATE OR REPLACE VIEW service.v_expiring_contracts AS
SELECT sc.*, c.display_name AS customer_name
  FROM service.service_contract sc JOIN sales.customer c ON c.id = sc.customer_id
 WHERE sc.status = 'active' AND sc.end_date <= CURRENT_DATE + INTERVAL '30 days';
