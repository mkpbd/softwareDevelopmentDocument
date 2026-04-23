-- =====================================================================
-- Module 05: Sales Management
-- Covers PRD Step 5
-- =====================================================================

SET search_path = app, core, public;

-- =============== SCHEMA ===============

CREATE TABLE IF NOT EXISTS app.customers (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  company_id      uuid NOT NULL REFERENCES app.companies(id),
  code            citext NOT NULL,
  customer_type   text NOT NULL DEFAULT 'business' CHECK (customer_type IN ('business','individual')),
  name            text NOT NULL,
  display_name    text,
  legal_name      text,
  email           citext,
  phone           text,
  gstin           text,
  pan             text,
  tax_category    text,
  credit_limit    numeric(19,4) NOT NULL DEFAULT 0,
  credit_days     smallint NOT NULL DEFAULT 0,
  payment_terms   text,
  price_list_id   uuid,
  default_currency char(3) NOT NULL DEFAULT 'INR',
  billing_address jsonb,
  shipping_address jsonb,
  status          text NOT NULL DEFAULT 'active' CHECK (status IN ('active','inactive','blocked')),
  territory_id    uuid,
  salesperson_id  uuid REFERENCES app.users(id),
  source          text,
  metadata        jsonb NOT NULL DEFAULT '{}'::jsonb,
  created_at      timestamptz NOT NULL DEFAULT now(),
  updated_at      timestamptz NOT NULL DEFAULT now(),
  created_by      uuid, updated_by uuid, version int NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, company_id, code)
);

CREATE TABLE IF NOT EXISTS app.customer_contacts (
  id            uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id     uuid NOT NULL,
  customer_id   uuid NOT NULL REFERENCES app.customers(id) ON DELETE CASCADE,
  name          text NOT NULL,
  designation   text,
  email         citext,
  phone         text,
  is_primary    boolean NOT NULL DEFAULT false,
  created_at    timestamptz NOT NULL DEFAULT now(),
  updated_at    timestamptz NOT NULL DEFAULT now(),
  created_by    uuid, updated_by uuid, version int NOT NULL DEFAULT 1
);

CREATE TABLE IF NOT EXISTS app.customer_addresses (
  id            uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id     uuid NOT NULL,
  customer_id   uuid NOT NULL REFERENCES app.customers(id) ON DELETE CASCADE,
  address_type  text NOT NULL CHECK (address_type IN ('billing','shipping','both','other')),
  label         text,
  line1         text NOT NULL, line2 text,
  city          text, state text, postal_code text, country char(2) NOT NULL DEFAULT 'IN',
  gstin         text,
  is_default    boolean NOT NULL DEFAULT false,
  created_at    timestamptz NOT NULL DEFAULT now(),
  updated_at    timestamptz NOT NULL DEFAULT now(),
  created_by    uuid, updated_by uuid, version int NOT NULL DEFAULT 1
);

CREATE TABLE IF NOT EXISTS app.price_lists (
  id            uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id     uuid NOT NULL,
  company_id    uuid NOT NULL REFERENCES app.companies(id),
  code          citext NOT NULL,
  name          text NOT NULL,
  list_type     text NOT NULL DEFAULT 'sell' CHECK (list_type IN ('sell','buy')),
  currency_code char(3) NOT NULL DEFAULT 'INR',
  valid_from    date,
  valid_to      date,
  active        boolean NOT NULL DEFAULT true,
  priority      int NOT NULL DEFAULT 100,
  created_at    timestamptz NOT NULL DEFAULT now(),
  updated_at    timestamptz NOT NULL DEFAULT now(),
  created_by    uuid, updated_by uuid, version int NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, company_id, code)
);

CREATE TABLE IF NOT EXISTS app.price_list_lines (
  id            uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id     uuid NOT NULL,
  price_list_id uuid NOT NULL REFERENCES app.price_lists(id) ON DELETE CASCADE,
  item_id       uuid NOT NULL,            -- FK to items in module 07
  uom_code      text,
  qty_min       numeric(19,6) NOT NULL DEFAULT 0,
  qty_max       numeric(19,6),
  unit_price    numeric(19,4) NOT NULL CHECK (unit_price >= 0),
  discount_percent numeric(5,2) NOT NULL DEFAULT 0 CHECK (discount_percent BETWEEN 0 AND 100),
  valid_from    date, valid_to date,
  created_at    timestamptz NOT NULL DEFAULT now(),
  updated_at    timestamptz NOT NULL DEFAULT now(),
  created_by    uuid, updated_by uuid, version int NOT NULL DEFAULT 1
);

ALTER TABLE app.customers
  ADD CONSTRAINT fk_customer_pricelist FOREIGN KEY (price_list_id) REFERENCES app.price_lists(id);

