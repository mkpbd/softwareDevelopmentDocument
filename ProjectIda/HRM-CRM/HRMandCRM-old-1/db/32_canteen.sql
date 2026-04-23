-- =====================================================================
-- STEP 32: Canteen & Cafeteria Management
-- =====================================================================

CREATE TABLE canteen.canteen (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    company_id      UUID NOT NULL,
    branch_id       UUID REFERENCES core.branch(id),
    code            TEXT NOT NULL,
    name            TEXT NOT NULL,
    location        TEXT,
    capacity        INT,
    manager_user_id UUID,
    is_active       BOOLEAN DEFAULT TRUE,
    UNIQUE (company_id, code)
);

CREATE TABLE canteen.caterer (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    canteen_id      UUID REFERENCES canteen.canteen(id),
    supplier_id     UUID REFERENCES purchase.supplier(id),
    contract_start  DATE,
    contract_end    DATE,
    payment_terms   TEXT,
    sla             JSONB,
    is_active       BOOLEAN DEFAULT TRUE
);

CREATE TABLE canteen.meal_type (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    code            TEXT NOT NULL,                -- BREAKFAST/LUNCH/DINNER/SNACK/TEA
    name            TEXT NOT NULL,
    start_time      TIME,
    end_time        TIME,
    booking_cutoff_min INT DEFAULT 30,
    sequence_no     INT,
    UNIQUE (tenant_id, code)
);

CREATE TABLE canteen.menu (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    canteen_id      UUID NOT NULL REFERENCES canteen.canteen(id),
    menu_date       DATE NOT NULL,
    meal_type_id    UUID NOT NULL REFERENCES canteen.meal_type(id),
    caterer_id      UUID REFERENCES canteen.caterer(id),
    menu_name       TEXT,
    status          TEXT DEFAULT 'open' CHECK (status IN ('open','closed','cancelled','locked')),
    UNIQUE (canteen_id, menu_date, meal_type_id)
);

CREATE TABLE canteen.menu_item (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    menu_id         UUID NOT NULL REFERENCES canteen.menu(id) ON DELETE CASCADE,
    item_name       TEXT NOT NULL,
    description     TEXT,
    category        TEXT,                         -- main/side/dessert/beverage
    is_veg          BOOLEAN,
    is_vegan        BOOLEAN DEFAULT FALSE,
    is_jain         BOOLEAN DEFAULT FALSE,
    allergens       TEXT[],
    ingredients     TEXT[],
    calories        INT,
    portion_size    TEXT,
    base_price      core.money_amt,
    is_available    BOOLEAN DEFAULT TRUE,
    photo_url       TEXT
);

CREATE TABLE canteen.pricing_rule (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    canteen_id      UUID REFERENCES canteen.canteen(id),
    meal_type_id    UUID REFERENCES canteen.meal_type(id),
    grade_id        UUID REFERENCES hr.grade(id),
    department_id   UUID REFERENCES hr.department(id),
    employee_share  core.money_amt NOT NULL,
    employer_share  core.money_amt NOT NULL,
    total_price     core.money_amt GENERATED ALWAYS AS (employee_share + employer_share) STORED,
    valid_from      DATE NOT NULL,
    valid_to        DATE,
    UNIQUE (canteen_id, meal_type_id, grade_id, department_id, valid_from)
);

CREATE TABLE canteen.entitlement (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    grade_id        UUID REFERENCES hr.grade(id),
    department_id   UUID REFERENCES hr.department(id),
    meal_type_id    UUID NOT NULL REFERENCES canteen.meal_type(id),
    daily_allowance INT DEFAULT 1,
    monthly_allowance INT,
    is_subsidized   BOOLEAN DEFAULT TRUE
);

CREATE TABLE canteen.booking (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    canteen_id      UUID NOT NULL REFERENCES canteen.canteen(id),
    employee_id     UUID REFERENCES hr.employee(id),
    contractor_name TEXT,
    meal_type_id    UUID NOT NULL REFERENCES canteen.meal_type(id),
    booking_date    DATE NOT NULL,
    booked_for_type TEXT DEFAULT 'self' CHECK (booked_for_type IN ('self','guest','contractor','temp')),
    booked_for_name TEXT,
    qty             INT DEFAULT 1,
    status          TEXT DEFAULT 'booked' CHECK (status IN ('booked','cancelled','consumed','no_show','expired')),
    token_no        TEXT,
    qr_code         TEXT,
    booked_at       TIMESTAMPTZ DEFAULT NOW(),
    cancelled_at    TIMESTAMPTZ,
    consumed_at     TIMESTAMPTZ,
    employee_share  core.money_amt,
    employer_share  core.money_amt,
    payment_mode    TEXT CHECK (payment_mode IN ('payroll','wallet','cash','coupon','free')),
    wallet_txn_id   UUID
);

