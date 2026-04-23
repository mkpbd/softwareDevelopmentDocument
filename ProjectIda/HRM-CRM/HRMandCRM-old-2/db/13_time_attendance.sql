-- =====================================================================
-- Module 13: Time & Attendance
-- Attendance, Leave, Shifts, Overtime, Holidays, Timesheets
-- =====================================================================

SET search_path = app, core, public;

-- =============== SCHEMA ===============

CREATE TABLE IF NOT EXISTS app.holiday_calendars (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  code            citext NOT NULL,
  name            text NOT NULL,
  year            smallint NOT NULL,
  region          text,
  active          boolean NOT NULL DEFAULT true,
  UNIQUE (tenant_id, code, year)
);

CREATE TABLE IF NOT EXISTS app.holidays (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  calendar_id     uuid NOT NULL REFERENCES app.holiday_calendars(id) ON DELETE CASCADE,
  holiday_date    date NOT NULL,
  name            text NOT NULL,
  holiday_type    text NOT NULL DEFAULT 'public' CHECK (holiday_type IN ('public','religious','optional','restricted')),
  UNIQUE (calendar_id, holiday_date)
);

CREATE TABLE IF NOT EXISTS app.shifts (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  code            citext NOT NULL,
  name            text NOT NULL,
  start_time      time NOT NULL,
  end_time        time NOT NULL,
  break_minutes   int NOT NULL DEFAULT 0,
  crosses_midnight boolean NOT NULL DEFAULT false,
  grace_minutes   int NOT NULL DEFAULT 15,
  half_day_hours  numeric(4,2) NOT NULL DEFAULT 4,
  full_day_hours  numeric(4,2) NOT NULL DEFAULT 8,
  active          boolean NOT NULL DEFAULT true,
  UNIQUE (tenant_id, code)
);

CREATE TABLE IF NOT EXISTS app.shift_rosters (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  employee_id     uuid NOT NULL REFERENCES app.employees(id) ON DELETE CASCADE,
  shift_id        uuid NOT NULL REFERENCES app.shifts(id),
  effective_from  date NOT NULL,
  effective_to    date,
  weekly_pattern  smallint[] NOT NULL DEFAULT ARRAY[1,1,1,1,1,0,0]::smallint[],  -- Mon..Sun
  UNIQUE (employee_id, effective_from)
);

CREATE TABLE IF NOT EXISTS app.attendance_records (
  id              uuid NOT NULL DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  employee_id     uuid NOT NULL REFERENCES app.employees(id) ON DELETE CASCADE,
  attendance_date date NOT NULL,
  shift_id        uuid REFERENCES app.shifts(id),
  scheduled_in    timestamptz,
  scheduled_out   timestamptz,
  first_in        timestamptz,
  last_out        timestamptz,
  hours_worked    numeric(5,2) NOT NULL DEFAULT 0,
  overtime_hours  numeric(5,2) NOT NULL DEFAULT 0,
  status          text NOT NULL DEFAULT 'present'
                  CHECK (status IN ('present','absent','half_day','on_leave','holiday','weekoff','wfh','on_duty','late','early_out')),
  late_minutes    int NOT NULL DEFAULT 0,
  early_out_minutes int NOT NULL DEFAULT 0,
  source          text CHECK (source IN (NULL,'biometric','geo','web','mobile','manual')),
  location_lat    numeric(10,7), location_lng numeric(10,7),
  ip_address      inet,
  regularization_status text CHECK (regularization_status IN (NULL,'pending','approved','rejected')),
  notes           text,
  created_at      timestamptz NOT NULL DEFAULT now(),
  updated_at      timestamptz NOT NULL DEFAULT now(),
  PRIMARY KEY (id, attendance_date),
  UNIQUE (tenant_id, employee_id, attendance_date)
) PARTITION BY RANGE (attendance_date);

CREATE TABLE IF NOT EXISTS app.attendance_records_2026 PARTITION OF app.attendance_records
  FOR VALUES FROM ('2026-01-01') TO ('2027-01-01');
CREATE TABLE IF NOT EXISTS app.attendance_records_default PARTITION OF app.attendance_records DEFAULT;