CREATE TABLE IF NOT EXISTS app.sales_orders (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  company_id      uuid NOT NULL REFERENCES app.companies(id),
  branch_id       uuid REFERENCES app.branches(id),
  order_number    text NOT NULL,
  order_date      date NOT NULL,
  customer_id     uuid NOT NULL REFERENCES app.customers(id),
  customer_po_number text,
  currency_code   char(3) NOT NULL DEFAULT 'INR',
  fx_rate         numeric(19,8) NOT NULL DEFAULT 1,
  price_list_id   uuid REFERENCES app.price_lists(id),
  billing_address jsonb,
  shipping_address jsonb,
  payment_terms   text,
  delivery_date   date,
  status          text NOT NULL DEFAULT 'draft'
                  CHECK (status IN ('draft','submitted','approved','partial','fulfilled','cancelled','closed')),
  approval_status text NOT NULL DEFAULT 'not_required'
                  CHECK (approval_status IN ('not_required','pending','approved','rejected')),
  subtotal        numeric(19,4) NOT NULL DEFAULT 0,
  discount_total  numeric(19,4) NOT NULL DEFAULT 0,
  tax_total       numeric(19,4) NOT NULL DEFAULT 0,
  grand_total     numeric(19,4) NOT NULL DEFAULT 0,
  salesperson_id  uuid REFERENCES app.users(id),
  notes           text,
  metadata        jsonb NOT NULL DEFAULT '{}'::jsonb,
  created_at      timestamptz NOT NULL DEFAULT now(),
  updated_at      timestamptz NOT NULL DEFAULT now(),
  created_by      uuid, updated_by uuid, version int NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, company_id, order_number)
);

CREATE TABLE IF NOT EXISTS app.sales_order_lines (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  sales_order_id  uuid NOT NULL REFERENCES app.sales_orders(id) ON DELETE CASCADE,
  line_no         smallint NOT NULL,
  item_id         uuid NOT NULL,
  description     text,
  uom_code        text NOT NULL,
  qty_ordered     numeric(19,6) NOT NULL CHECK (qty_ordered > 0),
  qty_delivered   numeric(19,6) NOT NULL DEFAULT 0,
  qty_invoiced    numeric(19,6) NOT NULL DEFAULT 0,
  qty_cancelled   numeric(19,6) NOT NULL DEFAULT 0,
  unit_price      numeric(19,4) NOT NULL CHECK (unit_price >= 0),
  discount_percent numeric(5,2) NOT NULL DEFAULT 0,
  discount_amount numeric(19,4) NOT NULL DEFAULT 0,
  tax_rate_percent numeric(5,2) NOT NULL DEFAULT 0,
  tax_amount      numeric(19,4) NOT NULL DEFAULT 0,
  line_total      numeric(19,4) NOT NULL DEFAULT 0,
  warehouse_id    uuid,
  required_date   date,
  created_at      timestamptz NOT NULL DEFAULT now(),
  updated_at      timestamptz NOT NULL DEFAULT now(),
  created_by      uuid, updated_by uuid, version int NOT NULL DEFAULT 1,
  UNIQUE (sales_order_id, line_no),
  CHECK (qty_delivered + qty_cancelled <= qty_ordered)
);

CREATE TABLE IF NOT EXISTS app.deliveries (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  company_id      uuid NOT NULL REFERENCES app.companies(id),
  branch_id       uuid REFERENCES app.branches(id),
  delivery_number text NOT NULL,
  delivery_date   date NOT NULL,
  customer_id     uuid NOT NULL REFERENCES app.customers(id),
  sales_order_id  uuid REFERENCES app.sales_orders(id),
  warehouse_id    uuid,
  shipping_address jsonb,
  carrier         text,
  tracking_number text,
  status          text NOT NULL DEFAULT 'draft'
                  CHECK (status IN ('draft','picked','shipped','delivered','returned','cancelled')),
  shipped_at      timestamptz,
  delivered_at    timestamptz,
  pod_document_id uuid,
  created_at      timestamptz NOT NULL DEFAULT now(),
  updated_at      timestamptz NOT NULL DEFAULT now(),
  created_by      uuid, updated_by uuid, version int NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, company_id, delivery_number)
);

CREATE TABLE IF NOT EXISTS app.delivery_lines (
  id            uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id     uuid NOT NULL,
  delivery_id   uuid NOT NULL REFERENCES app.deliveries(id) ON DELETE CASCADE,
  line_no       smallint NOT NULL,
  sales_order_line_id uuid REFERENCES app.sales_order_lines(id),
  item_id       uuid NOT NULL,
  uom_code      text NOT NULL,
  qty           numeric(19,6) NOT NULL CHECK (qty > 0),
  batch_id      uuid,
  serial_numbers text[],
  created_at    timestamptz NOT NULL DEFAULT now(),
  updated_at    timestamptz NOT NULL DEFAULT now(),
  created_by    uuid, updated_by uuid, version int NOT NULL DEFAULT 1,
  UNIQUE (delivery_id, line_no)
);

