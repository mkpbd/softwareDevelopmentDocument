-- =====================================================================
-- STEP 28: Security & Data Protection
-- =====================================================================

CREATE TABLE security.encryption_key (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID,
    key_alias       TEXT NOT NULL,
    kms_key_arn     TEXT,
    algorithm       TEXT DEFAULT 'AES-256-GCM',
    key_version     INT NOT NULL DEFAULT 1,
    purpose         TEXT,
    is_active       BOOLEAN DEFAULT TRUE,
    rotated_at      TIMESTAMPTZ,
    created_at      TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE (tenant_id, key_alias, key_version)
);

CREATE TABLE security.acl (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    entity_type     TEXT NOT NULL,
    entity_id       UUID NOT NULL,
    principal_type  TEXT CHECK (principal_type IN ('user','role','group','public')),
    principal_id    UUID,
    permission      TEXT NOT NULL,
    grant_type      TEXT CHECK (grant_type IN ('grant','deny')),
    granted_by      UUID,
    granted_at      TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE security.pii_classification (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    schema_name     TEXT NOT NULL,
    table_name      TEXT NOT NULL,
    column_name     TEXT NOT NULL,
    classification  TEXT CHECK (classification IN ('public','internal','confidential','restricted','pii','phi','pci')),
    mask_strategy   TEXT CHECK (mask_strategy IN ('none','partial','full','hash','tokenize','encrypt')),
    retention_days  INT,
    UNIQUE (schema_name, table_name, column_name)
);

CREATE TABLE security.data_subject_request (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    subject_type    TEXT CHECK (subject_type IN ('customer','employee','contact','user')),
    subject_id      UUID,
    subject_email   core.email_t,
    request_type    TEXT CHECK (request_type IN ('access','rectification','erasure','portability','restrict','object')),
    status          TEXT DEFAULT 'pending' CHECK (status IN ('pending','verified','in_progress','fulfilled','rejected','cancelled')),
    received_at     TIMESTAMPTZ DEFAULT NOW(),
    due_date        DATE,
    fulfilled_at    TIMESTAMPTZ,
    notes           TEXT,
    evidence_doc_id UUID
);

CREATE TABLE security.consent_record (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    subject_type    TEXT,
    subject_id      UUID,
    purpose         TEXT NOT NULL,
    consent_given   BOOLEAN NOT NULL,
    granted_at      TIMESTAMPTZ,
    revoked_at      TIMESTAMPTZ,
    ip_address      INET,
    evidence        JSONB
);

CREATE TABLE security.vulnerability (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID,
    discovered_at   TIMESTAMPTZ DEFAULT NOW(),
    source          TEXT,                         -- scanner/pentest/bug_bounty/internal
    cve_id          TEXT,
    severity        TEXT CHECK (severity IN ('info','low','medium','high','critical')),
    cvss_score      NUMERIC(4,1),
    component       TEXT,
    description     TEXT,
    recommendation  TEXT,
    status          TEXT DEFAULT 'open' CHECK (status IN ('open','in_progress','fixed','accepted_risk','wont_fix','false_positive')),
    remediated_at   TIMESTAMPTZ,
    remediated_by   UUID
);

CREATE TABLE security.pentest_report (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID,
    test_date       DATE NOT NULL,
    vendor          TEXT,
    scope           TEXT,
    report_doc_id   UUID,
    findings_count  INT,
    critical_count  INT,
    high_count      INT
);

CREATE TABLE security.compliance_control (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    framework       TEXT CHECK (framework IN ('soc2','iso27001','hipaa','pci_dss','gdpr','dpdp','ccpa','nist')),
    control_code    TEXT NOT NULL,
    description     TEXT,
    category        TEXT,
    UNIQUE (framework, control_code)
);

CREATE TABLE security.compliance_evidence (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    control_id      UUID NOT NULL REFERENCES security.compliance_control(id),
    status          TEXT CHECK (status IN ('compliant','non_compliant','partial','not_applicable','not_assessed')),
    evidence_doc_id UUID,
    assessed_by     UUID,
    assessed_at     TIMESTAMPTZ,
    next_review_date DATE,
    notes           TEXT
);

CREATE TABLE security.security_incident (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID,
    incident_no     TEXT NOT NULL,
    reported_at     TIMESTAMPTZ DEFAULT NOW(),
    incident_type   TEXT,                         -- breach/unauthorized_access/malware/ddos/phishing
    severity        TEXT,
    description     TEXT,
    affected_records INT,
    status          TEXT DEFAULT 'investigating',
    containment_at  TIMESTAMPTZ,
    resolved_at     TIMESTAMPTZ,
    root_cause      TEXT,
    remediation     TEXT,
    notification_required BOOLEAN,
    notified_at     TIMESTAMPTZ,
    UNIQUE (tenant_id, incident_no)
);

CREATE TABLE security.rate_limit (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID,
    scope           TEXT CHECK (scope IN ('ip','user','api_key','endpoint','global')),
    scope_id        TEXT,
    limit_per_min   INT,
    limit_per_hour  INT,
    limit_per_day   INT
);

CREATE TABLE security.rate_limit_violation (
    id              BIGSERIAL PRIMARY KEY,
    limit_id        UUID,
    scope_id        TEXT,
    violation_at    TIMESTAMPTZ DEFAULT NOW(),
    request_count   INT
);

CREATE TABLE security.threat_event (
    id              BIGSERIAL PRIMARY KEY,
    tenant_id       UUID,
    detected_at     TIMESTAMPTZ DEFAULT NOW(),
    event_type      TEXT,                         -- brute_force/sql_inj/xss/csrf/suspicious_login
    source_ip       INET,
    target          TEXT,
    user_id         UUID,
    severity        TEXT,
    payload         JSONB,
    action_taken    TEXT,
    siem_alert_id   TEXT
);

-- =====================================================================
-- INDEXES
-- =====================================================================
CREATE INDEX idx_acl_entity            ON security.acl(entity_type, entity_id);
CREATE INDEX idx_acl_principal         ON security.acl(principal_type, principal_id);
CREATE INDEX idx_pii_schema_table      ON security.pii_classification(schema_name, table_name);
CREATE INDEX idx_dsr_status            ON security.data_subject_request(tenant_id, status);
CREATE INDEX idx_vuln_status_sev       ON security.vulnerability(status, severity);
CREATE INDEX idx_threat_tenant_time    ON security.threat_event(tenant_id, detected_at DESC);
CREATE INDEX idx_incident_status       ON security.security_incident(status);

-- =====================================================================
-- FUNCTIONS
-- =====================================================================

-- PII masking helper (partial)
CREATE OR REPLACE FUNCTION security.fn_mask_email(p_email TEXT)
RETURNS TEXT AS $$
BEGIN
    IF p_email IS NULL OR position('@' in p_email) = 0 THEN RETURN p_email; END IF;
    RETURN left(split_part(p_email,'@',1),2) || '***@' || split_part(p_email,'@',2);
END; $$ LANGUAGE plpgsql IMMUTABLE;

CREATE OR REPLACE FUNCTION security.fn_mask_phone(p_phone TEXT)
RETURNS TEXT AS $$
BEGIN
    IF p_phone IS NULL THEN RETURN p_phone; END IF;
    RETURN repeat('*', GREATEST(length(p_phone) - 4, 0)) || right(p_phone, 4);
END; $$ LANGUAGE plpgsql IMMUTABLE;

-- Row-level security enable (example on a few tables)
ALTER TABLE sales.customer ENABLE ROW LEVEL SECURITY;
CREATE POLICY tenant_iso_customer ON sales.customer
    USING (tenant_id = core.fn_current_tenant());

ALTER TABLE purchase.supplier ENABLE ROW LEVEL SECURITY;
CREATE POLICY tenant_iso_supplier ON purchase.supplier
    USING (tenant_id = core.fn_current_tenant());

ALTER TABLE hr.employee ENABLE ROW LEVEL SECURITY;
CREATE POLICY tenant_iso_employee ON hr.employee
    USING (tenant_id = core.fn_current_tenant());
