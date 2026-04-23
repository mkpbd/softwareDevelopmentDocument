-- =====================================================================
-- Module 07: Inventory Management
-- Covers PRD Step 7 (items, UoM, warehouses, stock ledger, FIFO/WAC
-- valuation layers, batch/serial/expiry, reorder, barcode, bin, reservation)
-- =====================================================================

SET search_path = app, core, public;

-- =============== SCHEMA ===============

CREATE TABLE IF NOT EXISTS app.uoms (
  tenant_id     uuid NOT NULL,
  code          citext NOT NULL,
  name          text NOT NULL,
  category      text NOT NULL DEFAULT 'unit'
                CHECK (category IN ('unit','weight','volume','length','area','time')),
  active        boolean NOT NULL DEFAULT true,
  created_at    timestamptz NOT NULL DEFAULT now(),
  updated_at    timestamptz NOT NULL DEFAULT now(),
  created_by    uuid, updated_by uuid, version int NOT NULL DEFAULT 1,
  PRIMARY KEY (tenant_id, code)
);

CREATE TABLE IF NOT EXISTS app.uom_conversions (
  id            uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id     uuid NOT NULL,
  item_id       uuid,                     -- NULL = global for base unit category
  from_uom      text NOT NULL,
  to_uom        text NOT NULL,
  factor        numeric(19,8) NOT NULL CHECK (factor > 0),
  created_at    timestamptz NOT NULL DEFAULT now(),
  updated_at    timestamptz NOT NULL DEFAULT now(),
  created_by    uuid, updated_by uuid, version int NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, item_id, from_uom, to_uom),
  CHECK (from_uom <> to_uom)
);

CREATE TABLE IF NOT EXISTS app.item_categories (
  id            uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id     uuid NOT NULL,
  parent_id     uuid REFERENCES app.item_categories(id),
  code          citext NOT NULL,
  name          text NOT NULL,
  path          ltree,
  active        boolean NOT NULL DEFAULT true,
  created_at    timestamptz NOT NULL DEFAULT now(),
  updated_at    timestamptz NOT NULL DEFAULT now(),
  created_by    uuid, updated_by uuid, version int NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, code)
);

CREATE TABLE IF NOT EXISTS app.items (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  company_id      uuid NOT NULL REFERENCES app.companies(id),
  code            citext NOT NULL,
  sku             citext,
  name            text NOT NULL,
  description     text,
  category_id     uuid REFERENCES app.item_categories(id),
  item_type       text NOT NULL DEFAULT 'goods'
                  CHECK (item_type IN ('goods','service','consumable','asset','raw_material','finished_good','wip','scrap','kit')),
  track_inventory boolean NOT NULL DEFAULT true,
  maintain_stock  boolean NOT NULL DEFAULT true,
  has_batch       boolean NOT NULL DEFAULT false,
  has_serial      boolean NOT NULL DEFAULT false,
  has_expiry      boolean NOT NULL DEFAULT false,
  stock_uom       text NOT NULL,
  purchase_uom    text,
  sales_uom       text,
  valuation_method text NOT NULL DEFAULT 'WAC'
                  CHECK (valuation_method IN ('FIFO','LIFO','WAC','STANDARD')),
  standard_cost   numeric(19,4),
  std_sell_price  numeric(19,4),
  min_order_qty   numeric(19,6) NOT NULL DEFAULT 0,
  reorder_level   numeric(19,6),
  reorder_qty     numeric(19,6),
  lead_time_days  smallint,
  hsn_sac         text,
  default_tax_rate numeric(5,2),
  barcode         text,
  weight_kg       numeric(12,4),
  volume_m3       numeric(12,4),
  is_sales        boolean NOT NULL DEFAULT true,
  is_purchase     boolean NOT NULL DEFAULT true,
  active          boolean NOT NULL DEFAULT true,
  attributes      jsonb NOT NULL DEFAULT '{}'::jsonb,
  created_at      timestamptz NOT NULL DEFAULT now(),
  updated_at      timestamptz NOT NULL DEFAULT now(),
  created_by      uuid, updated_by uuid, version int NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, company_id, code)
);

CREATE TABLE IF NOT EXISTS app.item_variants (
  id            uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id     uuid NOT NULL,
  item_id       uuid NOT NULL REFERENCES app.items(id) ON DELETE CASCADE,
  variant_code  citext NOT NULL,
  sku           citext,
  attributes    jsonb NOT NULL DEFAULT '{}'::jsonb,   -- e.g. {color:red,size:L}
  barcode       text,
  active        boolean NOT NULL DEFAULT true,
  created_at    timestamptz NOT NULL DEFAULT now(),
  updated_at    timestamptz NOT NULL DEFAULT now(),
  created_by    uuid, updated_by uuid, version int NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, item_id, variant_code)
);

CREATE TABLE IF NOT EXISTS app.warehouses (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  company_id      uuid NOT NULL REFERENCES app.companies(id),
  branch_id       uuid REFERENCES app.branches(id),
  code            citext NOT NULL,
  name            text NOT NULL,
  warehouse_type  text NOT NULL DEFAULT 'standard'
                  CHECK (warehouse_type IN ('standard','transit','quarantine','consignment','bonded','rejected','virtual')),
  address         jsonb,
  allow_negative_stock boolean NOT NULL DEFAULT false,
  active          boolean NOT NULL DEFAULT true,
  parent_id       uuid REFERENCES app.warehouses(id),
  created_at      timestamptz NOT NULL DEFAULT now(),
  updated_at      timestamptz NOT NULL DEFAULT now(),
  created_by      uuid, updated_by uuid, version int NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, company_id, code)
);

