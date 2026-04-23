-- =====================================================================
-- ERP/HRM/CRM — Phase 1 MVP — PostgreSQL DB (shared-DB multi-tenant + RLS)
-- File: 00_bootstrap.sql
-- Purpose: extensions, tenant context, audit helpers, RLS helpers
-- Run first. All module files depend on this.
-- =====================================================================

-- ---------- EXTENSIONS ----------
CREATE EXTENSION IF NOT EXISTS pgcrypto;       -- gen_random_uuid, crypt
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";    -- uuid_generate_v4 (fallback)
CREATE EXTENSION IF NOT EXISTS citext;         -- case-insensitive text (emails)
CREATE EXTENSION IF NOT EXISTS pg_trgm;        -- trigram search
CREATE EXTENSION IF NOT EXISTS btree_gin;      -- gin w/ btree ops (composite)
CREATE EXTENSION IF NOT EXISTS btree_gist;     -- exclusion constraints
CREATE EXTENSION IF NOT EXISTS unaccent;       -- accent-insensitive search
CREATE EXTENSION IF NOT EXISTS pg_stat_statements; -- query profiling

-- ---------- SCHEMAS ----------
CREATE SCHEMA IF NOT EXISTS core;
CREATE SCHEMA IF NOT EXISTS app;
CREATE SCHEMA IF NOT EXISTS audit;
CREATE SCHEMA IF NOT EXISTS ops;

SET search_path = app, core, public;

-- ---------- TENANT CONTEXT ----------
-- Set per connection/transaction:
--   SELECT set_config('app.tenant_id', '<uuid>', true);
--   SELECT set_config('app.user_id',   '<uuid>', true);
-- All RLS policies read these.

CREATE OR REPLACE FUNCTION core.current_tenant_id()
RETURNS uuid
LANGUAGE sql
STABLE
AS $$
  SELECT NULLIF(current_setting('app.tenant_id', true), '')::uuid
$$;

CREATE OR REPLACE FUNCTION core.current_user_id()
RETURNS uuid
LANGUAGE sql
STABLE
AS $$
  SELECT NULLIF(current_setting('app.user_id', true), '')::uuid
$$;

CREATE OR REPLACE FUNCTION core.require_tenant()
RETURNS uuid
LANGUAGE plpgsql
STABLE
AS $$
DECLARE
  t uuid := core.current_tenant_id();
BEGIN
  IF t IS NULL THEN
    RAISE EXCEPTION 'tenant context not set (app.tenant_id)' USING ERRCODE = '42501';
  END IF;
  RETURN t;
END $$;

-- ---------- AUDIT HELPERS ----------
-- Standard audit columns: created_at, updated_at, created_by, updated_by, version
-- Every domain table includes them. Triggers below set them automatically.

CREATE OR REPLACE FUNCTION core.tg_set_timestamps()
RETURNS trigger
LANGUAGE plpgsql
AS $$
BEGIN
  IF TG_OP = 'INSERT' THEN
    NEW.created_at := COALESCE(NEW.created_at, now());
    NEW.updated_at := COALESCE(NEW.updated_at, now());
    NEW.created_by := COALESCE(NEW.created_by, core.current_user_id());
    NEW.updated_by := COALESCE(NEW.updated_by, core.current_user_id());
    NEW.version    := 1;
  ELSIF TG_OP = 'UPDATE' THEN
    NEW.created_at := OLD.created_at;
    NEW.created_by := OLD.created_by;
    NEW.updated_at := now();
    NEW.updated_by := core.current_user_id();
    NEW.version    := COALESCE(OLD.version, 1) + 1;
  END IF;
  RETURN NEW;
END $$;

-- ---------- TENANT GUARD ----------
-- Prevents tenant_id tampering on UPDATE; auto-fills on INSERT.
CREATE OR REPLACE FUNCTION core.tg_enforce_tenant()
RETURNS trigger
LANGUAGE plpgsql
AS $$
DECLARE
  ctx_tenant uuid := core.require_tenant();
BEGIN
  IF TG_OP = 'INSERT' THEN
    IF NEW.tenant_id IS NULL THEN
      NEW.tenant_id := ctx_tenant;
    ELSIF NEW.tenant_id <> ctx_tenant THEN
      RAISE EXCEPTION 'tenant_id mismatch: ctx=% row=%', ctx_tenant, NEW.tenant_id
        USING ERRCODE = '42501';
    END IF;
  ELSIF TG_OP = 'UPDATE' THEN
    IF NEW.tenant_id <> OLD.tenant_id THEN
      RAISE EXCEPTION 'tenant_id immutable' USING ERRCODE = '42501';
    END IF;
  END IF;
  RETURN NEW;
END $$;

-- ---------- GENERIC AUDIT LOG TABLE ----------
CREATE TABLE IF NOT EXISTS audit.change_log (
  id            bigserial PRIMARY KEY,
  tenant_id     uuid,
  table_schema  text NOT NULL,
  table_name    text NOT NULL,
  row_pk        text NOT NULL,
  op            char(1) NOT NULL CHECK (op IN ('I','U','D')),
  old_row       jsonb,
  new_row       jsonb,
  changed_cols  text[],
  changed_by    uuid,
  changed_at    timestamptz NOT NULL DEFAULT now(),
  txid          bigint NOT NULL DEFAULT txid_current()
);
CREATE INDEX IF NOT EXISTS idx_change_log_tenant_time ON audit.change_log(tenant_id, changed_at DESC);
CREATE INDEX IF NOT EXISTS idx_change_log_entity      ON audit.change_log(table_schema, table_name, row_pk);
CREATE INDEX IF NOT EXISTS idx_change_log_txid        ON audit.change_log(txid);

