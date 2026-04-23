-- =====================================================================
-- Module 19: Point of Sale (POS)
-- Counters, shifts, receipts, split tender, cash drawer
-- =====================================================================

SET search_path = app, core, public;

-- =============== SCHEMA ===============

CREATE TABLE IF NOT EXISTS app.pos_terminals (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  company_id      uuid NOT NULL REFERENCES app.companies(id),
  branch_id       uuid REFERENCES app.branches(id),
  terminal_code   citext NOT NULL,
  name            text NOT NULL,
  warehouse_id    uuid REFERENCES app.warehouses(id),
  cash_account_id uuid REFERENCES app.chart_of_accounts(id),
  default_customer_id uuid REFERENCES app.customers(id),
  printer_config  jsonb,
  active          boolean NOT NULL DEFAULT true,
  created_at      timestamptz NOT NULL DEFAULT now(),
  updated_at      timestamptz NOT NULL DEFAULT now(),
  created_by      uuid, updated_by uuid, version int NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, company_id, terminal_code)
);

CREATE TABLE IF NOT EXISTS app.pos_shifts (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  terminal_id     uuid NOT NULL REFERENCES app.pos_terminals(id),
  shift_number    text NOT NULL,
  cashier_user_id uuid NOT NULL REFERENCES app.users(id),
  opened_at       timestamptz NOT NULL DEFAULT now(),
  closed_at       timestamptz,
  opening_cash    numeric(19,4) NOT NULL DEFAULT 0,
  closing_cash    numeric(19,4),
  expected_cash   numeric(19,4),
  variance_cash   numeric(19,4) GENERATED ALWAYS AS (closing_cash - expected_cash) STORED,
  total_sales     numeric(19,4) NOT NULL DEFAULT 0,
  total_returns   numeric(19,4) NOT NULL DEFAULT 0,
  receipt_count   int NOT NULL DEFAULT 0,
  status          text NOT NULL DEFAULT 'open' CHECK (status IN ('open','closed','reconciled','voided')),
  notes           text,
  UNIQUE (tenant_id, shift_number)
);

CREATE TABLE IF NOT EXISTS app.pos_receipts (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  shift_id        uuid NOT NULL REFERENCES app.pos_shifts(id),
  terminal_id     uuid NOT NULL REFERENCES app.pos_terminals(id),
  receipt_number  text NOT NULL,
  receipt_date    timestamptz NOT NULL DEFAULT now(),
  customer_id     uuid REFERENCES app.customers(id),
  subtotal        numeric(19,4) NOT NULL DEFAULT 0,
  discount_total  numeric(19,4) NOT NULL DEFAULT 0,
  tax_total       numeric(19,4) NOT NULL DEFAULT 0,
  grand_total     numeric(19,4) NOT NULL DEFAULT 0,
  amount_paid     numeric(19,4) NOT NULL DEFAULT 0,
  change_due      numeric(19,4) NOT NULL DEFAULT 0,
  receipt_type    text NOT NULL DEFAULT 'sale' CHECK (receipt_type IN ('sale','return','exchange','void')),
  original_receipt_id uuid REFERENCES app.pos_receipts(id),
  sales_invoice_id uuid REFERENCES app.sales_invoices(id),
  status          text NOT NULL DEFAULT 'completed'
                  CHECK (status IN ('parked','completed','voided','refunded','partial_refund')),
  loyalty_points_earned int NOT NULL DEFAULT 0,
  loyalty_points_redeemed int NOT NULL DEFAULT 0,
  offline_created boolean NOT NULL DEFAULT false,
  synced_at       timestamptz,
  created_at      timestamptz NOT NULL DEFAULT now(),
  created_by      uuid,
  UNIQUE (tenant_id, receipt_number)
);

CREATE TABLE IF NOT EXISTS app.pos_receipt_lines (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  receipt_id      uuid NOT NULL REFERENCES app.pos_receipts(id) ON DELETE CASCADE,
  line_no         smallint NOT NULL,
  item_id         uuid NOT NULL,
  variant_id      uuid,
  barcode         text,
  description     text,
  qty             numeric(19,6) NOT NULL CHECK (qty <> 0),
  unit_price      numeric(19,4) NOT NULL,
  discount_amount numeric(19,4) NOT NULL DEFAULT 0,
  tax_rate_percent numeric(5,2) NOT NULL DEFAULT 0,
  tax_amount      numeric(19,4) NOT NULL DEFAULT 0,
  line_total      numeric(19,4) NOT NULL DEFAULT 0,
  UNIQUE (receipt_id, line_no)
);