CREATE TABLE IF NOT EXISTS app.warehouse_bins (
  id            uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id     uuid NOT NULL,
  warehouse_id  uuid NOT NULL REFERENCES app.warehouses(id) ON DELETE CASCADE,
  code          citext NOT NULL,
  zone          text, aisle text, rack text, shelf text, bin text,
  capacity      numeric(19,4),
  active        boolean NOT NULL DEFAULT true,
  created_at    timestamptz NOT NULL DEFAULT now(),
  updated_at    timestamptz NOT NULL DEFAULT now(),
  created_by    uuid, updated_by uuid, version int NOT NULL DEFAULT 1,
  UNIQUE (warehouse_id, code)
);

CREATE TABLE IF NOT EXISTS app.batches (
  id            uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id     uuid NOT NULL,
  item_id       uuid NOT NULL REFERENCES app.items(id),
  batch_no      text NOT NULL,
  mfg_date      date,
  expiry_date   date,
  supplier_id   uuid,
  country_of_origin char(2),
  notes         text,
  created_at    timestamptz NOT NULL DEFAULT now(),
  updated_at    timestamptz NOT NULL DEFAULT now(),
  created_by    uuid, updated_by uuid, version int NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, item_id, batch_no)
);

CREATE TABLE IF NOT EXISTS app.serials (
  id            uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id     uuid NOT NULL,
  item_id       uuid NOT NULL REFERENCES app.items(id),
  serial_no     citext NOT NULL,
  batch_id      uuid REFERENCES app.batches(id),
  warehouse_id  uuid REFERENCES app.warehouses(id),
  bin_id        uuid REFERENCES app.warehouse_bins(id),
  status        text NOT NULL DEFAULT 'in_stock'
                CHECK (status IN ('in_stock','reserved','sold','returned','scrapped','in_transit')),
  warranty_expires date,
  customer_id   uuid,
  created_at    timestamptz NOT NULL DEFAULT now(),
  updated_at    timestamptz NOT NULL DEFAULT now(),
  created_by    uuid, updated_by uuid, version int NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, item_id, serial_no)
);

-- Stock ledger (append-only fact table; partitioned by posting_date)
CREATE TABLE IF NOT EXISTS app.stock_ledger (
  id              uuid NOT NULL DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  company_id      uuid NOT NULL,
  posting_date    date NOT NULL,
  posting_time    timestamptz NOT NULL DEFAULT now(),
  item_id         uuid NOT NULL REFERENCES app.items(id),
  variant_id      uuid REFERENCES app.item_variants(id),
  warehouse_id    uuid NOT NULL REFERENCES app.warehouses(id),
  bin_id          uuid REFERENCES app.warehouse_bins(id),
  batch_id        uuid REFERENCES app.batches(id),
  serial_no       text,
  qty_change      numeric(19,6) NOT NULL,           -- signed: +in / -out
  uom_code        text NOT NULL,
  unit_rate       numeric(19,4) NOT NULL DEFAULT 0, -- cost in base currency
  value_change    numeric(19,4) NOT NULL DEFAULT 0, -- signed
  running_qty     numeric(19,6),                    -- after this entry
  running_value   numeric(19,4),
  txn_type        text NOT NULL CHECK (txn_type IN (
    'purchase_receipt','purchase_return','sales_delivery','sales_return',
    'stock_transfer_in','stock_transfer_out','adjustment','opening_balance',
    'manufacturing_consume','manufacturing_produce','scrap','count_adjust'
  )),
  source_table    text,
  source_id       uuid,
  notes           text,
  created_at      timestamptz NOT NULL DEFAULT now(),
  created_by      uuid,
  PRIMARY KEY (id, posting_date)
) PARTITION BY RANGE (posting_date);

CREATE TABLE IF NOT EXISTS app.stock_ledger_2026 PARTITION OF app.stock_ledger
  FOR VALUES FROM ('2026-01-01') TO ('2027-01-01');
CREATE TABLE IF NOT EXISTS app.stock_ledger_2027 PARTITION OF app.stock_ledger
  FOR VALUES FROM ('2027-01-01') TO ('2028-01-01');
CREATE TABLE IF NOT EXISTS app.stock_ledger_default PARTITION OF app.stock_ledger DEFAULT;

-- FIFO valuation layers (per item/warehouse/batch; consumed as stock outflows)
CREATE TABLE IF NOT EXISTS app.stock_valuation_layers (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  item_id         uuid NOT NULL REFERENCES app.items(id),
  variant_id      uuid REFERENCES app.item_variants(id),
  warehouse_id    uuid NOT NULL REFERENCES app.warehouses(id),
  batch_id        uuid REFERENCES app.batches(id),
  receipt_date    date NOT NULL,
  qty_received    numeric(19,6) NOT NULL CHECK (qty_received > 0),
  qty_available   numeric(19,6) NOT NULL,
  unit_cost       numeric(19,4) NOT NULL CHECK (unit_cost >= 0),
  source_table    text,
  source_id       uuid,
  created_at      timestamptz NOT NULL DEFAULT now()
);

