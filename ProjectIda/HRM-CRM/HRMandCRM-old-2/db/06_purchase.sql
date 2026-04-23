-- =====================================================================
-- Module 06: Purchase Management
-- Covers PRD Step 6 (3-way match, approval, GRN, landed cost hooks)
-- =====================================================================

SET search_path = app, core, public;

-- =============== SCHEMA ===============

CREATE TABLE IF NOT EXISTS app.suppliers (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  company_id      uuid NOT NULL REFERENCES app.companies(id),
  code            citext NOT NULL,
  supplier_type   text NOT NULL DEFAULT 'business' CHECK (supplier_type IN ('business','individual','government')),
  name            text NOT NULL,
  display_name    text,
  legal_name      text,
  email           citext,
  phone           text,
  gstin           text,
  pan             text,
  msme_category   text CHECK (msme_category IN ('micro','small','medium',NULL)),
  msme_udyam_no   text,
  tds_category    text,
  default_currency char(3) NOT NULL DEFAULT 'INR',
  payment_terms   text,
  credit_days     smallint NOT NULL DEFAULT 0,
  billing_address jsonb,
  shipping_address jsonb,
  kyc_status      text NOT NULL DEFAULT 'pending' CHECK (kyc_status IN ('pending','verified','rejected','expired')),
  status          text NOT NULL DEFAULT 'active' CHECK (status IN ('active','inactive','blocked','on_hold')),
  rating          numeric(3,2) CHECK (rating IS NULL OR rating BETWEEN 0 AND 5),
  metadata        jsonb NOT NULL DEFAULT '{}'::jsonb,
  created_at      timestamptz NOT NULL DEFAULT now(),
  updated_at      timestamptz NOT NULL DEFAULT now(),
  created_by      uuid, updated_by uuid, version int NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, company_id, code)
);

CREATE TABLE IF NOT EXISTS app.supplier_contacts (
  id            uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id     uuid NOT NULL,
  supplier_id   uuid NOT NULL REFERENCES app.suppliers(id) ON DELETE CASCADE,
  name          text NOT NULL,
  designation   text,
  email         citext, phone text,
  is_primary    boolean NOT NULL DEFAULT false,
  created_at    timestamptz NOT NULL DEFAULT now(),
  updated_at    timestamptz NOT NULL DEFAULT now(),
  created_by    uuid, updated_by uuid, version int NOT NULL DEFAULT 1
);

CREATE TABLE IF NOT EXISTS app.purchase_requisitions (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  company_id      uuid NOT NULL REFERENCES app.companies(id),
  branch_id       uuid REFERENCES app.branches(id),
  pr_number       text NOT NULL,
  pr_date         date NOT NULL,
  requested_by    uuid NOT NULL REFERENCES app.users(id),
  department      text,
  cost_center_id  uuid REFERENCES app.cost_centers(id),
  required_by     date,
  justification   text,
  status          text NOT NULL DEFAULT 'draft'
                  CHECK (status IN ('draft','submitted','approved','rejected','ordered','cancelled')),
  approval_status text NOT NULL DEFAULT 'not_required',
  estimated_total numeric(19,4) NOT NULL DEFAULT 0,
  created_at      timestamptz NOT NULL DEFAULT now(),
  updated_at      timestamptz NOT NULL DEFAULT now(),
  created_by      uuid, updated_by uuid, version int NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, company_id, pr_number)
);

CREATE TABLE IF NOT EXISTS app.pr_lines (
  id            uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id     uuid NOT NULL,
  pr_id         uuid NOT NULL REFERENCES app.purchase_requisitions(id) ON DELETE CASCADE,
  line_no       smallint NOT NULL,
  item_id       uuid,
  description   text NOT NULL,
  uom_code      text NOT NULL,
  qty           numeric(19,6) NOT NULL CHECK (qty > 0),
  estimated_price numeric(19,4),
  qty_ordered   numeric(19,6) NOT NULL DEFAULT 0,
  created_at    timestamptz NOT NULL DEFAULT now(),
  updated_at    timestamptz NOT NULL DEFAULT now(),
  created_by    uuid, updated_by uuid, version int NOT NULL DEFAULT 1,
  UNIQUE (pr_id, line_no)
);

CREATE TABLE IF NOT EXISTS app.rfqs (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  company_id      uuid NOT NULL REFERENCES app.companies(id),
  rfq_number      text NOT NULL,
  rfq_date        date NOT NULL,
  deadline        date,
  status          text NOT NULL DEFAULT 'draft'
                  CHECK (status IN ('draft','sent','closed','awarded','cancelled')),
  created_at      timestamptz NOT NULL DEFAULT now(),
  updated_at      timestamptz NOT NULL DEFAULT now(),
  created_by      uuid, updated_by uuid, version int NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, company_id, rfq_number)
);

