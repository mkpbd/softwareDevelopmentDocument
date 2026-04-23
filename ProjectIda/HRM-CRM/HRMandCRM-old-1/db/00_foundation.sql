-- =====================================================================
-- FOUNDATION: extensions, schemas, enums, audit infra, shared utilities
-- =====================================================================

-- Extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";
CREATE EXTENSION IF NOT EXISTS "citext";
CREATE EXTENSION IF NOT EXISTS "pg_trgm";
CREATE EXTENSION IF NOT EXISTS "btree_gin";
CREATE EXTENSION IF NOT EXISTS "btree_gist";
CREATE EXTENSION IF NOT EXISTS "hstore";
CREATE EXTENSION IF NOT EXISTS "unaccent";
CREATE EXTENSION IF NOT EXISTS "pg_stat_statements";

-- Schemas (logical module separation; default search_path stays public for app compatibility)
CREATE SCHEMA IF NOT EXISTS core;
CREATE SCHEMA IF NOT EXISTS iam;
CREATE SCHEMA IF NOT EXISTS finance;
CREATE SCHEMA IF NOT EXISTS tax;
CREATE SCHEMA IF NOT EXISTS sales;
CREATE SCHEMA IF NOT EXISTS purchase;
CREATE SCHEMA IF NOT EXISTS inventory;
CREATE SCHEMA IF NOT EXISTS manufacturing;
CREATE SCHEMA IF NOT EXISTS quality;
CREATE SCHEMA IF NOT EXISTS planning;
CREATE SCHEMA IF NOT EXISTS crm;
CREATE SCHEMA IF NOT EXISTS hr;
CREATE SCHEMA IF NOT EXISTS attendance;
CREATE SCHEMA IF NOT EXISTS payroll;
CREATE SCHEMA IF NOT EXISTS asset;
CREATE SCHEMA IF NOT EXISTS project;
CREATE SCHEMA IF NOT EXISTS service;
CREATE SCHEMA IF NOT EXISTS logistics;
CREATE SCHEMA IF NOT EXISTS pos;
CREATE SCHEMA IF NOT EXISTS subscription;
CREATE SCHEMA IF NOT EXISTS document;
CREATE SCHEMA IF NOT EXISTS workflow;
CREATE SCHEMA IF NOT EXISTS notify;
CREATE SCHEMA IF NOT EXISTS integration;
CREATE SCHEMA IF NOT EXISTS data_mgmt;
CREATE SCHEMA IF NOT EXISTS reporting;
CREATE SCHEMA IF NOT EXISTS bi_ai;
CREATE SCHEMA IF NOT EXISTS security;
CREATE SCHEMA IF NOT EXISTS observability;
CREATE SCHEMA IF NOT EXISTS mobile;
CREATE SCHEMA IF NOT EXISTS portal;
CREATE SCHEMA IF NOT EXISTS canteen;
CREATE SCHEMA IF NOT EXISTS audit;

-- =====================================================================
-- Global enums (referenced across modules)
-- =====================================================================
CREATE TYPE core.status_generic AS ENUM ('draft','active','inactive','archived','deleted');
CREATE TYPE core.approval_state AS ENUM ('pending','approved','rejected','cancelled','withdrawn');
CREATE TYPE core.doc_state AS ENUM ('draft','submitted','approved','posted','cancelled','void');
CREATE TYPE core.currency_code AS ENUM ('INR','USD','EUR','GBP','AED','SGD','AUD','CAD','JPY','CNY');
CREATE TYPE core.address_type AS ENUM ('billing','shipping','registered','branch','home','other');
CREATE TYPE core.contact_type AS ENUM ('phone','mobile','email','fax','whatsapp','telegram');
CREATE TYPE core.gender AS ENUM ('male','female','other','prefer_not_to_say');
CREATE TYPE core.party_type AS ENUM ('customer','vendor','employee','lead','contractor','other');

-- =====================================================================
-- Audit infrastructure
-- =====================================================================
CREATE TABLE audit.audit_log (
    id              BIGSERIAL PRIMARY KEY,
    tenant_id       UUID,
    actor_user_id   UUID,
    actor_ip        INET,
    action          TEXT NOT NULL,           -- INSERT/UPDATE/DELETE/LOGIN/...
    object_schema   TEXT,
    object_table    TEXT,
    object_id       TEXT,
    old_data        JSONB,
    new_data        JSONB,
    diff            JSONB,
    metadata        JSONB,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
) PARTITION BY RANGE (created_at);

CREATE INDEX idx_audit_log_tenant_time ON audit.audit_log (tenant_id, created_at DESC);
CREATE INDEX idx_audit_log_object     ON audit.audit_log (object_schema, object_table, object_id);
CREATE INDEX idx_audit_log_actor      ON audit.audit_log (actor_user_id, created_at DESC);
CREATE INDEX idx_audit_log_new_data   ON audit.audit_log USING gin (new_data);

-- Monthly partitions (template; create via automation)
CREATE TABLE audit.audit_log_default PARTITION OF audit.audit_log DEFAULT;

-- =====================================================================
-- Shared helpers
-- =====================================================================