CREATE TABLE IF NOT EXISTS app.sales_invoices (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  company_id      uuid NOT NULL REFERENCES app.companies(id),
  branch_id       uuid REFERENCES app.branches(id),
  invoice_number  text NOT NULL,
  invoice_date    date NOT NULL,
  due_date        date,
  customer_id     uuid NOT NULL REFERENCES app.customers(id),
  sales_order_id  uuid REFERENCES app.sales_orders(id),
  currency_code   char(3) NOT NULL DEFAULT 'INR',
  fx_rate         numeric(19,8) NOT NULL DEFAULT 1,
  place_of_supply text,
  reverse_charge  boolean NOT NULL DEFAULT false,
  subtotal        numeric(19,4) NOT NULL DEFAULT 0,
  discount_total  numeric(19,4) NOT NULL DEFAULT 0,
  taxable_amount  numeric(19,4) NOT NULL DEFAULT 0,
  cgst_total      numeric(19,4) NOT NULL DEFAULT 0,
  sgst_total      numeric(19,4) NOT NULL DEFAULT 0,
  igst_total      numeric(19,4) NOT NULL DEFAULT 0,
  cess_total      numeric(19,4) NOT NULL DEFAULT 0,
  round_off       numeric(19,4) NOT NULL DEFAULT 0,
  grand_total     numeric(19,4) NOT NULL DEFAULT 0,
  amount_paid     numeric(19,4) NOT NULL DEFAULT 0,
  amount_due      numeric(19,4) NOT NULL DEFAULT 0,
  status          text NOT NULL DEFAULT 'draft'
                  CHECK (status IN ('draft','submitted','posted','partial_paid','paid','overdue','cancelled','credit_noted')),
  payment_status  text NOT NULL DEFAULT 'unpaid'
                  CHECK (payment_status IN ('unpaid','partial','paid','overdue')),
  irn             text,
  qr_code         text,
  eway_bill_no    text,
  journal_entry_id uuid,
  notes           text,
  created_at      timestamptz NOT NULL DEFAULT now(),
  updated_at      timestamptz NOT NULL DEFAULT now(),
  created_by      uuid, updated_by uuid, version int NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, company_id, invoice_number)
);

CREATE TABLE IF NOT EXISTS app.sales_invoice_lines (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  sales_invoice_id uuid NOT NULL REFERENCES app.sales_invoices(id) ON DELETE CASCADE,
  line_no         smallint NOT NULL,
  item_id         uuid NOT NULL,
  description     text,
  hsn_sac         text,
  uom_code        text NOT NULL,
  qty             numeric(19,6) NOT NULL CHECK (qty > 0),
  unit_price      numeric(19,4) NOT NULL CHECK (unit_price >= 0),
  discount_percent numeric(5,2) NOT NULL DEFAULT 0,
  discount_amount numeric(19,4) NOT NULL DEFAULT 0,
  taxable_amount  numeric(19,4) NOT NULL DEFAULT 0,
  cgst_rate       numeric(5,2) NOT NULL DEFAULT 0,
  sgst_rate       numeric(5,2) NOT NULL DEFAULT 0,
  igst_rate       numeric(5,2) NOT NULL DEFAULT 0,
  cess_rate       numeric(5,2) NOT NULL DEFAULT 0,
  cgst_amount     numeric(19,4) NOT NULL DEFAULT 0,
  sgst_amount     numeric(19,4) NOT NULL DEFAULT 0,
  igst_amount     numeric(19,4) NOT NULL DEFAULT 0,
  cess_amount     numeric(19,4) NOT NULL DEFAULT 0,
  line_total      numeric(19,4) NOT NULL DEFAULT 0,
  revenue_account_id uuid REFERENCES app.chart_of_accounts(id),
  cost_center_id  uuid REFERENCES app.cost_centers(id),
  delivery_line_id uuid REFERENCES app.delivery_lines(id),
  created_at      timestamptz NOT NULL DEFAULT now(),
  updated_at      timestamptz NOT NULL DEFAULT now(),
  created_by      uuid, updated_by uuid, version int NOT NULL DEFAULT 1,
  UNIQUE (sales_invoice_id, line_no)
);

CREATE TABLE IF NOT EXISTS app.credit_notes (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  company_id      uuid NOT NULL REFERENCES app.companies(id),
  cn_number       text NOT NULL,
  cn_date         date NOT NULL,
  customer_id     uuid NOT NULL REFERENCES app.customers(id),
  reference_invoice_id uuid REFERENCES app.sales_invoices(id),
  reason          text,
  currency_code   char(3) NOT NULL DEFAULT 'INR',
  subtotal        numeric(19,4) NOT NULL DEFAULT 0,
  tax_total       numeric(19,4) NOT NULL DEFAULT 0,
  grand_total     numeric(19,4) NOT NULL DEFAULT 0,
  status          text NOT NULL DEFAULT 'draft' CHECK (status IN ('draft','posted','cancelled')),
  journal_entry_id uuid,
  created_at      timestamptz NOT NULL DEFAULT now(),
  updated_at      timestamptz NOT NULL DEFAULT now(),
  created_by      uuid, updated_by uuid, version int NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, company_id, cn_number)
);