CREATE TABLE IF NOT EXISTS app.rfq_suppliers (
  tenant_id     uuid NOT NULL,
  rfq_id        uuid NOT NULL REFERENCES app.rfqs(id) ON DELETE CASCADE,
  supplier_id   uuid NOT NULL REFERENCES app.suppliers(id),
  sent_at       timestamptz,
  response_status text NOT NULL DEFAULT 'pending' CHECK (response_status IN ('pending','responded','declined')),
  PRIMARY KEY (rfq_id, supplier_id)
);

CREATE TABLE IF NOT EXISTS app.rfq_lines (
  id            uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id     uuid NOT NULL,
  rfq_id        uuid NOT NULL REFERENCES app.rfqs(id) ON DELETE CASCADE,
  line_no       smallint NOT NULL,
  item_id       uuid,
  description   text NOT NULL,
  uom_code      text NOT NULL,
  qty           numeric(19,6) NOT NULL CHECK (qty > 0),
  UNIQUE (rfq_id, line_no)
);

CREATE TABLE IF NOT EXISTS app.rfq_quotes (
  id            uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id     uuid NOT NULL,
  rfq_id        uuid NOT NULL REFERENCES app.rfqs(id) ON DELETE CASCADE,
  supplier_id   uuid NOT NULL REFERENCES app.suppliers(id),
  rfq_line_id   uuid NOT NULL REFERENCES app.rfq_lines(id) ON DELETE CASCADE,
  unit_price    numeric(19,4) NOT NULL CHECK (unit_price >= 0),
  lead_time_days smallint,
  currency_code char(3) NOT NULL DEFAULT 'INR',
  notes         text,
  created_at    timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS app.purchase_orders (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  company_id      uuid NOT NULL REFERENCES app.companies(id),
  branch_id       uuid REFERENCES app.branches(id),
  po_number       text NOT NULL,
  po_date         date NOT NULL,
  supplier_id     uuid NOT NULL REFERENCES app.suppliers(id),
  pr_id           uuid REFERENCES app.purchase_requisitions(id),
  rfq_id          uuid REFERENCES app.rfqs(id),
  currency_code   char(3) NOT NULL DEFAULT 'INR',
  fx_rate         numeric(19,8) NOT NULL DEFAULT 1,
  payment_terms   text,
  expected_date   date,
  shipping_address jsonb,
  po_type         text NOT NULL DEFAULT 'standard'
                  CHECK (po_type IN ('standard','blanket','scheduled','service')),
  status          text NOT NULL DEFAULT 'draft'
                  CHECK (status IN ('draft','submitted','approved','sent','partial','received','cancelled','closed')),
  approval_status text NOT NULL DEFAULT 'not_required',
  subtotal        numeric(19,4) NOT NULL DEFAULT 0,
  discount_total  numeric(19,4) NOT NULL DEFAULT 0,
  tax_total       numeric(19,4) NOT NULL DEFAULT 0,
  grand_total     numeric(19,4) NOT NULL DEFAULT 0,
  buyer_id        uuid REFERENCES app.users(id),
  created_at      timestamptz NOT NULL DEFAULT now(),
  updated_at      timestamptz NOT NULL DEFAULT now(),
  created_by      uuid, updated_by uuid, version int NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, company_id, po_number)
);

CREATE TABLE IF NOT EXISTS app.po_lines (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  po_id           uuid NOT NULL REFERENCES app.purchase_orders(id) ON DELETE CASCADE,
  line_no         smallint NOT NULL,
  item_id         uuid NOT NULL,
  description     text,
  hsn_sac         text,
  uom_code        text NOT NULL,
  qty_ordered     numeric(19,6) NOT NULL CHECK (qty_ordered > 0),
  qty_received    numeric(19,6) NOT NULL DEFAULT 0,
  qty_invoiced    numeric(19,6) NOT NULL DEFAULT 0,
  qty_cancelled   numeric(19,6) NOT NULL DEFAULT 0,
  unit_price      numeric(19,4) NOT NULL CHECK (unit_price >= 0),
  discount_percent numeric(5,2) NOT NULL DEFAULT 0,
  discount_amount numeric(19,4) NOT NULL DEFAULT 0,
  tax_rate_percent numeric(5,2) NOT NULL DEFAULT 0,
  tax_amount      numeric(19,4) NOT NULL DEFAULT 0,
  line_total      numeric(19,4) NOT NULL DEFAULT 0,
  warehouse_id    uuid,
  expected_date   date,
  pr_line_id      uuid REFERENCES app.pr_lines(id),
  created_at      timestamptz NOT NULL DEFAULT now(),
  updated_at      timestamptz NOT NULL DEFAULT now(),
  created_by      uuid, updated_by uuid, version int NOT NULL DEFAULT 1,
  UNIQUE (po_id, line_no),
  CHECK (qty_received + qty_cancelled <= qty_ordered)
);