CREATE TABLE IF NOT EXISTS app.attendance_punches (
  id              uuid NOT NULL DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  employee_id     uuid NOT NULL,
  punched_at      timestamptz NOT NULL DEFAULT now(),
  punch_type      text NOT NULL CHECK (punch_type IN ('in','out')),
  source          text CHECK (source IN (NULL,'biometric','geo','web','mobile','rfid')),
  device_id       text,
  location_lat    numeric(10,7), location_lng numeric(10,7),
  ip_address      inet,
  PRIMARY KEY (id, punched_at)
) PARTITION BY RANGE (punched_at);

CREATE TABLE IF NOT EXISTS app.attendance_punches_2026 PARTITION OF app.attendance_punches
  FOR VALUES FROM ('2026-01-01') TO ('2027-01-01');
CREATE TABLE IF NOT EXISTS app.attendance_punches_default PARTITION OF app.attendance_punches DEFAULT;

CREATE TABLE IF NOT EXISTS app.leave_types (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  code            citext NOT NULL,
  name            text NOT NULL,
  is_paid         boolean NOT NULL DEFAULT true,
  accrual_type    text NOT NULL DEFAULT 'yearly' CHECK (accrual_type IN ('yearly','monthly','quarterly','none')),
  annual_quota    numeric(5,2),
  carry_forward_limit numeric(5,2) NOT NULL DEFAULT 0,
  encashable      boolean NOT NULL DEFAULT false,
  min_notice_days int NOT NULL DEFAULT 0,
  requires_approval boolean NOT NULL DEFAULT true,
  applies_to_probation boolean NOT NULL DEFAULT false,
  active          boolean NOT NULL DEFAULT true,
  UNIQUE (tenant_id, code)
);

CREATE TABLE IF NOT EXISTS app.leave_balances (
  tenant_id       uuid NOT NULL,
  employee_id     uuid NOT NULL REFERENCES app.employees(id) ON DELETE CASCADE,
  leave_type_id   uuid NOT NULL REFERENCES app.leave_types(id),
  year            smallint NOT NULL,
  opening_balance numeric(5,2) NOT NULL DEFAULT 0,
  accrued         numeric(5,2) NOT NULL DEFAULT 0,
  availed         numeric(5,2) NOT NULL DEFAULT 0,
  encashed        numeric(5,2) NOT NULL DEFAULT 0,
  lapsed          numeric(5,2) NOT NULL DEFAULT 0,
  balance         numeric(5,2) GENERATED ALWAYS AS
                   (opening_balance + accrued - availed - encashed - lapsed) STORED,
  updated_at      timestamptz NOT NULL DEFAULT now(),
  PRIMARY KEY (employee_id, leave_type_id, year)
);

CREATE TABLE IF NOT EXISTS app.leave_applications (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  employee_id     uuid NOT NULL REFERENCES app.employees(id) ON DELETE CASCADE,
  leave_type_id   uuid NOT NULL REFERENCES app.leave_types(id),
  application_number text NOT NULL,
  from_date       date NOT NULL,
  to_date         date NOT NULL,
  days            numeric(5,2) NOT NULL CHECK (days > 0),
  is_half_day     boolean NOT NULL DEFAULT false,
  reason          text,
  status          text NOT NULL DEFAULT 'submitted'
                  CHECK (status IN ('draft','submitted','approved','rejected','cancelled','withdrawn')),
  approver_id     uuid,
  approved_at     timestamptz,
  rejection_reason text,
  created_at      timestamptz NOT NULL DEFAULT now(),
  updated_at      timestamptz NOT NULL DEFAULT now(),
  UNIQUE (tenant_id, application_number),
  CHECK (to_date >= from_date)
);

