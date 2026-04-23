-- =====================================================================
-- Module 32: Canteen & Cafeteria Management
-- Multi-location canteens, caterers, menus, meals, booking, subsidy,
-- coupons, plate tracking, kitchen inventory, waste, feedback, hygiene
-- =====================================================================

SET search_path = app, core, public;

-- =============== SCHEMA ===============

CREATE TABLE IF NOT EXISTS app.canteens (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  company_id      uuid NOT NULL REFERENCES app.companies(id),
  branch_id       uuid REFERENCES app.branches(id),
  code            citext NOT NULL,
  name            text NOT NULL,
  location        text,
  capacity        int,
  warehouse_id    uuid REFERENCES app.warehouses(id),     -- raw material stock
  cost_center_id  uuid REFERENCES app.cost_centers(id),
  active          boolean NOT NULL DEFAULT true,
  operating_hours jsonb,                                  -- {mon:{open:"08:00",close:"22:00"},...}
  created_at      timestamptz NOT NULL DEFAULT now(),
  updated_at      timestamptz NOT NULL DEFAULT now(),
  created_by      uuid, updated_by uuid, version int NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, company_id, code)
);

CREATE TABLE IF NOT EXISTS app.caterers (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  supplier_id     uuid REFERENCES app.suppliers(id),     -- optional link
  code            citext NOT NULL,
  name            text NOT NULL,
  contact_person  text, phone text, email citext,
  contract_start  date, contract_end date,
  rate_card       jsonb,                                 -- {breakfast:60,lunch:80,dinner:75}
  hygiene_certificate_document_id uuid REFERENCES app.documents(id),
  rating          numeric(3,2),
  active          boolean NOT NULL DEFAULT true,
  created_at      timestamptz NOT NULL DEFAULT now(),
  updated_at      timestamptz NOT NULL DEFAULT now(),
  created_by      uuid, updated_by uuid, version int NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, code)
);

CREATE TABLE IF NOT EXISTS app.canteen_caterers (
  tenant_id       uuid NOT NULL,
  canteen_id      uuid NOT NULL REFERENCES app.canteens(id) ON DELETE CASCADE,
  caterer_id      uuid NOT NULL REFERENCES app.caterers(id) ON DELETE CASCADE,
  meal_types      text[] NOT NULL DEFAULT '{}',
  effective_from  date NOT NULL,
  effective_to    date,
  PRIMARY KEY (canteen_id, caterer_id, effective_from)
);

CREATE TABLE IF NOT EXISTS app.meal_types (
  tenant_id       uuid NOT NULL,
  code            citext NOT NULL,                       -- 'breakfast','lunch','dinner','snacks','tea'
  name            text NOT NULL,
  default_start   time, default_end time,
  cutoff_minutes_before int NOT NULL DEFAULT 60,
  display_order   smallint NOT NULL DEFAULT 0,
  active          boolean NOT NULL DEFAULT true,
  PRIMARY KEY (tenant_id, code)
);

CREATE TABLE IF NOT EXISTS app.menus (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  canteen_id      uuid NOT NULL REFERENCES app.canteens(id) ON DELETE CASCADE,
  caterer_id      uuid REFERENCES app.caterers(id),
  menu_date       date NOT NULL,
  meal_type       citext NOT NULL,
  status          text NOT NULL DEFAULT 'draft'
                  CHECK (status IN ('draft','published','served','closed','cancelled')),
  published_at    timestamptz,
  created_at      timestamptz NOT NULL DEFAULT now(),
  updated_at      timestamptz NOT NULL DEFAULT now(),
  created_by      uuid, updated_by uuid, version int NOT NULL DEFAULT 1,
  UNIQUE (canteen_id, menu_date, meal_type)
);