CREATE TABLE IF NOT EXISTS app.grns (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  company_id      uuid NOT NULL REFERENCES app.companies(id),
  grn_number      text NOT NULL,
  grn_date        date NOT NULL,
  supplier_id     uuid NOT NULL REFERENCES app.suppliers(id),
  po_id           uuid REFERENCES app.purchase_orders(id),
  warehouse_id    uuid,
  delivery_note_ref text,
  vehicle_number  text,
  status          text NOT NULL DEFAULT 'draft'
                  CHECK (status IN ('draft','received','partially_received','rejected','cancelled')),
  qc_status       text NOT NULL DEFAULT 'pending'
                  CHECK (qc_status IN ('pending','passed','failed','waived','partial')),
  received_by     uuid REFERENCES app.users(id),
  journal_entry_id uuid,
  created_at      timestamptz NOT NULL DEFAULT now(),
  updated_at      timestamptz NOT NULL DEFAULT now(),
  created_by      uuid, updated_by uuid, version int NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, company_id, grn_number)
);

CREATE TABLE IF NOT EXISTS app.grn_lines (
  id            uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id     uuid NOT NULL,
  grn_id        uuid NOT NULL REFERENCES app.grns(id) ON DELETE CASCADE,
  line_no       smallint NOT NULL,
  po_line_id    uuid REFERENCES app.po_lines(id),
  item_id       uuid NOT NULL,
  uom_code      text NOT NULL,
  qty_received  numeric(19,6) NOT NULL CHECK (qty_received >= 0),
  qty_accepted  numeric(19,6) NOT NULL DEFAULT 0,
  qty_rejected  numeric(19,6) NOT NULL DEFAULT 0,
  unit_price    numeric(19,4) NOT NULL DEFAULT 0,
  batch_no      text,
  serial_numbers text[],
  expiry_date   date,
  warehouse_id  uuid,
  bin_id        uuid,
  created_at    timestamptz NOT NULL DEFAULT now(),
  updated_at    timestamptz NOT NULL DEFAULT now(),
  created_by    uuid, updated_by uuid, version int NOT NULL DEFAULT 1,
  UNIQUE (grn_id, line_no),
  CHECK (qty_accepted + qty_rejected <= qty_received)
);

CREATE TABLE IF NOT EXISTS app.supplier_invoices (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  company_id      uuid NOT NULL REFERENCES app.companies(id),
  bill_number     text NOT NULL,                     -- supplier's own invoice#
  internal_number text NOT NULL,                     -- our system#
  bill_date       date NOT NULL,
  received_date   date,
  due_date        date,
  supplier_id     uuid NOT NULL REFERENCES app.suppliers(id),
  po_id           uuid REFERENCES app.purchase_orders(id),
  grn_id          uuid REFERENCES app.grns(id),
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
  tds_amount      numeric(19,4) NOT NULL DEFAULT 0,
  round_off       numeric(19,4) NOT NULL DEFAULT 0,
  grand_total     numeric(19,4) NOT NULL DEFAULT 0,
  amount_paid     numeric(19,4) NOT NULL DEFAULT 0,
  amount_due      numeric(19,4) NOT NULL DEFAULT 0,
  three_way_match_status text NOT NULL DEFAULT 'pending'
                  CHECK (three_way_match_status IN ('pending','matched','mismatch','waived')),
  status          text NOT NULL DEFAULT 'draft'
                  CHECK (status IN ('draft','submitted','posted','partial_paid','paid','overdue','disputed','cancelled')),
  journal_entry_id uuid,
  created_at      timestamptz NOT NULL DEFAULT now(),
  updated_at      timestamptz NOT NULL DEFAULT now(),
  created_by      uuid, updated_by uuid, version int NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, company_id, internal_number),
  UNIQUE (tenant_id, supplier_id, bill_number)           -- supplier+bill# uniqueness
);

CREATE TABLE IF NOT EXISTS app.si_lines (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  supplier_invoice_id uuid NOT NULL REFERENCES app.supplier_invoices(id) ON DELETE CASCADE,
  line_no         smallint NOT NULL,
  po_line_id      uuid REFERENCES app.po_lines(id),
  grn_line_id     uuid REFERENCES app.grn_lines(id),
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
  expense_account_id uuid REFERENCES app.chart_of_accounts(id),
  cost_center_id  uuid REFERENCES app.cost_centers(id),
  created_at      timestamptz NOT NULL DEFAULT now(),
  updated_at      timestamptz NOT NULL DEFAULT now(),
  created_by      uuid, updated_by uuid, version int NOT NULL DEFAULT 1,
  UNIQUE (supplier_invoice_id, line_no)
);

