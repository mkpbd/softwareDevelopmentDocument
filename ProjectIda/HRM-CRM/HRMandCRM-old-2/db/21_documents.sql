-- =====================================================================
-- Module 21: Document Management
-- Covers PRD Step 21
-- =====================================================================

SET search_path = app, core, public;

-- =============== SCHEMA ===============

CREATE TABLE IF NOT EXISTS app.documents (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL,
  name            text NOT NULL,
  mime_type       text NOT NULL,
  size_bytes      bigint NOT NULL CHECK (size_bytes >= 0),
  storage_key     text NOT NULL,                  -- S3/GCS object key
  storage_bucket  text NOT NULL,
  sha256          text NOT NULL,
  virus_scan_status text NOT NULL DEFAULT 'pending'
                  CHECK (virus_scan_status IN ('pending','clean','infected','skipped','error')),
  virus_scan_at   timestamptz,
  ocr_text        text,
  ocr_status      text NOT NULL DEFAULT 'pending'
                  CHECK (ocr_status IN ('pending','done','failed','skipped')),
  tags            text[] NOT NULL DEFAULT '{}',
  retention_until date,
  encrypted       boolean NOT NULL DEFAULT true,
  watermarked     boolean NOT NULL DEFAULT false,
  created_at      timestamptz NOT NULL DEFAULT now(),
  updated_at      timestamptz NOT NULL DEFAULT now(),
  created_by      uuid, updated_by uuid, version int NOT NULL DEFAULT 1
);

CREATE TABLE IF NOT EXISTS app.document_versions (
  id            uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id     uuid NOT NULL,
  document_id   uuid NOT NULL REFERENCES app.documents(id) ON DELETE CASCADE,
  version_no    int NOT NULL,
  storage_key   text NOT NULL,
  size_bytes    bigint NOT NULL,
  sha256        text NOT NULL,
  change_notes  text,
  created_at    timestamptz NOT NULL DEFAULT now(),
  created_by    uuid,
  UNIQUE (document_id, version_no)
);

CREATE TABLE IF NOT EXISTS app.document_links (
  id            uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id     uuid NOT NULL,
  document_id   uuid NOT NULL REFERENCES app.documents(id) ON DELETE CASCADE,
  entity_type   text NOT NULL,            -- 'sales_invoice', 'po', 'customer', ...
  entity_id     uuid NOT NULL,
  link_type     text NOT NULL DEFAULT 'attachment'
                CHECK (link_type IN ('attachment','primary','supporting','signed','proof')),
  created_at    timestamptz NOT NULL DEFAULT now(),
  created_by    uuid,
  UNIQUE (document_id, entity_type, entity_id, link_type)
);