-- =============== INDEXES ===============
CREATE INDEX IF NOT EXISTS idx_customers_tenant_status ON app.customers(tenant_id, company_id, status);
CREATE INDEX IF NOT EXISTS idx_customers_name_trgm     ON app.customers USING gin (name gin_trgm_ops);
CREATE INDEX IF NOT EXISTS idx_customers_email         ON app.customers(tenant_id, email) WHERE email IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_customers_gstin         ON app.customers(tenant_id, gstin) WHERE gstin IS NOT NULL;

CREATE INDEX IF NOT EXISTS idx_so_tenant_date   ON app.sales_orders(tenant_id, company_id, order_date DESC);
CREATE INDEX IF NOT EXISTS idx_so_customer      ON app.sales_orders(customer_id, order_date DESC);
CREATE INDEX IF NOT EXISTS idx_so_status        ON app.sales_orders(tenant_id, status) WHERE status IN ('draft','submitted','approved','partial');
CREATE INDEX IF NOT EXISTS idx_sol_so           ON app.sales_order_lines(sales_order_id);
CREATE INDEX IF NOT EXISTS idx_sol_item         ON app.sales_order_lines(item_id);

CREATE INDEX IF NOT EXISTS idx_delivery_so      ON app.deliveries(sales_order_id);
CREATE INDEX IF NOT EXISTS idx_delivery_status  ON app.deliveries(tenant_id, status) WHERE status IN ('draft','picked','shipped');
CREATE INDEX IF NOT EXISTS idx_dl_delivery      ON app.delivery_lines(delivery_id);

CREATE INDEX IF NOT EXISTS idx_si_customer_date ON app.sales_invoices(customer_id, invoice_date DESC);
CREATE INDEX IF NOT EXISTS idx_si_tenant_date   ON app.sales_invoices(tenant_id, invoice_date DESC);
CREATE INDEX IF NOT EXISTS idx_si_status        ON app.sales_invoices(tenant_id, status, due_date) WHERE status IN ('posted','partial_paid','overdue');
CREATE INDEX IF NOT EXISTS idx_si_due_overdue   ON app.sales_invoices(tenant_id, due_date) WHERE amount_due > 0;
CREATE INDEX IF NOT EXISTS idx_sil_invoice      ON app.sales_invoice_lines(sales_invoice_id);
CREATE INDEX IF NOT EXISTS idx_sil_item         ON app.sales_invoice_lines(item_id);

CREATE INDEX IF NOT EXISTS idx_pll_pricelist_item ON app.price_list_lines(price_list_id, item_id, valid_from, valid_to);

-- =============== RLS ===============
SELECT core.enable_tenant_rls('app.customers');
SELECT core.enable_tenant_rls('app.customer_contacts');
SELECT core.enable_tenant_rls('app.customer_addresses');
SELECT core.enable_tenant_rls('app.price_lists');
SELECT core.enable_tenant_rls('app.price_list_lines');
SELECT core.enable_tenant_rls('app.sales_orders');
SELECT core.enable_tenant_rls('app.sales_order_lines');
SELECT core.enable_tenant_rls('app.deliveries');
SELECT core.enable_tenant_rls('app.delivery_lines');
SELECT core.enable_tenant_rls('app.sales_invoices');
SELECT core.enable_tenant_rls('app.sales_invoice_lines');
SELECT core.enable_tenant_rls('app.credit_notes');

-- =============== FUNCTIONS ===============

-- Recompute sales_order totals from lines
CREATE OR REPLACE FUNCTION app.recompute_sales_order_totals(p_so_id uuid)
RETURNS void
LANGUAGE sql
AS $$
  UPDATE app.sales_orders so
     SET subtotal       = t.sub, discount_total = t.disc,
         tax_total      = t.tax, grand_total   = t.sub - t.disc + t.tax,
         updated_at     = now()
    FROM (SELECT COALESCE(SUM(qty_ordered * unit_price),0) sub,
                 COALESCE(SUM(discount_amount),0) disc,
                 COALESCE(SUM(tax_amount),0) tax
            FROM app.sales_order_lines
           WHERE sales_order_id = p_so_id) t
   WHERE so.id = p_so_id;
$$;