CREATE TABLE IF NOT EXISTS app.purchase_returns (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  company_id      uuid NOT NULL REFERENCES app.companies(id),
  return_number   text NOT NULL,
  return_date     date NOT NULL,
  supplier_id     uuid NOT NULL REFERENCES app.suppliers(id),
  grn_id          uuid REFERENCES app.grns(id),
  supplier_invoice_id uuid REFERENCES app.supplier_invoices(id),
  reason          text,
  status          text NOT NULL DEFAULT 'draft' CHECK (status IN ('draft','posted','cancelled')),
  total_amount    numeric(19,4) NOT NULL DEFAULT 0,
  journal_entry_id uuid,
  created_at      timestamptz NOT NULL DEFAULT now(),
  updated_at      timestamptz NOT NULL DEFAULT now(),
  created_by      uuid, updated_by uuid, version int NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, company_id, return_number)
);

-- =============== INDEXES ===============
CREATE INDEX IF NOT EXISTS idx_suppliers_tenant     ON app.suppliers(tenant_id, company_id, status);
CREATE INDEX IF NOT EXISTS idx_suppliers_gstin      ON app.suppliers(tenant_id, gstin) WHERE gstin IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_suppliers_name_trgm  ON app.suppliers USING gin (name gin_trgm_ops);
CREATE INDEX IF NOT EXISTS idx_suppliers_msme       ON app.suppliers(msme_category) WHERE msme_category IS NOT NULL;

CREATE INDEX IF NOT EXISTS idx_pr_tenant_date       ON app.purchase_requisitions(tenant_id, pr_date DESC);
CREATE INDEX IF NOT EXISTS idx_pr_status            ON app.purchase_requisitions(tenant_id, status) WHERE status IN ('draft','submitted');
CREATE INDEX IF NOT EXISTS idx_prl_pr              ON app.pr_lines(pr_id);

CREATE INDEX IF NOT EXISTS idx_po_supplier_date     ON app.purchase_orders(supplier_id, po_date DESC);
CREATE INDEX IF NOT EXISTS idx_po_tenant_date       ON app.purchase_orders(tenant_id, po_date DESC);
CREATE INDEX IF NOT EXISTS idx_po_status            ON app.purchase_orders(tenant_id, status) WHERE status IN ('draft','submitted','approved','partial');
CREATE INDEX IF NOT EXISTS idx_pol_po               ON app.po_lines(po_id);
CREATE INDEX IF NOT EXISTS idx_pol_item             ON app.po_lines(item_id);

CREATE INDEX IF NOT EXISTS idx_grn_po               ON app.grns(po_id);
CREATE INDEX IF NOT EXISTS idx_grn_supplier_date    ON app.grns(supplier_id, grn_date DESC);
CREATE INDEX IF NOT EXISTS idx_grnl_grn             ON app.grn_lines(grn_id);
CREATE INDEX IF NOT EXISTS idx_grnl_poline          ON app.grn_lines(po_line_id);

CREATE INDEX IF NOT EXISTS idx_si_supplier_date     ON app.supplier_invoices(supplier_id, bill_date DESC);
CREATE INDEX IF NOT EXISTS idx_si_tenant_status     ON app.supplier_invoices(tenant_id, status, due_date);
CREATE INDEX IF NOT EXISTS idx_si_due_open          ON app.supplier_invoices(tenant_id, due_date) WHERE amount_due > 0;
CREATE INDEX IF NOT EXISTS idx_sil_si               ON app.si_lines(supplier_invoice_id);

-- =============== RLS ===============
SELECT core.enable_tenant_rls('app.suppliers');
SELECT core.enable_tenant_rls('app.supplier_contacts');
SELECT core.enable_tenant_rls('app.purchase_requisitions');
SELECT core.enable_tenant_rls('app.pr_lines');
SELECT core.enable_tenant_rls('app.rfqs');
SELECT core.enable_tenant_rls('app.rfq_suppliers');
SELECT core.enable_tenant_rls('app.rfq_lines');
SELECT core.enable_tenant_rls('app.rfq_quotes');
SELECT core.enable_tenant_rls('app.purchase_orders');
SELECT core.enable_tenant_rls('app.po_lines');
SELECT core.enable_tenant_rls('app.grns');
SELECT core.enable_tenant_rls('app.grn_lines');
SELECT core.enable_tenant_rls('app.supplier_invoices');
SELECT core.enable_tenant_rls('app.si_lines');
SELECT core.enable_tenant_rls('app.purchase_returns');