-- Running stock balance (hot table for UI; maintained by triggers)
CREATE TABLE IF NOT EXISTS app.stock_balances (
  tenant_id       uuid NOT NULL,
  item_id         uuid NOT NULL,
  variant_id      uuid,
  warehouse_id    uuid NOT NULL,
  batch_id        uuid,
  qty_on_hand     numeric(19,6) NOT NULL DEFAULT 0,
  qty_reserved    numeric(19,6) NOT NULL DEFAULT 0,
  qty_available   numeric(19,6) GENERATED ALWAYS AS (qty_on_hand - qty_reserved) STORED,
  avg_cost        numeric(19,4) NOT NULL DEFAULT 0,
  total_value     numeric(19,4) NOT NULL DEFAULT 0,
  last_txn_at     timestamptz,
  updated_at      timestamptz NOT NULL DEFAULT now(),
  PRIMARY KEY (tenant_id, item_id,
               COALESCE(variant_id,'00000000-0000-0000-0000-000000000000'::uuid),
               warehouse_id,
               COALESCE(batch_id,'00000000-0000-0000-0000-000000000000'::uuid))
);

CREATE TABLE IF NOT EXISTS app.stock_reservations (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  item_id         uuid NOT NULL REFERENCES app.items(id),
  variant_id      uuid REFERENCES app.item_variants(id),
  warehouse_id    uuid NOT NULL REFERENCES app.warehouses(id),
  batch_id        uuid REFERENCES app.batches(id),
  qty             numeric(19,6) NOT NULL CHECK (qty > 0),
  source_table    text NOT NULL,
  source_id       uuid NOT NULL,
  status          text NOT NULL DEFAULT 'active'
                  CHECK (status IN ('active','released','consumed','expired')),
  reserved_at     timestamptz NOT NULL DEFAULT now(),
  released_at     timestamptz,
  expires_at      timestamptz,
  created_by      uuid
);

CREATE TABLE IF NOT EXISTS app.stock_transfers (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  transfer_number text NOT NULL,
  transfer_date   date NOT NULL,
  from_warehouse  uuid NOT NULL REFERENCES app.warehouses(id),
  to_warehouse    uuid NOT NULL REFERENCES app.warehouses(id),
  status          text NOT NULL DEFAULT 'draft'
                  CHECK (status IN ('draft','submitted','in_transit','received','cancelled')),
  notes           text,
  created_at      timestamptz NOT NULL DEFAULT now(),
  updated_at      timestamptz NOT NULL DEFAULT now(),
  created_by      uuid, updated_by uuid, version int NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, transfer_number),
  CHECK (from_warehouse <> to_warehouse)
);

CREATE TABLE IF NOT EXISTS app.stock_transfer_lines (
  id            uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id     uuid NOT NULL,
  transfer_id   uuid NOT NULL REFERENCES app.stock_transfers(id) ON DELETE CASCADE,
  line_no       smallint NOT NULL,
  item_id       uuid NOT NULL,
  batch_id      uuid,
  uom_code      text NOT NULL,
  qty           numeric(19,6) NOT NULL CHECK (qty > 0),
  UNIQUE (transfer_id, line_no)
);

CREATE TABLE IF NOT EXISTS app.stock_adjustments (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  adjustment_number text NOT NULL,
  adjustment_date date NOT NULL,
  reason          text NOT NULL CHECK (reason IN ('count','damage','loss','found','revaluation','other')),
  warehouse_id    uuid NOT NULL REFERENCES app.warehouses(id),
  status          text NOT NULL DEFAULT 'draft' CHECK (status IN ('draft','posted','cancelled')),
  notes           text,
  created_at      timestamptz NOT NULL DEFAULT now(),
  updated_at      timestamptz NOT NULL DEFAULT now(),
  created_by      uuid, updated_by uuid, version int NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, adjustment_number)
);

CREATE TABLE IF NOT EXISTS app.stock_adjustment_lines (
  id            uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id     uuid NOT NULL,
  adjustment_id uuid NOT NULL REFERENCES app.stock_adjustments(id) ON DELETE CASCADE,
  line_no       smallint NOT NULL,
  item_id       uuid NOT NULL,
  batch_id      uuid,
  qty_change    numeric(19,6) NOT NULL CHECK (qty_change <> 0),
  unit_rate     numeric(19,4) NOT NULL DEFAULT 0,
  UNIQUE (adjustment_id, line_no)
);

CREATE TABLE IF NOT EXISTS app.physical_counts (
  id            uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id     uuid NOT NULL,
  count_number  text NOT NULL,
  count_date    date NOT NULL,
  warehouse_id  uuid NOT NULL REFERENCES app.warehouses(id),
  status        text NOT NULL DEFAULT 'planned'
                CHECK (status IN ('planned','in_progress','completed','cancelled')),
  counted_by    uuid,
  notes         text,
  created_at    timestamptz NOT NULL DEFAULT now(),
  updated_at    timestamptz NOT NULL DEFAULT now(),
  created_by    uuid, updated_by uuid, version int NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, count_number)
);