CREATE TABLE IF NOT EXISTS app.document_signatures (
  id            uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id     uuid NOT NULL,
  document_id   uuid NOT NULL REFERENCES app.documents(id) ON DELETE CASCADE,
  signer_user_id uuid REFERENCES app.users(id),
  signer_name   text NOT NULL,
  signer_email  citext,
  signature_method text NOT NULL CHECK (signature_method IN ('esign','digital','aadhaar','wet')),
  signature_data bytea,
  cert_thumbprint text,
  signed_at     timestamptz,
  ip_address    inet,
  status        text NOT NULL DEFAULT 'pending'
                CHECK (status IN ('pending','signed','declined','expired')),
  created_at    timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS audit.document_access_log (
  id            bigserial PRIMARY KEY,
  tenant_id     uuid,
  document_id   uuid NOT NULL,
  user_id       uuid,
  action        text NOT NULL CHECK (action IN ('view','download','print','share','delete')),
  ip_address    inet,
  accessed_at   timestamptz NOT NULL DEFAULT now()
);

-- =============== INDEXES ===============
CREATE INDEX IF NOT EXISTS idx_docs_tenant           ON app.documents(tenant_id, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_docs_sha256           ON app.documents(sha256);
CREATE INDEX IF NOT EXISTS idx_docs_tags_gin         ON app.documents USING gin (tags);
CREATE INDEX IF NOT EXISTS idx_docs_ocr_fts          ON app.documents USING gin (to_tsvector('simple', COALESCE(ocr_text,'')));
CREATE INDEX IF NOT EXISTS idx_docs_name_trgm        ON app.documents USING gin (name gin_trgm_ops);
CREATE INDEX IF NOT EXISTS idx_doclinks_entity       ON app.document_links(entity_type, entity_id);
CREATE INDEX IF NOT EXISTS idx_docversions_doc       ON app.document_versions(document_id, version_no DESC);
CREATE INDEX IF NOT EXISTS idx_docsig_doc            ON app.document_signatures(document_id, status);
CREATE INDEX IF NOT EXISTS idx_docaccess_tenant_time ON audit.document_access_log(tenant_id, accessed_at DESC);
CREATE INDEX IF NOT EXISTS idx_docs_retention        ON app.documents(retention_until) WHERE retention_until IS NOT NULL;

-- =============== RLS ===============
SELECT core.enable_tenant_rls('app.documents');
SELECT core.enable_tenant_rls('app.document_versions');
SELECT core.enable_tenant_rls('app.document_links');
SELECT core.enable_tenant_rls('app.document_signatures');

-- =============== TRIGGERS ===============
SELECT core.attach_standard_triggers('app.documents');

-- Auto-increment version on content change (storage_key + sha256)
CREATE OR REPLACE FUNCTION core.tg_doc_version()
RETURNS trigger LANGUAGE plpgsql AS $$
DECLARE v_next int;
BEGIN
  IF TG_OP = 'UPDATE' AND (NEW.sha256 IS DISTINCT FROM OLD.sha256) THEN
    SELECT COALESCE(MAX(version_no),0)+1 INTO v_next
      FROM app.document_versions WHERE document_id = NEW.id;
    INSERT INTO app.document_versions(tenant_id,document_id,version_no,storage_key,size_bytes,sha256,created_by)
    VALUES (NEW.tenant_id, NEW.id, v_next, OLD.storage_key, OLD.size_bytes, OLD.sha256, core.current_user_id());
  END IF;
  RETURN NEW;
END $$;
DROP TRIGGER IF EXISTS trg_doc_version ON app.documents;
CREATE TRIGGER trg_doc_version AFTER UPDATE ON app.documents
  FOR EACH ROW EXECUTE FUNCTION core.tg_doc_version();

-- =============== FUNCTIONS ===============

CREATE OR REPLACE FUNCTION app.attach_document(
  p_document_id uuid, p_entity_type text, p_entity_id uuid, p_link_type text DEFAULT 'attachment'
) RETURNS uuid
LANGUAGE plpgsql AS $$
DECLARE v_id uuid := gen_random_uuid();
BEGIN
  INSERT INTO app.document_links(id,tenant_id,document_id,entity_type,entity_id,link_type,created_by)
  VALUES (v_id, core.require_tenant(), p_document_id, p_entity_type, p_entity_id, p_link_type, core.current_user_id())
  ON CONFLICT (document_id, entity_type, entity_id, link_type) DO UPDATE
    SET created_at = app.document_links.created_at
  RETURNING id INTO v_id;
  RETURN v_id;
END $$;

CREATE OR REPLACE FUNCTION app.purge_expired_documents()
RETURNS int
LANGUAGE plpgsql AS $$
DECLARE v_count int;
BEGIN
  DELETE FROM app.documents
   WHERE retention_until IS NOT NULL
     AND retention_until < CURRENT_DATE;
  GET DIAGNOSTICS v_count = ROW_COUNT;
  RETURN v_count;
END $$;

-- =============== VIEWS ===============
CREATE OR REPLACE VIEW app.v_entity_documents AS
SELECT dl.tenant_id, dl.entity_type, dl.entity_id,
       d.id document_id, d.name, d.mime_type, d.size_bytes, d.created_at
  FROM app.document_links dl
  JOIN app.documents d ON d.id = dl.document_id;
