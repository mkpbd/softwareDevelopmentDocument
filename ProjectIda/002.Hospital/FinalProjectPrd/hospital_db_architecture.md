# Hospital ERP System — Enterprise PostgreSQL Database Architecture

> **Version:** 1.0 · **Platform:** PostgreSQL 16+ · **Scale:** Multi-branch, millions of patients  
> **Author:** Database Architecture Team · **Classification:** Internal Technical Reference

---

## Table of Contents

1. [Domain Breakdown & Bounded Contexts](#1-domain-breakdown--bounded-contexts)
2. [Database Design Strategy](#2-database-design-strategy)
3. [Global Conventions & Shared Infrastructure](#3-global-conventions--shared-infrastructure)
4. [Module 1 — Patient Management](#4-module-1--patient-management)
5. [Module 2 — Appointment & Scheduling](#5-module-2--appointment--scheduling)
6. [Module 3 — OPD (Outpatient Department)](#6-module-3--opd-outpatient-department)
7. [Module 4 — IPD (Inpatient Department)](#7-module-4--ipd-inpatient-department)
8. [Module 5 — Electronic Medical Records (EMR)](#8-module-5--electronic-medical-records-emr)
9. [Module 6 — Laboratory Information System (LIS)](#9-module-6--laboratory-information-system-lis)
10. [Module 7 — Radiology Information System (RIS)](#10-module-7--radiology-information-system-ris)
11. [Module 8 — Pharmacy Management](#11-module-8--pharmacy-management)
12. [Module 9 — Billing & Revenue Cycle](#12-module-9--billing--revenue-cycle)
13. [Module 10 — Insurance & Claims](#13-module-10--insurance--claims)
14. [Module 11 — Human Resources & Payroll](#14-module-11--human-resources--payroll)
15. [Module 12 — Inventory & Supply Chain](#15-module-12--inventory--supply-chain)
16. [Advanced PostgreSQL Objects](#16-advanced-postgresql-objects)
17. [Business Logic at DB Level](#17-business-logic-at-db-level)
18. [Performance Optimization](#18-performance-optimization)
19. [Security & Compliance](#19-security--compliance)
20. [Reporting Layer](#20-reporting-layer)
21. [Naming Conventions Summary](#21-naming-conventions-summary)

---

## 1. Domain Breakdown & Bounded Contexts

### 1.1 Core Domains

| Domain | Bounded Context | Primary Owner | Data Nature |
|---|---|---|---|
| **Identity** | Tenant, Hospital Branch, User Auth | IT/Admin | Master |
| **Patient** | Demographics, MRN, Consent, Family | Registration | Master + Transactional |
| **Clinical** | OPD, IPD, EMR, Triage, Orders | Doctors/Nurses | Transactional |
| **Scheduling** | Appointments, Doctor Availability, Resources | Reception | Transactional |
| **Laboratory** | Orders, Samples, Results, QC | Lab | Transactional |
| **Radiology** | Imaging Orders, Studies, Reports, PACS | Radiology | Transactional |
| **Pharmacy** | Drug Catalog, Prescriptions, Dispensing, Stock | Pharmacy | Transactional |
| **Finance** | Billing, Payments, Insurance, Claims | Finance | Transactional + Audit |
| **HR** | Staff, Attendance, Payroll, Scheduling | HR | Master + Transactional |
| **Supply Chain** | Inventory, PO, GRN, Vendors | Store | Transactional |
| **Compliance** | Audit Logs, Consent, Legal Holds | Compliance | Append-only |
| **Reporting** | KPIs, Materialized Views, Dashboards | Management | OLAP |

### 1.2 Domain Relationships (High Level)

```
[Tenant/Branch] ──< owns >── [Patient] ──< attends >── [Appointment]
                                │                              │
                                ├──< has >── [EMR/Encounter]──┤
                                │                 │
                          [Admission]         [Lab Orders]──>[Lab Results]
                               │              [Rad Orders]──>[Rad Reports]
                               │              [Prescriptions]──>[Dispensing]
                               │
                          [Invoice]──>[Payment]──>[Insurance Claim]
```

---

## 2. Database Design Strategy

### 2.1 OLTP vs OLAP Separation

```
┌─────────────────────────────────────────────────────────────┐
│  PRIMARY DATABASE (PostgreSQL OLTP)                         │
│  ├── All transactional tables (patients, billing, orders)   │
│  ├── Optimized for INSERT/UPDATE/SELECT by PK               │
│  └── Strict ACID guarantees                                 │
├─────────────────────────────────────────────────────────────┤
│  REPORTING LAYER (Same PostgreSQL instance / Read Replica)  │
│  ├── Materialized views refreshed on schedule               │
│  ├── kpi_* tables (denormalized aggregates)                 │
│  └── Read replica for reporting queries                     │
└─────────────────────────────────────────────────────────────┘
```

### 2.2 Multi-Tenancy Strategy

Every table includes `tenant_id UUID NOT NULL` referencing `tenants`. Row-Level Security (RLS) policies enforce that each application role can only read/write rows belonging to its tenant. This supports a single database serving multiple hospital branches/groups.

### 2.3 Universal Audit Columns

Every table (except lookup/master tables) carries:

```sql
created_at   TIMESTAMPTZ NOT NULL DEFAULT NOW(),
created_by   UUID        NOT NULL,  -- references users.user_id
updated_at   TIMESTAMPTZ NOT NULL DEFAULT NOW(),
updated_by   UUID        NOT NULL,  -- references users.user_id
is_deleted   BOOLEAN     NOT NULL DEFAULT FALSE,
deleted_at   TIMESTAMPTZ,
deleted_by   UUID
```

### 2.4 Soft Delete Pattern

No hard deletes on any clinical or financial table. Queries use either:
- A global `WHERE is_deleted = FALSE` filter, or
- A PostgreSQL **partial index** on `is_deleted = FALSE` for performance.

### 2.5 UUID Key Strategy

```sql
-- All PKs use gen_random_uuid() (PostgreSQL 13+, no extension needed)
some_id UUID PRIMARY KEY DEFAULT gen_random_uuid()
```

---

## 3. Global Conventions & Shared Infrastructure

### 3.1 Tenants (Hospital Groups / Branches)

```sql
CREATE TABLE tenants (
    tenant_id        UUID         PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_code      VARCHAR(20)  NOT NULL,
    tenant_name      VARCHAR(200) NOT NULL,
    tenant_type      VARCHAR(50)  NOT NULL CHECK (tenant_type IN ('GROUP','BRANCH','STANDALONE')),
    parent_tenant_id UUID         REFERENCES tenants(tenant_id),
    address          JSONB,          -- { street, city, state, zip, country }
    contact_info     JSONB,          -- { phone, email, fax }
    settings         JSONB,          -- feature flags, configs per tenant
    license_info     JSONB,          -- license key, expiry, max_users
    is_active        BOOLEAN      NOT NULL DEFAULT TRUE,
    created_at       TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at       TIMESTAMPTZ  NOT NULL DEFAULT NOW()
);

CREATE UNIQUE INDEX uq_tenants_code ON tenants(tenant_code);
CREATE INDEX idx_tenants_parent ON tenants(parent_tenant_id);
```

### 3.2 Users & Authentication

```sql
CREATE TABLE users (
    user_id          UUID         PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id        UUID         NOT NULL REFERENCES tenants(tenant_id),
    username         VARCHAR(100) NOT NULL,
    email            VARCHAR(255) NOT NULL,
    password_hash    TEXT         NOT NULL,
    phone            VARCHAR(20),
    user_type        VARCHAR(50)  NOT NULL CHECK (user_type IN
                       ('DOCTOR','NURSE','RECEPTIONIST','LAB_TECH',
                        'PHARMACIST','ACCOUNTANT','HR','ADMIN','PATIENT','SYSTEM')),
    is_active        BOOLEAN      NOT NULL DEFAULT TRUE,
    last_login_at    TIMESTAMPTZ,
    failed_attempts  SMALLINT     NOT NULL DEFAULT 0,
    locked_until     TIMESTAMPTZ,
    mfa_enabled      BOOLEAN      NOT NULL DEFAULT FALSE,
    mfa_secret       TEXT,                        -- encrypted
    profile_data     JSONB,                       -- extra profile fields
    created_at       TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at       TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    is_deleted       BOOLEAN      NOT NULL DEFAULT FALSE,
    deleted_at       TIMESTAMPTZ
);

CREATE UNIQUE INDEX uq_users_email_tenant ON users(tenant_id, email) WHERE is_deleted = FALSE;
CREATE UNIQUE INDEX uq_users_username_tenant ON users(tenant_id, username) WHERE is_deleted = FALSE;
CREATE INDEX idx_users_tenant ON users(tenant_id);
CREATE INDEX idx_users_type ON users(user_type) WHERE is_deleted = FALSE;
```

### 3.3 Roles & Permissions (RBAC)

```sql
CREATE TABLE roles (
    role_id     UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id   UUID        NOT NULL REFERENCES tenants(tenant_id),
    role_name   VARCHAR(100) NOT NULL,
    description TEXT,
    is_system   BOOLEAN     NOT NULL DEFAULT FALSE,  -- system roles cannot be deleted
    created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE permissions (
    permission_id   UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    module_name     VARCHAR(100) NOT NULL,           -- 'PATIENT','BILLING','LAB' etc.
    action          VARCHAR(50)  NOT NULL,           -- 'READ','WRITE','DELETE','APPROVE'
    resource        VARCHAR(100),                    -- optional fine-grained resource
    description     TEXT,
    UNIQUE(module_name, action, resource)
);

CREATE TABLE role_permissions (
    role_permission_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    role_id       UUID NOT NULL REFERENCES roles(role_id) ON DELETE CASCADE,
    permission_id UUID NOT NULL REFERENCES permissions(permission_id) ON DELETE CASCADE,
    UNIQUE(role_id, permission_id)
);

CREATE TABLE user_roles (
    user_role_id  UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id       UUID        NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
    role_id       UUID        NOT NULL REFERENCES roles(role_id) ON DELETE CASCADE,
    assigned_at   TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    assigned_by   UUID        NOT NULL REFERENCES users(user_id),
    expires_at    TIMESTAMPTZ,
    UNIQUE(user_id, role_id)
);

CREATE INDEX idx_role_permissions_role ON role_permissions(role_id);
CREATE INDEX idx_user_roles_user ON user_roles(user_id);
```

### 3.4 Audit Log (Append-Only)

```sql
CREATE TABLE audit_logs (
    audit_log_id   UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id      UUID        NOT NULL,
    user_id        UUID,                              -- NULL for system actions
    session_id     UUID,
    action         VARCHAR(50) NOT NULL,             -- INSERT, UPDATE, DELETE, VIEW, LOGIN, APPROVE
    table_name     VARCHAR(100) NOT NULL,
    record_id      UUID,                             -- PK of the affected row
    old_values     JSONB,
    new_values     JSONB,
    ip_address     INET,
    user_agent     TEXT,
    occurred_at    TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    is_sensitive   BOOLEAN     NOT NULL DEFAULT FALSE  -- for PHI access logs
) PARTITION BY RANGE (occurred_at);

-- Monthly partitions (example: create via pg_partman or scheduled job)
CREATE TABLE audit_logs_2025_01 PARTITION OF audit_logs
    FOR VALUES FROM ('2025-01-01') TO ('2025-02-01');
CREATE TABLE audit_logs_2025_02 PARTITION OF audit_logs
    FOR VALUES FROM ('2025-02-01') TO ('2025-03-01');

CREATE INDEX idx_audit_logs_tenant_time ON audit_logs(tenant_id, occurred_at DESC);
CREATE INDEX idx_audit_logs_table_record ON audit_logs(table_name, record_id);
CREATE INDEX idx_audit_logs_user ON audit_logs(user_id, occurred_at DESC);
```

### 3.5 Lookup / Reference Data

```sql
CREATE TABLE lookup_categories (
    category_id   UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    category_code VARCHAR(50) NOT NULL UNIQUE,
    category_name VARCHAR(100) NOT NULL,
    description   TEXT
);

CREATE TABLE lookup_values (
    lookup_id     UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    category_id   UUID        NOT NULL REFERENCES lookup_categories(category_id),
    lookup_code   VARCHAR(100) NOT NULL,
    lookup_value  VARCHAR(255) NOT NULL,
    sort_order    SMALLINT    NOT NULL DEFAULT 0,
    is_active     BOOLEAN     NOT NULL DEFAULT TRUE,
    metadata      JSONB,
    UNIQUE(category_id, lookup_code)
);

-- Sample categories: BLOOD_GROUP, GENDER, MARITAL_STATUS, NATIONALITY,
--                    TRIAGE_LEVEL, BED_TYPE, WARD_TYPE, DISCHARGE_TYPE, etc.
CREATE INDEX idx_lookup_values_category ON lookup_values(category_id) WHERE is_active = TRUE;
```

---

## 4. Module 1 — Patient Management

### 4.1 Patients (Core Identity)

```sql
CREATE TABLE patients (
    patient_id       UUID         PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id        UUID         NOT NULL REFERENCES tenants(tenant_id),
    mrn              VARCHAR(30)  NOT NULL,           -- Medical Record Number (never changes)
    uhid             VARCHAR(30),                     -- Unique Hospital ID (system-specific)
    -- Personal Information
    first_name       VARCHAR(100) NOT NULL,
    middle_name      VARCHAR(100),
    last_name        VARCHAR(100) NOT NULL,
    date_of_birth    DATE         NOT NULL,
    gender           VARCHAR(20)  NOT NULL CHECK (gender IN ('MALE','FEMALE','OTHER','UNKNOWN')),
    blood_group      VARCHAR(10),                    -- e.g. 'A+', 'O-'
    marital_status   VARCHAR(30),
    nationality      VARCHAR(100),
    language_pref    VARCHAR(50)  DEFAULT 'EN',
    religion         VARCHAR(50),
    -- Contact
    primary_phone    VARCHAR(20),
    secondary_phone  VARCHAR(20),
    email            VARCHAR(255),
    address          JSONB NOT NULL,                 -- { street, city, state, zip, country }
    alternate_address JSONB,
    -- Classification
    patient_category VARCHAR(50)  NOT NULL DEFAULT 'GENERAL'
                     CHECK (patient_category IN
                       ('GENERAL','CORPORATE','GOVERNMENT','INTERNATIONAL','VIP','DECEASED')),
    -- Identifiers
    national_id      VARCHAR(50),                    -- stored encrypted
    passport_number  VARCHAR(50),
    driver_license   VARCHAR(50),
    -- Medical Flags
    has_allergies    BOOLEAN      NOT NULL DEFAULT FALSE,
    has_chronic      BOOLEAN      NOT NULL DEFAULT FALSE,
    is_vip           BOOLEAN      NOT NULL DEFAULT FALSE,
    is_deceased      BOOLEAN      NOT NULL DEFAULT FALSE,
    deceased_at      TIMESTAMPTZ,
    -- System
    photo_url        TEXT,
    qr_code          TEXT,
    notes            TEXT,
    created_at       TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    created_by       UUID         NOT NULL REFERENCES users(user_id),
    updated_at       TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_by       UUID         NOT NULL REFERENCES users(user_id),
    is_deleted       BOOLEAN      NOT NULL DEFAULT FALSE,
    deleted_at       TIMESTAMPTZ,
    deleted_by       UUID         REFERENCES users(user_id)
);

CREATE UNIQUE INDEX uq_patients_mrn_tenant  ON patients(tenant_id, mrn);
CREATE UNIQUE INDEX uq_patients_uhid_tenant ON patients(tenant_id, uhid) WHERE uhid IS NOT NULL;
CREATE INDEX idx_patients_tenant             ON patients(tenant_id) WHERE is_deleted = FALSE;
CREATE INDEX idx_patients_name               ON patients(tenant_id, last_name, first_name) WHERE is_deleted = FALSE;
CREATE INDEX idx_patients_dob                ON patients(date_of_birth) WHERE is_deleted = FALSE;
CREATE INDEX idx_patients_phone              ON patients(primary_phone) WHERE is_deleted = FALSE;
CREATE INDEX idx_patients_national_id        ON patients(national_id) WHERE national_id IS NOT NULL AND is_deleted = FALSE;
-- Full-text search across names
CREATE INDEX idx_patients_fulltext ON patients
    USING GIN (to_tsvector('english', first_name || ' ' || last_name));
```

### 4.2 Patient Emergency Contacts

```sql
CREATE TABLE patient_emergency_contacts (
    contact_id    UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    patient_id    UUID        NOT NULL REFERENCES patients(patient_id) ON DELETE CASCADE,
    tenant_id     UUID        NOT NULL REFERENCES tenants(tenant_id),
    contact_name  VARCHAR(200) NOT NULL,
    relationship  VARCHAR(50)  NOT NULL,              -- FATHER, MOTHER, SPOUSE, SIBLING, OTHER
    primary_phone VARCHAR(20)  NOT NULL,
    secondary_phone VARCHAR(20),
    email         VARCHAR(255),
    address       JSONB,
    is_primary    BOOLEAN     NOT NULL DEFAULT FALSE,
    created_at    TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by    UUID        NOT NULL REFERENCES users(user_id)
);

CREATE INDEX idx_emg_contacts_patient ON patient_emergency_contacts(patient_id);
```

### 4.3 Patient Family Links

```sql
CREATE TABLE patient_family_links (
    link_id          UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id        UUID        NOT NULL REFERENCES tenants(tenant_id),
    patient_id       UUID        NOT NULL REFERENCES patients(patient_id),
    related_patient_id UUID      NOT NULL REFERENCES patients(patient_id),
    relationship     VARCHAR(50) NOT NULL,  -- PARENT, CHILD, SPOUSE, SIBLING
    is_confirmed     BOOLEAN     NOT NULL DEFAULT FALSE,
    created_at       TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by       UUID        NOT NULL REFERENCES users(user_id),
    UNIQUE(patient_id, related_patient_id)
);
```

### 4.4 Patient Documents

```sql
CREATE TABLE patient_documents (
    document_id    UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    patient_id     UUID        NOT NULL REFERENCES patients(patient_id) ON DELETE CASCADE,
    tenant_id      UUID        NOT NULL REFERENCES tenants(tenant_id),
    document_type  VARCHAR(50) NOT NULL,  -- NATIONAL_ID, INSURANCE_CARD, CONSENT, REPORT
    document_name  VARCHAR(255) NOT NULL,
    file_url       TEXT        NOT NULL,
    file_size_kb   INT,
    mime_type      VARCHAR(100),
    is_verified    BOOLEAN     NOT NULL DEFAULT FALSE,
    verified_by    UUID        REFERENCES users(user_id),
    verified_at    TIMESTAMPTZ,
    expires_at     DATE,
    notes          TEXT,
    created_at     TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by     UUID        NOT NULL REFERENCES users(user_id),
    is_deleted     BOOLEAN     NOT NULL DEFAULT FALSE
);

CREATE INDEX idx_patient_docs_patient ON patient_documents(patient_id) WHERE is_deleted = FALSE;
CREATE INDEX idx_patient_docs_type    ON patient_documents(patient_id, document_type);
```

### 4.5 Patient Allergies

```sql
CREATE TABLE patient_allergies (
    allergy_id       UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    patient_id       UUID        NOT NULL REFERENCES patients(patient_id) ON DELETE CASCADE,
    tenant_id        UUID        NOT NULL REFERENCES tenants(tenant_id),
    allergen_type    VARCHAR(50) NOT NULL CHECK (allergen_type IN
                       ('DRUG','FOOD','ENVIRONMENTAL','CONTRAST','LATEX','OTHER')),
    allergen_name    VARCHAR(255) NOT NULL,
    reaction_type    VARCHAR(100),                    -- ANAPHYLAXIS, RASH, NAUSEA, etc.
    severity         VARCHAR(20)  NOT NULL CHECK (severity IN ('MILD','MODERATE','SEVERE','LIFE_THREATENING')),
    onset_date       DATE,
    is_active        BOOLEAN     NOT NULL DEFAULT TRUE,
    notes            TEXT,
    recorded_by      UUID        NOT NULL REFERENCES users(user_id),
    created_at       TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at       TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_patient_allergies_patient ON patient_allergies(patient_id) WHERE is_active = TRUE;
```

### 4.6 Patient Consents

```sql
CREATE TABLE patient_consents (
    consent_id        UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    patient_id        UUID        NOT NULL REFERENCES patients(patient_id),
    tenant_id         UUID        NOT NULL REFERENCES tenants(tenant_id),
    consent_type      VARCHAR(100) NOT NULL,  -- DATA_SHARING, RESEARCH, SURGERY, TELEMEDICINE, DNR
    consent_version   VARCHAR(20)  NOT NULL,
    is_granted        BOOLEAN     NOT NULL,
    granted_at        TIMESTAMPTZ,
    revoked_at        TIMESTAMPTZ,
    ip_address        INET,
    signature_url     TEXT,                   -- digital signature file
    witness_user_id   UUID        REFERENCES users(user_id),
    notes             TEXT,
    created_at        TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by        UUID        NOT NULL REFERENCES users(user_id)
);

CREATE INDEX idx_patient_consents_patient ON patient_consents(patient_id);
CREATE INDEX idx_patient_consents_type    ON patient_consents(patient_id, consent_type);
```

### 4.7 Patient Insurance

```sql
CREATE TABLE patient_insurance (
    insurance_id       UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    patient_id         UUID        NOT NULL REFERENCES patients(patient_id) ON DELETE CASCADE,
    tenant_id          UUID        NOT NULL REFERENCES tenants(tenant_id),
    insurer_id         UUID        NOT NULL REFERENCES insurers(insurer_id),
    policy_number      VARCHAR(100) NOT NULL,
    member_id          VARCHAR(100) NOT NULL,
    group_number       VARCHAR(100),
    policy_holder_name VARCHAR(200),
    relationship_to_holder VARCHAR(50),          -- SELF, SPOUSE, CHILD, PARENT
    plan_type          VARCHAR(50),              -- GOLD, SILVER, PLATINUM, CORPORATE
    policy_start_date  DATE        NOT NULL,
    policy_end_date    DATE        NOT NULL,
    sum_insured        NUMERIC(15,2),
    utilized_amount    NUMERIC(15,2) NOT NULL DEFAULT 0,
    is_primary         BOOLEAN     NOT NULL DEFAULT TRUE,
    is_cashless        BOOLEAN     NOT NULL DEFAULT FALSE,
    is_active          BOOLEAN     NOT NULL DEFAULT TRUE,
    card_front_url     TEXT,
    card_back_url      TEXT,
    last_verified_at   TIMESTAMPTZ,
    created_at         TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by         UUID        NOT NULL REFERENCES users(user_id),
    updated_at         TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_patient_insurance_patient   ON patient_insurance(patient_id) WHERE is_active = TRUE;
CREATE INDEX idx_patient_insurance_policy    ON patient_insurance(policy_number);
CREATE INDEX idx_patient_insurance_expiry    ON patient_insurance(policy_end_date) WHERE is_active = TRUE;
```

---

## 5. Module 2 — Appointment & Scheduling

### 5.1 Departments

```sql
CREATE TABLE departments (
    department_id   UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id       UUID        NOT NULL REFERENCES tenants(tenant_id),
    dept_code       VARCHAR(20) NOT NULL,
    dept_name       VARCHAR(200) NOT NULL,
    dept_type       VARCHAR(50) NOT NULL CHECK (dept_type IN
                      ('OPD','IPD','EMERGENCY','LAB','RADIOLOGY','PHARMACY',
                       'OPERATION_THEATRE','ICU','HR','ADMIN','FINANCE')),
    head_doctor_id  UUID        REFERENCES users(user_id),
    floor_number    VARCHAR(10),
    room_numbers    JSONB,                          -- array of room identifiers
    phone           VARCHAR(20),
    email           VARCHAR(100),
    is_active       BOOLEAN     NOT NULL DEFAULT TRUE,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE UNIQUE INDEX uq_departments_code ON departments(tenant_id, dept_code);
CREATE INDEX idx_departments_tenant     ON departments(tenant_id) WHERE is_active = TRUE;
```

### 5.2 Doctors (Staff Clinical Profile)

```sql
CREATE TABLE doctors (
    doctor_id        UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id          UUID        NOT NULL UNIQUE REFERENCES users(user_id),
    tenant_id        UUID        NOT NULL REFERENCES tenants(tenant_id),
    doctor_code      VARCHAR(30),
    specialization   VARCHAR(200) NOT NULL,
    sub_specialization VARCHAR(200),
    qualification    VARCHAR(500),
    medical_reg_no   VARCHAR(100) NOT NULL,          -- Medical council registration
    experience_years SMALLINT,
    consultation_fee NUMERIC(10,2),
    follow_up_fee    NUMERIC(10,2),
    languages        VARCHAR(255),                   -- comma-separated
    biography        TEXT,
    signature_url    TEXT,
    department_id    UUID        REFERENCES departments(department_id),
    is_active        BOOLEAN     NOT NULL DEFAULT TRUE,
    created_at       TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at       TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_doctors_tenant      ON doctors(tenant_id) WHERE is_active = TRUE;
CREATE INDEX idx_doctors_department  ON doctors(department_id);
CREATE INDEX idx_doctors_specialization ON doctors(specialization);
```

### 5.3 Doctor Schedule Templates

```sql
CREATE TABLE doctor_schedule_templates (
    template_id     UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    doctor_id       UUID        NOT NULL REFERENCES doctors(doctor_id),
    tenant_id       UUID        NOT NULL REFERENCES tenants(tenant_id),
    day_of_week     SMALLINT    NOT NULL CHECK (day_of_week BETWEEN 0 AND 6),  -- 0=Sunday
    shift_name      VARCHAR(50) NOT NULL,               -- MORNING, AFTERNOON, EVENING
    start_time      TIME        NOT NULL,
    end_time        TIME        NOT NULL,
    slot_duration   SMALLINT    NOT NULL DEFAULT 15,    -- minutes per slot
    max_patients    SMALLINT    NOT NULL DEFAULT 20,
    location        VARCHAR(200),                        -- room/clinic
    is_active       BOOLEAN     NOT NULL DEFAULT TRUE,
    effective_from  DATE        NOT NULL,
    effective_to    DATE,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT chk_schedule_times CHECK (end_time > start_time)
);

CREATE INDEX idx_schedule_template_doctor ON doctor_schedule_templates(doctor_id) WHERE is_active = TRUE;
```

### 5.4 Doctor Availability Overrides (Leave / Blocks)

```sql
CREATE TABLE doctor_availability_overrides (
    override_id     UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    doctor_id       UUID        NOT NULL REFERENCES doctors(doctor_id),
    tenant_id       UUID        NOT NULL REFERENCES tenants(tenant_id),
    override_date   DATE        NOT NULL,
    start_time      TIME,                                -- NULL = entire day
    end_time        TIME,
    override_type   VARCHAR(50) NOT NULL CHECK (override_type IN
                      ('LEAVE','CONFERENCE','SURGERY_BLOCK','EMERGENCY_DUTY',
                       'EXTRA_SLOTS','HOLIDAY')),
    reason          TEXT,
    is_approved     BOOLEAN     NOT NULL DEFAULT FALSE,
    approved_by     UUID        REFERENCES users(user_id),
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by      UUID        NOT NULL REFERENCES users(user_id)
);

CREATE INDEX idx_availability_overrides_doctor_date
    ON doctor_availability_overrides(doctor_id, override_date);
```

### 5.5 Appointment Slots (Generated)

```sql
CREATE TABLE appointment_slots (
    slot_id         UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    doctor_id       UUID        NOT NULL REFERENCES doctors(doctor_id),
    tenant_id       UUID        NOT NULL REFERENCES tenants(tenant_id),
    slot_date       DATE        NOT NULL,
    start_time      TIME        NOT NULL,
    end_time        TIME        NOT NULL,
    slot_type       VARCHAR(30) NOT NULL DEFAULT 'REGULAR'
                    CHECK (slot_type IN ('REGULAR','EMERGENCY','TELEMEDICINE','FOLLOWUP')),
    max_capacity    SMALLINT    NOT NULL DEFAULT 1,
    booked_count    SMALLINT    NOT NULL DEFAULT 0,
    is_available    BOOLEAN     NOT NULL DEFAULT TRUE,
    UNIQUE(doctor_id, slot_date, start_time)
);

CREATE INDEX idx_slots_doctor_date ON appointment_slots(doctor_id, slot_date) WHERE is_available = TRUE;
CREATE INDEX idx_slots_date        ON appointment_slots(slot_date, tenant_id) WHERE is_available = TRUE;
```

### 5.6 Appointments

```sql
CREATE TABLE appointments (
    appointment_id    UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id         UUID        NOT NULL REFERENCES tenants(tenant_id),
    patient_id        UUID        NOT NULL REFERENCES patients(patient_id),
    doctor_id         UUID        NOT NULL REFERENCES doctors(doctor_id),
    department_id     UUID        NOT NULL REFERENCES departments(department_id),
    slot_id           UUID        REFERENCES appointment_slots(slot_id),
    appointment_date  DATE        NOT NULL,
    start_time        TIME        NOT NULL,
    end_time          TIME,
    appointment_type  VARCHAR(50) NOT NULL CHECK (appointment_type IN
                        ('NEW_CONSULTATION','FOLLOW_UP','EMERGENCY','TELEMEDICINE',
                         'PRE_SURGERY','POST_SURGERY','THERAPY','VACCINATION')),
    booking_channel   VARCHAR(50) NOT NULL DEFAULT 'RECEPTION'
                      CHECK (booking_channel IN
                        ('RECEPTION','PATIENT_PORTAL','PHONE','WALK_IN','REFERRAL','INSURANCE_PORTAL')),
    status            VARCHAR(30) NOT NULL DEFAULT 'CONFIRMED'
                      CHECK (status IN
                        ('REQUESTED','CONFIRMED','CHECKED_IN','IN_PROGRESS',
                         'COMPLETED','CANCELLED','NO_SHOW','RESCHEDULED')),
    chief_complaint   TEXT,
    priority          VARCHAR(20) NOT NULL DEFAULT 'NORMAL'
                      CHECK (priority IN ('EMERGENCY','URGENT','NORMAL','LOW')),
    -- Referral
    referred_by       UUID        REFERENCES doctors(doctor_id),
    referring_doctor_name VARCHAR(200),
    -- Financial
    consultation_fee  NUMERIC(10,2),
    is_paid           BOOLEAN     NOT NULL DEFAULT FALSE,
    invoice_id        UUID,                              -- FK added after billing table creation
    -- Notifications
    reminder_sent_at  TIMESTAMPTZ,
    check_in_at       TIMESTAMPTZ,
    completed_at      TIMESTAMPTZ,
    cancellation_reason TEXT,
    cancelled_by      UUID        REFERENCES users(user_id),
    rescheduled_from  UUID        REFERENCES appointments(appointment_id),
    notes             TEXT,
    created_at        TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by        UUID        NOT NULL REFERENCES users(user_id),
    updated_at        TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_by        UUID        NOT NULL REFERENCES users(user_id),
    is_deleted        BOOLEAN     NOT NULL DEFAULT FALSE
);

CREATE INDEX idx_appointments_patient     ON appointments(patient_id) WHERE is_deleted = FALSE;
CREATE INDEX idx_appointments_doctor_date ON appointments(doctor_id, appointment_date) WHERE is_deleted = FALSE;
CREATE INDEX idx_appointments_date_tenant ON appointments(appointment_date, tenant_id) WHERE is_deleted = FALSE;
CREATE INDEX idx_appointments_status      ON appointments(status, appointment_date) WHERE is_deleted = FALSE;
```

### 5.7 Appointment Waitlist

```sql
CREATE TABLE appointment_waitlists (
    waitlist_id     UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id       UUID        NOT NULL REFERENCES tenants(tenant_id),
    patient_id      UUID        NOT NULL REFERENCES patients(patient_id),
    doctor_id       UUID        NOT NULL REFERENCES doctors(doctor_id),
    preferred_dates DATE[],                             -- array of preferred dates
    preferred_times JSONB,                              -- [{ "from": "09:00", "to": "12:00" }]
    priority_score  SMALLINT    NOT NULL DEFAULT 5,
    status          VARCHAR(30) NOT NULL DEFAULT 'WAITING'
                    CHECK (status IN ('WAITING','OFFERED','BOOKED','EXPIRED','CANCELLED')),
    offered_slot_id UUID        REFERENCES appointment_slots(slot_id),
    offered_at      TIMESTAMPTZ,
    response_deadline TIMESTAMPTZ,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_waitlist_doctor ON appointment_waitlists(doctor_id) WHERE status = 'WAITING';
```

---

## 6. Module 3 — OPD (Outpatient Department)

### 6.1 OPD Encounters

```sql
CREATE TABLE opd_encounters (
    encounter_id      UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id         UUID        NOT NULL REFERENCES tenants(tenant_id),
    patient_id        UUID        NOT NULL REFERENCES patients(patient_id),
    appointment_id    UUID        REFERENCES appointments(appointment_id),
    doctor_id         UUID        NOT NULL REFERENCES doctors(doctor_id),
    department_id     UUID        NOT NULL REFERENCES departments(department_id),
    encounter_number  VARCHAR(30) NOT NULL,             -- auto-generated sequence
    encounter_date    DATE        NOT NULL,
    check_in_time     TIMESTAMPTZ,
    consultation_start TIMESTAMPTZ,
    consultation_end  TIMESTAMPTZ,
    encounter_type    VARCHAR(50) NOT NULL DEFAULT 'OPD'
                      CHECK (encounter_type IN ('OPD','EMERGENCY','TELEMEDICINE')),
    -- Triage
    triage_level      VARCHAR(20) CHECK (triage_level IN ('RED','ORANGE','YELLOW','GREEN','BLUE')),
    triage_notes      TEXT,
    triage_by         UUID        REFERENCES users(user_id),
    triage_at         TIMESTAMPTZ,
    -- Clinical Summary
    chief_complaint   TEXT        NOT NULL,
    status            VARCHAR(30) NOT NULL DEFAULT 'IN_PROGRESS'
                      CHECK (status IN ('WAITING','IN_PROGRESS','COMPLETED','REFERRED','ADMITTED')),
    -- Financial
    invoice_id        UUID,
    created_at        TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by        UUID        NOT NULL REFERENCES users(user_id),
    updated_at        TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_by        UUID        NOT NULL REFERENCES users(user_id),
    is_deleted        BOOLEAN     NOT NULL DEFAULT FALSE
);

CREATE UNIQUE INDEX uq_opd_encounter_number ON opd_encounters(tenant_id, encounter_number);
CREATE INDEX idx_opd_encounters_patient     ON opd_encounters(patient_id) WHERE is_deleted = FALSE;
CREATE INDEX idx_opd_encounters_doctor_date ON opd_encounters(doctor_id, encounter_date) WHERE is_deleted = FALSE;
CREATE INDEX idx_opd_encounters_date_tenant ON opd_encounters(encounter_date, tenant_id) WHERE is_deleted = FALSE;
```

### 6.2 Vital Signs

```sql
CREATE TABLE vital_signs (
    vital_id         UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    encounter_id     UUID        NOT NULL REFERENCES opd_encounters(encounter_id) ON DELETE CASCADE,
    patient_id       UUID        NOT NULL REFERENCES patients(patient_id),
    tenant_id        UUID        NOT NULL REFERENCES tenants(tenant_id),
    recorded_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    recorded_by      UUID        NOT NULL REFERENCES users(user_id),
    -- Vitals
    height_cm        NUMERIC(5,1),
    weight_kg        NUMERIC(6,2),
    bmi              NUMERIC(5,2) GENERATED ALWAYS AS
                       (CASE WHEN height_cm > 0 AND weight_kg > 0
                             THEN ROUND((weight_kg / ((height_cm/100)^2))::NUMERIC, 2)
                             ELSE NULL END) STORED,
    temperature_c    NUMERIC(4,1),
    bp_systolic      SMALLINT,
    bp_diastolic     SMALLINT,
    pulse_rate       SMALLINT,
    respiratory_rate SMALLINT,
    spo2_percent     NUMERIC(4,1),
    blood_glucose_mgdl NUMERIC(6,1),
    pain_score       SMALLINT    CHECK (pain_score BETWEEN 0 AND 10),
    notes            TEXT
);

CREATE INDEX idx_vital_signs_encounter ON vital_signs(encounter_id);
CREATE INDEX idx_vital_signs_patient   ON vital_signs(patient_id, recorded_at DESC);
```

### 6.3 Clinical Notes (SOAP)

```sql
CREATE TABLE clinical_notes (
    note_id          UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    encounter_id     UUID        NOT NULL REFERENCES opd_encounters(encounter_id) ON DELETE CASCADE,
    patient_id       UUID        NOT NULL REFERENCES patients(patient_id),
    tenant_id        UUID        NOT NULL REFERENCES tenants(tenant_id),
    note_type        VARCHAR(30) NOT NULL CHECK (note_type IN
                       ('SOAP','PROGRESS','DISCHARGE','PROCEDURE','CONSULTATION','NURSING')),
    -- SOAP Structure
    subjective       TEXT,           -- Patient's own description
    objective        TEXT,           -- Examination findings
    assessment       TEXT,           -- Diagnosis / impression
    plan             TEXT,           -- Treatment plan
    -- Additional
    free_text        TEXT,           -- Unstructured notes
    is_signed        BOOLEAN     NOT NULL DEFAULT FALSE,
    signed_by        UUID        REFERENCES users(user_id),
    signed_at        TIMESTAMPTZ,
    is_amended       BOOLEAN     NOT NULL DEFAULT FALSE,
    amended_note_id  UUID        REFERENCES clinical_notes(note_id),
    -- Full-text search
    note_tsv         TSVECTOR GENERATED ALWAYS AS
                       (to_tsvector('english',
                         COALESCE(subjective,'') || ' ' ||
                         COALESCE(objective,'') || ' ' ||
                         COALESCE(assessment,'') || ' ' ||
                         COALESCE(plan,'') || ' ' ||
                         COALESCE(free_text,''))) STORED,
    created_at       TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by       UUID        NOT NULL REFERENCES users(user_id),
    updated_at       TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    is_deleted       BOOLEAN     NOT NULL DEFAULT FALSE
);

CREATE INDEX idx_clinical_notes_encounter  ON clinical_notes(encounter_id) WHERE is_deleted = FALSE;
CREATE INDEX idx_clinical_notes_patient    ON clinical_notes(patient_id) WHERE is_deleted = FALSE;
CREATE INDEX idx_clinical_notes_fulltext   ON clinical_notes USING GIN(note_tsv);
```

### 6.4 Diagnoses (ICD-10)

```sql
CREATE TABLE icd10_codes (
    icd10_id       UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    code           VARCHAR(20) NOT NULL UNIQUE,
    description    VARCHAR(500) NOT NULL,
    category       VARCHAR(200),
    is_active      BOOLEAN     NOT NULL DEFAULT TRUE
);

CREATE TABLE encounter_diagnoses (
    diagnosis_id    UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    encounter_id    UUID        NOT NULL REFERENCES opd_encounters(encounter_id) ON DELETE CASCADE,
    patient_id      UUID        NOT NULL REFERENCES patients(patient_id),
    tenant_id       UUID        NOT NULL REFERENCES tenants(tenant_id),
    icd10_id        UUID        NOT NULL REFERENCES icd10_codes(icd10_id),
    diagnosis_type  VARCHAR(30) NOT NULL DEFAULT 'PRIMARY'
                    CHECK (diagnosis_type IN ('PRIMARY','SECONDARY','DIFFERENTIAL','PROVISIONAL','FINAL')),
    notes           TEXT,
    is_chronic      BOOLEAN     NOT NULL DEFAULT FALSE,
    diagnosed_at    TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    diagnosed_by    UUID        NOT NULL REFERENCES users(user_id)
);

CREATE INDEX idx_enc_diagnoses_encounter ON encounter_diagnoses(encounter_id);
CREATE INDEX idx_enc_diagnoses_patient   ON encounter_diagnoses(patient_id);
CREATE INDEX idx_enc_diagnoses_icd10     ON encounter_diagnoses(icd10_id);
```

---

## 7. Module 4 — IPD (Inpatient Department)

### 7.1 Wards & Beds

```sql
CREATE TABLE wards (
    ward_id         UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id       UUID        NOT NULL REFERENCES tenants(tenant_id),
    ward_code       VARCHAR(20) NOT NULL,
    ward_name       VARCHAR(200) NOT NULL,
    ward_type       VARCHAR(50) NOT NULL CHECK (ward_type IN
                      ('GENERAL','PRIVATE','SEMI_PRIVATE','ICU','NICU','PICU',
                       'MATERNITY','SURGICAL','PEDIATRIC','ONCOLOGY','PSYCHIATRIC')),
    floor_number    VARCHAR(10),
    total_beds      SMALLINT    NOT NULL DEFAULT 0,
    head_nurse_id   UUID        REFERENCES users(user_id),
    is_active       BOOLEAN     NOT NULL DEFAULT TRUE,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE UNIQUE INDEX uq_wards_code ON wards(tenant_id, ward_code);

CREATE TABLE beds (
    bed_id          UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    ward_id         UUID        NOT NULL REFERENCES wards(ward_id),
    tenant_id       UUID        NOT NULL REFERENCES tenants(tenant_id),
    bed_number      VARCHAR(20) NOT NULL,
    bed_type        VARCHAR(50) NOT NULL DEFAULT 'STANDARD'
                    CHECK (bed_type IN ('STANDARD','ICU','ISOLATION','BARIATRIC','PEDIATRIC')),
    status          VARCHAR(30) NOT NULL DEFAULT 'AVAILABLE'
                    CHECK (status IN ('AVAILABLE','OCCUPIED','RESERVED','MAINTENANCE','HOUSEKEEPING')),
    floor_number    VARCHAR(10),
    room_number     VARCHAR(20),
    features        JSONB,                               -- oxygen_outlet, call_button, monitor_port
    daily_rate      NUMERIC(10,2),
    is_active       BOOLEAN     NOT NULL DEFAULT TRUE,
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE UNIQUE INDEX uq_beds_number ON beds(ward_id, bed_number);
CREATE INDEX idx_beds_status ON beds(tenant_id, status) WHERE is_active = TRUE;
```

### 7.2 Admissions

```sql
CREATE TABLE admissions (
    admission_id       UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id          UUID        NOT NULL REFERENCES tenants(tenant_id),
    patient_id         UUID        NOT NULL REFERENCES patients(patient_id),
    admission_number   VARCHAR(30) NOT NULL,
    -- Admission Info
    admission_date     TIMESTAMPTZ NOT NULL,
    admission_type     VARCHAR(50) NOT NULL CHECK (admission_type IN
                         ('ELECTIVE','EMERGENCY','TRANSFER_IN','DAY_CARE','MATERNITY')),
    admission_source   VARCHAR(50) NOT NULL CHECK (admission_source IN
                         ('OPD','EMERGENCY','REFERRAL','DIRECT','TRANSFER')),
    referring_encounter_id UUID    REFERENCES opd_encounters(encounter_id),
    -- Assignment
    ward_id            UUID        NOT NULL REFERENCES wards(ward_id),
    bed_id             UUID        NOT NULL REFERENCES beds(bed_id),
    primary_doctor_id  UUID        NOT NULL REFERENCES doctors(doctor_id),
    department_id      UUID        NOT NULL REFERENCES departments(department_id),
    -- Clinical
    chief_complaint    TEXT        NOT NULL,
    provisional_diagnosis TEXT,
    -- Discharge
    discharge_date     TIMESTAMPTZ,
    discharge_type     VARCHAR(50) CHECK (discharge_type IN
                         ('NORMAL','AGAINST_ADVICE','TRANSFER_OUT','EXPIRED','ABSCONDED')),
    discharge_summary  TEXT,
    total_days         SMALLINT GENERATED ALWAYS AS
                         (CASE WHEN discharge_date IS NOT NULL
                               THEN EXTRACT(DAY FROM discharge_date - admission_date)::SMALLINT
                               ELSE NULL END) STORED,
    -- Financial
    estimated_cost     NUMERIC(15,2),
    final_invoice_id   UUID,
    -- Status
    status             VARCHAR(30) NOT NULL DEFAULT 'ADMITTED'
                       CHECK (status IN ('ADMITTED','UNDER_OBSERVATION','TRANSFERRED','DISCHARGED')),
    -- Audit
    created_at         TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by         UUID        NOT NULL REFERENCES users(user_id),
    updated_at         TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_by         UUID        NOT NULL REFERENCES users(user_id),
    is_deleted         BOOLEAN     NOT NULL DEFAULT FALSE
);

CREATE UNIQUE INDEX uq_admissions_number ON admissions(tenant_id, admission_number);
CREATE INDEX idx_admissions_patient      ON admissions(patient_id) WHERE is_deleted = FALSE;
CREATE INDEX idx_admissions_bed          ON admissions(bed_id) WHERE status = 'ADMITTED';
CREATE INDEX idx_admissions_doctor       ON admissions(primary_doctor_id) WHERE status = 'ADMITTED';
CREATE INDEX idx_admissions_date_tenant  ON admissions(admission_date, tenant_id) WHERE is_deleted = FALSE;
```

### 7.3 Bed Transfer History

```sql
CREATE TABLE bed_transfers (
    transfer_id        UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    admission_id       UUID        NOT NULL REFERENCES admissions(admission_id),
    tenant_id          UUID        NOT NULL REFERENCES tenants(tenant_id),
    from_bed_id        UUID        NOT NULL REFERENCES beds(bed_id),
    to_bed_id          UUID        NOT NULL REFERENCES beds(bed_id),
    transfer_reason    TEXT,
    transferred_at     TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    transferred_by     UUID        NOT NULL REFERENCES users(user_id)
);
```

### 7.4 Doctor Rounds & Progress Notes

```sql
CREATE TABLE doctor_rounds (
    round_id           UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    admission_id       UUID        NOT NULL REFERENCES admissions(admission_id),
    patient_id         UUID        NOT NULL REFERENCES patients(patient_id),
    tenant_id          UUID        NOT NULL REFERENCES tenants(tenant_id),
    doctor_id          UUID        NOT NULL REFERENCES doctors(doctor_id),
    round_date         DATE        NOT NULL,
    round_time         TIME        NOT NULL,
    round_type         VARCHAR(30) NOT NULL DEFAULT 'ROUTINE'
                       CHECK (round_type IN ('ROUTINE','EMERGENCY','SPECIALIST','DISCHARGE')),
    subjective         TEXT,
    objective          TEXT,
    assessment         TEXT,
    plan               TEXT,
    is_signed          BOOLEAN     NOT NULL DEFAULT FALSE,
    signed_at          TIMESTAMPTZ,
    created_at         TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by         UUID        NOT NULL REFERENCES users(user_id)
);

CREATE INDEX idx_doctor_rounds_admission ON doctor_rounds(admission_id);
CREATE INDEX idx_doctor_rounds_date      ON doctor_rounds(patient_id, round_date DESC);
```

### 7.5 Nursing Care Records

```sql
CREATE TABLE nursing_care_records (
    care_record_id   UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    admission_id     UUID        NOT NULL REFERENCES admissions(admission_id),
    tenant_id        UUID        NOT NULL REFERENCES tenants(tenant_id),
    nurse_id         UUID        NOT NULL REFERENCES users(user_id),
    record_type      VARCHAR(50) NOT NULL CHECK (record_type IN
                       ('INTAKE_OUTPUT','MEDICATION_ADMINISTRATION','WOUND_CARE',
                        'IV_CARE','VITAL_SIGNS','ASSESSMENT','INCIDENT_REPORT')),
    recorded_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    details          JSONB       NOT NULL,              -- flexible structure per record_type
    notes            TEXT
);

CREATE INDEX idx_nursing_records_admission ON nursing_care_records(admission_id, recorded_at DESC);
```

### 7.6 Operation Theatre

```sql
CREATE TABLE operation_theatres (
    ot_id           UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id       UUID        NOT NULL REFERENCES tenants(tenant_id),
    ot_name         VARCHAR(100) NOT NULL,
    ot_type         VARCHAR(50) CHECK (ot_type IN ('MAJOR','MINOR','CATH_LAB','LASER','ENDOSCOPY')),
    is_available    BOOLEAN     NOT NULL DEFAULT TRUE,
    features        JSONB,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE surgery_schedules (
    surgery_id         UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id          UUID        NOT NULL REFERENCES tenants(tenant_id),
    admission_id       UUID        NOT NULL REFERENCES admissions(admission_id),
    patient_id         UUID        NOT NULL REFERENCES patients(patient_id),
    ot_id              UUID        NOT NULL REFERENCES operation_theatres(ot_id),
    primary_surgeon_id UUID        NOT NULL REFERENCES doctors(doctor_id),
    anesthetist_id     UUID        REFERENCES doctors(doctor_id),
    surgery_name       VARCHAR(500) NOT NULL,
    procedure_code     VARCHAR(50),                     -- CPT code
    scheduled_date     DATE        NOT NULL,
    scheduled_start    TIME        NOT NULL,
    scheduled_end      TIME,
    actual_start       TIMESTAMPTZ,
    actual_end         TIMESTAMPTZ,
    anesthesia_type    VARCHAR(50) CHECK (anesthesia_type IN
                         ('GENERAL','LOCAL','REGIONAL','SPINAL','EPIDURAL','SEDATION')),
    status             VARCHAR(30) NOT NULL DEFAULT 'SCHEDULED'
                       CHECK (status IN ('SCHEDULED','IN_PROGRESS','COMPLETED','CANCELLED','POSTPONED')),
    pre_op_notes       TEXT,
    operative_notes    TEXT,
    post_op_notes      TEXT,
    complications      JSONB,
    implants_used      JSONB,
    created_at         TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by         UUID        NOT NULL REFERENCES users(user_id),
    updated_at         TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_surgery_schedules_admission ON surgery_schedules(admission_id);
CREATE INDEX idx_surgery_schedules_ot_date   ON surgery_schedules(ot_id, scheduled_date);
CREATE INDEX idx_surgery_schedules_surgeon   ON surgery_schedules(primary_surgeon_id, scheduled_date);
```

---

## 8. Module 5 — Electronic Medical Records (EMR)

### 8.1 Problem List

```sql
CREATE TABLE patient_problems (
    problem_id       UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    patient_id       UUID        NOT NULL REFERENCES patients(patient_id) ON DELETE CASCADE,
    tenant_id        UUID        NOT NULL REFERENCES tenants(tenant_id),
    icd10_id         UUID        NOT NULL REFERENCES icd10_codes(icd10_id),
    problem_name     VARCHAR(500) NOT NULL,
    onset_date       DATE,
    resolved_date    DATE,
    status           VARCHAR(20) NOT NULL DEFAULT 'ACTIVE'
                     CHECK (status IN ('ACTIVE','RESOLVED','INACTIVE','RECURRENT')),
    severity         VARCHAR(20) CHECK (severity IN ('MILD','MODERATE','SEVERE')),
    notes            TEXT,
    recorded_by      UUID        NOT NULL REFERENCES users(user_id),
    created_at       TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at       TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_patient_problems_patient ON patient_problems(patient_id) WHERE status = 'ACTIVE';
```

### 8.2 Medication History

```sql
CREATE TABLE medications_master (
    medication_id    UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    generic_name     VARCHAR(500) NOT NULL,
    brand_name       VARCHAR(500),
    drug_class       VARCHAR(200),
    dosage_form      VARCHAR(100),                       -- TABLET, CAPSULE, INJECTION, SYRUP
    strength         VARCHAR(100),
    rxnorm_code      VARCHAR(50),
    controlled_drug  BOOLEAN     NOT NULL DEFAULT FALSE,
    is_active        BOOLEAN     NOT NULL DEFAULT TRUE,
    created_at       TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE prescriptions (
    prescription_id    UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id          UUID        NOT NULL REFERENCES tenants(tenant_id),
    patient_id         UUID        NOT NULL REFERENCES patients(patient_id),
    encounter_id       UUID        REFERENCES opd_encounters(encounter_id),
    admission_id       UUID        REFERENCES admissions(admission_id),
    prescribed_by      UUID        NOT NULL REFERENCES doctors(doctor_id),
    prescription_date  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    prescription_number VARCHAR(30) NOT NULL,
    status             VARCHAR(30) NOT NULL DEFAULT 'ACTIVE'
                       CHECK (status IN ('ACTIVE','DISPENSED','PARTIALLY_DISPENSED',
                                         'CANCELLED','EXPIRED')),
    notes              TEXT,
    created_at         TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by         UUID        NOT NULL REFERENCES users(user_id),
    is_deleted         BOOLEAN     NOT NULL DEFAULT FALSE
);

CREATE TABLE prescription_items (
    item_id           UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    prescription_id   UUID        NOT NULL REFERENCES prescriptions(prescription_id) ON DELETE CASCADE,
    medication_id     UUID        NOT NULL REFERENCES medications_master(medication_id),
    tenant_id         UUID        NOT NULL REFERENCES tenants(tenant_id),
    drug_name         VARCHAR(500) NOT NULL,             -- denormalized for records
    dose              VARCHAR(100) NOT NULL,
    route             VARCHAR(50)  NOT NULL,              -- ORAL, IV, IM, SC, TOPICAL
    frequency         VARCHAR(100) NOT NULL,              -- ONCE_DAILY, BD, TDS, QID, SOS
    duration_days     SMALLINT,
    quantity          NUMERIC(10,2),
    unit              VARCHAR(30),
    instructions      TEXT,
    is_substitutable  BOOLEAN     NOT NULL DEFAULT TRUE,
    start_date        DATE,
    end_date          DATE,
    is_dispensed      BOOLEAN     NOT NULL DEFAULT FALSE,
    dispensed_at      TIMESTAMPTZ
);

CREATE UNIQUE INDEX uq_prescriptions_number ON prescriptions(tenant_id, prescription_number);
CREATE INDEX idx_prescriptions_patient      ON prescriptions(patient_id) WHERE is_deleted = FALSE;
CREATE INDEX idx_prescriptions_encounter    ON prescriptions(encounter_id);
CREATE INDEX idx_prescription_items_med     ON prescription_items(medication_id);
```

### 8.3 Vaccination Records

```sql
CREATE TABLE vaccination_records (
    vaccination_id    UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    patient_id        UUID        NOT NULL REFERENCES patients(patient_id),
    tenant_id         UUID        NOT NULL REFERENCES tenants(tenant_id),
    vaccine_name      VARCHAR(200) NOT NULL,
    vaccine_code      VARCHAR(50),
    dose_number       SMALLINT    NOT NULL DEFAULT 1,
    administered_date DATE        NOT NULL,
    administered_by   UUID        NOT NULL REFERENCES users(user_id),
    batch_number      VARCHAR(100),
    manufacturer      VARCHAR(200),
    expiry_date       DATE,
    site              VARCHAR(50),                        -- LEFT_ARM, RIGHT_ARM, etc.
    route             VARCHAR(50),
    next_due_date     DATE,
    notes             TEXT,
    created_at        TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_vaccinations_patient ON vaccination_records(patient_id);
CREATE INDEX idx_vaccinations_due     ON vaccination_records(next_due_date) WHERE next_due_date IS NOT NULL;
```

### 8.4 Patient Chronic Conditions (Problem-Medication Link)

```sql
CREATE TABLE chronic_condition_medications (
    link_id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    problem_id      UUID NOT NULL REFERENCES patient_problems(problem_id) ON DELETE CASCADE,
    prescription_item_id UUID NOT NULL REFERENCES prescription_items(item_id) ON DELETE CASCADE,
    is_active       BOOLEAN NOT NULL DEFAULT TRUE
);
```

---

## 9. Module 6 — Laboratory Information System (LIS)

### 9.1 Lab Test Master

```sql
CREATE TABLE lab_test_master (
    lab_test_id      UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id        UUID        NOT NULL REFERENCES tenants(tenant_id),
    test_code        VARCHAR(50) NOT NULL,
    test_name        VARCHAR(500) NOT NULL,
    loinc_code       VARCHAR(50),
    test_category    VARCHAR(100) NOT NULL,               -- HEMATOLOGY, BIOCHEMISTRY, MICROBIOLOGY
    test_section     VARCHAR(100),
    sample_type      VARCHAR(50)  NOT NULL,               -- BLOOD, URINE, STOOL, SWAB, TISSUE
    container_type   VARCHAR(100),                        -- RED_TOP, EDTA, URINE_CUP
    sample_volume_ml NUMERIC(5,2),
    tat_hours        SMALLINT     NOT NULL DEFAULT 24,    -- Turnaround time
    base_price       NUMERIC(10,2) NOT NULL,
    instructions     TEXT,
    is_available     BOOLEAN     NOT NULL DEFAULT TRUE,
    is_send_out      BOOLEAN     NOT NULL DEFAULT FALSE,  -- Reference lab
    created_at       TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at       TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE UNIQUE INDEX uq_lab_test_code ON lab_test_master(tenant_id, test_code);
CREATE INDEX idx_lab_test_category   ON lab_test_master(test_category) WHERE is_available = TRUE;
```

### 9.2 Lab Test Profiles (Panels)

```sql
CREATE TABLE lab_test_profiles (
    profile_id      UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id       UUID        NOT NULL REFERENCES tenants(tenant_id),
    profile_code    VARCHAR(50) NOT NULL,
    profile_name    VARCHAR(200) NOT NULL,
    description     TEXT,
    profile_price   NUMERIC(10,2),
    is_active       BOOLEAN     NOT NULL DEFAULT TRUE,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE lab_profile_tests (
    profile_test_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    profile_id      UUID NOT NULL REFERENCES lab_test_profiles(profile_id) ON DELETE CASCADE,
    lab_test_id     UUID NOT NULL REFERENCES lab_test_master(lab_test_id),
    UNIQUE(profile_id, lab_test_id)
);
```

### 9.3 Lab Reference Ranges

```sql
CREATE TABLE lab_reference_ranges (
    range_id         UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    lab_test_id      UUID        NOT NULL REFERENCES lab_test_master(lab_test_id) ON DELETE CASCADE,
    gender           VARCHAR(10) CHECK (gender IN ('MALE','FEMALE','ANY')),
    age_from_years   SMALLINT,
    age_to_years     SMALLINT,
    normal_min       NUMERIC(12,4),
    normal_max       NUMERIC(12,4),
    critical_low     NUMERIC(12,4),
    critical_high    NUMERIC(12,4),
    unit             VARCHAR(50) NOT NULL,
    interpretation   TEXT,
    effective_from   DATE        NOT NULL,
    effective_to     DATE
);

CREATE INDEX idx_lab_ranges_test ON lab_reference_ranges(lab_test_id);
```

### 9.4 Lab Orders

```sql
CREATE TABLE lab_orders (
    lab_order_id      UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id         UUID        NOT NULL REFERENCES tenants(tenant_id),
    patient_id        UUID        NOT NULL REFERENCES patients(patient_id),
    encounter_id      UUID        REFERENCES opd_encounters(encounter_id),
    admission_id      UUID        REFERENCES admissions(admission_id),
    ordered_by        UUID        NOT NULL REFERENCES doctors(doctor_id),
    order_number      VARCHAR(30) NOT NULL,
    ordered_at        TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    priority          VARCHAR(20) NOT NULL DEFAULT 'ROUTINE'
                      CHECK (priority IN ('ROUTINE','URGENT','STAT')),
    clinical_info     TEXT,
    status            VARCHAR(30) NOT NULL DEFAULT 'ORDERED'
                      CHECK (status IN
                        ('ORDERED','SAMPLE_COLLECTED','IN_PROCESS',
                         'RESULTED','VERIFIED','CANCELLED','SENT_OUT')),
    created_at        TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by        UUID        NOT NULL REFERENCES users(user_id),
    is_deleted        BOOLEAN     NOT NULL DEFAULT FALSE
);

CREATE TABLE lab_order_items (
    order_item_id   UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    lab_order_id    UUID        NOT NULL REFERENCES lab_orders(lab_order_id) ON DELETE CASCADE,
    lab_test_id     UUID        NOT NULL REFERENCES lab_test_master(lab_test_id),
    profile_id      UUID        REFERENCES lab_test_profiles(profile_id),
    tenant_id       UUID        NOT NULL REFERENCES tenants(tenant_id),
    status          VARCHAR(30) NOT NULL DEFAULT 'ORDERED'
                    CHECK (status IN ('ORDERED','SAMPLE_COLLECTED','IN_PROCESS',
                                      'RESULTED','VERIFIED','CANCELLED')),
    cancelled_reason TEXT,
    price           NUMERIC(10,2)
);

CREATE UNIQUE INDEX uq_lab_order_number ON lab_orders(tenant_id, order_number);
CREATE INDEX idx_lab_orders_patient     ON lab_orders(patient_id) WHERE is_deleted = FALSE;
CREATE INDEX idx_lab_orders_status      ON lab_orders(status, tenant_id) WHERE is_deleted = FALSE;
CREATE INDEX idx_lab_order_items_order  ON lab_order_items(lab_order_id);
```

### 9.5 Lab Samples

```sql
CREATE TABLE lab_samples (
    sample_id        UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id        UUID        NOT NULL REFERENCES tenants(tenant_id),
    lab_order_id     UUID        NOT NULL REFERENCES lab_orders(lab_order_id),
    barcode          VARCHAR(100) NOT NULL UNIQUE,
    sample_type      VARCHAR(50) NOT NULL,
    container_type   VARCHAR(100),
    collected_at     TIMESTAMPTZ,
    collected_by     UUID        REFERENCES users(user_id),
    received_at      TIMESTAMPTZ,
    received_by      UUID        REFERENCES users(user_id),
    volume_ml        NUMERIC(6,2),
    quality          VARCHAR(30) CHECK (quality IN ('ACCEPTABLE','HEMOLYZED','CLOTTED',
                                                     'INSUFFICIENT','CONTAMINATED')),
    rejection_reason TEXT,
    status           VARCHAR(30) NOT NULL DEFAULT 'COLLECTED'
                     CHECK (status IN ('COLLECTED','IN_TRANSIT','RECEIVED',
                                       'PROCESSING','STORED','DISPOSED','REJECTED')),
    storage_location VARCHAR(100),
    disposed_at      TIMESTAMPTZ,
    created_at       TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_lab_samples_order   ON lab_samples(lab_order_id);
CREATE INDEX idx_lab_samples_barcode ON lab_samples(barcode);
CREATE INDEX idx_lab_samples_status  ON lab_samples(status);
```

### 9.6 Lab Results

```sql
CREATE TABLE lab_results (
    result_id        UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id        UUID        NOT NULL REFERENCES tenants(tenant_id),
    order_item_id    UUID        NOT NULL REFERENCES lab_order_items(order_item_id),
    sample_id        UUID        REFERENCES lab_samples(sample_id),
    lab_test_id      UUID        NOT NULL REFERENCES lab_test_master(lab_test_id),
    patient_id       UUID        NOT NULL REFERENCES patients(patient_id),
    -- Result Values
    result_value     VARCHAR(500),                       -- numeric or text result
    result_numeric   NUMERIC(15,4),
    result_unit      VARCHAR(50),
    result_type      VARCHAR(30) NOT NULL DEFAULT 'NUMERIC'
                     CHECK (result_type IN ('NUMERIC','TEXT','NARRATIVE','CULTURE','IMAGE_REF')),
    -- Interpretation
    abnormal_flag    VARCHAR(20) CHECK (abnormal_flag IN
                       ('NORMAL','LOW','HIGH','CRITICAL_LOW','CRITICAL_HIGH',
                        'POSITIVE','NEGATIVE','REACTIVE','NON_REACTIVE')),
    interpretation   TEXT,
    -- Lifecycle
    resulted_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    resulted_by      UUID        NOT NULL REFERENCES users(user_id),
    verified_at      TIMESTAMPTZ,
    verified_by      UUID        REFERENCES users(user_id),
    status           VARCHAR(20) NOT NULL DEFAULT 'PRELIMINARY'
                     CHECK (status IN ('PRELIMINARY','FINAL','CORRECTED','CANCELLED')),
    previous_result_id UUID      REFERENCES lab_results(result_id),  -- for delta check
    delta_flag       BOOLEAN     NOT NULL DEFAULT FALSE,
    critical_notified_at TIMESTAMPTZ,
    critical_notified_to UUID    REFERENCES users(user_id),
    machine_id       VARCHAR(100),
    created_at       TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_lab_results_order_item ON lab_results(order_item_id);
CREATE INDEX idx_lab_results_patient    ON lab_results(patient_id, resulted_at DESC);
CREATE INDEX idx_lab_results_critical   ON lab_results(tenant_id, resulted_at)
    WHERE abnormal_flag IN ('CRITICAL_LOW','CRITICAL_HIGH');
```

---

## 10. Module 7 — Radiology Information System (RIS)

### 10.1 Imaging Modalities Master

```sql
CREATE TABLE imaging_modalities (
    modality_id    UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id      UUID        NOT NULL REFERENCES tenants(tenant_id),
    modality_code  VARCHAR(20) NOT NULL,               -- XRAY, CT, MRI, USG, PET, NM
    modality_name  VARCHAR(200) NOT NULL,
    equipment_name VARCHAR(200),
    location       VARCHAR(200),
    is_active      BOOLEAN     NOT NULL DEFAULT TRUE,
    created_at     TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
```

### 10.2 Radiology Orders

```sql
CREATE TABLE radiology_orders (
    rad_order_id     UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id        UUID        NOT NULL REFERENCES tenants(tenant_id),
    patient_id       UUID        NOT NULL REFERENCES patients(patient_id),
    encounter_id     UUID        REFERENCES opd_encounters(encounter_id),
    admission_id     UUID        REFERENCES admissions(admission_id),
    ordered_by       UUID        NOT NULL REFERENCES doctors(doctor_id),
    order_number     VARCHAR(30) NOT NULL,
    modality_id      UUID        NOT NULL REFERENCES imaging_modalities(modality_id),
    study_name       VARCHAR(500) NOT NULL,
    body_part        VARCHAR(100),
    laterality       VARCHAR(20) CHECK (laterality IN ('LEFT','RIGHT','BILATERAL','NA')),
    indication       TEXT,
    contrast_required BOOLEAN    NOT NULL DEFAULT FALSE,
    priority         VARCHAR(20) NOT NULL DEFAULT 'ROUTINE'
                     CHECK (priority IN ('ROUTINE','URGENT','STAT')),
    scheduled_at     TIMESTAMPTZ,
    status           VARCHAR(30) NOT NULL DEFAULT 'ORDERED'
                     CHECK (status IN
                       ('ORDERED','SCHEDULED','PATIENT_ARRIVED','IN_PROGRESS',
                        'IMAGES_ACQUIRED','REPORTED','VERIFIED','CANCELLED')),
    preparation_instructions TEXT,
    contraindications JSONB,                            -- pregnancy, metal implants, etc.
    price            NUMERIC(10,2),
    created_at       TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by       UUID        NOT NULL REFERENCES users(user_id),
    is_deleted       BOOLEAN     NOT NULL DEFAULT FALSE
);

CREATE UNIQUE INDEX uq_rad_order_number ON radiology_orders(tenant_id, order_number);
CREATE INDEX idx_rad_orders_patient     ON radiology_orders(patient_id) WHERE is_deleted = FALSE;
CREATE INDEX idx_rad_orders_scheduled   ON radiology_orders(scheduled_at, tenant_id) WHERE is_deleted = FALSE;
CREATE INDEX idx_rad_orders_status      ON radiology_orders(status, tenant_id) WHERE is_deleted = FALSE;
```

### 10.3 Radiology Studies (PACS Link)

```sql
CREATE TABLE radiology_studies (
    study_id         UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    rad_order_id     UUID        NOT NULL UNIQUE REFERENCES radiology_orders(rad_order_id),
    tenant_id        UUID        NOT NULL REFERENCES tenants(tenant_id),
    patient_id       UUID        NOT NULL REFERENCES patients(patient_id),
    accession_number VARCHAR(50) NOT NULL,              -- PACS reference
    study_uid        VARCHAR(200),                       -- DICOM Study UID
    performed_at     TIMESTAMPTZ NOT NULL,
    performed_by     UUID        NOT NULL REFERENCES users(user_id),
    image_count      SMALLINT    NOT NULL DEFAULT 0,
    pacs_url         TEXT,                               -- link to PACS viewer
    storage_size_mb  NUMERIC(10,2),
    status           VARCHAR(20) NOT NULL DEFAULT 'ACQUIRED'
                     CHECK (status IN ('ACQUIRED','PROCESSED','ARCHIVED','PURGED')),
    created_at       TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE UNIQUE INDEX uq_rad_study_accession ON radiology_studies(tenant_id, accession_number);
CREATE INDEX idx_rad_studies_patient       ON radiology_studies(patient_id);
```

### 10.4 Radiology Reports

```sql
CREATE TABLE radiology_reports (
    report_id        UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    study_id         UUID        NOT NULL REFERENCES radiology_studies(study_id),
    rad_order_id     UUID        NOT NULL REFERENCES radiology_orders(rad_order_id),
    tenant_id        UUID        NOT NULL REFERENCES tenants(tenant_id),
    patient_id       UUID        NOT NULL REFERENCES patients(patient_id),
    radiologist_id   UUID        NOT NULL REFERENCES doctors(doctor_id),
    indication       TEXT,
    technique        TEXT,
    comparison       TEXT,                              -- previous study comparison
    findings         TEXT        NOT NULL,
    impression       TEXT        NOT NULL,              -- conclusion / diagnosis
    recommendations  TEXT,
    structured_data  JSONB,                             -- coded findings (RADS score etc.)
    report_type      VARCHAR(20) NOT NULL DEFAULT 'FINAL'
                     CHECK (report_type IN ('PRELIMINARY','FINAL','ADDENDUM','AMENDED')),
    reported_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    verified_at      TIMESTAMPTZ,
    verified_by      UUID        REFERENCES doctors(doctor_id),
    report_tsv       TSVECTOR GENERATED ALWAYS AS
                       (to_tsvector('english',
                         COALESCE(findings,'') || ' ' || COALESCE(impression,''))) STORED,
    created_at       TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_rad_reports_study   ON radiology_reports(study_id);
CREATE INDEX idx_rad_reports_patient ON radiology_reports(patient_id, reported_at DESC);
CREATE INDEX idx_rad_reports_fulltext ON radiology_reports USING GIN(report_tsv);
```

---

## 11. Module 8 — Pharmacy Management

### 11.1 Drug Catalog

```sql
CREATE TABLE drug_catalog (
    drug_id          UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id        UUID        NOT NULL REFERENCES tenants(tenant_id),
    drug_code        VARCHAR(50) NOT NULL,
    generic_name     VARCHAR(500) NOT NULL,
    brand_name       VARCHAR(500),
    drug_class       VARCHAR(200),
    drug_category    VARCHAR(100) CHECK (drug_category IN
                       ('TABLET','CAPSULE','INJECTION','SYRUP','OINTMENT',
                        'DROPS','INHALER','SUPPOSITORY','PATCH','POWDER')),
    strength         VARCHAR(100),
    unit_of_measure  VARCHAR(30) NOT NULL,               -- TAB, ML, VIAL, TUBE
    rxnorm_code      VARCHAR(50),
    hsn_code         VARCHAR(20),                         -- tax classification
    is_controlled    BOOLEAN     NOT NULL DEFAULT FALSE,
    is_narcotic      BOOLEAN     NOT NULL DEFAULT FALSE,
    is_high_alert    BOOLEAN     NOT NULL DEFAULT FALSE,
    storage_conditions VARCHAR(100),                     -- ROOM_TEMP, REFRIGERATED, FROZEN
    reorder_level    NUMERIC(10,2) NOT NULL DEFAULT 0,
    reorder_quantity NUMERIC(10,2),
    is_active        BOOLEAN     NOT NULL DEFAULT TRUE,
    created_at       TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at       TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE UNIQUE INDEX uq_drug_catalog_code ON drug_catalog(tenant_id, drug_code);
CREATE INDEX idx_drug_catalog_name       ON drug_catalog(tenant_id, generic_name);
CREATE INDEX idx_drug_catalog_active     ON drug_catalog(tenant_id) WHERE is_active = TRUE;
```

### 11.2 Drug Price List

```sql
CREATE TABLE drug_price_list (
    price_id         UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    drug_id          UUID        NOT NULL REFERENCES drug_catalog(drug_id) ON DELETE CASCADE,
    tenant_id        UUID        NOT NULL REFERENCES tenants(tenant_id),
    patient_category VARCHAR(50) NOT NULL DEFAULT 'GENERAL',   -- GENERAL, CORPORATE, GOVT, VIP
    selling_price    NUMERIC(10,4) NOT NULL,
    effective_from   DATE        NOT NULL,
    effective_to     DATE,
    tax_percent      NUMERIC(5,2) NOT NULL DEFAULT 0,
    created_at       TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by       UUID        NOT NULL REFERENCES users(user_id)
);

CREATE INDEX idx_drug_price_drug ON drug_price_list(drug_id, patient_category);
```

### 11.3 Pharmacy Inventory (Stock)

```sql
CREATE TABLE pharmacy_inventory (
    inventory_id     UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id        UUID        NOT NULL REFERENCES tenants(tenant_id),
    drug_id          UUID        NOT NULL REFERENCES drug_catalog(drug_id),
    batch_number     VARCHAR(100) NOT NULL,
    manufacturer     VARCHAR(200),
    manufacturing_date DATE,
    expiry_date      DATE        NOT NULL,
    purchase_price   NUMERIC(10,4) NOT NULL,
    selling_price    NUMERIC(10,4) NOT NULL,
    quantity_in      NUMERIC(12,4) NOT NULL,              -- received quantity
    quantity_out     NUMERIC(12,4) NOT NULL DEFAULT 0,    -- dispensed / consumed
    quantity_adj     NUMERIC(12,4) NOT NULL DEFAULT 0,    -- adjustments
    quantity_current NUMERIC(12,4) GENERATED ALWAYS AS
                       (quantity_in - quantity_out + quantity_adj) STORED,
    rack_location    VARCHAR(50),
    is_quarantined   BOOLEAN     NOT NULL DEFAULT FALSE,
    grn_id           UUID,                                -- reference to goods receipt
    created_at       TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at       TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_pharmacy_inv_drug    ON pharmacy_inventory(tenant_id, drug_id) WHERE quantity_current > 0;
CREATE INDEX idx_pharmacy_inv_expiry  ON pharmacy_inventory(expiry_date) WHERE quantity_current > 0;
CREATE INDEX idx_pharmacy_inv_batch   ON pharmacy_inventory(batch_number);
-- FEFO: First Expiry First Out query support
CREATE INDEX idx_pharmacy_inv_fefo    ON pharmacy_inventory(drug_id, expiry_date ASC)
    WHERE quantity_current > 0 AND is_quarantined = FALSE;
```

### 11.4 Dispensing

```sql
CREATE TABLE dispensing_records (
    dispensing_id     UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id         UUID        NOT NULL REFERENCES tenants(tenant_id),
    prescription_id   UUID        NOT NULL REFERENCES prescriptions(prescription_id),
    prescription_item_id UUID     NOT NULL REFERENCES prescription_items(item_id),
    patient_id        UUID        NOT NULL REFERENCES patients(patient_id),
    dispensed_by      UUID        NOT NULL REFERENCES users(user_id),
    dispensed_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    drug_id           UUID        NOT NULL REFERENCES drug_catalog(drug_id),
    inventory_id      UUID        NOT NULL REFERENCES pharmacy_inventory(inventory_id),
    batch_number      VARCHAR(100),
    quantity_dispensed NUMERIC(10,4) NOT NULL,
    unit_price        NUMERIC(10,4) NOT NULL,
    total_price       NUMERIC(12,4) NOT NULL,
    is_substituted    BOOLEAN     NOT NULL DEFAULT FALSE,
    substitution_reason TEXT,
    patient_counselled BOOLEAN    NOT NULL DEFAULT FALSE,
    return_quantity   NUMERIC(10,4) NOT NULL DEFAULT 0,
    invoice_id        UUID,
    created_at        TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_dispensing_prescription  ON dispensing_records(prescription_id);
CREATE INDEX idx_dispensing_patient_date  ON dispensing_records(patient_id, dispensed_at DESC);
CREATE INDEX idx_dispensing_drug          ON dispensing_records(drug_id, dispensed_at DESC);
```

### 11.5 Drug Interaction & Allergy Check

```sql
CREATE TABLE drug_interactions (
    interaction_id   UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    drug_a_id        UUID        NOT NULL REFERENCES drug_catalog(drug_id),
    drug_b_id        UUID        NOT NULL REFERENCES drug_catalog(drug_id),
    severity         VARCHAR(20) NOT NULL CHECK (severity IN ('MINOR','MODERATE','MAJOR','CONTRAINDICATED')),
    description      TEXT        NOT NULL,
    action_required  TEXT,
    source_reference VARCHAR(255),
    is_active        BOOLEAN     NOT NULL DEFAULT TRUE,
    UNIQUE(drug_a_id, drug_b_id),
    CHECK(drug_a_id <> drug_b_id)
);

CREATE INDEX idx_drug_interactions_a ON drug_interactions(drug_a_id);
CREATE INDEX idx_drug_interactions_b ON drug_interactions(drug_b_id);
```

---

## 12. Module 9 — Billing & Revenue Cycle

### 12.1 Service Charge Master

```sql
CREATE TABLE service_charge_master (
    service_id       UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id        UUID        NOT NULL REFERENCES tenants(tenant_id),
    service_code     VARCHAR(50) NOT NULL,
    service_name     VARCHAR(500) NOT NULL,
    service_category VARCHAR(100) NOT NULL CHECK (service_category IN
                       ('CONSULTATION','PROCEDURE','LAB','RADIOLOGY',
                        'ROOM_CHARGE','NURSING','PHARMACY','SURGERY',
                        'CONSUMABLE','PACKAGE','MISC')),
    cpt_code         VARCHAR(20),
    department_id    UUID        REFERENCES departments(department_id),
    is_active        BOOLEAN     NOT NULL DEFAULT TRUE,
    created_at       TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE UNIQUE INDEX uq_service_code ON service_charge_master(tenant_id, service_code);

CREATE TABLE service_price_list (
    price_id         UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    service_id       UUID        NOT NULL REFERENCES service_charge_master(service_id),
    tenant_id        UUID        NOT NULL REFERENCES tenants(tenant_id),
    patient_category VARCHAR(50) NOT NULL DEFAULT 'GENERAL',
    base_price       NUMERIC(12,4) NOT NULL,
    tax_percent      NUMERIC(5,2) NOT NULL DEFAULT 0,
    effective_from   DATE        NOT NULL,
    effective_to     DATE,
    created_by       UUID        NOT NULL REFERENCES users(user_id),
    created_at       TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_service_price_service ON service_price_list(service_id, patient_category);
```

### 12.2 Billing Packages

```sql
CREATE TABLE billing_packages (
    package_id       UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id        UUID        NOT NULL REFERENCES tenants(tenant_id),
    package_code     VARCHAR(50) NOT NULL,
    package_name     VARCHAR(500) NOT NULL,
    description      TEXT,
    package_price    NUMERIC(12,2) NOT NULL,
    patient_category VARCHAR(50) NOT NULL DEFAULT 'GENERAL',
    effective_from   DATE        NOT NULL,
    effective_to     DATE,
    is_active        BOOLEAN     NOT NULL DEFAULT TRUE,
    created_at       TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE billing_package_items (
    pkg_item_id      UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    package_id       UUID        NOT NULL REFERENCES billing_packages(package_id) ON DELETE CASCADE,
    service_id       UUID        NOT NULL REFERENCES service_charge_master(service_id),
    quantity         NUMERIC(10,2) NOT NULL DEFAULT 1,
    is_included      BOOLEAN     NOT NULL DEFAULT TRUE,  -- FALSE = excluded/extra
    UNIQUE(package_id, service_id)
);
```

### 12.3 Invoices

```sql
CREATE TABLE invoices (
    invoice_id       UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id        UUID        NOT NULL REFERENCES tenants(tenant_id),
    patient_id       UUID        NOT NULL REFERENCES patients(patient_id),
    invoice_number   VARCHAR(30) NOT NULL,
    invoice_type     VARCHAR(30) NOT NULL CHECK (invoice_type IN
                       ('OPD','IPD','LAB','RADIOLOGY','PHARMACY','PACKAGE','ADVANCE','MISC')),
    encounter_id     UUID        REFERENCES opd_encounters(encounter_id),
    admission_id     UUID        REFERENCES admissions(admission_id),
    invoice_date     DATE        NOT NULL,
    -- Amounts
    gross_amount     NUMERIC(15,4) NOT NULL DEFAULT 0,
    discount_amount  NUMERIC(15,4) NOT NULL DEFAULT 0,
    discount_percent NUMERIC(5,2)  NOT NULL DEFAULT 0,
    tax_amount       NUMERIC(15,4) NOT NULL DEFAULT 0,
    net_amount       NUMERIC(15,4) NOT NULL DEFAULT 0,
    advance_adjusted NUMERIC(15,4) NOT NULL DEFAULT 0,
    paid_amount      NUMERIC(15,4) NOT NULL DEFAULT 0,
    due_amount       NUMERIC(15,4) GENERATED ALWAYS AS
                       (net_amount - paid_amount - advance_adjusted) STORED,
    -- Status
    status           VARCHAR(30) NOT NULL DEFAULT 'DRAFT'
                     CHECK (status IN
                       ('DRAFT','FINALIZED','PARTIALLY_PAID','PAID',
                        'CANCELLED','REFUNDED','BAD_DEBT','INSURANCE_PENDING')),
    -- Insurance
    insurance_id     UUID        REFERENCES patient_insurance(insurance_id),
    insurance_claim_id UUID,
    insurance_amount NUMERIC(15,4) NOT NULL DEFAULT 0,
    patient_amount   NUMERIC(15,4) NOT NULL DEFAULT 0,
    -- Discount Approval
    discount_approved_by UUID    REFERENCES users(user_id),
    discount_reason  TEXT,
    -- Audit
    finalized_at     TIMESTAMPTZ,
    finalized_by     UUID        REFERENCES users(user_id),
    cancelled_at     TIMESTAMPTZ,
    cancelled_by     UUID        REFERENCES users(user_id),
    cancellation_reason TEXT,
    created_at       TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by       UUID        NOT NULL REFERENCES users(user_id),
    updated_at       TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_by       UUID        NOT NULL REFERENCES users(user_id),
    is_deleted       BOOLEAN     NOT NULL DEFAULT FALSE
);

CREATE UNIQUE INDEX uq_invoice_number ON invoices(tenant_id, invoice_number);
CREATE INDEX idx_invoices_patient      ON invoices(patient_id) WHERE is_deleted = FALSE;
CREATE INDEX idx_invoices_date_tenant  ON invoices(invoice_date, tenant_id) WHERE is_deleted = FALSE;
CREATE INDEX idx_invoices_status       ON invoices(status, tenant_id) WHERE is_deleted = FALSE;
CREATE INDEX idx_invoices_due          ON invoices(tenant_id) WHERE due_amount > 0 AND is_deleted = FALSE;
```

### 12.4 Invoice Line Items

```sql
CREATE TABLE invoice_items (
    invoice_item_id  UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    invoice_id       UUID        NOT NULL REFERENCES invoices(invoice_id) ON DELETE CASCADE,
    tenant_id        UUID        NOT NULL REFERENCES tenants(tenant_id),
    service_id       UUID        REFERENCES service_charge_master(service_id),
    drug_id          UUID        REFERENCES drug_catalog(drug_id),
    item_name        VARCHAR(500) NOT NULL,
    item_category    VARCHAR(100),
    quantity         NUMERIC(10,4) NOT NULL DEFAULT 1,
    unit_price       NUMERIC(12,4) NOT NULL,
    discount_percent NUMERIC(5,2) NOT NULL DEFAULT 0,
    discount_amount  NUMERIC(12,4) NOT NULL DEFAULT 0,
    tax_percent      NUMERIC(5,2) NOT NULL DEFAULT 0,
    tax_amount       NUMERIC(12,4) NOT NULL DEFAULT 0,
    total_amount     NUMERIC(15,4) NOT NULL,
    reference_id     UUID,                               -- links to specific test/order/dispensing
    reference_type   VARCHAR(50),
    performed_by     UUID        REFERENCES users(user_id),
    service_date     DATE        NOT NULL,
    is_cancelled     BOOLEAN     NOT NULL DEFAULT FALSE
);

CREATE INDEX idx_invoice_items_invoice ON invoice_items(invoice_id);
```

### 12.5 Payments

```sql
CREATE TABLE payments (
    payment_id       UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id        UUID        NOT NULL REFERENCES tenants(tenant_id),
    invoice_id       UUID        NOT NULL REFERENCES invoices(invoice_id),
    patient_id       UUID        NOT NULL REFERENCES patients(patient_id),
    payment_number   VARCHAR(30) NOT NULL,
    payment_date     DATE        NOT NULL,
    payment_time     TIME        NOT NULL,
    amount           NUMERIC(15,4) NOT NULL,
    payment_mode     VARCHAR(50) NOT NULL CHECK (payment_mode IN
                       ('CASH','CREDIT_CARD','DEBIT_CARD','UPI','NET_BANKING',
                        'MOBILE_WALLET','CHEQUE','INSURANCE','CORPORATE_CREDIT','REFUND')),
    transaction_reference VARCHAR(100),                  -- bank/card transaction ref
    bank_name        VARCHAR(100),
    cheque_number    VARCHAR(50),
    cheque_date      DATE,
    is_verified      BOOLEAN     NOT NULL DEFAULT FALSE,
    verified_by      UUID        REFERENCES users(user_id),
    status           VARCHAR(20) NOT NULL DEFAULT 'COMPLETED'
                     CHECK (status IN ('PENDING','COMPLETED','FAILED','REVERSED')),
    reversal_payment_id UUID     REFERENCES payments(payment_id),
    reversal_reason  TEXT,
    collected_by     UUID        NOT NULL REFERENCES users(user_id),
    shift_id         UUID,                               -- cashier shift reference
    notes            TEXT,
    created_at       TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by       UUID        NOT NULL REFERENCES users(user_id)
);

CREATE UNIQUE INDEX uq_payment_number ON payments(tenant_id, payment_number);
CREATE INDEX idx_payments_invoice    ON payments(invoice_id);
CREATE INDEX idx_payments_patient    ON payments(patient_id, payment_date DESC);
CREATE INDEX idx_payments_date       ON payments(payment_date, tenant_id) WHERE status = 'COMPLETED';
CREATE INDEX idx_payments_mode       ON payments(payment_mode, payment_date);
```

### 12.6 Advance Payments

```sql
CREATE TABLE advance_payments (
    advance_id       UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id        UUID        NOT NULL REFERENCES tenants(tenant_id),
    patient_id       UUID        NOT NULL REFERENCES patients(patient_id),
    admission_id     UUID        REFERENCES admissions(admission_id),
    advance_number   VARCHAR(30) NOT NULL,
    amount           NUMERIC(15,4) NOT NULL,
    utilized_amount  NUMERIC(15,4) NOT NULL DEFAULT 0,
    balance          NUMERIC(15,4) GENERATED ALWAYS AS (amount - utilized_amount) STORED,
    payment_mode     VARCHAR(50) NOT NULL,
    transaction_ref  VARCHAR(100),
    status           VARCHAR(20) NOT NULL DEFAULT 'ACTIVE'
                     CHECK (status IN ('ACTIVE','PARTIALLY_USED','FULLY_USED','REFUNDED')),
    collected_by     UUID        NOT NULL REFERENCES users(user_id),
    created_at       TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_advance_payments_patient ON advance_payments(patient_id) WHERE status IN ('ACTIVE','PARTIALLY_USED');
```

---

## 13. Module 10 — Insurance & Claims

### 13.1 Insurers

```sql
CREATE TABLE insurers (
    insurer_id       UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id        UUID        NOT NULL REFERENCES tenants(tenant_id),
    insurer_code     VARCHAR(30) NOT NULL,
    insurer_name     VARCHAR(300) NOT NULL,
    insurer_type     VARCHAR(30) NOT NULL CHECK (insurer_type IN
                       ('PRIVATE','GOVERNMENT','TPA','CORPORATE')),
    tpa_name         VARCHAR(300),
    payer_id         VARCHAR(50),                         -- EDI payer ID
    contact_info     JSONB,
    claim_portal_url TEXT,
    contract_details JSONB,
    cashless_enabled BOOLEAN     NOT NULL DEFAULT FALSE,
    reimbursement_days SMALLINT,
    is_active        BOOLEAN     NOT NULL DEFAULT TRUE,
    created_at       TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at       TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE UNIQUE INDEX uq_insurer_code ON insurers(tenant_id, insurer_code);
```

### 13.2 Pre-Authorizations

```sql
CREATE TABLE pre_authorizations (
    preauth_id       UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id        UUID        NOT NULL REFERENCES tenants(tenant_id),
    patient_id       UUID        NOT NULL REFERENCES patients(patient_id),
    insurance_id     UUID        NOT NULL REFERENCES patient_insurance(insurance_id),
    insurer_id       UUID        NOT NULL REFERENCES insurers(insurer_id),
    encounter_id     UUID        REFERENCES opd_encounters(encounter_id),
    admission_id     UUID        REFERENCES admissions(admission_id),
    preauth_number   VARCHAR(50),                        -- internal ref
    insurer_ref_no   VARCHAR(100),                       -- insurer-assigned ref
    requested_at     TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    treatment_description TEXT   NOT NULL,
    estimated_cost   NUMERIC(15,2) NOT NULL,
    approved_amount  NUMERIC(15,2),
    status           VARCHAR(30) NOT NULL DEFAULT 'SUBMITTED'
                     CHECK (status IN
                       ('DRAFT','SUBMITTED','UNDER_REVIEW','APPROVED',
                        'PARTIAL_APPROVED','REJECTED','EXPIRED','CANCELLED')),
    approved_at      TIMESTAMPTZ,
    rejected_at      TIMESTAMPTZ,
    rejection_reason TEXT,
    expiry_date      DATE,
    documents        JSONB,                              -- array of document URLs
    notes            TEXT,
    created_at       TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by       UUID        NOT NULL REFERENCES users(user_id),
    updated_at       TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_preauth_patient   ON pre_authorizations(patient_id);
CREATE INDEX idx_preauth_insurance ON pre_authorizations(insurance_id);
CREATE INDEX idx_preauth_status    ON pre_authorizations(status, tenant_id);
```

### 13.3 Insurance Claims

```sql
CREATE TABLE insurance_claims (
    claim_id         UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id        UUID        NOT NULL REFERENCES tenants(tenant_id),
    patient_id       UUID        NOT NULL REFERENCES patients(patient_id),
    invoice_id       UUID        NOT NULL REFERENCES invoices(invoice_id),
    insurance_id     UUID        NOT NULL REFERENCES patient_insurance(insurance_id),
    insurer_id       UUID        NOT NULL REFERENCES insurers(insurer_id),
    preauth_id       UUID        REFERENCES pre_authorizations(preauth_id),
    claim_number     VARCHAR(50) NOT NULL,               -- internal
    insurer_claim_ref VARCHAR(100),                      -- insurer-assigned
    claim_type       VARCHAR(30) NOT NULL CHECK (claim_type IN ('CASHLESS','REIMBURSEMENT')),
    submitted_at     TIMESTAMPTZ,
    claimed_amount   NUMERIC(15,4) NOT NULL,
    approved_amount  NUMERIC(15,4) NOT NULL DEFAULT 0,
    deducted_amount  NUMERIC(15,4) NOT NULL DEFAULT 0,
    settled_amount   NUMERIC(15,4) NOT NULL DEFAULT 0,
    patient_liability NUMERIC(15,4) NOT NULL DEFAULT 0,
    status           VARCHAR(30) NOT NULL DEFAULT 'DRAFT'
                     CHECK (status IN
                       ('DRAFT','SUBMITTED','UNDER_REVIEW','APPROVED',
                        'PARTIAL_APPROVED','REJECTED','SETTLED','APPEALED','WRITTEN_OFF')),
    settled_at       TIMESTAMPTZ,
    settlement_ref   VARCHAR(100),
    denial_reason    TEXT,
    appeal_count     SMALLINT    NOT NULL DEFAULT 0,
    last_appeal_at   TIMESTAMPTZ,
    documents        JSONB,
    notes            TEXT,
    created_at       TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by       UUID        NOT NULL REFERENCES users(user_id),
    updated_at       TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    is_deleted       BOOLEAN     NOT NULL DEFAULT FALSE
);

CREATE UNIQUE INDEX uq_claim_number ON insurance_claims(tenant_id, claim_number);
CREATE INDEX idx_claims_patient     ON insurance_claims(patient_id) WHERE is_deleted = FALSE;
CREATE INDEX idx_claims_invoice     ON insurance_claims(invoice_id);
CREATE INDEX idx_claims_status      ON insurance_claims(status, tenant_id) WHERE is_deleted = FALSE;
CREATE INDEX idx_claims_submitted   ON insurance_claims(submitted_at, insurer_id);
```

---

## 14. Module 11 — Human Resources & Payroll

### 14.1 Employees

```sql
CREATE TABLE employees (
    employee_id      UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id          UUID        UNIQUE REFERENCES users(user_id),
    tenant_id        UUID        NOT NULL REFERENCES tenants(tenant_id),
    employee_code    VARCHAR(30) NOT NULL,
    first_name       VARCHAR(100) NOT NULL,
    last_name        VARCHAR(100) NOT NULL,
    date_of_birth    DATE        NOT NULL,
    gender           VARCHAR(20),
    national_id      VARCHAR(50),                         -- encrypted
    phone            VARCHAR(20),
    email            VARCHAR(255),
    address          JSONB,
    department_id    UUID        REFERENCES departments(department_id),
    designation      VARCHAR(200) NOT NULL,
    employment_type  VARCHAR(30) NOT NULL CHECK (employment_type IN
                       ('FULL_TIME','PART_TIME','CONTRACT','INTERN','CONSULTANT')),
    joining_date     DATE        NOT NULL,
    confirmation_date DATE,
    resignation_date DATE,
    termination_date DATE,
    employment_status VARCHAR(30) NOT NULL DEFAULT 'ACTIVE'
                      CHECK (employment_status IN
                        ('ACTIVE','ON_PROBATION','ON_LEAVE','RESIGNED','TERMINATED','RETIRED')),
    reporting_manager_id UUID    REFERENCES employees(employee_id),
    bank_account_no  TEXT,                               -- encrypted
    bank_name        VARCHAR(100),
    tax_id           VARCHAR(50),
    documents        JSONB,
    created_at       TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at       TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    is_deleted       BOOLEAN     NOT NULL DEFAULT FALSE
);

CREATE UNIQUE INDEX uq_employee_code ON employees(tenant_id, employee_code);
CREATE INDEX idx_employees_tenant    ON employees(tenant_id) WHERE employment_status = 'ACTIVE';
CREATE INDEX idx_employees_dept      ON employees(department_id) WHERE is_deleted = FALSE;
```

### 14.2 Attendance

```sql
CREATE TABLE attendance_records (
    attendance_id    UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    employee_id      UUID        NOT NULL REFERENCES employees(employee_id),
    tenant_id        UUID        NOT NULL REFERENCES tenants(tenant_id),
    attendance_date  DATE        NOT NULL,
    check_in_time    TIMESTAMPTZ,
    check_out_time   TIMESTAMPTZ,
    working_hours    NUMERIC(5,2) GENERATED ALWAYS AS
                       (CASE WHEN check_in_time IS NOT NULL AND check_out_time IS NOT NULL
                             THEN ROUND(EXTRACT(EPOCH FROM (check_out_time - check_in_time))/3600, 2)
                             ELSE 0 END) STORED,
    status           VARCHAR(20) NOT NULL DEFAULT 'PRESENT'
                     CHECK (status IN ('PRESENT','ABSENT','HALF_DAY','LATE','ON_LEAVE',
                                        'HOLIDAY','WEEKEND')),
    leave_type       VARCHAR(50),
    approved_by      UUID        REFERENCES users(user_id),
    notes            TEXT,
    UNIQUE(employee_id, attendance_date)
);

CREATE INDEX idx_attendance_employee ON attendance_records(employee_id, attendance_date DESC);
CREATE INDEX idx_attendance_date     ON attendance_records(tenant_id, attendance_date);
```

### 14.3 Payroll

```sql
CREATE TABLE payroll_periods (
    period_id        UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id        UUID        NOT NULL REFERENCES tenants(tenant_id),
    period_name      VARCHAR(100) NOT NULL,
    start_date       DATE        NOT NULL,
    end_date         DATE        NOT NULL,
    payment_date     DATE,
    status           VARCHAR(20) NOT NULL DEFAULT 'OPEN'
                     CHECK (status IN ('OPEN','PROCESSING','CLOSED','PAID')),
    created_at       TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE payroll_records (
    payroll_id       UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    period_id        UUID        NOT NULL REFERENCES payroll_periods(period_id),
    employee_id      UUID        NOT NULL REFERENCES employees(employee_id),
    tenant_id        UUID        NOT NULL REFERENCES tenants(tenant_id),
    basic_salary     NUMERIC(15,4) NOT NULL,
    allowances       JSONB,                              -- HRA, transport, medical, etc.
    gross_salary     NUMERIC(15,4) NOT NULL,
    deductions       JSONB,                              -- PF, tax, insurance, advances
    net_salary       NUMERIC(15,4) NOT NULL,
    days_worked      SMALLINT    NOT NULL,
    days_absent      SMALLINT    NOT NULL DEFAULT 0,
    overtime_hours   NUMERIC(6,2) NOT NULL DEFAULT 0,
    overtime_amount  NUMERIC(12,4) NOT NULL DEFAULT 0,
    tax_amount       NUMERIC(12,4) NOT NULL DEFAULT 0,
    payment_status   VARCHAR(20) NOT NULL DEFAULT 'PENDING'
                     CHECK (payment_status IN ('PENDING','APPROVED','PAID','REVERSED')),
    paid_at          TIMESTAMPTZ,
    bank_transaction_ref VARCHAR(100),
    created_at       TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE(period_id, employee_id)
);

CREATE INDEX idx_payroll_records_period   ON payroll_records(period_id);
CREATE INDEX idx_payroll_records_employee ON payroll_records(employee_id, period_id);
```

---

## 15. Module 12 — Inventory & Supply Chain

### 15.1 Vendors

```sql
CREATE TABLE vendors (
    vendor_id        UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id        UUID        NOT NULL REFERENCES tenants(tenant_id),
    vendor_code      VARCHAR(30) NOT NULL,
    vendor_name      VARCHAR(300) NOT NULL,
    vendor_type      VARCHAR(50) NOT NULL CHECK (vendor_type IN
                       ('DRUG_SUPPLIER','EQUIPMENT','CONSUMABLE','SERVICE','FOOD','LAUNDRY')),
    contact_info     JSONB,
    address          JSONB,
    tax_id           VARCHAR(50),
    bank_details     JSONB,                              -- stored encrypted
    payment_terms    VARCHAR(100),
    credit_days      SMALLINT    NOT NULL DEFAULT 30,
    drug_license_no  VARCHAR(100),
    license_expiry   DATE,
    rating           SMALLINT    CHECK (rating BETWEEN 1 AND 5),
    is_blacklisted   BOOLEAN     NOT NULL DEFAULT FALSE,
    is_active        BOOLEAN     NOT NULL DEFAULT TRUE,
    created_at       TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at       TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE UNIQUE INDEX uq_vendor_code ON vendors(tenant_id, vendor_code);
```

### 15.2 Purchase Orders

```sql
CREATE TABLE purchase_orders (
    po_id            UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id        UUID        NOT NULL REFERENCES tenants(tenant_id),
    vendor_id        UUID        NOT NULL REFERENCES vendors(vendor_id),
    po_number        VARCHAR(30) NOT NULL,
    po_date          DATE        NOT NULL,
    expected_delivery DATE,
    status           VARCHAR(30) NOT NULL DEFAULT 'DRAFT'
                     CHECK (status IN
                       ('DRAFT','APPROVED','SENT_TO_VENDOR','PARTIAL_RECEIVED',
                        'RECEIVED','CANCELLED','CLOSED')),
    total_amount     NUMERIC(15,4) NOT NULL DEFAULT 0,
    discount_amount  NUMERIC(15,4) NOT NULL DEFAULT 0,
    tax_amount       NUMERIC(15,4) NOT NULL DEFAULT 0,
    net_amount       NUMERIC(15,4) NOT NULL DEFAULT 0,
    approved_by      UUID        REFERENCES users(user_id),
    approved_at      TIMESTAMPTZ,
    notes            TEXT,
    created_at       TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by       UUID        NOT NULL REFERENCES users(user_id),
    is_deleted       BOOLEAN     NOT NULL DEFAULT FALSE
);

CREATE TABLE purchase_order_items (
    po_item_id       UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    po_id            UUID        NOT NULL REFERENCES purchase_orders(po_id) ON DELETE CASCADE,
    drug_id          UUID        REFERENCES drug_catalog(drug_id),
    item_name        VARCHAR(500) NOT NULL,
    ordered_quantity NUMERIC(12,4) NOT NULL,
    received_quantity NUMERIC(12,4) NOT NULL DEFAULT 0,
    unit_price       NUMERIC(10,4) NOT NULL,
    discount_percent NUMERIC(5,2) NOT NULL DEFAULT 0,
    tax_percent      NUMERIC(5,2) NOT NULL DEFAULT 0,
    total_amount     NUMERIC(15,4) NOT NULL
);

CREATE UNIQUE INDEX uq_po_number ON purchase_orders(tenant_id, po_number);
CREATE INDEX idx_po_vendor      ON purchase_orders(vendor_id, po_date DESC);
CREATE INDEX idx_po_status      ON purchase_orders(status, tenant_id) WHERE is_deleted = FALSE;
```

### 15.3 Goods Receipt Notes (GRN)

```sql
CREATE TABLE goods_receipt_notes (
    grn_id           UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id        UUID        NOT NULL REFERENCES tenants(tenant_id),
    po_id            UUID        REFERENCES purchase_orders(po_id),
    vendor_id        UUID        NOT NULL REFERENCES vendors(vendor_id),
    grn_number       VARCHAR(30) NOT NULL,
    grn_date         DATE        NOT NULL,
    invoice_number   VARCHAR(100),                       -- vendor invoice
    invoice_date     DATE,
    status           VARCHAR(20) NOT NULL DEFAULT 'RECEIVED'
                     CHECK (status IN ('RECEIVED','QUALITY_CHECKED','APPROVED','RETURNED')),
    total_amount     NUMERIC(15,4) NOT NULL DEFAULT 0,
    received_by      UUID        NOT NULL REFERENCES users(user_id),
    quality_checked_by UUID      REFERENCES users(user_id),
    notes            TEXT,
    created_at       TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE grn_items (
    grn_item_id      UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    grn_id           UUID        NOT NULL REFERENCES goods_receipt_notes(grn_id) ON DELETE CASCADE,
    po_item_id       UUID        REFERENCES purchase_order_items(po_item_id),
    drug_id          UUID        REFERENCES drug_catalog(drug_id),
    item_name        VARCHAR(500) NOT NULL,
    batch_number     VARCHAR(100) NOT NULL,
    manufacturing_date DATE,
    expiry_date      DATE        NOT NULL,
    received_quantity NUMERIC(12,4) NOT NULL,
    accepted_quantity NUMERIC(12,4) NOT NULL DEFAULT 0,
    rejected_quantity NUMERIC(12,4) NOT NULL DEFAULT 0,
    rejection_reason TEXT,
    unit_price       NUMERIC(10,4) NOT NULL,
    total_amount     NUMERIC(15,4) NOT NULL
);

CREATE UNIQUE INDEX uq_grn_number ON goods_receipt_notes(tenant_id, grn_number);
```

---

## 16. Advanced PostgreSQL Objects

### 16.1 Views

#### Active Patient Summary View
```sql
CREATE VIEW v_patient_summary AS
SELECT
    p.patient_id,
    p.tenant_id,
    p.mrn,
    p.first_name || ' ' || p.last_name           AS full_name,
    p.date_of_birth,
    DATE_PART('year', AGE(p.date_of_birth))::INT AS age,
    p.gender,
    p.blood_group,
    p.patient_category,
    p.primary_phone,
    p.email,
    -- Aggregated counts
    (SELECT COUNT(*) FROM opd_encounters oe
     WHERE oe.patient_id = p.patient_id AND oe.is_deleted = FALSE)     AS total_opd_visits,
    (SELECT COUNT(*) FROM admissions a
     WHERE a.patient_id = p.patient_id AND a.is_deleted = FALSE)        AS total_admissions,
    (SELECT MAX(oe.encounter_date) FROM opd_encounters oe
     WHERE oe.patient_id = p.patient_id AND oe.is_deleted = FALSE)      AS last_visit_date,
    (SELECT SUM(i.due_amount) FROM invoices i
     WHERE i.patient_id = p.patient_id AND i.is_deleted = FALSE)        AS outstanding_balance,
    p.has_allergies,
    p.has_chronic,
    p.is_vip,
    p.created_at                                  AS registered_at
FROM patients p
WHERE p.is_deleted = FALSE;
```

#### Daily Appointment Dashboard View
```sql
CREATE VIEW v_today_appointments AS
SELECT
    a.appointment_id,
    a.tenant_id,
    a.appointment_date,
    a.start_time,
    a.end_time,
    a.status,
    a.appointment_type,
    p.mrn,
    p.first_name || ' ' || p.last_name  AS patient_name,
    p.primary_phone                      AS patient_phone,
    u.username                           AS doctor_username,
    d.specialization                     AS doctor_specialization,
    dept.dept_name                       AS department,
    a.chief_complaint,
    a.priority
FROM appointments a
JOIN patients p    ON p.patient_id    = a.patient_id
JOIN doctors d     ON d.doctor_id     = a.doctor_id
JOIN users u       ON u.user_id       = d.user_id
JOIN departments dept ON dept.department_id = a.department_id
WHERE a.appointment_date = CURRENT_DATE
  AND a.is_deleted = FALSE;
```

#### Bed Occupancy View
```sql
CREATE VIEW v_bed_occupancy AS
SELECT
    w.tenant_id,
    w.ward_id,
    w.ward_name,
    w.ward_type,
    COUNT(b.bed_id)                                    AS total_beds,
    COUNT(b.bed_id) FILTER (WHERE b.status = 'AVAILABLE')   AS available_beds,
    COUNT(b.bed_id) FILTER (WHERE b.status = 'OCCUPIED')    AS occupied_beds,
    COUNT(b.bed_id) FILTER (WHERE b.status = 'MAINTENANCE') AS maintenance_beds,
    ROUND(
        COUNT(b.bed_id) FILTER (WHERE b.status = 'OCCUPIED')::NUMERIC
        / NULLIF(COUNT(b.bed_id), 0) * 100, 2
    )                                                  AS occupancy_percent
FROM wards w
LEFT JOIN beds b ON b.ward_id = w.ward_id AND b.is_active = TRUE
WHERE w.is_active = TRUE
GROUP BY w.tenant_id, w.ward_id, w.ward_name, w.ward_type;
```

#### Outstanding Receivables View
```sql
CREATE VIEW v_outstanding_receivables AS
SELECT
    i.tenant_id,
    i.invoice_id,
    i.invoice_number,
    i.invoice_date,
    p.mrn,
    p.first_name || ' ' || p.last_name AS patient_name,
    p.patient_category,
    i.net_amount,
    i.paid_amount,
    i.due_amount,
    i.status,
    CURRENT_DATE - i.invoice_date      AS age_days,
    CASE
        WHEN CURRENT_DATE - i.invoice_date <= 30  THEN '0-30 days'
        WHEN CURRENT_DATE - i.invoice_date <= 60  THEN '31-60 days'
        WHEN CURRENT_DATE - i.invoice_date <= 90  THEN '61-90 days'
        ELSE '90+ days'
    END                                AS aging_bucket
FROM invoices i
JOIN patients p ON p.patient_id = i.patient_id
WHERE i.due_amount > 0
  AND i.status NOT IN ('CANCELLED','BAD_DEBT')
  AND i.is_deleted = FALSE;
```

### 16.2 Materialized Views

```sql
-- Daily Revenue KPI (refresh nightly)
CREATE MATERIALIZED VIEW mv_daily_revenue AS
SELECT
    i.tenant_id,
    i.invoice_date                           AS report_date,
    COUNT(DISTINCT i.invoice_id)             AS invoice_count,
    COUNT(DISTINCT i.patient_id)             AS unique_patients,
    SUM(i.gross_amount)                      AS gross_revenue,
    SUM(i.discount_amount)                   AS total_discounts,
    SUM(i.net_amount)                        AS net_revenue,
    SUM(i.paid_amount)                       AS collected_revenue,
    SUM(i.due_amount)                        AS pending_revenue,
    SUM(i.net_amount) FILTER (WHERE i.invoice_type = 'OPD')       AS opd_revenue,
    SUM(i.net_amount) FILTER (WHERE i.invoice_type = 'IPD')       AS ipd_revenue,
    SUM(i.net_amount) FILTER (WHERE i.invoice_type = 'LAB')       AS lab_revenue,
    SUM(i.net_amount) FILTER (WHERE i.invoice_type = 'RADIOLOGY') AS radiology_revenue,
    SUM(i.net_amount) FILTER (WHERE i.invoice_type = 'PHARMACY')  AS pharmacy_revenue
FROM invoices i
WHERE i.is_deleted = FALSE AND i.status != 'CANCELLED'
GROUP BY i.tenant_id, i.invoice_date
WITH DATA;

CREATE UNIQUE INDEX uq_mv_daily_revenue ON mv_daily_revenue(tenant_id, report_date);

-- Monthly Patient Statistics (refresh monthly)
CREATE MATERIALIZED VIEW mv_monthly_patient_stats AS
SELECT
    p.tenant_id,
    DATE_TRUNC('month', p.created_at)::DATE  AS month,
    COUNT(*)                                  AS new_registrations,
    COUNT(*) FILTER (WHERE p.patient_category = 'GENERAL')      AS general_patients,
    COUNT(*) FILTER (WHERE p.patient_category = 'VIP')          AS vip_patients,
    COUNT(*) FILTER (WHERE p.patient_category = 'INTERNATIONAL') AS international_patients,
    COUNT(*) FILTER (WHERE p.gender = 'MALE')   AS male_patients,
    COUNT(*) FILTER (WHERE p.gender = 'FEMALE') AS female_patients
FROM patients p
WHERE p.is_deleted = FALSE
GROUP BY p.tenant_id, DATE_TRUNC('month', p.created_at)::DATE
WITH DATA;

CREATE UNIQUE INDEX uq_mv_monthly_patient_stats ON mv_monthly_patient_stats(tenant_id, month);

-- Doctor Performance (refresh nightly)
CREATE MATERIALIZED VIEW mv_doctor_performance AS
SELECT
    d.doctor_id,
    d.tenant_id,
    u.username                                AS doctor_name,
    d.specialization,
    DATE_TRUNC('month', oe.encounter_date)::DATE AS month,
    COUNT(oe.encounter_id)                    AS total_consultations,
    COUNT(oe.encounter_id) FILTER (WHERE oe.status = 'COMPLETED') AS completed,
    AVG(EXTRACT(EPOCH FROM (oe.consultation_end - oe.consultation_start))/60)::NUMERIC(6,2) AS avg_consult_minutes,
    COUNT(a.admission_id)                     AS total_admissions
FROM doctors d
JOIN users u ON u.user_id = d.user_id
LEFT JOIN opd_encounters oe ON oe.doctor_id = d.doctor_id AND oe.is_deleted = FALSE
LEFT JOIN admissions a ON a.primary_doctor_id = d.doctor_id AND a.is_deleted = FALSE
GROUP BY d.doctor_id, d.tenant_id, u.username, d.specialization,
         DATE_TRUNC('month', oe.encounter_date)::DATE
WITH DATA;
```

### 16.3 PL/pgSQL Functions

```sql
-- Generate sequential business numbers
CREATE OR REPLACE FUNCTION generate_sequence_number(
    p_tenant_id UUID,
    p_prefix    VARCHAR,
    p_table     VARCHAR,
    p_column    VARCHAR
) RETURNS VARCHAR AS $$
DECLARE
    v_seq    BIGINT;
    v_number VARCHAR;
BEGIN
    -- Use advisory lock for sequence safety
    PERFORM pg_advisory_xact_lock(hashtext(p_tenant_id::TEXT || p_prefix));

    EXECUTE format(
        'SELECT COALESCE(MAX(SUBSTRING(%I FROM %L)::BIGINT), 0) + 1
         FROM %I WHERE tenant_id = $1 AND %I LIKE $2',
        p_column, '\d+$', p_table, p_column
    ) INTO v_seq USING p_tenant_id, p_prefix || '%';

    v_number := p_prefix || TO_CHAR(v_seq, 'FM000000');
    RETURN v_number;
END;
$$ LANGUAGE plpgsql;

-- Calculate patient age accurately
CREATE OR REPLACE FUNCTION get_patient_age(p_dob DATE)
RETURNS TABLE(years INT, months INT, days INT) AS $$
BEGIN
    RETURN QUERY
    SELECT
        DATE_PART('year',  AGE(p_dob))::INT,
        DATE_PART('month', AGE(p_dob))::INT,
        DATE_PART('day',   AGE(p_dob))::INT;
END;
$$ LANGUAGE plpgsql STABLE;

-- Get available slots for a doctor on a date
CREATE OR REPLACE FUNCTION get_available_slots(
    p_doctor_id UUID,
    p_date      DATE
) RETURNS TABLE(
    slot_id    UUID,
    start_time TIME,
    end_time   TIME,
    slot_type  VARCHAR,
    remaining  SMALLINT
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        s.slot_id,
        s.start_time,
        s.end_time,
        s.slot_type,
        (s.max_capacity - s.booked_count)::SMALLINT AS remaining
    FROM appointment_slots s
    WHERE s.doctor_id   = p_doctor_id
      AND s.slot_date   = p_date
      AND s.is_available = TRUE
      AND (s.max_capacity - s.booked_count) > 0
    ORDER BY s.start_time;
END;
$$ LANGUAGE plpgsql STABLE;

-- Check drug interactions for a new prescription
CREATE OR REPLACE FUNCTION check_drug_interactions(
    p_new_drug_id UUID,
    p_patient_id  UUID
) RETURNS TABLE(
    interacting_drug_name VARCHAR,
    severity              VARCHAR,
    description           TEXT
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        dc.generic_name,
        di.severity,
        di.description
    FROM prescriptions pr
    JOIN prescription_items pi  ON pi.prescription_id = pr.prescription_id
    JOIN drug_interactions di   ON (di.drug_a_id = p_new_drug_id AND di.drug_b_id = pi.medication_id)
                                OR (di.drug_b_id = p_new_drug_id AND di.drug_a_id = pi.medication_id)
    JOIN drug_catalog dc        ON dc.drug_id =
        CASE WHEN di.drug_a_id = p_new_drug_id THEN di.drug_b_id ELSE di.drug_a_id END
    WHERE pr.patient_id = p_patient_id
      AND pr.status     = 'ACTIVE'
      AND pr.is_deleted = FALSE
      AND di.is_active  = TRUE
    ORDER BY CASE di.severity
        WHEN 'CONTRAINDICATED' THEN 1
        WHEN 'MAJOR'           THEN 2
        WHEN 'MODERATE'        THEN 3
        ELSE 4 END;
END;
$$ LANGUAGE plpgsql STABLE;
```

### 16.4 Triggers

```sql
-- Trigger: Auto-update updated_at timestamp
CREATE OR REPLACE FUNCTION trigger_set_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Apply to all major tables
CREATE TRIGGER trg_patients_updated_at
    BEFORE UPDATE ON patients
    FOR EACH ROW EXECUTE FUNCTION trigger_set_updated_at();

CREATE TRIGGER trg_invoices_updated_at
    BEFORE UPDATE ON invoices
    FOR EACH ROW EXECUTE FUNCTION trigger_set_updated_at();

-- Trigger: Auto write audit log
CREATE OR REPLACE FUNCTION trigger_audit_log()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO audit_logs (
        tenant_id, user_id, action, table_name,
        record_id, old_values, new_values, occurred_at
    ) VALUES (
        COALESCE(NEW.tenant_id, OLD.tenant_id),
        current_setting('app.current_user_id', TRUE)::UUID,
        TG_OP,
        TG_TABLE_NAME,
        COALESCE(NEW.patient_id, NEW.invoice_id, NEW.admission_id),  -- adjust per table
        CASE WHEN TG_OP IN ('UPDATE','DELETE') THEN row_to_json(OLD) ELSE NULL END,
        CASE WHEN TG_OP IN ('INSERT','UPDATE') THEN row_to_json(NEW) ELSE NULL END,
        NOW()
    );
    RETURN COALESCE(NEW, OLD);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger: Prevent updates to patient MRN
CREATE OR REPLACE FUNCTION trigger_protect_mrn()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.mrn <> OLD.mrn THEN
        RAISE EXCEPTION 'MRN cannot be changed after registration. Patient ID: %', OLD.patient_id;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_protect_patient_mrn
    BEFORE UPDATE ON patients
    FOR EACH ROW EXECUTE FUNCTION trigger_protect_mrn();

-- Trigger: Deduct pharmacy inventory on dispensing
CREATE OR REPLACE FUNCTION trigger_deduct_inventory_on_dispense()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        UPDATE pharmacy_inventory
        SET quantity_out = quantity_out + NEW.quantity_dispensed,
            updated_at   = NOW()
        WHERE inventory_id = NEW.inventory_id;

        -- Validate stock after deduction
        IF (SELECT quantity_current FROM pharmacy_inventory
            WHERE inventory_id = NEW.inventory_id) < 0 THEN
            RAISE EXCEPTION 'Insufficient stock for inventory_id: %', NEW.inventory_id;
        END IF;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_deduct_inventory_on_dispense
    AFTER INSERT ON dispensing_records
    FOR EACH ROW EXECUTE FUNCTION trigger_deduct_inventory_on_dispense();

-- Trigger: Update bed status on admission / discharge
CREATE OR REPLACE FUNCTION trigger_manage_bed_status()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        UPDATE beds SET status = 'OCCUPIED', updated_at = NOW()
        WHERE bed_id = NEW.bed_id;

    ELSIF TG_OP = 'UPDATE' AND OLD.status != 'DISCHARGED' AND NEW.status = 'DISCHARGED' THEN
        UPDATE beds SET status = 'HOUSEKEEPING', updated_at = NOW()
        WHERE bed_id = OLD.bed_id;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_manage_bed_status
    AFTER INSERT OR UPDATE ON admissions
    FOR EACH ROW EXECUTE FUNCTION trigger_manage_bed_status();

-- Trigger: Update invoice due amount on payment
CREATE OR REPLACE FUNCTION trigger_update_invoice_on_payment()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE invoices
    SET paid_amount = (
            SELECT COALESCE(SUM(amount), 0)
            FROM payments
            WHERE invoice_id = NEW.invoice_id AND status = 'COMPLETED'
        ),
        status = CASE
            WHEN (net_amount - advance_adjusted) <= (
                SELECT COALESCE(SUM(amount), 0)
                FROM payments
                WHERE invoice_id = NEW.invoice_id AND status = 'COMPLETED'
            ) THEN 'PAID'
            WHEN (
                SELECT COALESCE(SUM(amount), 0)
                FROM payments
                WHERE invoice_id = NEW.invoice_id AND status = 'COMPLETED'
            ) > 0 THEN 'PARTIALLY_PAID'
            ELSE status
        END,
        updated_at = NOW()
    WHERE invoice_id = NEW.invoice_id;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_update_invoice_on_payment
    AFTER INSERT OR UPDATE ON payments
    FOR EACH ROW EXECUTE FUNCTION trigger_update_invoice_on_payment();
```

---

## 17. Business Logic at DB Level

### 17.1 Patient Admission Workflow

```sql
-- Stored procedure: Admit patient (complete atomic workflow)
CREATE OR REPLACE PROCEDURE admit_patient(
    p_tenant_id         UUID,
    p_patient_id        UUID,
    p_ward_id           UUID,
    p_bed_id            UUID,
    p_doctor_id         UUID,
    p_department_id     UUID,
    p_admission_type    VARCHAR,
    p_admission_source  VARCHAR,
    p_chief_complaint   TEXT,
    p_encounter_id      UUID DEFAULT NULL,
    p_created_by        UUID DEFAULT NULL
)
LANGUAGE plpgsql AS $$
DECLARE
    v_admission_number  VARCHAR;
    v_bed_status        VARCHAR;
    v_admission_id      UUID;
BEGIN
    -- 1. Check bed availability
    SELECT status INTO v_bed_status FROM beds WHERE bed_id = p_bed_id FOR UPDATE;
    IF v_bed_status != 'AVAILABLE' THEN
        RAISE EXCEPTION 'Bed % is not available. Current status: %', p_bed_id, v_bed_status;
    END IF;

    -- 2. Generate admission number
    v_admission_number := generate_sequence_number(
        p_tenant_id, 'ADM', 'admissions', 'admission_number');

    -- 3. Create admission record
    INSERT INTO admissions (
        tenant_id, patient_id, admission_number, admission_date, admission_type,
        admission_source, referring_encounter_id, ward_id, bed_id,
        primary_doctor_id, department_id, chief_complaint, status,
        created_by, updated_by
    ) VALUES (
        p_tenant_id, p_patient_id, v_admission_number, NOW(), p_admission_type,
        p_admission_source, p_encounter_id, p_ward_id, p_bed_id,
        p_doctor_id, p_department_id, p_chief_complaint, 'ADMITTED',
        p_created_by, p_created_by
    ) RETURNING admission_id INTO v_admission_id;

    -- 4. Bed status updated via trigger (trg_manage_bed_status)

    -- 5. Create initial advance invoice (optional: could be a separate call)
    RAISE NOTICE 'Patient admitted successfully. Admission ID: %, Number: %',
                  v_admission_id, v_admission_number;
END;
$$;
```

### 17.2 Appointment Booking Constraint Enforcement

```sql
-- Prevent double-booking via unique partial index
CREATE UNIQUE INDEX uq_no_double_booking
    ON appointments(doctor_id, appointment_date, start_time)
    WHERE status NOT IN ('CANCELLED','NO_SHOW','RESCHEDULED')
      AND is_deleted = FALSE;

-- Constraint: Appointment cannot be in the past (applied in application layer,
-- but DB-level check for direct DB access)
ALTER TABLE appointments ADD CONSTRAINT chk_appointment_not_past
    CHECK (appointment_date >= CURRENT_DATE - INTERVAL '1 day');
```

### 17.3 Pharmacy Stock FEFO Procedure

```sql
-- Procedure: Dispense drug using FEFO (First Expiry, First Out) rule
CREATE OR REPLACE FUNCTION fefo_get_inventory_for_dispense(
    p_tenant_id UUID,
    p_drug_id   UUID,
    p_quantity  NUMERIC
) RETURNS TABLE(
    inventory_id UUID,
    batch_number VARCHAR,
    expiry_date  DATE,
    available    NUMERIC,
    to_take      NUMERIC
) AS $$
DECLARE
    v_remaining NUMERIC := p_quantity;
    v_to_take   NUMERIC;
    rec         RECORD;
BEGIN
    FOR rec IN
        SELECT pi.inventory_id, pi.batch_number, pi.expiry_date, pi.quantity_current
        FROM pharmacy_inventory pi
        WHERE pi.tenant_id   = p_tenant_id
          AND pi.drug_id     = p_drug_id
          AND pi.quantity_current > 0
          AND pi.is_quarantined   = FALSE
          AND pi.expiry_date      > CURRENT_DATE
        ORDER BY pi.expiry_date ASC, pi.created_at ASC
        FOR UPDATE
    LOOP
        IF v_remaining <= 0 THEN EXIT; END IF;
        v_to_take := LEAST(rec.quantity_current, v_remaining);
        v_remaining := v_remaining - v_to_take;
        RETURN QUERY SELECT rec.inventory_id, rec.batch_number,
                            rec.expiry_date, rec.quantity_current, v_to_take;
    END LOOP;

    IF v_remaining > 0 THEN
        RAISE EXCEPTION 'Insufficient stock for drug_id %. Shortage: %', p_drug_id, v_remaining;
    END IF;
END;
$$ LANGUAGE plpgsql;
```

### 17.4 Billing Lifecycle Enforcement

```sql
-- Constraint: Invoice cannot be cancelled if it has successful payments
CREATE OR REPLACE FUNCTION check_invoice_cancellation()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.status = 'CANCELLED' AND OLD.status != 'CANCELLED' THEN
        IF EXISTS (
            SELECT 1 FROM payments
            WHERE invoice_id = NEW.invoice_id AND status = 'COMPLETED'
        ) THEN
            RAISE EXCEPTION
                'Cannot cancel invoice % with completed payments. Reverse payments first.',
                NEW.invoice_number;
        END IF;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_check_invoice_cancellation
    BEFORE UPDATE ON invoices
    FOR EACH ROW EXECUTE FUNCTION check_invoice_cancellation();
```

---

## 18. Performance Optimization

### 18.1 Index Strategy Summary

| Table | Index Type | Columns | Purpose |
|---|---|---|---|
| `patients` | BTREE | `(tenant_id, mrn)` | MRN lookup |
| `patients` | GIN | `to_tsvector(name)` | Full-text search |
| `appointments` | BTREE | `(doctor_id, appointment_date)` | Doctor schedule view |
| `appointments` | UNIQUE PARTIAL | `(doctor_id, date, time) WHERE not cancelled` | Double-booking prevention |
| `lab_results` | BTREE PARTIAL | `(tenant_id, resulted_at) WHERE critical` | Critical value alerts |
| `pharmacy_inventory` | BTREE | `(drug_id, expiry_date ASC) WHERE available` | FEFO dispensing |
| `invoices` | BTREE PARTIAL | `(tenant_id) WHERE due > 0` | Receivables query |
| `audit_logs` | BTREE | `(tenant_id, occurred_at DESC)` | Partitioned audit trail |
| `clinical_notes` | GIN | `note_tsv` | Clinical search |
| `radiology_reports` | GIN | `report_tsv` | Report search |

### 18.2 Table Partitioning

```sql
-- Partitioned billing table by year (for large hospitals with millions of records)
CREATE TABLE invoices_2024 PARTITION OF invoices
    FOR VALUES FROM ('2024-01-01') TO ('2025-01-01');
CREATE TABLE invoices_2025 PARTITION OF invoices
    FOR VALUES FROM ('2025-01-01') TO ('2026-01-01');

-- Partitioned audit logs by month (already shown in Section 3.4)
-- Use pg_partman extension for automated partition management:
-- SELECT partman.create_parent('public.audit_logs', 'occurred_at', 'native', 'monthly');
```

### 18.3 Connection Pooling Configuration (PgBouncer)

```ini
; pgbouncer.ini recommended settings for hospital ERP
pool_mode        = transaction
max_client_conn  = 500
default_pool_size = 25
min_pool_size    = 5
reserve_pool_size = 10
server_idle_timeout = 600
```

### 18.4 Query Optimization Patterns

```sql
-- Use covering indexes to avoid heap fetches on hot queries
CREATE INDEX idx_appointments_covering
    ON appointments(doctor_id, appointment_date, status)
    INCLUDE (patient_id, start_time, chief_complaint)
    WHERE is_deleted = FALSE;

-- Use partial indexes to dramatically reduce index size
CREATE INDEX idx_active_admissions
    ON admissions(tenant_id, ward_id)
    WHERE status = 'ADMITTED' AND is_deleted = FALSE;

-- Use BRIN indexes for time-series tables (much smaller than BTREE)
CREATE INDEX idx_audit_logs_brin ON audit_logs
    USING BRIN (occurred_at) WITH (pages_per_range = 128);

-- Scheduled materialized view refresh
-- Add to pg_cron or application scheduler:
-- SELECT cron.schedule('refresh-daily-revenue', '0 1 * * *',
--   $$REFRESH MATERIALIZED VIEW CONCURRENTLY mv_daily_revenue$$);
```

---

## 19. Security & Compliance

### 19.1 PostgreSQL Roles (RBAC)

```sql
-- Application roles (connection-level, never login directly)
CREATE ROLE hms_app_role         NOLOGIN;  -- base application role
CREATE ROLE hms_readonly_role    NOLOGIN;  -- reporting / BI
CREATE ROLE hms_admin_role       NOLOGIN;  -- DBA / super access (restricted)
CREATE ROLE hms_audit_role       NOLOGIN;  -- audit log access only

-- Application user (used by connection pool)
CREATE USER hms_app_user WITH PASSWORD 'strong_password_here' CONNECTION LIMIT 50;
GRANT hms_app_role TO hms_app_user;

-- Grant privileges to app role
GRANT SELECT, INSERT, UPDATE ON ALL TABLES IN SCHEMA public TO hms_app_role;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO hms_readonly_role;
GRANT SELECT ON audit_logs TO hms_audit_role;

-- Revoke direct delete (use is_deleted = TRUE instead)
REVOKE DELETE ON patients, invoices, admissions, lab_results FROM hms_app_role;
REVOKE DROP ON ALL TABLES IN SCHEMA public FROM hms_app_role;
```

### 19.2 Row-Level Security (RLS)

```sql
-- Enable RLS on all major tables
ALTER TABLE patients       ENABLE ROW LEVEL SECURITY;
ALTER TABLE invoices       ENABLE ROW LEVEL SECURITY;
ALTER TABLE admissions     ENABLE ROW LEVEL SECURITY;
ALTER TABLE opd_encounters ENABLE ROW LEVEL SECURITY;
ALTER TABLE lab_results    ENABLE ROW LEVEL SECURITY;

-- Policy: App role can only access rows for its tenant
CREATE POLICY tenant_isolation_policy ON patients
    FOR ALL TO hms_app_role
    USING (tenant_id = current_setting('app.current_tenant_id')::UUID);

CREATE POLICY tenant_isolation_policy ON invoices
    FOR ALL TO hms_app_role
    USING (tenant_id = current_setting('app.current_tenant_id')::UUID);

-- Policy: Soft-deleted records are invisible
CREATE POLICY hide_deleted_patients ON patients
    FOR SELECT TO hms_app_role
    USING (is_deleted = FALSE);

-- Application sets tenant context on each connection:
-- SET app.current_tenant_id = '<tenant_uuid>';
-- SET app.current_user_id   = '<user_uuid>';
```

### 19.3 Sensitive Data Encryption

```sql
-- Enable pgcrypto extension for field-level encryption
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- Encrypt sensitive columns at application layer (or at DB using pgcrypto)
-- Example: encrypt national_id before INSERT
-- UPDATE patients SET national_id = pgp_sym_encrypt(national_id, current_setting('app.enc_key'));
-- SELECT pgp_sym_decrypt(national_id::bytea, current_setting('app.enc_key')) FROM patients;

-- Fields requiring encryption:
-- patients.national_id, patients.passport_number
-- employees.national_id, employees.bank_account_no
-- vendors.bank_details (JSONB - encrypt the whole object)
-- users.mfa_secret

-- Use SSL/TLS for all connections:
-- postgresql.conf: ssl = on, ssl_cert_file, ssl_key_file
```

### 19.4 HIPAA / GDPR Compliance Features

```sql
-- Sensitive data access log (break-the-glass)
CREATE TABLE sensitive_data_access_log (
    log_id         UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id      UUID        NOT NULL,
    user_id        UUID        NOT NULL REFERENCES users(user_id),
    patient_id     UUID        NOT NULL REFERENCES patients(patient_id),
    access_type    VARCHAR(50) NOT NULL,             -- VIEW_RECORD, PRINT, EXPORT, BREAK_GLASS
    reason         TEXT,
    ip_address     INET,
    accessed_at    TIMESTAMPTZ NOT NULL DEFAULT NOW()
) PARTITION BY RANGE (accessed_at);

-- Legal hold (prevent deletion of records under legal review)
CREATE TABLE legal_holds (
    hold_id        UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id      UUID        NOT NULL,
    record_type    VARCHAR(100) NOT NULL,
    record_id      UUID        NOT NULL,
    reason         TEXT        NOT NULL,
    held_by        UUID        NOT NULL REFERENCES users(user_id),
    held_at        TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    released_at    TIMESTAMPTZ,
    released_by    UUID        REFERENCES users(user_id)
);

CREATE INDEX idx_legal_holds_record ON legal_holds(record_type, record_id)
    WHERE released_at IS NULL;
```

---

## 20. Reporting Layer

### 20.1 KPI Tables (Pre-aggregated for Dashboard Speed)

```sql
CREATE TABLE kpi_daily_operations (
    kpi_id           UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id        UUID        NOT NULL REFERENCES tenants(tenant_id),
    report_date      DATE        NOT NULL,
    -- Patient KPIs
    new_registrations     INT    NOT NULL DEFAULT 0,
    opd_visits            INT    NOT NULL DEFAULT 0,
    emergency_visits      INT    NOT NULL DEFAULT 0,
    new_admissions        INT    NOT NULL DEFAULT 0,
    discharges            INT    NOT NULL DEFAULT 0,
    current_census        INT    NOT NULL DEFAULT 0,   -- total inpatients at EOD
    bed_occupancy_pct     NUMERIC(5,2),
    -- Financial KPIs
    opd_revenue           NUMERIC(15,2) NOT NULL DEFAULT 0,
    ipd_revenue           NUMERIC(15,2) NOT NULL DEFAULT 0,
    lab_revenue           NUMERIC(15,2) NOT NULL DEFAULT 0,
    pharmacy_revenue      NUMERIC(15,2) NOT NULL DEFAULT 0,
    total_revenue         NUMERIC(15,2) NOT NULL DEFAULT 0,
    cash_collected        NUMERIC(15,2) NOT NULL DEFAULT 0,
    outstanding           NUMERIC(15,2) NOT NULL DEFAULT 0,
    -- Clinical KPIs
    lab_tests_ordered     INT    NOT NULL DEFAULT 0,
    imaging_studies       INT    NOT NULL DEFAULT 0,
    surgeries_performed   INT    NOT NULL DEFAULT 0,
    -- Quality KPIs
    avg_wait_time_minutes NUMERIC(6,2),
    patient_satisfaction  NUMERIC(4,2),
    readmission_count     INT    NOT NULL DEFAULT 0,
    generated_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE(tenant_id, report_date)
);

CREATE INDEX idx_kpi_daily_ops_date ON kpi_daily_operations(tenant_id, report_date DESC);
```

### 20.2 Department-Level Revenue View

```sql
CREATE MATERIALIZED VIEW mv_department_revenue AS
SELECT
    i.tenant_id,
    DATE_TRUNC('month', i.invoice_date)::DATE    AS month,
    dept.dept_name,
    dept.dept_type,
    COUNT(DISTINCT i.invoice_id)                 AS invoice_count,
    SUM(ii.total_amount)                         AS revenue,
    SUM(ii.discount_amount)                      AS discounts,
    COUNT(DISTINCT i.patient_id)                 AS unique_patients
FROM invoice_items ii
JOIN invoices    i    ON i.invoice_id    = ii.invoice_id
JOIN service_charge_master sc ON sc.service_id = ii.service_id
JOIN departments dept ON dept.department_id = sc.department_id
WHERE i.is_deleted = FALSE AND i.status != 'CANCELLED'
GROUP BY i.tenant_id, DATE_TRUNC('month', i.invoice_date)::DATE,
         dept.dept_name, dept.dept_type
WITH DATA;

CREATE INDEX idx_mv_dept_revenue ON mv_department_revenue(tenant_id, month DESC);
```

### 20.3 Insurance Claims Aging View

```sql
CREATE VIEW v_insurance_claims_aging AS
SELECT
    ic.tenant_id,
    ins.insurer_name,
    ic.claim_id,
    ic.claim_number,
    ic.status,
    ic.submitted_at::DATE                          AS submitted_date,
    ic.claimed_amount,
    ic.approved_amount,
    ic.settled_amount,
    ic.claimed_amount - ic.settled_amount          AS outstanding_amount,
    CURRENT_DATE - ic.submitted_at::DATE           AS pending_days,
    CASE
        WHEN CURRENT_DATE - ic.submitted_at::DATE <= 30  THEN '0-30 days'
        WHEN CURRENT_DATE - ic.submitted_at::DATE <= 60  THEN '31-60 days'
        WHEN CURRENT_DATE - ic.submitted_at::DATE <= 90  THEN '61-90 days'
        ELSE '90+ days'
    END                                            AS aging_bucket
FROM insurance_claims ic
JOIN insurers ins ON ins.insurer_id = ic.insurer_id
WHERE ic.status NOT IN ('SETTLED','WRITTEN_OFF')
  AND ic.is_deleted = FALSE;
```

---

## 21. Naming Conventions Summary

| Object Type | Convention | Example |
|---|---|---|
| **Table** | `snake_case`, plural | `patients`, `invoice_items` |
| **Primary Key** | `<table_name_singular>_id` UUID | `patient_id`, `invoice_id` |
| **Foreign Key** | `<referenced_table_singular>_id` UUID | `doctor_id`, `tenant_id` |
| **BTREE Index** | `idx_<table>_<column(s)>` | `idx_patients_name` |
| **Partial Index** | `idx_<table>_<column>_<qualifier>` | `idx_invoices_due` |
| **Unique Constraint** | `uq_<table>_<column(s)>` | `uq_patients_mrn_tenant` |
| **Check Constraint** | `chk_<table>_<description>` | `chk_schedule_times` |
| **Trigger** | `trg_<table>_<action>` | `trg_patients_updated_at` |
| **Function** | `snake_case` verb phrase | `get_available_slots()` |
| **Procedure** | `snake_case` verb phrase | `admit_patient()` |
| **View** | `v_<description>` | `v_bed_occupancy` |
| **Materialized View** | `mv_<description>` | `mv_daily_revenue` |
| **Enum/Status values** | `UPPER_SNAKE_CASE` | `'ADMITTED'`, `'COMPLETED'` |
| **JSONB columns** | `snake_case` noun | `contact_info`, `address` |
| **Audit columns** | Standard set | `created_at`, `created_by`, `is_deleted` |
| **Sequence numbers** | Prefix + zero-padded 6 digits | `ADM000001`, `INV000045` |

---

## Appendix: Quick Reference — Module to Table Map

| Module | Core Tables |
|---|---|
| **Tenant / Auth** | `tenants`, `users`, `roles`, `permissions`, `user_roles`, `audit_logs` |
| **Patient** | `patients`, `patient_emergency_contacts`, `patient_family_links`, `patient_documents`, `patient_allergies`, `patient_consents`, `patient_insurance` |
| **Scheduling** | `departments`, `doctors`, `doctor_schedule_templates`, `doctor_availability_overrides`, `appointment_slots`, `appointments`, `appointment_waitlists` |
| **OPD** | `opd_encounters`, `vital_signs`, `clinical_notes`, `icd10_codes`, `encounter_diagnoses` |
| **IPD** | `wards`, `beds`, `admissions`, `bed_transfers`, `doctor_rounds`, `nursing_care_records`, `operation_theatres`, `surgery_schedules` |
| **EMR** | `patient_problems`, `medications_master`, `prescriptions`, `prescription_items`, `vaccination_records` |
| **LIS** | `lab_test_master`, `lab_test_profiles`, `lab_profile_tests`, `lab_reference_ranges`, `lab_orders`, `lab_order_items`, `lab_samples`, `lab_results` |
| **RIS** | `imaging_modalities`, `radiology_orders`, `radiology_studies`, `radiology_reports` |
| **Pharmacy** | `drug_catalog`, `drug_price_list`, `pharmacy_inventory`, `dispensing_records`, `drug_interactions` |
| **Billing** | `service_charge_master`, `service_price_list`, `billing_packages`, `billing_package_items`, `invoices`, `invoice_items`, `payments`, `advance_payments` |
| **Insurance** | `insurers`, `pre_authorizations`, `insurance_claims` |
| **HR** | `employees`, `attendance_records`, `payroll_periods`, `payroll_records` |
| **Supply Chain** | `vendors`, `purchase_orders`, `purchase_order_items`, `goods_receipt_notes`, `grn_items` |
| **Compliance** | `audit_logs`, `sensitive_data_access_log`, `legal_holds` |
| **Reporting** | `kpi_daily_operations`, `mv_daily_revenue`, `mv_monthly_patient_stats`, `mv_doctor_performance`, `mv_department_revenue` |

---

*End of Hospital ERP PostgreSQL Database Architecture v1.0*