-- Compute line-level Indian GST (intrastate vs interstate)
CREATE OR REPLACE FUNCTION app.compute_gst_split(
  p_taxable numeric, p_gst_rate numeric, p_intrastate boolean
) RETURNS TABLE(cgst_amt numeric, sgst_amt numeric, igst_amt numeric)
LANGUAGE sql
IMMUTABLE
AS $$
  SELECT
    CASE WHEN p_intrastate THEN round(p_taxable * (p_gst_rate/2)/100, 4) ELSE 0 END,
    CASE WHEN p_intrastate THEN round(p_taxable * (p_gst_rate/2)/100, 4) ELSE 0 END,
    CASE WHEN NOT p_intrastate THEN round(p_taxable * p_gst_rate/100, 4) ELSE 0 END
$$;

-- Recompute invoice line amounts (discount, taxable, gst)
CREATE OR REPLACE FUNCTION app.recompute_invoice_line(p_line_id uuid)
RETURNS void
LANGUAGE plpgsql
AS $$
DECLARE
  v_gross numeric(19,4); v_disc numeric(19,4); v_taxable numeric(19,4);
  v_cgst numeric(19,4); v_sgst numeric(19,4); v_igst numeric(19,4); v_cess numeric(19,4);
BEGIN
  UPDATE app.sales_invoice_lines
     SET
       discount_amount = round(qty * unit_price * (discount_percent/100), 4),
       taxable_amount  = round(qty * unit_price - round(qty * unit_price * (discount_percent/100),4), 4),
       cgst_amount     = round(
         (qty * unit_price - round(qty * unit_price * (discount_percent/100),4)) * cgst_rate/100, 4),
       sgst_amount     = round(
         (qty * unit_price - round(qty * unit_price * (discount_percent/100),4)) * sgst_rate/100, 4),
       igst_amount     = round(
         (qty * unit_price - round(qty * unit_price * (discount_percent/100),4)) * igst_rate/100, 4),
       cess_amount     = round(
         (qty * unit_price - round(qty * unit_price * (discount_percent/100),4)) * cess_rate/100, 4),
       line_total      = round(
         (qty * unit_price - round(qty * unit_price * (discount_percent/100),4)) *
         (1 + (cgst_rate+sgst_rate+igst_rate+cess_rate)/100), 4),
       updated_at = now()
   WHERE id = p_line_id;
END $$;

-- Recompute invoice header totals
CREATE OR REPLACE FUNCTION app.recompute_sales_invoice_totals(p_inv_id uuid)
RETURNS void
LANGUAGE sql
AS $$
  UPDATE app.sales_invoices si
     SET subtotal       = t.gross,
         discount_total = t.disc,
         taxable_amount = t.taxable,
         cgst_total     = t.cgst,
         sgst_total     = t.sgst,
         igst_total     = t.igst,
         cess_total     = t.cess,
         grand_total    = round(t.taxable + t.cgst + t.sgst + t.igst + t.cess, 2),
         amount_due     = round(t.taxable + t.cgst + t.sgst + t.igst + t.cess, 2) - si.amount_paid,
         updated_at     = now()
    FROM (SELECT
            COALESCE(SUM(qty * unit_price),0)    gross,
            COALESCE(SUM(discount_amount),0)     disc,
            COALESCE(SUM(taxable_amount),0)      taxable,
            COALESCE(SUM(cgst_amount),0)         cgst,
            COALESCE(SUM(sgst_amount),0)         sgst,
            COALESCE(SUM(igst_amount),0)         igst,
            COALESCE(SUM(cess_amount),0)         cess
          FROM app.sales_invoice_lines WHERE sales_invoice_id = p_inv_id) t
   WHERE si.id = p_inv_id;
$$;

-- Credit check: usable credit remaining for a customer
CREATE OR REPLACE FUNCTION app.customer_available_credit(p_customer_id uuid)
RETURNS numeric
LANGUAGE sql
STABLE
AS $$
  SELECT c.credit_limit - COALESCE((
    SELECT SUM(amount_due) FROM app.sales_invoices
     WHERE customer_id = p_customer_id AND amount_due > 0
  ),0)
    FROM app.customers c WHERE c.id = p_customer_id
$$;

-- Best unit price from customer's price list for an item, on a given date
CREATE OR REPLACE FUNCTION app.price_for_item(
  p_customer_id uuid, p_item_id uuid, p_qty numeric, p_on_date date DEFAULT CURRENT_DATE
) RETURNS numeric
LANGUAGE sql
STABLE
AS $$
  SELECT pll.unit_price * (1 - pll.discount_percent/100)
    FROM app.customers c
    JOIN app.price_lists pl        ON pl.id = c.price_list_id AND pl.active
    JOIN app.price_list_lines pll  ON pll.price_list_id = pl.id
   WHERE c.id = p_customer_id
     AND pll.item_id = p_item_id
     AND p_qty BETWEEN pll.qty_min AND COALESCE(pll.qty_max, 1e18)
     AND (pll.valid_from IS NULL OR pll.valid_from <= p_on_date)
     AND (pll.valid_to   IS NULL OR pll.valid_to   >= p_on_date)
   ORDER BY pll.qty_min DESC, pll.unit_price ASC
   LIMIT 1