CREATE TABLE IF NOT EXISTS app.physical_count_lines (
  id            uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id     uuid NOT NULL,
  count_id      uuid NOT NULL REFERENCES app.physical_counts(id) ON DELETE CASCADE,
  item_id       uuid NOT NULL,
  batch_id      uuid,
  bin_id        uuid,
  qty_system    numeric(19,6) NOT NULL DEFAULT 0,
  qty_counted   numeric(19,6) NOT NULL DEFAULT 0,
  variance      numeric(19,6) GENERATED ALWAYS AS (qty_counted - qty_system) STORED
);

-- =============== INDEXES ===============
CREATE INDEX IF NOT EXISTS idx_items_tenant_active   ON app.items(tenant_id, company_id) WHERE active;
CREATE INDEX IF NOT EXISTS idx_items_name_trgm       ON app.items USING gin (name gin_trgm_ops);
CREATE INDEX IF NOT EXISTS idx_items_sku             ON app.items(tenant_id, sku) WHERE sku IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_items_barcode         ON app.items(barcode) WHERE barcode IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_items_category        ON app.items(category_id);
CREATE INDEX IF NOT EXISTS idx_items_attrs_gin       ON app.items USING gin (attributes jsonb_path_ops);

CREATE INDEX IF NOT EXISTS idx_variants_item         ON app.item_variants(item_id);
CREATE INDEX IF NOT EXISTS idx_variants_attrs_gin    ON app.item_variants USING gin (attributes jsonb_path_ops);

CREATE INDEX IF NOT EXISTS idx_warehouses_tenant     ON app.warehouses(tenant_id, company_id) WHERE active;
CREATE INDEX IF NOT EXISTS idx_bins_warehouse        ON app.warehouse_bins(warehouse_id) WHERE active;

CREATE INDEX IF NOT EXISTS idx_batches_expiry        ON app.batches(tenant_id, item_id, expiry_date) WHERE expiry_date IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_serials_item_status   ON app.serials(tenant_id, item_id, status);

CREATE INDEX IF NOT EXISTS idx_sl_item_wh_date       ON app.stock_ledger(item_id, warehouse_id, posting_date DESC);
CREATE INDEX IF NOT EXISTS idx_sl_source             ON app.stock_ledger(source_table, source_id);
CREATE INDEX IF NOT EXISTS idx_sl_tenant_date        ON app.stock_ledger(tenant_id, posting_date DESC);

CREATE INDEX IF NOT EXISTS idx_svl_available         ON app.stock_valuation_layers(tenant_id, item_id, warehouse_id, receipt_date)
  WHERE qty_available > 0;

CREATE INDEX IF NOT EXISTS idx_sb_tenant_wh          ON app.stock_balances(tenant_id, warehouse_id);
CREATE INDEX IF NOT EXISTS idx_sb_item               ON app.stock_balances(tenant_id, item_id);
CREATE INDEX IF NOT EXISTS idx_sb_low_stock          ON app.stock_balances(item_id, warehouse_id) WHERE qty_on_hand > 0;

CREATE INDEX IF NOT EXISTS idx_sr_active             ON app.stock_reservations(tenant_id, item_id, warehouse_id) WHERE status='active';
CREATE INDEX IF NOT EXISTS idx_sr_source             ON app.stock_reservations(source_table, source_id);

-- =============== RLS ===============
SELECT core.enable_tenant_rls('app.uoms');
SELECT core.enable_tenant_rls('app.uom_conversions');
SELECT core.enable_tenant_rls('app.item_categories');
SELECT core.enable_tenant_rls('app.items');
SELECT core.enable_tenant_rls('app.item_variants');
SELECT core.enable_tenant_rls('app.warehouses');
SELECT core.enable_tenant_rls('app.warehouse_bins');
SELECT core.enable_tenant_rls('app.batches');
SELECT core.enable_tenant_rls('app.serials');
SELECT core.enable_tenant_rls('app.stock_ledger');
SELECT core.enable_tenant_rls('app.stock_valuation_layers');
SELECT core.enable_tenant_rls('app.stock_balances');
SELECT core.enable_tenant_rls('app.stock_reservations');
SELECT core.enable_tenant_rls('app.stock_transfers');
SELECT core.enable_tenant_rls('app.stock_transfer_lines');
SELECT core.enable_tenant_rls('app.stock_adjustments');
SELECT core.enable_tenant_rls('app.stock_adjustment_lines');
SELECT core.enable_tenant_rls('app.physical_counts');
SELECT core.enable_tenant_rls('app.physical_count_lines');

-- =============== FUNCTIONS ===============

-- Convert quantity between UoMs for an item
CREATE OR REPLACE FUNCTION app.convert_uom(
  p_item_id uuid, p_qty numeric, p_from text, p_to text
) RETURNS numeric
LANGUAGE plpgsql STABLE AS $$
DECLARE v_factor numeric(19,8);
BEGIN
  IF p_from = p_to THEN RETURN p_qty; END IF;
  SELECT factor INTO v_factor
    FROM app.uom_conversions
   WHERE tenant_id = core.require_tenant()
     AND (item_id = p_item_id OR item_id IS NULL)
     AND from_uom = p_from AND to_uom = p_to
   ORDER BY (item_id IS NULL) ASC LIMIT 1;

  IF v_factor IS NULL THEN
    SELECT 1/factor INTO v_factor
      FROM app.uom_conversions
     WHERE tenant_id = core.require_tenant()
       AND (item_id = p_item_id OR item_id IS NULL)
       AND from_uom = p_to AND to_uom = p_from
     ORDER BY (item_id IS NULL) ASC LIMIT 1;
  END IF;

  IF v_factor IS NULL THEN
    RAISE EXCEPTION 'no UoM conversion % -> % for item %', p_from, p_to, p_item_id;
  END IF;
  RETURN p_qty * v_factor;
