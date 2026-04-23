-- =====================================================================
-- STEP 13: Time & Attendance
-- =====================================================================

CREATE TABLE attendance.shift (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    company_id      UUID NOT NULL,
    code            TEXT NOT NULL,
    name            TEXT NOT NULL,
    start_time      TIME NOT NULL,
    end_time        TIME NOT NULL,
    break_minutes   INT DEFAULT 0,
    grace_minutes   INT DEFAULT 0,
    half_day_hours  NUMERIC(4,2) DEFAULT 4,
    full_day_hours  NUMERIC(4,2) DEFAULT 8,
    crosses_midnight BOOLEAN DEFAULT FALSE,
    UNIQUE (company_id, code)
);

CREATE TABLE attendance.roster (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    employee_id     UUID NOT NULL REFERENCES hr.employee(id) ON DELETE CASCADE,
    shift_id        UUID NOT NULL REFERENCES attendance.shift(id),
    roster_date     DATE NOT NULL,
    is_week_off     BOOLEAN DEFAULT FALSE,
    UNIQUE (employee_id, roster_date)
);

CREATE TABLE attendance.holiday_calendar (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    company_id      UUID NOT NULL,
    year            INT NOT NULL,
    branch_id       UUID,
    code            TEXT NOT NULL,
    name            TEXT NOT NULL,
    UNIQUE (company_id, year, code)
);

CREATE TABLE attendance.holiday (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    calendar_id     UUID NOT NULL REFERENCES attendance.holiday_calendar(id) ON DELETE CASCADE,
    holiday_date    DATE NOT NULL,
    name            TEXT NOT NULL,
    is_optional     BOOLEAN DEFAULT FALSE,
    UNIQUE (calendar_id, holiday_date)
);

CREATE TABLE attendance.punch (
    id              BIGSERIAL,
    tenant_id       UUID NOT NULL,
    employee_id     UUID NOT NULL,
    punch_time      TIMESTAMPTZ NOT NULL,
    punch_type      TEXT CHECK (punch_type IN ('in','out','break_start','break_end')),
    source          TEXT CHECK (source IN ('biometric','mobile','web','rfid','manual','api')),
    device_id       TEXT,
    geo_location    POINT,
    ip_address      INET,
    photo_url       TEXT,
    is_approved     BOOLEAN DEFAULT TRUE,
    created_at      TIMESTAMPTZ DEFAULT NOW(),
    PRIMARY KEY (id, punch_time)
) PARTITION BY RANGE (punch_time);
CREATE TABLE attendance.punch_default PARTITION OF attendance.punch DEFAULT;

CREATE TABLE attendance.daily_attendance (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    employee_id     UUID NOT NULL REFERENCES hr.employee(id),
    attendance_date DATE NOT NULL,
    shift_id        UUID REFERENCES attendance.shift(id),
    first_in        TIMESTAMPTZ,
    last_out        TIMESTAMPTZ,
    total_hours     NUMERIC(6,2),
    break_hours     NUMERIC(6,2),
    late_by_minutes INT,
    early_by_minutes INT,
    overtime_hours  NUMERIC(6,2) DEFAULT 0,
    status          TEXT NOT NULL DEFAULT 'present'
        CHECK (status IN ('present','absent','half_day','week_off','holiday','leave','on_duty','work_from_home')),
    leave_type_id   UUID,
    remarks         TEXT,
    UNIQUE (employee_id, attendance_date)
);

-- Leave policy
CREATE TABLE attendance.leave_type (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    code            TEXT NOT NULL,
    name            TEXT NOT NULL,
    is_paid         BOOLEAN DEFAULT TRUE,
    is_carry_forward BOOLEAN DEFAULT FALSE,
    max_carry_forward NUMERIC(6,2),
    is_encashable   BOOLEAN DEFAULT FALSE,
    max_days_per_application INT,
    min_days_notice INT,
    allow_half_day  BOOLEAN DEFAULT TRUE,
    deducts_from    UUID REFERENCES attendance.leave_type(id),  -- e.g., lop deducts nothing
    UNIQUE (tenant_id, code)
);

CREATE TABLE attendance.leave_policy (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    name            TEXT NOT NULL,
    leave_type_id   UUID NOT NULL REFERENCES attendance.leave_type(id),
    allocation_period TEXT CHECK (allocation_period IN ('monthly','quarterly','yearly')),
    allocation_qty  NUMERIC(6,2) NOT NULL,
    accrual_method  TEXT CHECK (accrual_method IN ('upfront','accrual','prorated')),
    applicable_to_grade_ids UUID[],
    effective_from  DATE,
    effective_to    DATE
);