-- =============== FUNCTIONS ===============

-- Recompute PO totals
CREATE OR REPLACE FUNCTION app.recompute_po_totals(p_po_id uuid)
RETURNS void LANGUAGE sql AS $$
  UPDATE app.purchase_orders po
     SET subtotal = t.sub, discount_total = t.disc, tax_total = t.tax,
         grand_total = t.sub - t.disc + t.tax, updated_at = now()
    FROM (SELECT COALESCE(SUM(qty_ordered*unit_price),0) sub,
                 COALESCE(SUM(discount_amount),0) disc,
                 COALESCE(SUM(tax_amount),0) tax
            FROM app.po_lines WHERE po_id = p_po_id) t
   WHERE po.id = p_po_id;
$$;

-- Three-way match: PO vs GRN vs supplier invoice (per PO line)
-- Returns 'matched' | 'mismatch' plus discrepancy details as JSON
CREATE OR REPLACE FUNCTION app.three_way_match(p_supplier_invoice_id uuid)
RETURNS jsonb
LANGUAGE plpgsql
STABLE
AS $$
DECLARE
  v_result jsonb := '{"status":"matched","discrepancies":[]}'::jsonb;
  v_discrepancies jsonb := '[]'::jsonb;
  r record;
  v_tolerance numeric := 0.02;  -- 2% tolerance
BEGIN
  FOR r IN
    SELECT
      pol.id AS po_line_id,
      pol.qty_ordered, pol.unit_price AS po_unit_price,
      COALESCE(SUM(grnl.qty_accepted),0)  AS qty_received,
      sil.qty   AS qty_invoiced,
      sil.unit_price AS inv_unit_price
    FROM app.si_lines sil
    JOIN app.po_lines pol ON pol.id = sil.po_line_id
    LEFT JOIN app.grn_lines grnl ON grnl.po_line_id = pol.id
   WHERE sil.supplier_invoice_id = p_supplier_invoice_id
   GROUP BY pol.id, pol.qty_ordered, pol.unit_price, sil.qty, sil.unit_price
  LOOP
    IF r.qty_invoiced > r.qty_received THEN
      v_discrepancies := v_discrepancies || jsonb_build_object(
        'po_line_id', r.po_line_id, 'type', 'qty_over_received',
        'qty_received', r.qty_received, 'qty_invoiced', r.qty_invoiced);
    END IF;
    IF abs(r.inv_unit_price - r.po_unit_price) > r.po_unit_price * v_tolerance THEN
      v_discrepancies := v_discrepancies || jsonb_build_object(
        'po_line_id', r.po_line_id, 'type', 'price_variance',
        'po_price', r.po_unit_price, 'inv_price', r.inv_unit_price);
    END IF;
  END LOOP;

  IF jsonb_array_length(v_discrepancies) > 0 THEN
    v_result := jsonb_build_object('status','mismatch','discrepancies', v_discrepancies);
  END IF;
  RETURN v_result;
END $$;

-- Supplier aging (AP)
CREATE OR REPLACE FUNCTION app.ap_aging(p_company_id uuid, p_as_of date DEFAULT CURRENT_DATE)
RETURNS TABLE(supplier_id uuid, name text, d0_30 numeric, d31_60 numeric, d61_90 numeric, d90_plus numeric)
LANGUAGE sql STABLE AS $$
  SELECT si.supplier_id, s.name,
         SUM(CASE WHEN p_as_of - si.due_date <= 30 THEN si.amount_due ELSE 0 END),
         SUM(CASE WHEN p_as_of - si.due_date BETWEEN 31 AND 60 THEN si.amount_due ELSE 0 END),
         SUM(CASE WHEN p_as_of - si.due_date BETWEEN 61 AND 90 THEN si.amount_due ELSE 0 END),
         SUM(CASE WHEN p_as_of - si.due_date > 90 THEN si.amount_due ELSE 0 END)
    FROM app.supplier_invoices si
    JOIN app.suppliers s ON s.id = si.supplier_id
   WHERE si.company_id = p_company_id AND si.amount_due > 0
   GROUP BY si.supplier_id, s.name
$$;

-- =============== PROCEDURES ===============

-- Receive a GRN from a PO: inserts stock layers, updates PO qty_received
-- (Stock layer creation lives in inventory module; this only updates PO)
CREATE OR REPLACE PROCEDURE app.receive_grn(p_grn_id uuid)
LANGUAGE plpgsql AS $$
DECLARE
  v_grn app.grns%ROWTYPE;
  r record;