$$;

-- =============== PROCEDURES ===============

-- Submit sales order (validates credit, triggers approval workflow if needed)
CREATE OR REPLACE PROCEDURE app.submit_sales_order(p_so_id uuid)
LANGUAGE plpgsql
AS $$
DECLARE
  v_so app.sales_orders%ROWTYPE;
  v_available numeric;
BEGIN
  SELECT * INTO v_so FROM app.sales_orders WHERE id = p_so_id;
  IF NOT FOUND THEN RAISE EXCEPTION 'sales order % not found', p_so_id; END IF;
  IF v_so.status <> 'draft' THEN RAISE EXCEPTION 'SO must be draft to submit (is %)', v_so.status; END IF;

  PERFORM app.recompute_sales_order_totals(p_so_id);
  SELECT grand_total INTO v_so.grand_total FROM app.sales_orders WHERE id = p_so_id;

  v_available := app.customer_available_credit(v_so.customer_id);
  IF v_available < v_so.grand_total THEN
    UPDATE app.sales_orders SET status='submitted', approval_status='pending', updated_at=now() WHERE id=p_so_id;
  ELSE
    UPDATE app.sales_orders SET status='approved', approval_status='approved', updated_at=now() WHERE id=p_so_id;
  END IF;
END $$;

-- Post sales invoice: creates journal entry, updates AR
CREATE OR REPLACE PROCEDURE app.post_sales_invoice(p_inv_id uuid)
LANGUAGE plpgsql
AS $$
DECLARE
  v_inv  app.sales_invoices%ROWTYPE;
  v_fy uuid; v_fp uuid; v_st text;
  v_ar  uuid;     v_cgst_a uuid; v_sgst_a uuid; v_igst_a uuid;
  v_je_id uuid := gen_random_uuid();
  v_je_num text; v_ln int := 0;
  r record;