END $$;

-- FIFO consume: deducts from oldest valuation layers; returns weighted avg cost
CREATE OR REPLACE FUNCTION app.consume_fifo(
  p_item_id uuid, p_warehouse_id uuid, p_qty numeric, p_batch_id uuid DEFAULT NULL
) RETURNS numeric
LANGUAGE plpgsql AS $$
DECLARE
  v_remaining numeric(19,6) := p_qty;
  v_total_value numeric(19,4) := 0;
  v_take numeric(19,6);
  r record;
BEGIN
  FOR r IN
    SELECT id, qty_available, unit_cost
      FROM app.stock_valuation_layers
     WHERE tenant_id = core.require_tenant()
       AND item_id = p_item_id AND warehouse_id = p_warehouse_id
       AND (p_batch_id IS NULL OR batch_id = p_batch_id)
       AND qty_available > 0
     ORDER BY receipt_date, id
     FOR UPDATE
  LOOP
    EXIT WHEN v_remaining <= 0;
    v_take := LEAST(v_remaining, r.qty_available);
    UPDATE app.stock_valuation_layers
       SET qty_available = qty_available - v_take
     WHERE id = r.id;
    v_total_value := v_total_value + v_take * r.unit_cost;
    v_remaining := v_remaining - v_take;
  END LOOP;

  IF v_remaining > 0 THEN
    RAISE EXCEPTION 'insufficient FIFO layers for item % wh % (short %)',
      p_item_id, p_warehouse_id, v_remaining;
  END IF;
  RETURN round(v_total_value / p_qty, 4);
END $$;

-- Weighted average cost for an item/warehouse
CREATE OR REPLACE FUNCTION app.wac_cost(p_item_id uuid, p_warehouse_id uuid DEFAULT NULL)
RETURNS numeric
LANGUAGE sql STABLE AS $$
  SELECT CASE WHEN SUM(qty_on_hand) > 0
              THEN SUM(total_value)/SUM(qty_on_hand)
              ELSE 0 END
    FROM app.stock_balances
   WHERE tenant_id = core.require_tenant()
     AND item_id = p_item_id
     AND (p_warehouse_id IS NULL OR warehouse_id = p_warehouse_id)
$$;

-- Reorder suggestion
CREATE OR REPLACE FUNCTION app.reorder_suggestions(p_company_id uuid)
RETURNS TABLE(item_id uuid, item_code text, on_hand numeric, reorder_level numeric,
              reorder_qty numeric, suggested_qty numeric)
LANGUAGE sql STABLE AS $$
  SELECT i.id, i.code::text,
         COALESCE(SUM(sb.qty_on_hand),0),
         i.reorder_level, i.reorder_qty,
         GREATEST(i.reorder_qty, i.reorder_level - COALESCE(SUM(sb.qty_on_hand),0))
    FROM app.items i
    LEFT JOIN app.stock_balances sb ON sb.item_id = i.id
   WHERE i.company_id = p_company_id AND i.active AND i.maintain_stock
     AND i.reorder_level IS NOT NULL
   GROUP BY i.id, i.code, i.reorder_level, i.reorder_qty
  HAVING COALESCE(SUM(sb.qty_on_hand),0) < i.reorder_level
$$;

-- Post a stock ledger entry + maintain balances + FIFO layers
CREATE OR REPLACE FUNCTION app.post_stock_entry(
  p_company_id    uuid,
  p_item_id       uuid,
  p_warehouse_id  uuid,
  p_qty           numeric,       -- signed (+in / -out)
  p_unit_rate     numeric,       -- per-unit cost in base currency (required for inflow)
  p_txn_type      text,
  p_posting_date  date,
  p_uom           text,
  p_source_table  text DEFAULT NULL,
  p_source_id     uuid DEFAULT NULL,
  p_batch_id      uuid DEFAULT NULL,
  p_variant_id    uuid DEFAULT NULL,
  p_bin_id        uuid DEFAULT NULL,
  p_serial_no     text DEFAULT NULL,
  p_notes         text DEFAULT NULL
) RETURNS uuid
LANGUAGE plpgsql AS $$
DECLARE
  v_id uuid := gen_random_uuid();
  v_item app.items%ROWTYPE;
  v_effective_cost numeric(19,4);
  v_value_change numeric(19,4);
  v_tenant uuid := core.require_tenant();