BEGIN
  SELECT * INTO v_grn FROM app.grns WHERE id = p_grn_id;
  IF v_grn.status NOT IN ('draft','partially_received') THEN
    RAISE EXCEPTION 'invalid grn status %', v_grn.status;
  END IF;

  -- Cascade qty_received to PO lines
  FOR r IN
    SELECT po_line_id, SUM(qty_accepted) AS qty
      FROM app.grn_lines WHERE grn_id = p_grn_id AND po_line_id IS NOT NULL
      GROUP BY po_line_id
  LOOP
    UPDATE app.po_lines
       SET qty_received = qty_received + r.qty,
           updated_at = now()
     WHERE id = r.po_line_id;
  END LOOP;

  -- Stock ledger entries created by inventory module trigger (tg_grn_to_stock)

  UPDATE app.grns SET status = 'received', updated_at = now() WHERE id = p_grn_id;

  -- Update PO status
  UPDATE app.purchase_orders po
     SET status = CASE
       WHEN NOT EXISTS (SELECT 1 FROM app.po_lines l
                         WHERE l.po_id = po.id AND l.qty_received < l.qty_ordered)
       THEN 'received'
       ELSE 'partial'
     END
   WHERE po.id = v_grn.po_id;
END $$;

-- Post supplier invoice: create JE (Dr expense/stock, Cr AP, Dr GST input)
CREATE OR REPLACE PROCEDURE app.post_supplier_invoice(p_inv_id uuid)
LANGUAGE plpgsql AS $$
DECLARE
  v_inv app.supplier_invoices%ROWTYPE;
  v_fy uuid; v_fp uuid; v_st text;
  v_ap uuid; v_cgst uuid; v_sgst uuid; v_igst uuid;
  v_je_id uuid := gen_random_uuid();
  v_je_num text; v_ln int := 0;
  v_match jsonb;
  r record;