CREATE TABLE IF NOT EXISTS app.pos_payments (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  receipt_id      uuid NOT NULL REFERENCES app.pos_receipts(id) ON DELETE CASCADE,
  payment_mode    text NOT NULL CHECK (payment_mode IN ('cash','card','upi','wallet','gift_card','store_credit','cheque','other')),
  amount          numeric(19,4) NOT NULL CHECK (amount > 0),
  reference       text,
  card_last4      text,
  approval_code   text,
  processor       text,
  created_at      timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS app.pos_cash_movements (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  shift_id        uuid NOT NULL REFERENCES app.pos_shifts(id),
  movement_type   text NOT NULL CHECK (movement_type IN ('pay_in','pay_out','float_in','float_out','bank_drop')),
  amount          numeric(19,4) NOT NULL CHECK (amount > 0),
  reason          text,
  created_at      timestamptz NOT NULL DEFAULT now(),
  created_by      uuid
);

-- =============== INDEXES ===============
CREATE INDEX IF NOT EXISTS idx_terminals_active ON app.pos_terminals(tenant_id) WHERE active;
CREATE INDEX IF NOT EXISTS idx_shifts_cashier   ON app.pos_shifts(cashier_user_id, opened_at DESC);
CREATE INDEX IF NOT EXISTS idx_shifts_open      ON app.pos_shifts(terminal_id) WHERE status='open';
CREATE INDEX IF NOT EXISTS idx_receipts_shift   ON app.pos_receipts(shift_id);
CREATE INDEX IF NOT EXISTS idx_receipts_customer ON app.pos_receipts(customer_id, receipt_date DESC);
CREATE INDEX IF NOT EXISTS idx_receipts_number  ON app.pos_receipts(tenant_id, receipt_number);
CREATE INDEX IF NOT EXISTS idx_receipts_date    ON app.pos_receipts(tenant_id, receipt_date DESC);
CREATE INDEX IF NOT EXISTS idx_rlines_receipt   ON app.pos_receipt_lines(receipt_id);
CREATE INDEX IF NOT EXISTS idx_rlines_item      ON app.pos_receipt_lines(item_id);
CREATE INDEX IF NOT EXISTS idx_payments_receipt ON app.pos_payments(receipt_id);
CREATE INDEX IF NOT EXISTS idx_cash_shift       ON app.pos_cash_movements(shift_id);

-- =============== RLS + TRIGGERS ===============
SELECT core.enable_tenant_rls('app.pos_terminals');
SELECT core.enable_tenant_rls('app.pos_shifts');
SELECT core.enable_tenant_rls('app.pos_receipts');
SELECT core.enable_tenant_rls('app.pos_receipt_lines');
SELECT core.enable_tenant_rls('app.pos_payments');
SELECT core.enable_tenant_rls('app.pos_cash_movements');

SELECT core.attach_standard_triggers('app.pos_terminals');

-- =============== FUNCTIONS ===============

-- Close shift and compute expected cash (opening + cash sales - cash payouts)
CREATE OR REPLACE PROCEDURE app.close_pos_shift(p_shift_id uuid, p_closing_cash numeric)
LANGUAGE plpgsql AS $$
DECLARE
  v_expected numeric(19,4);
  v_cash_sales numeric(19,4);
  v_pay_in numeric(19,4); v_pay_out numeric(19,4);
  v_opening numeric(19,4);
BEGIN
  SELECT opening_cash INTO v_opening FROM app.pos_shifts WHERE id = p_shift_id;

  SELECT COALESCE(SUM(pp.amount),0)
    INTO v_cash_sales
    FROM app.pos_payments pp
    JOIN app.pos_receipts r ON r.id = pp.receipt_id
   WHERE r.shift_id = p_shift_id AND pp.payment_mode = 'cash' AND r.status = 'completed';

  SELECT COALESCE(SUM(CASE WHEN movement_type IN ('pay_in','float_in') THEN amount ELSE 0 END),0),
         COALESCE(SUM(CASE WHEN movement_type IN ('pay_out','float_out','bank_drop') THEN amount ELSE 0 END),0)
    INTO v_pay_in, v_pay_out
    FROM app.pos_cash_movements WHERE shift_id = p_shift_id;

  v_expected := v_opening + v_cash_sales + v_pay_in - v_pay_out;

  UPDATE app.pos_shifts
     SET closed_at = now(),
         closing_cash = p_closing_cash,
         expected_cash = v_expected,
         status = 'closed'
   WHERE id = p_shift_id AND status = 'open';

  IF NOT FOUND THEN RAISE EXCEPTION 'shift not open or not found'; END IF;
END $$;

-- Quick barcode lookup for POS UI
CREATE OR REPLACE FUNCTION app.pos_lookup_barcode(p_barcode text)
RETURNS TABLE(item_id uuid, variant_id uuid, code text, name text, unit_price numeric, tax_rate numeric)
LANGUAGE sql STABLE AS $$
  SELECT i.id, NULL::uuid, i.code::text, i.name,
         COALESCE(i.std_sell_price,0), COALESCE(i.default_tax_rate,0)
    FROM app.items i WHERE i.barcode = p_barcode AND i.active
  UNION ALL
  SELECT v.item_id, v.id, v.variant_code::text, (SELECT name FROM app.items WHERE id = v.item_id),
         (SELECT std_sell_price FROM app.items WHERE id = v.item_id),
         (SELECT default_tax_rate FROM app.items WHERE id = v.item_id)
    FROM app.item_variants v WHERE v.barcode = p_barcode AND v.active
$$;

-- =============== VIEWS ===============
CREATE OR REPLACE VIEW app.v_daily_sales AS
SELECT tenant_id, terminal_id, date_trunc('day', receipt_date)::date AS day,
       COUNT(*) receipt_count,
       SUM(grand_total) FILTER (WHERE receipt_type='sale')   AS gross_sales,
       SUM(grand_total) FILTER (WHERE receipt_type='return') AS returns,
       SUM(grand_total) FILTER (WHERE receipt_type='sale')
         - COALESCE(SUM(grand_total) FILTER (WHERE receipt_type='return'),0) AS net_sales
  FROM app.pos_receipts
 WHERE status='completed'
 GROUP BY 1,2,3;

CREATE OR REPLACE VIEW app.v_pos_shift_summary AS
SELECT s.tenant_id, s.terminal_id, s.shift_number, s.cashier_user_id,
       s.opened_at, s.closed_at, s.opening_cash, s.closing_cash,
       s.expected_cash, s.variance_cash, s.receipt_count, s.total_sales
  FROM app.pos_shifts s;