BEGIN
  SELECT * INTO v_item FROM app.items WHERE id = p_item_id;
  IF NOT v_item.maintain_stock THEN RETURN NULL; END IF;

  -- Determine cost
  IF p_qty > 0 THEN
    v_effective_cost := p_unit_rate;
    INSERT INTO app.stock_valuation_layers(
      tenant_id,item_id,variant_id,warehouse_id,batch_id,receipt_date,
      qty_received,qty_available,unit_cost,source_table,source_id)
    VALUES (v_tenant, p_item_id, p_variant_id, p_warehouse_id, p_batch_id, p_posting_date,
            p_qty, p_qty, p_unit_rate, p_source_table, p_source_id);
  ELSE
    IF v_item.valuation_method = 'FIFO' THEN
      v_effective_cost := app.consume_fifo(p_item_id, p_warehouse_id, -p_qty, p_batch_id);
    ELSE
      v_effective_cost := app.wac_cost(p_item_id, p_warehouse_id);
    END IF;
  END IF;

  v_value_change := round(p_qty * v_effective_cost, 4);

  INSERT INTO app.stock_ledger(
    id, tenant_id, company_id, posting_date, posting_time,
    item_id, variant_id, warehouse_id, bin_id, batch_id, serial_no,
    qty_change, uom_code, unit_rate, value_change, txn_type,
    source_table, source_id, notes)
  VALUES (
    v_id, v_tenant, p_company_id, p_posting_date, now(),
    p_item_id, p_variant_id, p_warehouse_id, p_bin_id, p_batch_id, p_serial_no,
    p_qty, p_uom, v_effective_cost, v_value_change, p_txn_type,
    p_source_table, p_source_id, p_notes);

  -- Upsert running balance
  INSERT INTO app.stock_balances(tenant_id,item_id,variant_id,warehouse_id,batch_id,
         qty_on_hand,avg_cost,total_value,last_txn_at)
  VALUES (v_tenant, p_item_id, p_variant_id, p_warehouse_id, p_batch_id,
          p_qty, v_effective_cost, v_value_change, now())
  ON CONFLICT (tenant_id,item_id,
               COALESCE(variant_id,'00000000-0000-0000-0000-000000000000'::uuid),
               warehouse_id,
               COALESCE(batch_id,'00000000-0000-0000-0000-000000000000'::uuid))
  DO UPDATE SET
    qty_on_hand = app.stock_balances.qty_on_hand + EXCLUDED.qty_on_hand,
    total_value = app.stock_balances.total_value + EXCLUDED.total_value,
    avg_cost    = CASE WHEN (app.stock_balances.qty_on_hand + EXCLUDED.qty_on_hand) > 0
                       THEN (app.stock_balances.total_value + EXCLUDED.total_value) /
                            (app.stock_balances.qty_on_hand + EXCLUDED.qty_on_hand)
                       ELSE 0 END,
    last_txn_at = now(),
    updated_at  = now();

  -- Guard against negative unless warehouse allows
  IF EXISTS (
    SELECT 1 FROM app.stock_balances sb
    JOIN app.warehouses w ON w.id = sb.warehouse_id
    WHERE sb.item_id = p_item_id AND sb.warehouse_id = p_warehouse_id
      AND sb.qty_on_hand < 0 AND NOT w.allow_negative_stock
  ) THEN
    RAISE EXCEPTION 'negative stock not allowed: item=% warehouse=%', p_item_id, p_warehouse_id;
  END IF;

  RETURN v_id;
END $$;

-- Reserve stock for a document (e.g. sales order)
CREATE OR REPLACE FUNCTION app.reserve_stock(
  p_item_id uuid, p_warehouse_id uuid, p_qty numeric,
  p_source_table text, p_source_id uuid, p_batch_id uuid DEFAULT NULL,
  p_expires timestamptz DEFAULT NULL
) RETURNS uuid
LANGUAGE plpgsql AS $$
DECLARE
  v_avail numeric(19,6); v_id uuid := gen_random_uuid();
BEGIN
  SELECT COALESCE(SUM(qty_available),0) INTO v_avail
    FROM app.stock_balances
   WHERE item_id = p_item_id AND warehouse_id = p_warehouse_id
     AND (p_batch_id IS NULL OR batch_id = p_batch_id);

  IF v_avail < p_qty THEN
    RAISE EXCEPTION 'insufficient available qty (have %, need %)', v_avail, p_qty;
  END IF;

  INSERT INTO app.stock_reservations(id,tenant_id,item_id,warehouse_id,batch_id,qty,
         source_table,source_id,expires_at,created_by)
  VALUES (v_id, core.require_tenant(), p_item_id, p_warehouse_id, p_batch_id, p_qty,
          p_source_table, p_source_id, p_expires, core.current_user_id());

  UPDATE app.stock_balances
     SET qty_reserved = qty_reserved + p_qty, updated_at = now()
   WHERE item_id = p_item_id AND warehouse_id = p_warehouse_id
     AND (p_batch_id IS NULL AND batch_id IS NULL OR batch_id = p_batch_id);

  RETURN v_id;
END $$;

CREATE OR REPLACE FUNCTION app.release_reservation(p_reservation_id uuid)
RETURNS void
LANGUAGE plpgsql AS $$
DECLARE v app.stock_reservations%ROWTYPE;
BEGIN
  UPDATE app.stock_reservations SET status='released', released_at=now()
   WHERE id = p_reservation_id AND status = 'active'
   RETURNING * INTO v;
  IF FOUND THEN
    UPDATE app.stock_balances
       SET qty_reserved = GREATEST(0, qty_reserved - v.qty), updated_at = now()
     WHERE item_id = v.item_id AND warehouse_id = v.warehouse_id
       AND (v.batch_id IS NULL AND batch_id IS NULL OR batch_id = v.batch_id);
  END IF;