BEGIN
  SELECT * INTO v_inv FROM app.supplier_invoices WHERE id = p_inv_id;
  IF v_inv.status <> 'submitted' THEN RAISE EXCEPTION 'invoice must be submitted'; END IF;

  -- Run 3-way match (do not block; flag mismatch)
  v_match := app.three_way_match(p_inv_id);
  UPDATE app.supplier_invoices
     SET three_way_match_status = CASE v_match->>'status' WHEN 'matched' THEN 'matched' ELSE 'mismatch' END
   WHERE id = p_inv_id;

  SELECT fiscal_year_id, period_id, status INTO v_fy, v_fp, v_st
    FROM core.period_for_date(v_inv.company_id, v_inv.bill_date);
  IF v_st IS DISTINCT FROM 'open' THEN RAISE EXCEPTION 'period not open'; END IF;

  SELECT id INTO v_ap  FROM app.chart_of_accounts WHERE company_id=v_inv.company_id AND account_subtype='accounts_payable' AND NOT is_group LIMIT 1;
  SELECT id INTO v_cgst FROM app.chart_of_accounts WHERE company_id=v_inv.company_id AND code ILIKE 'CGST_IN%' AND NOT is_group LIMIT 1;
  SELECT id INTO v_sgst FROM app.chart_of_accounts WHERE company_id=v_inv.company_id AND code ILIKE 'SGST_IN%' AND NOT is_group LIMIT 1;
  SELECT id INTO v_igst FROM app.chart_of_accounts WHERE company_id=v_inv.company_id AND code ILIKE 'IGST_IN%' AND NOT is_group LIMIT 1;

  v_je_num := core.next_doc_number('JE_PURCH');

  INSERT INTO app.journal_entries(id,tenant_id,company_id,fiscal_year_id,financial_period_id,
         entry_number,posting_date,entry_type,source_module,source_document_id,
         reference,currency_code,fx_rate,status)
  VALUES (v_je_id, v_inv.tenant_id, v_inv.company_id, v_fy, v_fp,
          v_je_num, v_inv.bill_date, 'system', 'purchase', v_inv.id,
          v_inv.bill_number, v_inv.currency_code, v_inv.fx_rate, 'draft');

  -- Credit: AP
  v_ln := v_ln + 1;
  INSERT INTO app.journal_lines(id,tenant_id,journal_entry_id,posting_date,line_no,
         account_id,party_type,party_id,debit,credit,currency_code,fx_rate,description)
  VALUES (gen_random_uuid(), v_inv.tenant_id, v_je_id, v_inv.bill_date, v_ln,
          v_ap, 'supplier', v_inv.supplier_id, 0, v_inv.grand_total - v_inv.tds_amount,
          v_inv.currency_code, v_inv.fx_rate, 'Supplier bill '||v_inv.bill_number);

  -- Debit: expense per line
  FOR r IN
    SELECT COALESCE(expense_account_id,
             (SELECT id FROM app.chart_of_accounts
               WHERE company_id=v_inv.company_id AND account_type='expense' AND NOT is_group LIMIT 1)) AS acct,
           COALESCE(cost_center_id,NULL) AS cc, SUM(taxable_amount) AS amt
      FROM app.si_lines WHERE supplier_invoice_id = p_inv_id
     GROUP BY 1,2
  LOOP
    v_ln := v_ln + 1;
    INSERT INTO app.journal_lines(id,tenant_id,journal_entry_id,posting_date,line_no,
           account_id,cost_center_id,debit,credit,currency_code,fx_rate,description)
    VALUES (gen_random_uuid(), v_inv.tenant_id, v_je_id, v_inv.bill_date, v_ln,
            r.acct, r.cc, r.amt, 0, v_inv.currency_code, v_inv.fx_rate, 'Purchase expense');
  END LOOP;

  -- Debit: GST inputs
  IF v_inv.cgst_total > 0 AND v_cgst IS NOT NULL THEN
    v_ln := v_ln + 1;
    INSERT INTO app.journal_lines(id,tenant_id,journal_entry_id,posting_date,line_no,account_id,debit,credit,currency_code,fx_rate,description)
    VALUES (gen_random_uuid(), v_inv.tenant_id, v_je_id, v_inv.bill_date, v_ln, v_cgst, v_inv.cgst_total, 0, v_inv.currency_code, v_inv.fx_rate, 'CGST input');
  END IF;
  IF v_inv.sgst_total > 0 AND v_sgst IS NOT NULL THEN
    v_ln := v_ln + 1;
    INSERT INTO app.journal_lines(id,tenant_id,journal_entry_id,posting_date,line_no,account_id,debit,credit,currency_code,fx_rate,description)
    VALUES (gen_random_uuid(), v_inv.tenant_id, v_je_id, v_inv.bill_date, v_ln, v_sgst, v_inv.sgst_total, 0, v_inv.currency_code, v_inv.fx_rate, 'SGST input');
  END IF;
  IF v_inv.igst_total > 0 AND v_igst IS NOT NULL THEN
    v_ln := v_ln + 1;
    INSERT INTO app.journal_lines(id,tenant_id,journal_entry_id,posting_date,line_no,account_id,debit,credit,currency_code,fx_rate,description)
    VALUES (gen_random_uuid(), v_inv.tenant_id, v_je_id, v_inv.bill_date, v_ln, v_igst, v_inv.igst_total, 0, v_inv.currency_code, v_inv.fx_rate, 'IGST input');
  END IF;

  -- Credit: TDS payable (if any)
  IF v_inv.tds_amount > 0 THEN
    v_ln := v_ln + 1;
    INSERT INTO app.journal_lines(id,tenant_id,journal_entry_id,posting_date,line_no,account_id,debit,credit,currency_code,fx_rate,description)
    SELECT gen_random_uuid(), v_inv.tenant_id, v_je_id, v_inv.bill_date, v_ln,
           coa.id, 0, v_inv.tds_amount, v_inv.currency_code, v_inv.fx_rate, 'TDS payable'
      FROM app.chart_of_accounts coa
     WHERE coa.company_id = v_inv.company_id AND coa.code ILIKE 'TDS_PAY%' AND NOT coa.is_group LIMIT 1;
  END IF;

  PERFORM app.post_journal_entry(v_je_id);

  UPDATE app.supplier_invoices
     SET status='posted', journal_entry_id=v_je_id,
         due_date = COALESCE(due_date, bill_date +
                    (SELECT COALESCE(credit_days,0) FROM app.suppliers WHERE id=v_inv.supplier_id)),
         updated_at=now()
   WHERE id = p_inv_id;
END $$;

-- =============== TRIGGERS ===============
SELECT core.attach_standard_triggers('app.suppliers');
SELECT core.attach_standard_triggers('app.supplier_contacts');
SELECT core.attach_standard_triggers('app.purchase_requisitions');
SELECT core.attach_standard_triggers('app.pr_lines');
SELECT core.attach_standard_triggers('app.rfqs');
SELECT core.attach_standard_triggers('app.purchase_orders');
SELECT core.attach_standard_triggers('app.po_lines');
SELECT core.attach_standard_triggers('app.grns');
SELECT core.attach_standard_triggers('app.grn_lines');
SELECT core.attach_standard_triggers('app.supplier_invoices');
SELECT core.attach_standard_triggers('app.si_lines');
SELECT core.attach_standard_triggers('app.purchase_returns');

