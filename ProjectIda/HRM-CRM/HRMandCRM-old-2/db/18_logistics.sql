-- =====================================================================
-- Module 18: Logistics & Warehouse
-- Shipments, carriers, routes, track & trace, POD, cross-dock
-- =====================================================================

SET search_path = app, core, public;

-- =============== SCHEMA ===============

CREATE TABLE IF NOT EXISTS app.carriers (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  code            citext NOT NULL,
  name            text NOT NULL,
  carrier_type    text NOT NULL CHECK (carrier_type IN ('courier','ltl','ftl','3pl','parcel','air','ocean','rail')),
  service_types   text[] NOT NULL DEFAULT '{}',
  api_config      jsonb,
  is_integrated   boolean NOT NULL DEFAULT false,
  active          boolean NOT NULL DEFAULT true,
  rating          numeric(3,2),
  created_at      timestamptz NOT NULL DEFAULT now(),
  updated_at      timestamptz NOT NULL DEFAULT now(),
  created_by      uuid, updated_by uuid, version int NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, code)
);

CREATE TABLE IF NOT EXISTS app.shipments (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  company_id      uuid NOT NULL REFERENCES app.companies(id),
  shipment_number text NOT NULL,
  shipment_date   date NOT NULL,
  shipment_type   text NOT NULL CHECK (shipment_type IN ('outbound','inbound','transfer','return')),
  reference_type  text CHECK (reference_type IN (NULL,'delivery','sales_order','po','transfer','grn','return')),
  reference_id    uuid,
  origin          jsonb NOT NULL,
  destination     jsonb NOT NULL,
  carrier_id      uuid REFERENCES app.carriers(id),
  service_level   text,
  tracking_number text,
  awb_number      text,
  eway_bill_no    text,
  weight_kg       numeric(12,4),
  dimensions_cm   jsonb,
  piece_count     int,
  freight_cost    numeric(19,4),
  declared_value  numeric(19,4),
  shipped_at      timestamptz,
  estimated_delivery timestamptz,
  delivered_at    timestamptz,
  pod_document_id uuid REFERENCES app.documents(id),
  status          text NOT NULL DEFAULT 'planned'
                  CHECK (status IN ('planned','booked','picked','packed','shipped','in_transit','out_for_delivery','delivered','returned','lost','damaged','cancelled')),
  metadata        jsonb NOT NULL DEFAULT '{}'::jsonb,
  created_at      timestamptz NOT NULL DEFAULT now(),
  updated_at      timestamptz NOT NULL DEFAULT now(),
  created_by      uuid, updated_by uuid, version int NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, company_id, shipment_number)
);

CREATE TABLE IF NOT EXISTS app.shipment_lines (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  shipment_id     uuid NOT NULL REFERENCES app.shipments(id) ON DELETE CASCADE,
  line_no         smallint NOT NULL,
  item_id         uuid,
  description     text,
  qty             numeric(19,6) NOT NULL CHECK (qty > 0),
  uom_code        text NOT NULL,
  weight_kg       numeric(12,4),
  delivery_line_id uuid REFERENCES app.delivery_lines(id),
  UNIQUE (shipment_id, line_no)
);

CREATE TABLE IF NOT EXISTS app.tracking_events (
  id              uuid NOT NULL DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  shipment_id     uuid NOT NULL,
  event_code      text NOT NULL,
  description     text NOT NULL,
  location        text,
  location_lat    numeric(10,7), location_lng numeric(10,7),
  occurred_at     timestamptz NOT NULL,
  received_at     timestamptz NOT NULL DEFAULT now(),
  raw_payload     jsonb,
  PRIMARY KEY (id, occurred_at)
) PARTITION BY RANGE (occurred_at);

CREATE TABLE IF NOT EXISTS app.tracking_events_2026 PARTITION OF app.tracking_events
  FOR VALUES FROM ('2026-01-01') TO ('2027-01-01');
CREATE TABLE IF NOT EXISTS app.tracking_events_default PARTITION OF app.tracking_events DEFAULT;