CREATE OR REPLACE FUNCTION core.tg_audit_row()
RETURNS trigger
LANGUAGE plpgsql
AS $$
DECLARE
  v_old jsonb; v_new jsonb; v_cols text[]; v_pk text;
BEGIN
  IF TG_OP = 'INSERT' THEN
    v_new := to_jsonb(NEW); v_pk := (v_new->>'id');
  ELSIF TG_OP = 'UPDATE' THEN
    v_old := to_jsonb(OLD); v_new := to_jsonb(NEW); v_pk := (v_new->>'id');
    SELECT array_agg(k) INTO v_cols
      FROM jsonb_each(v_new) k_full(k,v)
      WHERE v_new->k_full.k IS DISTINCT FROM v_old->k_full.k;
  ELSE
    v_old := to_jsonb(OLD); v_pk := (v_old->>'id');
  END IF;

  INSERT INTO audit.change_log(tenant_id,table_schema,table_name,row_pk,op,old_row,new_row,changed_cols,changed_by)
  VALUES (
    COALESCE((COALESCE(v_new,v_old)->>'tenant_id')::uuid, core.current_tenant_id()),
    TG_TABLE_SCHEMA, TG_TABLE_NAME, v_pk,
    LEFT(TG_OP,1), v_old, v_new, v_cols, core.current_user_id()
  );
  RETURN COALESCE(NEW, OLD);
END $$;

-- ---------- RLS HELPER ----------
-- Attach to a tenant-scoped table:
--   SELECT core.enable_tenant_rls('app.customers');
CREATE OR REPLACE FUNCTION core.enable_tenant_rls(p_table regclass)
RETURNS void
LANGUAGE plpgsql
AS $$
DECLARE
  v_schema text; v_name text;
BEGIN
  SELECT n.nspname, c.relname INTO v_schema, v_name
  FROM pg_class c JOIN pg_namespace n ON n.oid=c.relnamespace WHERE c.oid=p_table;

  EXECUTE format('ALTER TABLE %I.%I ENABLE ROW LEVEL SECURITY', v_schema, v_name);
  EXECUTE format('ALTER TABLE %I.%I FORCE ROW LEVEL SECURITY',  v_schema, v_name);

  EXECUTE format($f$DROP POLICY IF EXISTS tenant_isolation ON %I.%I$f$, v_schema, v_name);
  EXECUTE format($f$
    CREATE POLICY tenant_isolation ON %I.%I
      USING      (tenant_id = core.current_tenant_id())
      WITH CHECK (tenant_id = core.current_tenant_id())
  $f$, v_schema, v_name);
END $$;

-- ---------- STANDARD TRIGGER ATTACHER ----------
CREATE OR REPLACE FUNCTION core.attach_standard_triggers(p_table regclass)
RETURNS void
LANGUAGE plpgsql
AS $$
DECLARE
  v_schema text; v_name text;
BEGIN
  SELECT n.nspname, c.relname INTO v_schema, v_name
  FROM pg_class c JOIN pg_namespace n ON n.oid=c.relnamespace WHERE c.oid=p_table;

  EXECUTE format('DROP TRIGGER IF EXISTS trg_timestamps ON %I.%I', v_schema, v_name);
  EXECUTE format('CREATE TRIGGER trg_timestamps BEFORE INSERT OR UPDATE ON %I.%I
                  FOR EACH ROW EXECUTE FUNCTION core.tg_set_timestamps()',
                 v_schema, v_name);

  EXECUTE format('DROP TRIGGER IF EXISTS trg_tenant ON %I.%I', v_schema, v_name);
  EXECUTE format('CREATE TRIGGER trg_tenant BEFORE INSERT OR UPDATE ON %I.%I
                  FOR EACH ROW EXECUTE FUNCTION core.tg_enforce_tenant()',
                 v_schema, v_name);

  EXECUTE format('DROP TRIGGER IF EXISTS trg_audit ON %I.%I', v_schema, v_name);
  EXECUTE format('CREATE TRIGGER trg_audit AFTER INSERT OR UPDATE OR DELETE ON %I.%I
                  FOR EACH ROW EXECUTE FUNCTION core.tg_audit_row()',
                 v_schema, v_name);
END $$;

-- ---------- DOCUMENT NUMBERING (used by sales/purchase/inv) ----------
CREATE OR REPLACE FUNCTION core.next_doc_number(p_sequence_code text)
RETURNS text
LANGUAGE plpgsql
AS $$
DECLARE
  v_tenant uuid := core.require_tenant();
  v_prefix text; v_pad int; v_next bigint; v_format text;
BEGIN
  UPDATE app.document_sequences
     SET current_value = current_value + 1,
         updated_at    = now()
   WHERE tenant_id = v_tenant AND code = p_sequence_code
   RETURNING prefix, padding, current_value, format INTO v_prefix, v_pad, v_next, v_format;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'sequence not found: %', p_sequence_code USING ERRCODE='P0002';
  END IF;

  RETURN COALESCE(v_prefix,'') || lpad(v_next::text, v_pad, '0');
END $$;

-- ---------- MONEY / DECIMAL HELPERS ----------
-- All money columns: numeric(19,4). Rates: numeric(19,8).
-- Quantities: numeric(19,6).

COMMENT ON SCHEMA core  IS 'Framework: helpers, tenant context, audit';
COMMENT ON SCHEMA app   IS 'Business domain tables';
COMMENT ON SCHEMA audit IS 'Change log, auth events';
COMMENT ON SCHEMA ops   IS 'System ops: jobs, metrics, webhooks';