CREATE TABLE attendance.leave_balance (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    employee_id     UUID NOT NULL REFERENCES hr.employee(id) ON DELETE CASCADE,
    leave_type_id   UUID NOT NULL REFERENCES attendance.leave_type(id),
    year            INT NOT NULL,
    allocated       NUMERIC(6,2) NOT NULL DEFAULT 0,
    used            NUMERIC(6,2) NOT NULL DEFAULT 0,
    carried_forward NUMERIC(6,2) DEFAULT 0,
    encashed        NUMERIC(6,2) DEFAULT 0,
    balance         NUMERIC(6,2) GENERATED ALWAYS AS (allocated + carried_forward - used - encashed) STORED,
    UNIQUE (employee_id, leave_type_id, year)
);

CREATE TABLE attendance.leave_application (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    doc_no          TEXT NOT NULL,
    employee_id     UUID NOT NULL REFERENCES hr.employee(id),
    leave_type_id   UUID NOT NULL REFERENCES attendance.leave_type(id),
    from_date       DATE NOT NULL,
    to_date         DATE NOT NULL,
    total_days      NUMERIC(5,1) NOT NULL,
    is_half_day     BOOLEAN DEFAULT FALSE,
    reason          TEXT,
    contact_during_leave core.phone_t,
    status          core.approval_state DEFAULT 'pending',
    approver_id     UUID,
    approved_at     TIMESTAMPTZ,
    applied_at      TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE (tenant_id, doc_no),
    CHECK (to_date >= from_date)
);

CREATE TABLE attendance.overtime (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    employee_id     UUID NOT NULL REFERENCES hr.employee(id),
    ot_date         DATE NOT NULL,
    hours           NUMERIC(4,2) NOT NULL,
    rate_multiplier NUMERIC(4,2) DEFAULT 1.5,
    approved_by     UUID,
    status          core.approval_state DEFAULT 'pending'
);

CREATE TABLE attendance.regularization (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    employee_id     UUID NOT NULL REFERENCES hr.employee(id),
    attendance_date DATE NOT NULL,
    requested_in    TIMESTAMPTZ,
    requested_out   TIMESTAMPTZ,
    reason          TEXT NOT NULL,
    status          core.approval_state DEFAULT 'pending',
    approver_id     UUID,
    approved_at     TIMESTAMPTZ
);

CREATE TABLE attendance.timesheet (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    employee_id     UUID NOT NULL REFERENCES hr.employee(id),
    week_start      DATE NOT NULL,
    week_end        DATE NOT NULL,
    total_hours     NUMERIC(6,2),
    billable_hours  NUMERIC(6,2),
    status          TEXT DEFAULT 'draft' CHECK (status IN ('draft','submitted','approved','rejected')),
    submitted_at    TIMESTAMPTZ,
    approved_by     UUID,
    approved_at     TIMESTAMPTZ,
    UNIQUE (employee_id, week_start)
);

CREATE TABLE attendance.timesheet_entry (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    timesheet_id    UUID NOT NULL REFERENCES attendance.timesheet(id) ON DELETE CASCADE,
    entry_date      DATE NOT NULL,
    project_id      UUID,
    task_id         UUID,
    activity        TEXT,
    hours           NUMERIC(5,2) NOT NULL,
    is_billable     BOOLEAN DEFAULT FALSE,
    notes           TEXT
);

-- =====================================================================
-- INDEXES
-- =====================================================================
CREATE INDEX idx_roster_date          ON attendance.roster(roster_date);
CREATE INDEX idx_punch_emp_time       ON attendance.punch(employee_id, punch_time DESC);
CREATE INDEX idx_attendance_emp_date  ON attendance.daily_attendance(employee_id, attendance_date DESC);
CREATE INDEX idx_attendance_date      ON attendance.daily_attendance(attendance_date, status);
CREATE INDEX idx_leave_app_emp        ON attendance.leave_application(employee_id, status);
CREATE INDEX idx_leave_app_dates      ON attendance.leave_application(from_date, to_date);
CREATE INDEX idx_leave_balance_emp    ON attendance.leave_balance(employee_id, year);
CREATE INDEX idx_timesheet_emp_week   ON attendance.timesheet(employee_id, week_start);

-- =====================================================================
-- FUNCTIONS
-- =====================================================================

-- Calculate daily attendance from punches
CREATE OR REPLACE FUNCTION attendance.fn_calc_daily_attendance(p_emp UUID, p_date DATE)
RETURNS VOID AS $$
DECLARE
    v_first TIMESTAMPTZ;
    v_last  TIMESTAMPTZ;
    v_hrs   NUMERIC(6,2);
    v_shift attendance.shift%ROWTYPE;
    v_status TEXT;
    v_late  INT := 0;