CREATE TABLE IF NOT EXISTS app.menu_items (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  menu_id         uuid NOT NULL REFERENCES app.menus(id) ON DELETE CASCADE,
  dish_code       citext NOT NULL,
  dish_name       text NOT NULL,
  category        text,                                   -- 'main','side','dessert','beverage'
  dietary         text[] NOT NULL DEFAULT '{}',           -- ['veg','non_veg','vegan','jain','halal','gluten_free']
  allergens       text[] NOT NULL DEFAULT '{}',           -- ['nuts','dairy','soy','gluten','egg']
  ingredients     text,
  calories_kcal   int,
  protein_g       numeric(6,2), carbs_g numeric(6,2), fat_g numeric(6,2),
  price           numeric(10,2) NOT NULL DEFAULT 0,
  employer_subsidy_pct numeric(5,2) NOT NULL DEFAULT 0,
  max_servings    int,
  servings_prepared int NOT NULL DEFAULT 0,
  servings_sold   int NOT NULL DEFAULT 0,
  photo_document_id uuid REFERENCES app.documents(id),
  display_order   int NOT NULL DEFAULT 0,
  UNIQUE (menu_id, dish_code)
);

-- Subsidy / entitlement rules (by grade/dept/employment-type)
CREATE TABLE IF NOT EXISTS app.meal_entitlements (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  code            citext NOT NULL,
  name            text NOT NULL,
  applies_to      text NOT NULL CHECK (applies_to IN ('grade','department','employment_type','location','all')),
  applies_ref     text,                                   -- grade code / dept code / etc.
  meal_type       citext,
  employer_share_pct numeric(5,2) NOT NULL DEFAULT 0 CHECK (employer_share_pct BETWEEN 0 AND 100),
  employee_share_pct numeric(5,2) GENERATED ALWAYS AS (100 - employer_share_pct) STORED,
  daily_limit     int,
  monthly_limit   int,
  effective_from  date NOT NULL,
  effective_to    date,
  active          boolean NOT NULL DEFAULT true,
  UNIQUE (tenant_id, code)
);