-- Standard updated_at trigger fn
CREATE OR REPLACE FUNCTION core.fn_set_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    IF TG_OP = 'UPDATE' THEN
        NEW.updated_by = COALESCE(NEW.updated_by, current_setting('app.current_user_id', true)::uuid);
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Generic audit trigger fn (JSONB diff)
CREATE OR REPLACE FUNCTION audit.fn_row_audit()
RETURNS TRIGGER AS $$
DECLARE
    v_old JSONB;
    v_new JSONB;
    v_tenant UUID := NULLIF(current_setting('app.tenant_id', true), '')::uuid;
    v_actor  UUID := NULLIF(current_setting('app.current_user_id', true), '')::uuid;
    v_ip     INET := NULLIF(current_setting('app.client_ip', true), '')::inet;
BEGIN
    IF TG_OP = 'DELETE' THEN
        v_old := to_jsonb(OLD);
    ELSIF TG_OP = 'INSERT' THEN
        v_new := to_jsonb(NEW);
    ELSE
        v_old := to_jsonb(OLD);
        v_new := to_jsonb(NEW);
    END IF;

    INSERT INTO audit.audit_log(tenant_id, actor_user_id, actor_ip, action,
        object_schema, object_table, object_id, old_data, new_data, diff)
    VALUES (
        v_tenant, v_actor, v_ip, TG_OP,
        TG_TABLE_SCHEMA, TG_TABLE_NAME,
        COALESCE((v_new->>'id'), (v_old->>'id')),
        v_old, v_new,
        CASE WHEN TG_OP='UPDATE' THEN
            (SELECT jsonb_object_agg(k, v_new->k)
             FROM jsonb_object_keys(v_new) k
             WHERE v_new->k IS DISTINCT FROM v_old->k)
        END
    );
    RETURN COALESCE(NEW, OLD);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Soft-delete guard
CREATE OR REPLACE FUNCTION core.fn_soft_delete_guard()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'DELETE' AND current_setting('app.allow_hard_delete', true) IS DISTINCT FROM 'true' THEN
        UPDATE ONLY TG_RELID::regclass::text::regclass
            SET deleted_at = NOW() WHERE id = OLD.id;
        RETURN NULL;
    END IF;
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

-- Document numbering helper (used by all doc-producing modules)
CREATE TABLE core.doc_number_sequence (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    doc_type        TEXT NOT NULL,           -- 'sales_invoice','purchase_order',...
    branch_id       UUID,
    fiscal_year_id  UUID,
    prefix          TEXT DEFAULT '',
    suffix          TEXT DEFAULT '',
    padding         INT  DEFAULT 6 CHECK (padding BETWEEN 0 AND 12),
    next_value      BIGINT NOT NULL DEFAULT 1,
    reset_policy    TEXT DEFAULT 'never' CHECK (reset_policy IN ('never','yearly','monthly','daily')),
    last_reset_at   TIMESTAMPTZ,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE (tenant_id, doc_type, branch_id, fiscal_year_id)
);

CREATE OR REPLACE FUNCTION core.fn_next_doc_number(
    p_tenant_id UUID,
    p_doc_type  TEXT,
    p_branch_id UUID DEFAULT NULL,
    p_fy_id     UUID DEFAULT NULL
) RETURNS TEXT AS $$
DECLARE
    v_seq core.doc_number_sequence%ROWTYPE;
    v_num TEXT;
BEGIN
    SELECT * INTO v_seq
      FROM core.doc_number_sequence
     WHERE tenant_id = p_tenant_id
       AND doc_type  = p_doc_type
       AND branch_id IS NOT DISTINCT FROM p_branch_id
       AND fiscal_year_id IS NOT DISTINCT FROM p_fy_id
     FOR UPDATE;

    IF NOT FOUND THEN
        INSERT INTO core.doc_number_sequence(tenant_id, doc_type, branch_id, fiscal_year_id)
        VALUES (p_tenant_id, p_doc_type, p_branch_id, p_fy_id)
        RETURNING * INTO v_seq;
    END IF;

    v_num := v_seq.prefix || lpad(v_seq.next_value::text, v_seq.padding, '0') || v_seq.suffix;

    UPDATE core.doc_number_sequence
       SET next_value = next_value + 1,
           updated_at = NOW()
     WHERE id = v_seq.id;

    RETURN v_num;
END;
$$ LANGUAGE plpgsql;

-- Generic tenant-scoping RLS helper
CREATE OR REPLACE FUNCTION core.fn_current_tenant()
RETURNS UUID AS $$
    SELECT NULLIF(current_setting('app.tenant_id', true), '')::uuid;
$$ LANGUAGE sql STABLE;

-- Money type via numeric(19,4) standard everywhere
-- Use DOMAIN for consistency
CREATE DOMAIN core.money_amt AS NUMERIC(19,4) DEFAULT 0 NOT NULL;
CREATE DOMAIN core.qty_amt   AS NUMERIC(19,6) DEFAULT 0 NOT NULL;
CREATE DOMAIN core.pct_amt   AS NUMERIC(9,4) CHECK (VALUE BETWEEN -100 AND 1000) DEFAULT 0;
CREATE DOMAIN core.email_t   AS CITEXT CHECK (VALUE ~* '^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$');
CREATE DOMAIN core.phone_t   AS TEXT CHECK (VALUE ~ '^\+?[0-9 \-()]{6,20}$');