-- PO line totals auto
CREATE OR REPLACE FUNCTION core.tg_pol_linetotal()
RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
  NEW.discount_amount := round(NEW.qty_ordered * NEW.unit_price * (NEW.discount_percent/100), 4);
  NEW.tax_amount      := round((NEW.qty_ordered * NEW.unit_price - NEW.discount_amount) * NEW.tax_rate_percent/100, 4);
  NEW.line_total      := round(NEW.qty_ordered * NEW.unit_price - NEW.discount_amount + NEW.tax_amount, 4);
  RETURN NEW;
END $$;
DROP TRIGGER IF EXISTS trg_pol_linetotal ON app.po_lines;
CREATE TRIGGER trg_pol_linetotal BEFORE INSERT OR UPDATE ON app.po_lines
  FOR EACH ROW EXECUTE FUNCTION core.tg_pol_linetotal();

CREATE OR REPLACE FUNCTION core.tg_po_recompute()
RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
  PERFORM app.recompute_po_totals(COALESCE(NEW.po_id, OLD.po_id));
  RETURN COALESCE(NEW, OLD);
END $$;
DROP TRIGGER IF EXISTS trg_po_recompute ON app.po_lines;
CREATE TRIGGER trg_po_recompute
  AFTER INSERT OR UPDATE OR DELETE ON app.po_lines
  FOR EACH ROW EXECUTE FUNCTION core.tg_po_recompute();

-- Block delete of posted docs
CREATE OR REPLACE FUNCTION core.tg_block_delete_posted_purchase()
RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
  IF TG_TABLE_NAME = 'supplier_invoices' AND OLD.status IN ('posted','partial_paid','paid') THEN
    RAISE EXCEPTION 'cannot delete posted bill %', OLD.internal_number;
  END IF;
  IF TG_TABLE_NAME = 'purchase_orders' AND OLD.status NOT IN ('draft','cancelled') THEN
    RAISE EXCEPTION 'cannot delete active PO %', OLD.po_number;
  END IF;
  RETURN OLD;
END $$;
DROP TRIGGER IF EXISTS trg_si_nodelete ON app.supplier_invoices;
CREATE TRIGGER trg_si_nodelete BEFORE DELETE ON app.supplier_invoices
  FOR EACH ROW EXECUTE FUNCTION core.tg_block_delete_posted_purchase();
DROP TRIGGER IF EXISTS trg_po_nodelete ON app.purchase_orders;
CREATE TRIGGER trg_po_nodelete BEFORE DELETE ON app.purchase_orders
  FOR EACH ROW EXECUTE FUNCTION core.tg_block_delete_posted_purchase();

-- =============== VIEWS ===============
CREATE OR REPLACE VIEW app.v_supplier_outstanding AS
SELECT si.tenant_id, si.supplier_id, s.name,
       SUM(si.amount_due)                                           AS total_due,
       SUM(si.amount_due) FILTER (WHERE si.due_date < CURRENT_DATE) AS overdue
  FROM app.supplier_invoices si
  JOIN app.suppliers s ON s.id = si.supplier_id
 WHERE si.amount_due > 0
 GROUP BY si.tenant_id, si.supplier_id, s.name;

CREATE OR REPLACE VIEW app.v_po_status AS
SELECT po.tenant_id, po.id po_id, po.po_number, po.supplier_id, po.po_date,
       po.grand_total, po.status,
       SUM(pol.qty_ordered)  AS total_qty,
       SUM(pol.qty_received) AS received_qty,
       SUM(pol.qty_invoiced) AS invoiced_qty,
       round( SUM(pol.qty_received) / NULLIF(SUM(pol.qty_ordered),0) * 100, 2) AS pct_received
  FROM app.purchase_orders po
  JOIN app.po_lines pol ON pol.po_id = po.id
 GROUP BY po.tenant_id, po.id, po.po_number, po.supplier_id, po.po_date, po.grand_total, po.status;

CREATE OR REPLACE VIEW app.v_three_way_match AS
SELECT si.tenant_id, si.id AS invoice_id, si.internal_number, si.po_id,
       si.three_way_match_status,
       SUM(sil.qty)          AS qty_invoiced,
       SUM(pol.qty_received) AS qty_received,
       SUM(pol.qty_ordered)  AS qty_ordered
  FROM app.supplier_invoices si
  JOIN app.si_lines sil ON sil.supplier_invoice_id = si.id
  LEFT JOIN app.po_lines pol ON pol.id = sil.po_line_id
 GROUP BY si.tenant_id, si.id, si.internal_number, si.po_id, si.three_way_match_status;