BEGIN
  SELECT * INTO v_inv FROM app.sales_invoices WHERE id = p_inv_id;
  IF v_inv.status <> 'submitted' THEN RAISE EXCEPTION 'invoice status must be submitted'; END IF;

  PERFORM app.recompute_sales_invoice_totals(p_inv_id);
  SELECT * INTO v_inv FROM app.sales_invoices WHERE id = p_inv_id;

  SELECT fiscal_year_id, period_id, status INTO v_fy, v_fp, v_st
    FROM core.period_for_date(v_inv.company_id, v_inv.invoice_date);
  IF v_st IS DISTINCT FROM 'open' THEN RAISE EXCEPTION 'period not open'; END IF;

  SELECT id INTO v_ar FROM app.chart_of_accounts
   WHERE company_id=v_inv.company_id AND account_subtype='accounts_receivable' AND NOT is_group LIMIT 1;
  SELECT id INTO v_cgst_a FROM app.chart_of_accounts
   WHERE company_id=v_inv.company_id AND code ILIKE 'CGST%' AND NOT is_group LIMIT 1;
  SELECT id INTO v_sgst_a FROM app.chart_of_accounts
   WHERE company_id=v_inv.company_id AND code ILIKE 'SGST%' AND NOT is_group LIMIT 1;
  SELECT id INTO v_igst_a FROM app.chart_of_accounts
   WHERE company_id=v_inv.company_id AND code ILIKE 'IGST%' AND NOT is_group LIMIT 1;

  v_je_num := core.next_doc_number('JE_SALES');

  INSERT INTO app.journal_entries(id,tenant_id,company_id,fiscal_year_id,financial_period_id,
         entry_number,posting_date,entry_type,source_module,source_document_id,
         reference,currency_code,fx_rate,status)
  VALUES (v_je_id, v_inv.tenant_id, v_inv.company_id, v_fy, v_fp,
          v_je_num, v_inv.invoice_date, 'system', 'sales', v_inv.id,
          v_inv.invoice_number, v_inv.currency_code, v_inv.fx_rate, 'draft');

  -- Debit: AR (customer) — gross
  v_ln := v_ln + 1;
  INSERT INTO app.journal_lines(id,tenant_id,journal_entry_id,posting_date,line_no,
         account_id,party_type,party_id,debit,credit,currency_code,fx_rate,description)
  VALUES (gen_random_uuid(), v_inv.tenant_id, v_je_id, v_inv.invoice_date, v_ln,
          v_ar, 'customer', v_inv.customer_id, v_inv.grand_total, 0,
          v_inv.currency_code, v_inv.fx_rate, 'Invoice '||v_inv.invoice_number);

  -- Credit: Revenue per line (grouped by revenue account)
  FOR r IN
    SELECT COALESCE(revenue_account_id,
             (SELECT id FROM app.chart_of_accounts
               WHERE company_id = v_inv.company_id AND account_type='revenue' AND NOT is_group LIMIT 1)
           ) AS acct,
           COALESCE(cost_center_id, NULL) AS cc,
           SUM(taxable_amount) AS amt
      FROM app.sales_invoice_lines
     WHERE sales_invoice_id = p_inv_id
     GROUP BY 1,2
  LOOP
    v_ln := v_ln + 1;
    INSERT INTO app.journal_lines(id,tenant_id,journal_entry_id,posting_date,line_no,
           account_id,cost_center_id,debit,credit,currency_code,fx_rate,description)
    VALUES (gen_random_uuid(), v_inv.tenant_id, v_je_id, v_inv.invoice_date, v_ln,
            r.acct, r.cc, 0, r.amt, v_inv.currency_code, v_inv.fx_rate, 'Sales revenue');
  END LOOP;

  -- Credit: GST outputs
  IF v_inv.cgst_total > 0 AND v_cgst_a IS NOT NULL THEN
    v_ln := v_ln + 1;
    INSERT INTO app.journal_lines(id,tenant_id,journal_entry_id,posting_date,line_no,
           account_id,debit,credit,currency_code,fx_rate,description)
    VALUES (gen_random_uuid(), v_inv.tenant_id, v_je_id, v_inv.invoice_date, v_ln,
            v_cgst_a, 0, v_inv.cgst_total, v_inv.currency_code, v_inv.fx_rate, 'CGST output');
  END IF;
  IF v_inv.sgst_total > 0 AND v_sgst_a IS NOT NULL THEN
    v_ln := v_ln + 1;
    INSERT INTO app.journal_lines(id,tenant_id,journal_entry_id,posting_date,line_no,
           account_id,debit,credit,currency_code,fx_rate,description)
    VALUES (gen_random_uuid(), v_inv.tenant_id, v_je_id, v_inv.invoice_date, v_ln,
            v_sgst_a, 0, v_inv.sgst_total, v_inv.currency_code, v_inv.fx_rate, 'SGST output');
  END IF;
  IF v_inv.igst_total > 0 AND v_igst_a IS NOT NULL THEN
    v_ln := v_ln + 1;
    INSERT INTO app.journal_lines(id,tenant_id,journal_entry_id,posting_date,line_no,
           account_id,debit,credit,currency_code,fx_rate,description)
    VALUES (gen_random_uuid(), v_inv.tenant_id, v_je_id, v_inv.invoice_date, v_ln,
            v_igst_a, 0, v_inv.igst_total, v_inv.currency_code, v_inv.fx_rate, 'IGST output');
  END IF;

  PERFORM app.post_journal_entry(v_je_id);

  UPDATE app.sales_invoices
     SET status='posted', journal_entry_id = v_je_id,
         due_date = COALESCE(due_date, invoice_date + (
           SELECT COALESCE(credit_days,0) FROM app.customers WHERE id = v_inv.customer_id)),
         updated_at = now()
   WHERE id = p_inv_id;
END $$;

-- =============== TRIGGERS ===============
SELECT core.attach_standard_triggers('app.customers');
SELECT core.attach_standard_triggers('app.customer_contacts');
SELECT core.attach_standard_triggers('app.customer_addresses');
SELECT core.attach_standard_triggers('app.price_lists');
SELECT core.attach_standard_triggers('app.price_list_lines');
SELECT core.attach_standard_triggers('app.sales_orders');
SELECT core.attach_standard_triggers('app.sales_order_lines');
SELECT core.attach_standard_triggers('app.deliveries');
SELECT core.attach_standard_triggers('app.delivery_lines');
SELECT core.attach_standard_triggers('app.sales_invoices');
SELECT core.attach_standard_triggers('app.sales_invoice_lines');
SELECT core.attach_standard_triggers('app.credit_notes');

-- Auto line_total for SO line
CREATE OR REPLACE FUNCTION core.tg_sol_linetotal()
RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
  NEW.discount_amount := round(NEW.qty_ordered * NEW.unit_price * (NEW.discount_percent/100), 4);
  NEW.tax_amount      := round((NEW.qty_ordered * NEW.unit_price - NEW.discount_amount) * NEW.tax_rate_percent/100, 4);
  NEW.line_total      := round(NEW.qty_ordered * NEW.unit_price - NEW.discount_amount + NEW.tax_amount, 4);
  RETURN NEW;
END $$;
DROP TRIGGER IF EXISTS trg_sol_linetotal ON app.sales_order_lines;
CREATE TRIGGER trg_sol_linetotal
  BEFORE INSERT OR UPDATE ON app.sales_order_lines
  FOR EACH ROW EXECUTE FUNCTION core.tg_sol_linetotal();