END $$;

-- =============== PROCEDURES ===============

-- Execute stock transfer (posts -out from source, +in to destination)
CREATE OR REPLACE PROCEDURE app.execute_stock_transfer(p_transfer_id uuid)
LANGUAGE plpgsql AS $$
DECLARE
  v_tr app.stock_transfers%ROWTYPE;
  r record;
  v_cost numeric(19,4);
BEGIN
  SELECT * INTO v_tr FROM app.stock_transfers WHERE id = p_transfer_id;
  IF v_tr.status NOT IN ('draft','submitted','in_transit') THEN
    RAISE EXCEPTION 'invalid transfer status %', v_tr.status;
  END IF;

  FOR r IN
    SELECT stl.item_id, stl.batch_id, stl.uom_code, stl.qty
      FROM app.stock_transfer_lines stl WHERE stl.transfer_id = p_transfer_id
  LOOP
    -- OUT from source
    PERFORM app.post_stock_entry(
      p_company_id   := (SELECT company_id FROM app.warehouses WHERE id = v_tr.from_warehouse),
      p_item_id      := r.item_id,
      p_warehouse_id := v_tr.from_warehouse,
      p_qty          := -r.qty,
      p_unit_rate    := 0,
      p_txn_type     := 'stock_transfer_out',
      p_posting_date := v_tr.transfer_date,
      p_uom          := r.uom_code,
      p_source_table := 'stock_transfers',
      p_source_id    := p_transfer_id,
      p_batch_id     := r.batch_id);

    -- Use the cost that OUT just consumed (read back latest ledger line)
    SELECT unit_rate INTO v_cost FROM app.stock_ledger
      WHERE source_table='stock_transfers' AND source_id = p_transfer_id
        AND item_id = r.item_id AND warehouse_id = v_tr.from_warehouse
     ORDER BY posting_time DESC LIMIT 1;

    -- IN to destination at the same cost
    PERFORM app.post_stock_entry(
      p_company_id   := (SELECT company_id FROM app.warehouses WHERE id = v_tr.to_warehouse),
      p_item_id      := r.item_id,
      p_warehouse_id := v_tr.to_warehouse,
      p_qty          := r.qty,
      p_unit_rate    := COALESCE(v_cost,0),
      p_txn_type     := 'stock_transfer_in',
      p_posting_date := v_tr.transfer_date,
      p_uom          := r.uom_code,
      p_source_table := 'stock_transfers',
      p_source_id    := p_transfer_id,
      p_batch_id     := r.batch_id);
  END LOOP;

  UPDATE app.stock_transfers SET status='received', updated_at=now() WHERE id = p_transfer_id;
END $$;

-- =============== TRIGGERS ===============
SELECT core.attach_standard_triggers('app.uoms');
SELECT core.attach_standard_triggers('app.uom_conversions');
SELECT core.attach_standard_triggers('app.item_categories');
SELECT core.attach_standard_triggers('app.items');
SELECT core.attach_standard_triggers('app.item_variants');
SELECT core.attach_standard_triggers('app.warehouses');
SELECT core.attach_standard_triggers('app.warehouse_bins');
SELECT core.attach_standard_triggers('app.batches');
SELECT core.attach_standard_triggers('app.serials');
SELECT core.attach_standard_triggers('app.stock_transfers');
SELECT core.attach_standard_triggers('app.stock_adjustments');
SELECT core.attach_standard_triggers('app.physical_counts');

-- GRN -> stock: after grn_lines insert, post a purchase_receipt stock entry
CREATE OR REPLACE FUNCTION core.tg_grn_to_stock()
RETURNS trigger LANGUAGE plpgsql AS $$
DECLARE
  v_company uuid; v_batch_id uuid;
BEGIN
  IF NEW.qty_accepted <= 0 THEN RETURN NEW; END IF;

  SELECT company_id INTO v_company FROM app.grns WHERE id = NEW.grn_id;

  -- Upsert batch if provided
  IF NEW.batch_no IS NOT NULL THEN
    INSERT INTO app.batches(tenant_id,item_id,batch_no,expiry_date)
    VALUES (NEW.tenant_id, NEW.item_id, NEW.batch_no, NEW.expiry_date)
    ON CONFLICT (tenant_id, item_id, batch_no) DO UPDATE SET expiry_date = EXCLUDED.expiry_date
    RETURNING id INTO v_batch_id;
  END IF;

  PERFORM app.post_stock_entry(
    p_company_id   := v_company,
    p_item_id      := NEW.item_id,
    p_warehouse_id := NEW.warehouse_id,
    p_qty          := NEW.qty_accepted,
    p_unit_rate    := NEW.unit_price,
    p_txn_type     := 'purchase_receipt',
    p_posting_date := (SELECT grn_date FROM app.grns WHERE id = NEW.grn_id),
    p_uom          := NEW.uom_code,
    p_source_table := 'grn_lines',
    p_source_id    := NEW.id,
    p_batch_id     := v_batch_id,
    p_bin_id       := NEW.bin_id);
  RETURN NEW;
