-- =====================================================================
-- Module 17: Service & Field Operations
-- AMC/warranty, service tickets, technician dispatch, routes, field visits
-- =====================================================================

SET search_path = app, core, public;

-- =============== SCHEMA ===============

CREATE TABLE IF NOT EXISTS app.service_contracts (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  company_id      uuid NOT NULL REFERENCES app.companies(id),
  contract_number text NOT NULL,
  customer_id     uuid NOT NULL REFERENCES app.customers(id),
  contract_type   text NOT NULL CHECK (contract_type IN ('amc','cmc','warranty','sla','prepaid','pay_per_use')),
  start_date      date NOT NULL,
  end_date        date NOT NULL,
  total_visits_included int,
  visits_consumed int NOT NULL DEFAULT 0,
  contract_value  numeric(19,4) NOT NULL DEFAULT 0,
  billing_frequency text CHECK (billing_frequency IN (NULL,'monthly','quarterly','yearly','one_time')),
  auto_renew      boolean NOT NULL DEFAULT false,
  status          text NOT NULL DEFAULT 'active'
                  CHECK (status IN ('draft','active','suspended','expired','cancelled','renewed')),
  created_at      timestamptz NOT NULL DEFAULT now(),
  updated_at      timestamptz NOT NULL DEFAULT now(),
  created_by      uuid, updated_by uuid, version int NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, company_id, contract_number),
  CHECK (end_date > start_date)
);

CREATE TABLE IF NOT EXISTS app.service_contract_items (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  contract_id     uuid NOT NULL REFERENCES app.service_contracts(id) ON DELETE CASCADE,
  item_id         uuid,
  asset_id        uuid REFERENCES app.assets(id),
  serial_no       text,
  coverage_details text
);

CREATE TABLE IF NOT EXISTS app.warranties (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  item_id         uuid,
  serial_no       text,
  customer_id     uuid REFERENCES app.customers(id),
  warranty_type   text NOT NULL CHECK (warranty_type IN ('manufacturer','extended','service')),
  start_date      date NOT NULL,
  end_date        date NOT NULL,
  terms           text,
  claim_count     int NOT NULL DEFAULT 0,
  status          text NOT NULL DEFAULT 'active' CHECK (status IN ('active','expired','voided','claimed')),
  UNIQUE (tenant_id, item_id, serial_no),
  CHECK (end_date > start_date)
);

CREATE TABLE IF NOT EXISTS app.technicians (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  employee_id     uuid NOT NULL REFERENCES app.employees(id) ON DELETE CASCADE,
  tech_code       citext NOT NULL,
  specialization  text[],
  base_location   jsonb,
  current_location jsonb,
  current_location_updated_at timestamptz,
  available       boolean NOT NULL DEFAULT true,
  max_visits_per_day int NOT NULL DEFAULT 6,
  rating          numeric(3,2),
  UNIQUE (tenant_id, tech_code)
);

CREATE TABLE IF NOT EXISTS app.service_tickets (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  company_id      uuid NOT NULL REFERENCES app.companies(id),
  ticket_number   text NOT NULL,
  customer_id     uuid NOT NULL REFERENCES app.customers(id),
  contract_id     uuid REFERENCES app.service_contracts(id),
  warranty_id     uuid REFERENCES app.warranties(id),
  asset_id        uuid REFERENCES app.assets(id),
  service_type    text NOT NULL CHECK (service_type IN ('installation','maintenance','repair','inspection','replacement','consulting')),
  priority        text NOT NULL DEFAULT 'normal' CHECK (priority IN ('low','normal','high','urgent','critical')),
  severity        text CHECK (severity IN (NULL,'minor','major','critical','blocker')),
  reported_issue  text NOT NULL,
  service_address jsonb,
  location_lat    numeric(10,7), location_lng numeric(10,7),
  reported_at     timestamptz NOT NULL DEFAULT now(),
  scheduled_at    timestamptz,
  sla_response_at timestamptz,
  sla_resolve_at  timestamptz,
  first_response_at timestamptz,
  resolved_at     timestamptz,
  closed_at       timestamptz,
  status          text NOT NULL DEFAULT 'open'
                  CHECK (status IN ('open','assigned','scheduled','in_progress','on_hold','resolved','closed','cancelled','escalated')),
  assigned_tech_id uuid REFERENCES app.technicians(id),
  is_billable     boolean NOT NULL DEFAULT false,
  billable_amount numeric(19,4),
  sales_invoice_id uuid REFERENCES app.sales_invoices(id),
  metadata        jsonb NOT NULL DEFAULT '{}'::jsonb,
  created_at      timestamptz NOT NULL DEFAULT now(),
  updated_at      timestamptz NOT NULL DEFAULT now(),
  created_by      uuid, updated_by uuid, version int NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, company_id, ticket_number)
);

CREATE TABLE IF NOT EXISTS app.service_visits (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  ticket_id       uuid NOT NULL REFERENCES app.service_tickets(id) ON DELETE CASCADE,
  visit_number    int NOT NULL,
  scheduled_at    timestamptz NOT NULL,
  tech_id         uuid REFERENCES app.technicians(id),
  check_in_at     timestamptz, check_out_at timestamptz,
  status          text NOT NULL DEFAULT 'scheduled'
                  CHECK (status IN ('scheduled','in_progress','completed','missed','cancelled','rescheduled')),
  work_performed  text,
  customer_signature_document_id uuid REFERENCES app.documents(id),
  customer_rating smallint CHECK (customer_rating IS NULL OR customer_rating BETWEEN 1 AND 5),
  customer_feedback text,
  check_in_location jsonb,
  check_out_location jsonb,
  UNIQUE (ticket_id, visit_number)
);