CREATE TABLE IF NOT EXISTS app.delivery_routes (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  route_date      date NOT NULL,
  route_code      text,
  vehicle_number  text,
  driver_employee_id uuid REFERENCES app.employees(id),
  origin_warehouse_id uuid REFERENCES app.warehouses(id),
  stop_order      uuid[] NOT NULL DEFAULT '{}',
  total_distance_km numeric(9,2),
  estimated_duration_min int,
  status          text NOT NULL DEFAULT 'planned'
                  CHECK (status IN ('planned','in_progress','completed','cancelled')),
  created_at      timestamptz NOT NULL DEFAULT now(),
  updated_at      timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS app.cross_dock_receipts (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  warehouse_id    uuid NOT NULL REFERENCES app.warehouses(id),
  inbound_shipment_id uuid REFERENCES app.shipments(id),
  outbound_shipment_id uuid REFERENCES app.shipments(id),
  item_id         uuid NOT NULL,
  qty             numeric(19,6) NOT NULL,
  uom_code        text NOT NULL,
  arrived_at      timestamptz NOT NULL DEFAULT now(),
  shipped_at      timestamptz,
  status          text NOT NULL DEFAULT 'arrived'
                  CHECK (status IN ('arrived','sorted','loaded','shipped','stored_instead'))
);

-- =============== INDEXES ===============
CREATE INDEX IF NOT EXISTS idx_carriers_active    ON app.carriers(tenant_id) WHERE active;
CREATE INDEX IF NOT EXISTS idx_ship_ref           ON app.shipments(reference_type, reference_id);
CREATE INDEX IF NOT EXISTS idx_ship_tracking      ON app.shipments(tracking_number) WHERE tracking_number IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_ship_status_date   ON app.shipments(tenant_id, status, shipment_date DESC);
CREATE INDEX IF NOT EXISTS idx_ship_eta           ON app.shipments(estimated_delivery) WHERE status IN ('shipped','in_transit','out_for_delivery');
CREATE INDEX IF NOT EXISTS idx_shipline_ship      ON app.shipment_lines(shipment_id);
CREATE INDEX IF NOT EXISTS idx_track_ship         ON app.tracking_events(shipment_id, occurred_at DESC);
CREATE INDEX IF NOT EXISTS idx_droute_date        ON app.delivery_routes(route_date, status);
CREATE INDEX IF NOT EXISTS idx_xdock_wh_status    ON app.cross_dock_receipts(warehouse_id, status);

-- =============== RLS + TRIGGERS ===============
SELECT core.enable_tenant_rls('app.carriers');
SELECT core.enable_tenant_rls('app.shipments');
SELECT core.enable_tenant_rls('app.shipment_lines');
SELECT core.enable_tenant_rls('app.tracking_events');
SELECT core.enable_tenant_rls('app.delivery_routes');
SELECT core.enable_tenant_rls('app.cross_dock_receipts');

SELECT core.attach_standard_triggers('app.carriers');
SELECT core.attach_standard_triggers('app.shipments');
SELECT core.attach_standard_triggers('app.delivery_routes');

-- =============== FUNCTIONS / VIEWS ===============

-- Latest event per shipment
CREATE OR REPLACE VIEW app.v_shipment_last_event AS
SELECT DISTINCT ON (shipment_id)
       shipment_id, event_code, description, location, occurred_at
  FROM app.tracking_events
 ORDER BY shipment_id, occurred_at DESC;

CREATE OR REPLACE VIEW app.v_on_time_delivery AS
SELECT tenant_id,
       date_trunc('month', shipment_date)::date AS month,
       COUNT(*) total,
       COUNT(*) FILTER (WHERE delivered_at <= estimated_delivery)    AS on_time,
       round(COUNT(*) FILTER (WHERE delivered_at <= estimated_delivery)::numeric
             / NULLIF(COUNT(*),0) * 100, 2) AS on_time_pct
  FROM app.shipments
 WHERE status = 'delivered' AND estimated_delivery IS NOT NULL
 GROUP BY 1,2;

-- Add tracking event (idempotent — dedupe on event_code + occurred_at)
CREATE OR REPLACE FUNCTION app.add_tracking_event(
  p_shipment_id uuid, p_event_code text, p_description text,
  p_location text, p_occurred_at timestamptz, p_payload jsonb DEFAULT NULL
) RETURNS uuid
LANGUAGE plpgsql AS $$
DECLARE v_id uuid;
BEGIN
  SELECT id INTO v_id FROM app.tracking_events
   WHERE shipment_id = p_shipment_id AND event_code = p_event_code AND occurred_at = p_occurred_at;
  IF v_id IS NOT NULL THEN RETURN v_id; END IF;

  v_id := gen_random_uuid();
  INSERT INTO app.tracking_events(id,tenant_id,shipment_id,event_code,description,location,occurred_at,raw_payload)
  VALUES (v_id, core.require_tenant(), p_shipment_id, p_event_code, p_description, p_location, p_occurred_at, p_payload);

  -- Reflect key statuses on shipment
  IF p_event_code = 'DELIVERED' THEN
    UPDATE app.shipments SET status='delivered', delivered_at = p_occurred_at WHERE id = p_shipment_id;
  ELSIF p_event_code IN ('OUT_FOR_DELIVERY','IN_TRANSIT','SHIPPED') THEN
    UPDATE app.shipments SET status=lower(p_event_code) WHERE id = p_shipment_id;
  END IF;
  RETURN v_id;
END $$;