END $$;
DROP TRIGGER IF EXISTS trg_grn_to_stock ON app.grn_lines;
CREATE TRIGGER trg_grn_to_stock
  AFTER INSERT ON app.grn_lines
  FOR EACH ROW EXECUTE FUNCTION core.tg_grn_to_stock();

-- Delivery -> stock: after delivery_lines insert on delivered status, post outflow
CREATE OR REPLACE FUNCTION core.tg_delivery_to_stock()
RETURNS trigger LANGUAGE plpgsql AS $$
DECLARE
  v_delivery app.deliveries%ROWTYPE; v_company uuid;
BEGIN
  SELECT * INTO v_delivery FROM app.deliveries WHERE id = NEW.delivery_id;
  IF v_delivery.status NOT IN ('shipped','delivered') THEN RETURN NEW; END IF;
  v_company := v_delivery.company_id;

  PERFORM app.post_stock_entry(
    p_company_id   := v_company,
    p_item_id      := NEW.item_id,
    p_warehouse_id := v_delivery.warehouse_id,
    p_qty          := -NEW.qty,
    p_unit_rate    := 0,
    p_txn_type     := 'sales_delivery',
    p_posting_date := v_delivery.delivery_date,
    p_uom          := NEW.uom_code,
    p_source_table := 'delivery_lines',
    p_source_id    := NEW.id,
    p_batch_id     := NEW.batch_id);
  RETURN NEW;
END $$;
DROP TRIGGER IF EXISTS trg_delivery_to_stock ON app.delivery_lines;
CREATE TRIGGER trg_delivery_to_stock
  AFTER INSERT ON app.delivery_lines
  FOR EACH ROW EXECUTE FUNCTION core.tg_delivery_to_stock();

-- Expiry alert check (advisory; cron calls)
CREATE OR REPLACE FUNCTION app.expiring_batches(p_days int DEFAULT 30)
RETURNS TABLE(item_id uuid, batch_no text, expiry_date date, qty numeric, warehouse_id uuid)
LANGUAGE sql STABLE AS $$
  SELECT b.item_id, b.batch_no, b.expiry_date,
         COALESCE(SUM(sb.qty_on_hand),0) AS qty, sb.warehouse_id
    FROM app.batches b
    LEFT JOIN app.stock_balances sb ON sb.batch_id = b.id
   WHERE b.tenant_id = core.require_tenant()
     AND b.expiry_date IS NOT NULL
     AND b.expiry_date <= CURRENT_DATE + (p_days||' days')::interval
   GROUP BY b.item_id, b.batch_no, b.expiry_date, sb.warehouse_id
  HAVING COALESCE(SUM(sb.qty_on_hand),0) > 0
$$;

-- =============== VIEWS ===============
CREATE OR REPLACE VIEW app.v_stock_on_hand AS
SELECT sb.tenant_id, sb.item_id, i.code AS item_code, i.name AS item_name,
       sb.warehouse_id, w.name AS warehouse_name,
       SUM(sb.qty_on_hand)   AS qty_on_hand,
       SUM(sb.qty_reserved)  AS qty_reserved,
       SUM(sb.qty_available) AS qty_available,
       SUM(sb.total_value)   AS total_value
  FROM app.stock_balances sb
  JOIN app.items i       ON i.id = sb.item_id
  JOIN app.warehouses w  ON w.id = sb.warehouse_id
 GROUP BY sb.tenant_id, sb.item_id, i.code, i.name, sb.warehouse_id, w.name;

CREATE OR REPLACE VIEW app.v_abc_analysis AS
WITH consumption AS (
  SELECT sl.tenant_id, sl.item_id,
         SUM(ABS(sl.value_change)) AS value
    FROM app.stock_ledger sl
   WHERE sl.posting_date >= CURRENT_DATE - interval '365 days'
     AND sl.qty_change < 0
   GROUP BY sl.tenant_id, sl.item_id
), ranked AS (
  SELECT tenant_id, item_id, value,
         SUM(value) OVER (PARTITION BY tenant_id)                            AS total_value,
         SUM(value) OVER (PARTITION BY tenant_id ORDER BY value DESC)         AS cum_value
    FROM consumption
)
SELECT tenant_id, item_id, value,
       CASE
         WHEN cum_value/NULLIF(total_value,0) <= 0.80 THEN 'A'
         WHEN cum_value/NULLIF(total_value,0) <= 0.95 THEN 'B'
         ELSE 'C' END AS abc_class
  FROM ranked;

CREATE OR REPLACE VIEW app.v_reorder_alerts AS
SELECT i.tenant_id, i.id AS item_id, i.code, i.name,
       i.reorder_level, i.reorder_qty,
       COALESCE(SUM(sb.qty_on_hand),0) AS on_hand,
       i.reorder_level - COALESCE(SUM(sb.qty_on_hand),0) AS shortage
  FROM app.items i
  LEFT JOIN app.stock_balances sb ON sb.item_id = i.id
 WHERE i.active AND i.maintain_stock AND i.reorder_level IS NOT NULL
 GROUP BY i.tenant_id, i.id, i.code, i.name, i.reorder_level, i.reorder_qty
HAVING COALESCE(SUM(sb.qty_on_hand),0) < i.reorder_level;