CREATE TABLE canteen.coupon (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    coupon_no       TEXT NOT NULL UNIQUE,
    issued_to_employee_id UUID REFERENCES hr.employee(id),
    meal_type_id    UUID,
    value           core.money_amt,
    valid_from      DATE,
    valid_to        DATE,
    status          TEXT DEFAULT 'active' CHECK (status IN ('active','redeemed','expired','cancelled')),
    redeemed_at     TIMESTAMPTZ,
    redeemed_booking_id UUID REFERENCES canteen.booking(id)
);

CREATE TABLE canteen.wallet (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    employee_id     UUID NOT NULL REFERENCES hr.employee(id),
    balance         core.money_amt DEFAULT 0,
    currency_code   CHAR(3) DEFAULT 'INR',
    UNIQUE (employee_id)
);

CREATE TABLE canteen.wallet_txn (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    wallet_id       UUID NOT NULL REFERENCES canteen.wallet(id) ON DELETE CASCADE,
    txn_type        TEXT CHECK (txn_type IN ('topup','deduct','refund','adjust','expire')),
    amount          core.money_amt NOT NULL,
    balance_after   core.money_amt,
    reference_type  TEXT,
    reference_id    UUID,
    created_at      TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE canteen.counter_punch (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    canteen_id      UUID NOT NULL REFERENCES canteen.canteen(id),
    punch_time      TIMESTAMPTZ DEFAULT NOW(),
    employee_id     UUID REFERENCES hr.employee(id),
    booking_id      UUID REFERENCES canteen.booking(id),
    punch_method    TEXT CHECK (punch_method IN ('rfid','biometric','qr_mobile','manual')),
    device_id       TEXT,
    is_consumed     BOOLEAN DEFAULT TRUE
);

CREATE TABLE canteen.raw_material_issue (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    canteen_id      UUID NOT NULL REFERENCES canteen.canteen(id),
    issue_date      DATE NOT NULL,
    caterer_id      UUID REFERENCES canteen.caterer(id),
    stock_entry_id  UUID REFERENCES inventory.stock_entry(id),
    total_cost      core.money_amt
);

CREATE TABLE canteen.consumption (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    canteen_id      UUID NOT NULL REFERENCES canteen.canteen(id),
    menu_id         UUID REFERENCES canteen.menu(id),
    consumption_date DATE NOT NULL,
    item_id         UUID REFERENCES inventory.item(id),
    planned_qty     core.qty_amt,
    actual_qty      core.qty_amt,
    waste_qty       core.qty_amt DEFAULT 0,
    unit_cost       core.money_amt,
    total_cost      core.money_amt
);

CREATE TABLE canteen.feedback (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    employee_id     UUID REFERENCES hr.employee(id),
    booking_id      UUID REFERENCES canteen.booking(id),
    menu_id         UUID,
    rating          INT CHECK (rating BETWEEN 1 AND 5),
    taste_rating    INT,
    hygiene_rating  INT,
    portion_rating  INT,
    service_rating  INT,
    comments        TEXT,
    created_at      TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE canteen.hygiene_checklist (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    canteen_id      UUID NOT NULL REFERENCES canteen.canteen(id),
    check_date      DATE NOT NULL,
    checklist       JSONB NOT NULL,
    score           NUMERIC(5,2),
    inspector_id    UUID,
    photos          JSONB,
    corrective_action TEXT
);

CREATE TABLE canteen.charge_back (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    company_id      UUID NOT NULL,
    period_start    DATE NOT NULL,
    period_end      DATE NOT NULL,
    cost_center_id  UUID REFERENCES finance.cost_center(id),
    department_id   UUID REFERENCES hr.department(id),
    amount          core.money_amt,
    meal_count      INT,
    je_id           UUID REFERENCES finance.journal_entry(id),
    status          TEXT DEFAULT 'draft' CHECK (status IN ('draft','posted','cancelled'))
);

-- =====================================================================
-- INDEXES
-- =====================================================================
CREATE INDEX idx_menu_date             ON canteen.menu(canteen_id, menu_date);
CREATE INDEX idx_booking_emp_date      ON canteen.booking(employee_id, booking_date);
CREATE INDEX idx_booking_canteen_date  ON canteen.booking(canteen_id, booking_date, meal_type_id);
CREATE INDEX idx_booking_status        ON canteen.booking(status, booking_date);
CREATE INDEX idx_counter_punch_booking ON canteen.counter_punch(booking_id);
CREATE INDEX idx_feedback_menu         ON canteen.feedback(menu_id, rating);
CREATE INDEX idx_wallet_txn_wallet     ON canteen.wallet_txn(wallet_id, created_at DESC);

-- =====================================================================
-- FUNCTIONS
-- =====================================================================

-- Book meal (validate cutoff, entitlement, subsidy)
CREATE OR REPLACE FUNCTION canteen.fn_book_meal(
    p_emp UUID, p_canteen UUID, p_meal UUID, p_date DATE, p_qty INT DEFAULT 1
) RETURNS UUID AS $$
DECLARE
    v_id UUID;
    v_price RECORD;
    v_emp RECORD;
    v_cutoff INT;
    v_cutoff_ts TIMESTAMPTZ;
BEGIN
    SELECT e.*, g.id AS grade_id_only FROM hr.employee e LEFT JOIN hr.grade g ON g.id = e.grade_id
      INTO v_emp WHERE e.id = p_emp;

    SELECT mt.booking_cutoff_min, (p_date + mt.start_time)::timestamp - (mt.booking_cutoff_min||' min')::interval
      INTO v_cutoff, v_cutoff_ts
      FROM canteen.meal_type mt WHERE mt.id = p_meal;

    IF NOW() > v_cutoff_ts THEN
        RAISE EXCEPTION 'Booking cutoff passed (% min before meal)', v_cutoff;
    END IF;

    IF EXISTS (SELECT 1 FROM canteen.booking WHERE employee_id = p_emp AND booking_date = p_date
                 AND meal_type_id = p_meal AND status IN ('booked','consumed')) THEN
        RAISE EXCEPTION 'Already booked for same meal';
    END IF;

    SELECT employee_share, employer_share INTO v_price
      FROM canteen.pricing_rule
     WHERE canteen_id = p_canteen AND meal_type_id = p_meal
       AND (grade_id IS NULL OR grade_id = v_emp.grade_id)
       AND (department_id IS NULL OR department_id = v_emp.department_id)
       AND valid_from <= p_date AND (valid_to IS NULL OR valid_to >= p_date)
     ORDER BY COALESCE(grade_id::text,'') DESC, COALESCE(department_id::text,'') DESC
     LIMIT 1;

    INSERT INTO canteen.booking(tenant_id, canteen_id, employee_id, meal_type_id, booking_date,
        qty, employee_share, employer_share, status, token_no, qr_code, payment_mode)
    VALUES (v_emp.tenant_id, p_canteen, p_emp, p_meal, p_date, p_qty,
        COALESCE(v_price.employee_share,0)*p_qty,
        COALESCE(v_price.employer_share,0)*p_qty,
        'booked', 'CT-'||substring(uuid_generate_v4()::text,1,8),
        encode(gen_random_bytes(12),'base64'), 'payroll')
    RETURNING id INTO v_id;
    RETURN v_id;
END;
$$ LANGUAGE plpgsql;

-- Consume (counter punch)
CREATE OR REPLACE FUNCTION canteen.fn_consume_booking(p_booking UUID, p_method TEXT)
RETURNS VOID AS $$
BEGIN
    UPDATE canteen.booking SET status='consumed', consumed_at=NOW() WHERE id = p_booking AND status='booked';
    IF NOT FOUND THEN RAISE EXCEPTION 'Booking not valid or already consumed'; END IF;
    INSERT INTO canteen.counter_punch(canteen_id, booking_id, employee_id, punch_method)
    SELECT canteen_id, id, employee_id, p_method FROM canteen.booking WHERE id = p_booking;
END;
$$ LANGUAGE plpgsql;

-- Payroll deduction aggregation (for monthly payroll)
CREATE OR REPLACE FUNCTION canteen.fn_monthly_employee_share(p_emp UUID, p_from DATE, p_to DATE)
RETURNS core.money_amt AS $$
    SELECT COALESCE(SUM(employee_share),0)
      FROM canteen.booking
     WHERE employee_id = p_emp AND booking_date BETWEEN p_from AND p_to
       AND status = 'consumed' AND payment_mode = 'payroll';
$$ LANGUAGE sql STABLE;

-- =====================================================================
-- VIEWS
-- =====================================================================
CREATE OR REPLACE VIEW canteen.v_daily_footfall AS
SELECT canteen_id, booking_date, meal_type_id,
       COUNT(*) FILTER (WHERE status='booked') AS booked,
       COUNT(*) FILTER (WHERE status='consumed') AS consumed,
       COUNT(*) FILTER (WHERE status='no_show') AS no_show,
       COUNT(*) FILTER (WHERE status='cancelled') AS cancelled
  FROM canteen.booking GROUP BY 1,2,3;

CREATE OR REPLACE VIEW canteen.v_subsidy_spend AS
SELECT canteen_id, date_trunc('month', booking_date) AS month,
       SUM(employer_share) AS subsidy, SUM(employee_share) AS employee_paid,
       COUNT(*) AS meal_count
  FROM canteen.booking WHERE status='consumed' GROUP BY 1,2;

CREATE OR REPLACE VIEW canteen.v_popular_items AS
SELECT mi.item_name, COUNT(b.id) AS orders, AVG(f.rating) AS avg_rating
  FROM canteen.menu_item mi
  JOIN canteen.menu m ON m.id = mi.menu_id
  LEFT JOIN canteen.booking b ON b.canteen_id = m.canteen_id AND b.booking_date = m.menu_date
       AND b.meal_type_id = m.meal_type_id AND b.status='consumed'
  LEFT JOIN canteen.feedback f ON f.menu_id = m.id
 GROUP BY mi.item_name ORDER BY orders DESC;

CREATE OR REPLACE VIEW canteen.v_waste_summary AS
SELECT canteen_id, date_trunc('week', consumption_date) AS week,
       SUM(waste_qty * unit_cost) AS waste_cost,
       SUM(waste_qty) AS waste_qty
  FROM canteen.consumption GROUP BY 1,2;