CREATE TABLE IF NOT EXISTS app.overtime_records (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  employee_id     uuid NOT NULL REFERENCES app.employees(id),
  ot_date         date NOT NULL,
  ot_hours        numeric(5,2) NOT NULL CHECK (ot_hours > 0),
  ot_rate_multiplier numeric(5,2) NOT NULL DEFAULT 1.5,
  reason          text,
  approved_by     uuid,
  status          text NOT NULL DEFAULT 'submitted'
                  CHECK (status IN ('submitted','approved','rejected','paid')),
  created_at      timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS app.timesheets (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  employee_id     uuid NOT NULL REFERENCES app.employees(id) ON DELETE CASCADE,
  week_start      date NOT NULL,
  total_hours     numeric(6,2) NOT NULL DEFAULT 0,
  billable_hours  numeric(6,2) NOT NULL DEFAULT 0,
  status          text NOT NULL DEFAULT 'draft'
                  CHECK (status IN ('draft','submitted','approved','rejected')),
  submitted_at    timestamptz, approved_at timestamptz, approved_by uuid,
  created_at      timestamptz NOT NULL DEFAULT now(),
  updated_at      timestamptz NOT NULL DEFAULT now(),
  UNIQUE (employee_id, week_start)
);

CREATE TABLE IF NOT EXISTS app.timesheet_entries (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  timesheet_id    uuid NOT NULL REFERENCES app.timesheets(id) ON DELETE CASCADE,
  entry_date      date NOT NULL,
  project_id      uuid,
  task_id         uuid,
  customer_id     uuid REFERENCES app.customers(id),
  hours           numeric(5,2) NOT NULL CHECK (hours > 0),
  is_billable     boolean NOT NULL DEFAULT true,
  activity_code   text,
  description     text,
  created_at      timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS app.attendance_regularizations (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  employee_id     uuid NOT NULL REFERENCES app.employees(id),
  attendance_date date NOT NULL,
  requested_in    timestamptz, requested_out timestamptz,
  reason          text NOT NULL,
  status          text NOT NULL DEFAULT 'pending'
                  CHECK (status IN ('pending','approved','rejected')),
  approver_id     uuid, approved_at timestamptz,
  created_at      timestamptz NOT NULL DEFAULT now()
);

-- =============== INDEXES ===============
CREATE INDEX IF NOT EXISTS idx_shifts_active    ON app.shifts(tenant_id) WHERE active;
CREATE INDEX IF NOT EXISTS idx_roster_emp       ON app.shift_rosters(employee_id, effective_from DESC);
CREATE INDEX IF NOT EXISTS idx_attn_emp_date    ON app.attendance_records(employee_id, attendance_date DESC);
CREATE INDEX IF NOT EXISTS idx_attn_status_date ON app.attendance_records(tenant_id, status, attendance_date);
CREATE INDEX IF NOT EXISTS idx_punches_emp_time ON app.attendance_punches(employee_id, punched_at DESC);
CREATE INDEX IF NOT EXISTS idx_ltypes_active    ON app.leave_types(tenant_id) WHERE active;
CREATE INDEX IF NOT EXISTS idx_lbal_emp_year    ON app.leave_balances(employee_id, year);
CREATE INDEX IF NOT EXISTS idx_lapp_emp_status  ON app.leave_applications(employee_id, status);
CREATE INDEX IF NOT EXISTS idx_lapp_dates       ON app.leave_applications(from_date, to_date);
CREATE INDEX IF NOT EXISTS idx_ot_emp_date      ON app.overtime_records(employee_id, ot_date DESC);
CREATE INDEX IF NOT EXISTS idx_ts_emp_week      ON app.timesheets(employee_id, week_start DESC);
CREATE INDEX IF NOT EXISTS idx_tse_timesheet    ON app.timesheet_entries(timesheet_id, entry_date);
CREATE INDEX IF NOT EXISTS idx_tse_project      ON app.timesheet_entries(project_id) WHERE project_id IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_reg_emp_date     ON app.attendance_regularizations(employee_id, attendance_date);

-- =============== RLS + TRIGGERS ===============
SELECT core.enable_tenant_rls('app.holiday_calendars');
SELECT core.enable_tenant_rls('app.holidays');
SELECT core.enable_tenant_rls('app.shifts');
SELECT core.enable_tenant_rls('app.shift_rosters');
SELECT core.enable_tenant_rls('app.attendance_records');
SELECT core.enable_tenant_rls('app.attendance_punches');
SELECT core.enable_tenant_rls('app.leave_types');
SELECT core.enable_tenant_rls('app.leave_balances');
SELECT core.enable_tenant_rls('app.leave_applications');
SELECT core.enable_tenant_rls('app.overtime_records');
SELECT core.enable_tenant_rls('app.timesheets');
SELECT core.enable_tenant_rls('app.timesheet_entries');
SELECT core.enable_tenant_rls('app.attendance_regularizations');

SELECT core.attach_standard_triggers('app.shifts');
SELECT core.attach_standard_triggers('app.leave_types');
SELECT core.attach_standard_triggers('app.leave_applications');
SELECT core.attach_standard_triggers('app.timesheets');

-- =============== FUNCTIONS ===============

-- Compute attendance for a day from punches (first/last punch window)
CREATE OR REPLACE FUNCTION app.compute_attendance(p_employee_id uuid, p_date date)
RETURNS void
LANGUAGE plpgsql AS $$
DECLARE
  v_first timestamptz; v_last timestamptz;
  v_shift app.shifts%ROWTYPE; v_shift_id uuid;
  v_hours numeric(5,2); v_status text;
BEGIN
  SELECT MIN(punched_at), MAX(punched_at)
    INTO v_first, v_last
    FROM app.attendance_punches
   WHERE employee_id = p_employee_id
     AND punched_at::date = p_date;

  SELECT sr.shift_id INTO v_shift_id
    FROM app.shift_rosters sr
   WHERE sr.employee_id = p_employee_id
     AND sr.effective_from <= p_date
     AND (sr.effective_to IS NULL OR sr.effective_to >= p_date)
   ORDER BY sr.effective_from DESC LIMIT 1;

  SELECT * INTO v_shift FROM app.shifts WHERE id = v_shift_id;

  v_hours := CASE WHEN v_first IS NULL THEN 0
                  ELSE round(EXTRACT(EPOCH FROM (v_last - v_first))/3600, 2)
                  END;

  v_status := CASE
    WHEN v_first IS NULL THEN 'absent'
    WHEN v_hours >= COALESCE(v_shift.full_day_hours, 8) THEN 'present'
    WHEN v_hours >= COALESCE(v_shift.half_day_hours, 4) THEN 'half_day'
    ELSE 'half_day'
  END;

  INSERT INTO app.attendance_records(tenant_id, employee_id, attendance_date, shift_id,
         first_in, last_out, hours_worked, status)
  VALUES (core.current_tenant_id(), p_employee_id, p_date, v_shift_id,
          v_first, v_last, v_hours, v_status)
  ON CONFLICT (tenant_id, employee_id, attendance_date) DO UPDATE SET
    shift_id     = EXCLUDED.shift_id,
    first_in     = EXCLUDED.first_in,
    last_out     = EXCLUDED.last_out,
    hours_worked = EXCLUDED.hours_worked,
    status       = EXCLUDED.status,
    updated_at   = now();
END $$;

-- Check leave balance + working day count for leave application
CREATE OR REPLACE FUNCTION app.leave_working_days(
  p_from date, p_to date, p_calendar_id uuid
) RETURNS int
LANGUAGE sql STABLE AS $$
  SELECT COUNT(*)::int
    FROM generate_series(p_from, p_to, interval '1 day') d
   WHERE EXTRACT(ISODOW FROM d) < 6                           -- exclude Sat/Sun
     AND NOT EXISTS (
       SELECT 1 FROM app.holidays h
        WHERE h.calendar_id = p_calendar_id AND h.holiday_date = d::date
     )
$$;

-- Apply leave: deduct balance on approval
CREATE OR REPLACE PROCEDURE app.approve_leave(p_application_id uuid, p_approver_id uuid)
LANGUAGE plpgsql AS $$
DECLARE v_app app.leave_applications%ROWTYPE; v_year smallint;
BEGIN
  SELECT * INTO v_app FROM app.leave_applications WHERE id = p_application_id;
  IF v_app.status <> 'submitted' THEN RAISE EXCEPTION 'application not submitted'; END IF;

  v_year := EXTRACT(YEAR FROM v_app.from_date);

  UPDATE app.leave_balances
     SET availed = availed + v_app.days, updated_at = now()
   WHERE employee_id = v_app.employee_id AND leave_type_id = v_app.leave_type_id AND year = v_year;

  IF NOT FOUND THEN RAISE EXCEPTION 'no leave balance row for year %', v_year; END IF;

  UPDATE app.leave_applications
     SET status='approved', approver_id=p_approver_id, approved_at=now(), updated_at=now()
   WHERE id = p_application_id;
END $$;

-- =============== VIEWS ===============
CREATE OR REPLACE VIEW app.v_attendance_summary AS
SELECT ar.tenant_id, ar.employee_id,
       date_trunc('month', ar.attendance_date)::date AS month,
       COUNT(*) FILTER (WHERE ar.status='present')   present_days,
       COUNT(*) FILTER (WHERE ar.status='absent')    absent_days,
       COUNT(*) FILTER (WHERE ar.status='half_day')  half_days,
       COUNT(*) FILTER (WHERE ar.status='on_leave')  leave_days,
       COUNT(*) FILTER (WHERE ar.late_minutes > 0)   late_count,
       SUM(ar.hours_worked)  AS total_hours,
       SUM(ar.overtime_hours) AS ot_hours
  FROM app.attendance_records ar
 GROUP BY 1,2,3;