BEGIN
    SELECT MIN(punch_time), MAX(punch_time) INTO v_first, v_last
      FROM attendance.punch
     WHERE employee_id = p_emp
       AND punch_time::date = p_date
       AND is_approved;

    SELECT s.* INTO v_shift
      FROM attendance.roster r JOIN attendance.shift s ON s.id = r.shift_id
     WHERE r.employee_id = p_emp AND r.roster_date = p_date;

    IF v_first IS NULL THEN
        v_status := 'absent';
    ELSE
        v_hrs := EXTRACT(EPOCH FROM v_last - v_first)/3600 - COALESCE(v_shift.break_minutes,0)/60.0;
        v_status := CASE
            WHEN v_hrs >= COALESCE(v_shift.full_day_hours,8) THEN 'present'
            WHEN v_hrs >= COALESCE(v_shift.half_day_hours,4) THEN 'half_day'
            ELSE 'absent' END;
        IF v_shift.start_time IS NOT NULL THEN
            v_late := GREATEST(0, EXTRACT(EPOCH FROM v_first::time - v_shift.start_time)/60)::int - COALESCE(v_shift.grace_minutes,0);
        END IF;
    END IF;

    INSERT INTO attendance.daily_attendance(tenant_id, employee_id, attendance_date, shift_id,
        first_in, last_out, total_hours, late_by_minutes, status)
    SELECT e.tenant_id, p_emp, p_date, v_shift.id, v_first, v_last, v_hrs, GREATEST(v_late,0), v_status
      FROM hr.employee e WHERE e.id = p_emp
    ON CONFLICT (employee_id, attendance_date)
    DO UPDATE SET first_in = EXCLUDED.first_in, last_out = EXCLUDED.last_out,
                  total_hours = EXCLUDED.total_hours, late_by_minutes = EXCLUDED.late_by_minutes,
                  status = EXCLUDED.status;
END;
$$ LANGUAGE plpgsql;

-- Apply leave (validates balance, blocks overlap)
CREATE OR REPLACE FUNCTION attendance.fn_apply_leave(
    p_emp UUID, p_lt UUID, p_from DATE, p_to DATE, p_reason TEXT
) RETURNS UUID AS $$
DECLARE
    v_days NUMERIC;
    v_bal  NUMERIC;
    v_id   UUID;
    v_tenant UUID;
BEGIN
    SELECT tenant_id INTO v_tenant FROM hr.employee WHERE id = p_emp;
    v_days := (p_to - p_from) + 1;

    IF EXISTS (SELECT 1 FROM attendance.leave_application
                WHERE employee_id = p_emp AND status IN ('pending','approved')
                  AND daterange(from_date, to_date, '[]') && daterange(p_from, p_to, '[]')) THEN
        RAISE EXCEPTION 'Overlapping leave application exists';
    END IF;

    SELECT balance INTO v_bal FROM attendance.leave_balance
     WHERE employee_id = p_emp AND leave_type_id = p_lt AND year = EXTRACT(YEAR FROM p_from);
    IF COALESCE(v_bal,0) < v_days THEN
        RAISE EXCEPTION 'Insufficient leave balance: available %, requested %', v_bal, v_days;
    END IF;

    INSERT INTO attendance.leave_application(tenant_id, doc_no, employee_id, leave_type_id,
        from_date, to_date, total_days, reason, status)
    VALUES (v_tenant, core.fn_next_doc_number(v_tenant,'leave_application'),
        p_emp, p_lt, p_from, p_to, v_days, p_reason, 'pending')
    RETURNING id INTO v_id;
    RETURN v_id;
END;
$$ LANGUAGE plpgsql;

-- Approve leave (deduct from balance)
CREATE OR REPLACE FUNCTION attendance.fn_approve_leave(p_leave UUID, p_approver UUID)
RETURNS VOID AS $$
DECLARE v_la attendance.leave_application%ROWTYPE;
BEGIN
    SELECT * INTO v_la FROM attendance.leave_application WHERE id = p_leave FOR UPDATE;
    IF v_la.status <> 'pending' THEN RAISE EXCEPTION 'Leave not pending'; END IF;

    UPDATE attendance.leave_balance
       SET used = used + v_la.total_days
     WHERE employee_id = v_la.employee_id AND leave_type_id = v_la.leave_type_id
       AND year = EXTRACT(YEAR FROM v_la.from_date);

    UPDATE attendance.leave_application
       SET status='approved', approver_id = p_approver, approved_at = NOW()
     WHERE id = p_leave;
END;
$$ LANGUAGE plpgsql;

-- =====================================================================
-- VIEWS
-- =====================================================================
CREATE OR REPLACE VIEW attendance.v_monthly_summary AS
SELECT employee_id, date_trunc('month', attendance_date)::date AS month,
       COUNT(*) FILTER (WHERE status='present') AS present_days,
       COUNT(*) FILTER (WHERE status='absent') AS absent_days,
       COUNT(*) FILTER (WHERE status='leave') AS leave_days,
       COUNT(*) FILTER (WHERE status='half_day') AS half_days,
       SUM(total_hours) AS total_hours,
       SUM(overtime_hours) AS ot_hours
  FROM attendance.daily_attendance GROUP BY 1,2;

CREATE OR REPLACE VIEW attendance.v_leave_liability AS
SELECT employee_id, leave_type_id, year, allocated, used, balance,
       balance * 0 AS liability_placeholder  -- join payroll for actual valuation
  FROM attendance.leave_balance;