CREATE TABLE IF NOT EXISTS app.service_parts_used (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  visit_id        uuid NOT NULL REFERENCES app.service_visits(id) ON DELETE CASCADE,
  item_id         uuid NOT NULL,
  qty             numeric(19,6) NOT NULL CHECK (qty > 0),
  uom_code        text NOT NULL,
  unit_rate       numeric(19,4),
  is_covered      boolean NOT NULL DEFAULT false,
  warehouse_id    uuid REFERENCES app.warehouses(id)
);

CREATE TABLE IF NOT EXISTS app.service_routes (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  route_date      date NOT NULL,
  tech_id         uuid NOT NULL REFERENCES app.technicians(id),
  visit_order     uuid[] NOT NULL DEFAULT '{}',      -- ordered visit IDs
  optimized       boolean NOT NULL DEFAULT false,
  total_distance_km numeric(9,2),
  total_duration_min int,
  UNIQUE (tech_id, route_date)
);

-- =============== INDEXES ===============
CREATE INDEX IF NOT EXISTS idx_contracts_cust      ON app.service_contracts(customer_id, status);
CREATE INDEX IF NOT EXISTS idx_contracts_expiry    ON app.service_contracts(end_date) WHERE status='active';
CREATE INDEX IF NOT EXISTS idx_warranty_item       ON app.warranties(item_id, serial_no);
CREATE INDEX IF NOT EXISTS idx_warranty_expiry     ON app.warranties(end_date) WHERE status='active';
CREATE INDEX IF NOT EXISTS idx_tech_available      ON app.technicians(tenant_id) WHERE available;
CREATE INDEX IF NOT EXISTS idx_stkt_customer_date  ON app.service_tickets(customer_id, reported_at DESC);
CREATE INDEX IF NOT EXISTS idx_stkt_status_prio    ON app.service_tickets(tenant_id, status, priority);
CREATE INDEX IF NOT EXISTS idx_stkt_sla_breach     ON app.service_tickets(sla_resolve_at) WHERE status NOT IN ('resolved','closed','cancelled');
CREATE INDEX IF NOT EXISTS idx_stkt_tech           ON app.service_tickets(assigned_tech_id, status) WHERE status NOT IN ('resolved','closed');
CREATE INDEX IF NOT EXISTS idx_visits_sched        ON app.service_visits(scheduled_at);
CREATE INDEX IF NOT EXISTS idx_visits_tech         ON app.service_visits(tech_id, scheduled_at);
CREATE INDEX IF NOT EXISTS idx_parts_visit         ON app.service_parts_used(visit_id);
CREATE INDEX IF NOT EXISTS idx_route_date_tech     ON app.service_routes(route_date, tech_id);

-- =============== RLS + TRIGGERS ===============
SELECT core.enable_tenant_rls('app.service_contracts');
SELECT core.enable_tenant_rls('app.service_contract_items');
SELECT core.enable_tenant_rls('app.warranties');
SELECT core.enable_tenant_rls('app.technicians');
SELECT core.enable_tenant_rls('app.service_tickets');
SELECT core.enable_tenant_rls('app.service_visits');
SELECT core.enable_tenant_rls('app.service_parts_used');
SELECT core.enable_tenant_rls('app.service_routes');

SELECT core.attach_standard_triggers('app.service_contracts');
SELECT core.attach_standard_triggers('app.warranties');
SELECT core.attach_standard_triggers('app.service_tickets');

-- =============== FUNCTIONS / VIEWS ===============

-- Consume parts on visit → stock outflow
CREATE OR REPLACE FUNCTION core.tg_parts_to_stock()
RETURNS trigger LANGUAGE plpgsql AS $$
DECLARE v_company uuid;
BEGIN
  SELECT st.company_id INTO v_company
    FROM app.service_visits sv JOIN app.service_tickets st ON st.id = sv.ticket_id
   WHERE sv.id = NEW.visit_id;

  PERFORM app.post_stock_entry(
    p_company_id   := v_company,
    p_item_id      := NEW.item_id,
    p_warehouse_id := NEW.warehouse_id,
    p_qty          := -NEW.qty,
    p_unit_rate    := COALESCE(NEW.unit_rate, 0),
    p_txn_type     := 'sales_delivery',
    p_posting_date := CURRENT_DATE,
    p_uom          := NEW.uom_code,
    p_source_table := 'service_parts_used',
    p_source_id    := NEW.id);
  RETURN NEW;
END $$;
DROP TRIGGER IF EXISTS trg_parts_to_stock ON app.service_parts_used;
CREATE TRIGGER trg_parts_to_stock
  AFTER INSERT ON app.service_parts_used
  FOR EACH ROW WHEN (NEW.warehouse_id IS NOT NULL)
  EXECUTE FUNCTION core.tg_parts_to_stock();

CREATE OR REPLACE VIEW app.v_tech_utilization AS
SELECT sv.tenant_id, sv.tech_id, t.tech_code,
       date_trunc('day', sv.scheduled_at)::date AS day,
       COUNT(*) visits_scheduled,
       COUNT(*) FILTER (WHERE sv.status='completed') visits_completed,
       AVG(EXTRACT(EPOCH FROM (sv.check_out_at - sv.check_in_at))/60) AS avg_minutes_per_visit
  FROM app.service_visits sv
  JOIN app.technicians t ON t.id = sv.tech_id
 GROUP BY 1,2,3,4;

CREATE OR REPLACE VIEW app.v_contract_expiring AS
SELECT sc.tenant_id, sc.contract_number, sc.customer_id, sc.end_date,
       sc.end_date - CURRENT_DATE AS days_to_expire
  FROM app.service_contracts sc
 WHERE sc.status = 'active' AND sc.end_date <= CURRENT_DATE + interval '60 days';