CREATE TABLE IF NOT EXISTS app.meal_bookings (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  canteen_id      uuid NOT NULL REFERENCES app.canteens(id),
  menu_id         uuid REFERENCES app.menus(id),
  meal_type       citext NOT NULL,
  meal_date       date NOT NULL,
  booked_by_employee_id uuid REFERENCES app.employees(id),
  guest_name      text,
  guest_sponsor_employee_id uuid REFERENCES app.employees(id),
  is_guest        boolean NOT NULL DEFAULT false,
  is_contractor   boolean NOT NULL DEFAULT false,
  booking_time    timestamptz NOT NULL DEFAULT now(),
  quantity        smallint NOT NULL DEFAULT 1 CHECK (quantity > 0),
  dish_preferences jsonb,                                 -- {dishes:[...], notes:""}
  total_price     numeric(10,2) NOT NULL DEFAULT 0,
  employer_amount numeric(10,2) NOT NULL DEFAULT 0,
  employee_amount numeric(10,2) NOT NULL DEFAULT 0,
  status          text NOT NULL DEFAULT 'booked'
                  CHECK (status IN ('booked','confirmed','cancelled','consumed','no_show','expired')),
  coupon_code     text,
  cancelled_at    timestamptz,
  consumed_at     timestamptz,
  punch_method    text CHECK (punch_method IN (NULL,'rfid','biometric','qr_code','manual','mobile_qr')),
  created_at      timestamptz NOT NULL DEFAULT now(),
  updated_at      timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS app.meal_coupons (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  booking_id      uuid REFERENCES app.meal_bookings(id) ON DELETE SET NULL,
  employee_id     uuid REFERENCES app.employees(id),
  coupon_code     text NOT NULL UNIQUE,
  qr_payload      text,
  meal_type       citext,
  valid_date      date NOT NULL,
  value           numeric(10,2) NOT NULL,
  status          text NOT NULL DEFAULT 'issued'
                  CHECK (status IN ('issued','redeemed','cancelled','expired')),
  redeemed_at     timestamptz,
  redeemed_at_canteen uuid REFERENCES app.canteens(id),
  issued_at       timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS app.plate_events (
  id              uuid NOT NULL DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  canteen_id      uuid NOT NULL REFERENCES app.canteens(id),
  employee_id     uuid REFERENCES app.employees(id),
  booking_id      uuid REFERENCES app.meal_bookings(id),
  coupon_id       uuid REFERENCES app.meal_coupons(id),
  event_type      text NOT NULL CHECK (event_type IN ('punch_in','plate_issued','plate_returned','waste_recorded')),
  meal_type       citext,
  menu_id         uuid REFERENCES app.menus(id),
  weight_grams    int,
  source          text CHECK (source IN (NULL,'rfid','biometric','qr_code','manual','mobile_qr')),
  device_id       text,
  occurred_at     timestamptz NOT NULL DEFAULT now(),
  PRIMARY KEY (id, occurred_at)
) PARTITION BY RANGE (occurred_at);

CREATE TABLE IF NOT EXISTS app.plate_events_2026 PARTITION OF app.plate_events
  FOR VALUES FROM ('2026-01-01') TO ('2027-01-01');
CREATE TABLE IF NOT EXISTS app.plate_events_default PARTITION OF app.plate_events DEFAULT;

-- Kitchen inventory issues (raw material consumption for cooking)
CREATE TABLE IF NOT EXISTS app.kitchen_issues (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  canteen_id      uuid NOT NULL REFERENCES app.canteens(id),
  menu_id         uuid REFERENCES app.menus(id),
  issue_date      date NOT NULL,
  shift           text CHECK (shift IN (NULL,'breakfast','lunch','dinner','snacks','prep')),
  issued_by       uuid,
  notes           text,
  status          text NOT NULL DEFAULT 'draft' CHECK (status IN ('draft','issued','consumed','cancelled')),
  created_at      timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS app.kitchen_issue_lines (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  issue_id        uuid NOT NULL REFERENCES app.kitchen_issues(id) ON DELETE CASCADE,
  item_id         uuid NOT NULL,                          -- raw material (links Step 7)
  qty             numeric(19,6) NOT NULL CHECK (qty > 0),
  uom_code        text NOT NULL,
  dish_code       text,                                   -- links back to menu dish if specific
  unit_cost       numeric(19,4)
);

CREATE TABLE IF NOT EXISTS app.food_waste_records (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  canteen_id      uuid NOT NULL REFERENCES app.canteens(id),
  waste_date      date NOT NULL,
  meal_type       citext,
  waste_category  text NOT NULL CHECK (waste_category IN ('over_prep','plate_waste','spoilage','returns','spillage')),
  weight_kg       numeric(10,3) NOT NULL CHECK (weight_kg > 0),
  estimated_cost  numeric(19,4),
  reason          text,
  recorded_by     uuid,
  created_at      timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS app.meal_feedback (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  booking_id      uuid REFERENCES app.meal_bookings(id),
  canteen_id      uuid NOT NULL REFERENCES app.canteens(id),
  employee_id     uuid REFERENCES app.employees(id),
  meal_date       date NOT NULL,
  meal_type       citext,
  rating          smallint NOT NULL CHECK (rating BETWEEN 1 AND 5),
  taste_rating    smallint CHECK (taste_rating BETWEEN 1 AND 5),
  quantity_rating smallint CHECK (quantity_rating BETWEEN 1 AND 5),
  hygiene_rating  smallint CHECK (hygiene_rating BETWEEN 1 AND 5),
  comment         text,
  submitted_at    timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS app.hygiene_checklists (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  canteen_id      uuid NOT NULL REFERENCES app.canteens(id),
  check_date      date NOT NULL,
  shift           text,
  inspector_id    uuid REFERENCES app.employees(id),
  overall_score   smallint CHECK (overall_score BETWEEN 0 AND 100),
  status          text NOT NULL DEFAULT 'pending'
                  CHECK (status IN ('pending','passed','failed','conditional')),
  findings        jsonb,                                  -- [{item,status,note}]
  created_at      timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS app.meal_wallets (
  tenant_id       uuid NOT NULL,
  employee_id     uuid NOT NULL REFERENCES app.employees(id) ON DELETE CASCADE,
  balance         numeric(19,4) NOT NULL DEFAULT 0,
  updated_at      timestamptz NOT NULL DEFAULT now(),
  PRIMARY KEY (employee_id)
);

CREATE TABLE IF NOT EXISTS app.meal_wallet_txns (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  employee_id     uuid NOT NULL REFERENCES app.employees(id) ON DELETE CASCADE,
  txn_type        text NOT NULL CHECK (txn_type IN ('topup','deduction','refund','adjustment','payroll_recovery')),
  amount          numeric(19,4) NOT NULL CHECK (amount <> 0),
  reference_type  text, reference_id uuid,
  balance_after   numeric(19,4) NOT NULL,
  notes           text,
  created_at      timestamptz NOT NULL DEFAULT now(),
  created_by      uuid
);

-- =============== INDEXES ===============
CREATE INDEX IF NOT EXISTS idx_canteens_branch        ON app.canteens(branch_id) WHERE active;
CREATE INDEX IF NOT EXISTS idx_caterers_supplier      ON app.caterers(supplier_id);
CREATE INDEX IF NOT EXISTS idx_menus_canteen_date     ON app.menus(canteen_id, menu_date DESC, meal_type);
CREATE INDEX IF NOT EXISTS idx_menus_published        ON app.menus(menu_date) WHERE status='published';
CREATE INDEX IF NOT EXISTS idx_menuitems_menu         ON app.menu_items(menu_id);
CREATE INDEX IF NOT EXISTS idx_menuitems_dietary      ON app.menu_items USING gin (dietary);
CREATE INDEX IF NOT EXISTS idx_menuitems_allergens    ON app.menu_items USING gin (allergens);
CREATE INDEX IF NOT EXISTS idx_entitle_active         ON app.meal_entitlements(tenant_id, applies_to) WHERE active;
CREATE INDEX IF NOT EXISTS idx_bookings_emp_date      ON app.meal_bookings(booked_by_employee_id, meal_date DESC);
CREATE INDEX IF NOT EXISTS idx_bookings_canteen_date  ON app.meal_bookings(canteen_id, meal_date, meal_type);
CREATE INDEX IF NOT EXISTS idx_bookings_status        ON app.meal_bookings(tenant_id, status, meal_date);
CREATE INDEX IF NOT EXISTS idx_coupons_emp_date       ON app.meal_coupons(employee_id, valid_date);
CREATE INDEX IF NOT EXISTS idx_coupons_code           ON app.meal_coupons(coupon_code) WHERE status='issued';
CREATE INDEX IF NOT EXISTS idx_plate_canteen_time     ON app.plate_events(canteen_id, occurred_at DESC);
CREATE INDEX IF NOT EXISTS idx_plate_emp_time         ON app.plate_events(employee_id, occurred_at DESC);
CREATE INDEX IF NOT EXISTS idx_kissue_canteen_date    ON app.kitchen_issues(canteen_id, issue_date DESC);
CREATE INDEX IF NOT EXISTS idx_kissue_lines_issue     ON app.kitchen_issue_lines(issue_id);
CREATE INDEX IF NOT EXISTS idx_waste_canteen_date     ON app.food_waste_records(canteen_id, waste_date DESC);
CREATE INDEX IF NOT EXISTS idx_feedback_canteen_date  ON app.meal_feedback(canteen_id, meal_date DESC);
CREATE INDEX IF NOT EXISTS idx_hygiene_canteen_date   ON app.hygiene_checklists(canteen_id, check_date DESC);
CREATE INDEX IF NOT EXISTS idx_wallet_txn_emp_time    ON app.meal_wallet_txns(employee_id, created_at DESC);

-- =============== RLS + TRIGGERS ===============
SELECT core.enable_tenant_rls('app.canteens');
SELECT core.enable_tenant_rls('app.caterers');
SELECT core.enable_tenant_rls('app.canteen_caterers');
SELECT core.enable_tenant_rls('app.meal_types');
SELECT core.enable_tenant_rls('app.menus');
SELECT core.enable_tenant_rls('app.menu_items');
SELECT core.enable_tenant_rls('app.meal_entitlements');
SELECT core.enable_tenant_rls('app.meal_bookings');
SELECT core.enable_tenant_rls('app.meal_coupons');
SELECT core.enable_tenant_rls('app.plate_events');
SELECT core.enable_tenant_rls('app.kitchen_issues');
SELECT core.enable_tenant_rls('app.kitchen_issue_lines');
SELECT core.enable_tenant_rls('app.food_waste_records');
SELECT core.enable_tenant_rls('app.meal_feedback');
SELECT core.enable_tenant_rls('app.hygiene_checklists');
SELECT core.enable_tenant_rls('app.meal_wallets');
SELECT core.enable_tenant_rls('app.meal_wallet_txns');

SELECT core.attach_standard_triggers('app.canteens');
SELECT core.attach_standard_triggers('app.caterers');
SELECT core.attach_standard_triggers('app.menus');
SELECT core.attach_standard_triggers('app.meal_entitlements');
SELECT core.attach_standard_triggers('app.meal_bookings');
SELECT core.attach_standard_triggers('app.kitchen_issues');
SELECT core.attach_standard_triggers('app.hygiene_checklists');

-- =============== FUNCTIONS ===============

-- Resolve employer subsidy for an employee on a given meal type
CREATE OR REPLACE FUNCTION app.resolve_meal_subsidy(p_employee_id uuid, p_meal_type text)
RETURNS numeric
LANGUAGE sql STABLE AS $$
  SELECT COALESCE(MAX(me.employer_share_pct), 0)
    FROM app.employees e
    LEFT JOIN app.grades g ON g.id = e.grade_id
    LEFT JOIN app.departments d ON d.id = e.department_id
    JOIN app.meal_entitlements me ON me.active
       AND (me.meal_type IS NULL OR me.meal_type = p_meal_type)
       AND me.effective_from <= CURRENT_DATE
       AND (me.effective_to IS NULL OR me.effective_to >= CURRENT_DATE)
       AND (
           (me.applies_to = 'all')
        OR (me.applies_to = 'grade'           AND me.applies_ref = g.code::text)
        OR (me.applies_to = 'department'      AND me.applies_ref = d.code::text)
        OR (me.applies_to = 'employment_type' AND me.applies_ref = e.employment_type)
       )
   WHERE e.id = p_employee_id
$$;

-- Book a meal (applies subsidy, attendance-linked eligibility)
CREATE OR REPLACE FUNCTION app.book_meal(
  p_canteen_id uuid, p_employee_id uuid,
  p_meal_date date, p_meal_type text,
  p_quantity int DEFAULT 1, p_dish_prefs jsonb DEFAULT NULL
) RETURNS uuid
LANGUAGE plpgsql AS $$
DECLARE
  v_id uuid := gen_random_uuid();
  v_menu uuid; v_price numeric(10,2); v_subsidy_pct numeric;
  v_total numeric(10,2); v_er numeric(10,2); v_ee numeric(10,2);
  v_attn_status text;
BEGIN
  -- Attendance-linked eligibility (must be present / on_duty on date)
  SELECT status INTO v_attn_status
    FROM app.attendance_records
   WHERE employee_id = p_employee_id AND attendance_date = p_meal_date;
  IF v_attn_status IS NOT NULL AND v_attn_status IN ('absent','on_leave') THEN
    RAISE EXCEPTION 'meal booking blocked: employee % is % on %', p_employee_id, v_attn_status, p_meal_date;
  END IF;

  SELECT id INTO v_menu FROM app.menus
   WHERE canteen_id = p_canteen_id AND menu_date = p_meal_date
     AND meal_type = p_meal_type AND status = 'published';
  IF v_menu IS NULL THEN RAISE EXCEPTION 'no published menu for % % %', p_canteen_id, p_meal_date, p_meal_type; END IF;

  SELECT COALESCE(AVG(price),0) INTO v_price FROM app.menu_items WHERE menu_id = v_menu;
  v_subsidy_pct := app.resolve_meal_subsidy(p_employee_id, p_meal_type);

  v_total := round(v_price * p_quantity, 2);
  v_er    := round(v_total * v_subsidy_pct / 100, 2);
  v_ee    := v_total - v_er;

  INSERT INTO app.meal_bookings(id,tenant_id,canteen_id,menu_id,meal_type,meal_date,
         booked_by_employee_id,quantity,dish_preferences,total_price,employer_amount,employee_amount)
  VALUES (v_id, core.require_tenant(), p_canteen_id, v_menu, p_meal_type, p_meal_date,
          p_employee_id, p_quantity, p_dish_prefs, v_total, v_er, v_ee);

  -- Issue coupon
  INSERT INTO app.meal_coupons(tenant_id,booking_id,employee_id,coupon_code,qr_payload,
         meal_type,valid_date,value)
  VALUES (core.require_tenant(), v_id, p_employee_id,
          upper(substr(encode(gen_random_bytes(6),'hex'),1,10)),
          encode(gen_random_bytes(16),'base64'),
          p_meal_type, p_meal_date, v_total);

  RETURN v_id;
END $$;

-- Redeem coupon on punch-in
CREATE OR REPLACE PROCEDURE app.redeem_meal_coupon(p_coupon_code text, p_canteen_id uuid, p_source text DEFAULT 'qr_code')
LANGUAGE plpgsql AS $$
DECLARE v_coupon app.meal_coupons%ROWTYPE;
BEGIN
  UPDATE app.meal_coupons
     SET status='redeemed', redeemed_at = now(), redeemed_at_canteen = p_canteen_id
   WHERE coupon_code = p_coupon_code AND status = 'issued' AND valid_date = CURRENT_DATE
   RETURNING * INTO v_coupon;

  IF NOT FOUND THEN RAISE EXCEPTION 'coupon invalid or expired'; END IF;

  UPDATE app.meal_bookings SET status='consumed', consumed_at = now(), punch_method = p_source
   WHERE id = v_coupon.booking_id;

  INSERT INTO app.plate_events(tenant_id,canteen_id,employee_id,booking_id,coupon_id,
         event_type,meal_type,source)
  VALUES (core.require_tenant(), p_canteen_id, v_coupon.employee_id, v_coupon.booking_id, v_coupon.id,
          'punch_in', v_coupon.meal_type, p_source);

  -- Deduct employee share from wallet
  INSERT INTO app.meal_wallets(tenant_id, employee_id, balance)
  VALUES (core.require_tenant(), v_coupon.employee_id, 0)
  ON CONFLICT (employee_id) DO NOTHING;

  UPDATE app.meal_wallets
     SET balance = balance - (SELECT employee_amount FROM app.meal_bookings WHERE id = v_coupon.booking_id),
         updated_at = now()
   WHERE employee_id = v_coupon.employee_id;

  INSERT INTO app.meal_wallet_txns(tenant_id,employee_id,txn_type,amount,reference_type,reference_id,balance_after)
  SELECT core.require_tenant(), v_coupon.employee_id, 'deduction',
         -mb.employee_amount, 'meal_booking', mb.id, w.balance
    FROM app.meal_bookings mb
    JOIN app.meal_wallets w ON w.employee_id = v_coupon.employee_id
   WHERE mb.id = v_coupon.booking_id;
END $$;

-- Post kitchen issue → stock outflow (raw materials)
CREATE OR REPLACE FUNCTION core.tg_kitchen_issue_to_stock()
RETURNS trigger LANGUAGE plpgsql AS $$
DECLARE v_wh uuid; v_comp uuid; v_issue app.kitchen_issues%ROWTYPE;
BEGIN
  SELECT * INTO v_issue FROM app.kitchen_issues WHERE id = NEW.issue_id;
  SELECT c.warehouse_id, c.company_id INTO v_wh, v_comp
    FROM app.canteens c WHERE c.id = v_issue.canteen_id;
  IF v_wh IS NULL THEN RETURN NEW; END IF;

  PERFORM app.post_stock_entry(
    p_company_id   := v_comp,
    p_item_id      := NEW.item_id,
    p_warehouse_id := v_wh,
    p_qty          := -NEW.qty,
    p_unit_rate    := COALESCE(NEW.unit_cost, 0),
    p_txn_type     := 'manufacturing_consume',
    p_posting_date := v_issue.issue_date,
    p_uom          := NEW.uom_code,
    p_source_table := 'kitchen_issue_lines',
    p_source_id    := NEW.id);
  RETURN NEW;
END $$;
DROP TRIGGER IF EXISTS trg_kitchen_issue_to_stock ON app.kitchen_issue_lines;
CREATE TRIGGER trg_kitchen_issue_to_stock
  AFTER INSERT ON app.kitchen_issue_lines
  FOR EACH ROW EXECUTE FUNCTION core.tg_kitchen_issue_to_stock();

-- Payroll recovery: sweep meal wallet debits into payroll run (call monthly)
CREATE OR REPLACE FUNCTION app.recover_meal_deductions(p_company_id uuid, p_period_end date)
RETURNS int
LANGUAGE plpgsql AS $$
DECLARE v_count int := 0;
BEGIN
  INSERT INTO app.meal_wallet_txns(tenant_id,employee_id,txn_type,amount,reference_type,balance_after,notes)
  SELECT w.tenant_id, w.employee_id, 'payroll_recovery',
         -w.balance, 'payroll', 0, 'Monthly sweep for '||p_period_end
    FROM app.meal_wallets w
    JOIN app.employees e ON e.id = w.employee_id
   WHERE w.balance < 0 AND e.company_id = p_company_id;
  GET DIAGNOSTICS v_count = ROW_COUNT;

  UPDATE app.meal_wallets w
     SET balance = 0, updated_at = now()
    FROM app.employees e
   WHERE e.id = w.employee_id AND e.company_id = p_company_id AND w.balance < 0;
  RETURN v_count;
END $$;

-- =============== VIEWS ===============
CREATE OR REPLACE VIEW app.v_canteen_daily_kpi AS
SELECT b.tenant_id, b.canteen_id, b.meal_date, b.meal_type,
       COUNT(*) FILTER (WHERE b.status IN ('booked','confirmed','consumed'))   AS booked,
       COUNT(*) FILTER (WHERE b.status = 'consumed')                          AS consumed,
       COUNT(*) FILTER (WHERE b.status = 'no_show')                           AS no_show,
       COUNT(*) FILTER (WHERE b.is_guest)                                     AS guest_count,
       SUM(b.total_price)  FILTER (WHERE b.status = 'consumed')               AS revenue,
       SUM(b.employer_amount) FILTER (WHERE b.status = 'consumed')            AS subsidy_spend
  FROM app.meal_bookings b
 GROUP BY 1,2,3,4;

CREATE OR REPLACE VIEW app.v_food_waste_summary AS
SELECT tenant_id, canteen_id, date_trunc('month', waste_date)::date AS month,
       SUM(weight_kg)                           AS total_waste_kg,
       SUM(estimated_cost)                      AS total_cost,
       SUM(weight_kg) FILTER (WHERE waste_category='plate_waste')   AS plate_waste_kg,
       SUM(weight_kg) FILTER (WHERE waste_category='over_prep')     AS over_prep_kg
  FROM app.food_waste_records
 GROUP BY 1,2,3;

CREATE OR REPLACE VIEW app.v_popular_dishes AS
SELECT mi.tenant_id, mi.dish_code, mi.dish_name,
       SUM(mi.servings_sold) AS total_sold,
       COUNT(DISTINCT mi.menu_id) AS times_on_menu,
       AVG(mi.price) AS avg_price
  FROM app.menu_items mi
 GROUP BY mi.tenant_id, mi.dish_code, mi.dish_name
 ORDER BY total_sold DESC;

-- =============== SEED ===============
INSERT INTO app.meal_types(tenant_id, code, name, default_start, default_end, cutoff_minutes_before, display_order)
SELECT t.id, v.code, v.name, v.s, v.e, 60, v.ord
  FROM app.tenants t
 CROSS JOIN (VALUES
   ('breakfast','Breakfast','07:30'::time,'10:00'::time,1),
   ('lunch','Lunch','12:00'::time,'14:30'::time,2),
   ('snacks','Snacks','16:00'::time,'17:30'::time,3),
   ('dinner','Dinner','19:00'::time,'21:30'::time,4),
   ('tea','Tea','10:00'::time,'11:00'::time,5)
 ) AS v(code,name,s,e,ord)
ON CONFLICT (tenant_id, code) DO NOTHING;