-- Recompute SO header totals on line change
CREATE OR REPLACE FUNCTION core.tg_so_recompute()
RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
  PERFORM app.recompute_sales_order_totals(COALESCE(NEW.sales_order_id, OLD.sales_order_id));
  RETURN COALESCE(NEW, OLD);
END $$;
DROP TRIGGER IF EXISTS trg_so_recompute ON app.sales_order_lines;
CREATE TRIGGER trg_so_recompute
  AFTER INSERT OR UPDATE OR DELETE ON app.sales_order_lines
  FOR EACH ROW EXECUTE FUNCTION core.tg_so_recompute();

-- Recompute invoice on line change
CREATE OR REPLACE FUNCTION core.tg_si_recompute()
RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
  IF TG_OP IN ('INSERT','UPDATE') THEN
    PERFORM app.recompute_invoice_line(NEW.id);
  END IF;
  PERFORM app.recompute_sales_invoice_totals(COALESCE(NEW.sales_invoice_id, OLD.sales_invoice_id));
  RETURN COALESCE(NEW, OLD);
END $$;
DROP TRIGGER IF EXISTS trg_si_recompute ON app.sales_invoice_lines;
CREATE TRIGGER trg_si_recompute
  AFTER INSERT OR UPDATE OR DELETE ON app.sales_invoice_lines
  FOR EACH ROW EXECUTE FUNCTION core.tg_si_recompute();

-- Block invoice/SO deletion when posted
CREATE OR REPLACE FUNCTION core.tg_block_delete_posted_sales()
RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
  IF TG_TABLE_NAME = 'sales_invoices' AND OLD.status IN ('posted','partial_paid','paid','credit_noted') THEN
    RAISE EXCEPTION 'cannot delete posted invoice %', OLD.invoice_number;
  END IF;
  IF TG_TABLE_NAME = 'sales_orders' AND OLD.status NOT IN ('draft','cancelled') THEN
    RAISE EXCEPTION 'cannot delete active sales order %', OLD.order_number;
  END IF;
  RETURN OLD;
END $$;
DROP TRIGGER IF EXISTS trg_si_nodelete ON app.sales_invoices;
CREATE TRIGGER trg_si_nodelete BEFORE DELETE ON app.sales_invoices
  FOR EACH ROW EXECUTE FUNCTION core.tg_block_delete_posted_sales();
DROP TRIGGER IF EXISTS trg_so_nodelete ON app.sales_orders;
CREATE TRIGGER trg_so_nodelete BEFORE DELETE ON app.sales_orders
  FOR EACH ROW EXECUTE FUNCTION core.tg_block_delete_posted_sales();

-- =============== VIEWS ===============
CREATE OR REPLACE VIEW app.v_customer_outstanding AS
SELECT si.tenant_id, si.customer_id, c.name,
       COUNT(*) FILTER (WHERE si.amount_due > 0)                       AS open_invoice_count,
       SUM(si.amount_due) FILTER (WHERE si.amount_due > 0)             AS total_due,
       SUM(si.amount_due) FILTER (WHERE si.due_date < CURRENT_DATE)    AS overdue_amount
  FROM app.sales_invoices si
  JOIN app.customers c ON c.id = si.customer_id
 WHERE si.status IN ('posted','partial_paid','overdue')
 GROUP BY si.tenant_id, si.customer_id, c.name;

CREATE OR REPLACE VIEW app.v_sales_pipeline AS
SELECT so.tenant_id, so.company_id,
       date_trunc('month', so.order_date)::date   AS period,
       so.status,
       COUNT(*)                                   AS order_count,
       SUM(so.grand_total)                        AS total_value
  FROM app.sales_orders so
 GROUP BY 1,2,3,4;

CREATE OR REPLACE VIEW app.v_ar_aging AS
SELECT si.tenant_id, si.customer_id, c.name,
       SUM(CASE WHEN CURRENT_DATE - si.due_date <=  0 THEN si.amount_due ELSE 0 END) AS current_bucket,
       SUM(CASE WHEN CURRENT_DATE - si.due_date BETWEEN 1  AND 30 THEN si.amount_due ELSE 0 END) AS d1_30,
       SUM(CASE WHEN CURRENT_DATE - si.due_date BETWEEN 31 AND 60 THEN si.amount_due ELSE 0 END) AS d31_60,
       SUM(CASE WHEN CURRENT_DATE - si.due_date BETWEEN 61 AND 90 THEN si.amount_due ELSE 0 END) AS d61_90,
       SUM(CASE WHEN CURRENT_DATE - si.due_date >  90                 THEN si.amount_due ELSE 0 END) AS d90_plus
  FROM app.sales_invoices si
  JOIN app.customers c ON c.id = si.customer_id
 WHERE si.amount_due > 0
 GROUP BY si.tenant_id, si.customer_id, c.name;
