-- =====================================================================
-- STEP 21: Document Management
-- =====================================================================

CREATE TABLE document.folder (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    parent_id       UUID REFERENCES document.folder(id),
    name            TEXT NOT NULL,
    path            TEXT,                         -- materialized path
    owner_user_id   UUID,
    access_mode     TEXT DEFAULT 'private' CHECK (access_mode IN ('private','tenant','public','restricted')),
    created_at      TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE document.document (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    folder_id       UUID REFERENCES document.folder(id),
    name            TEXT NOT NULL,
    description     TEXT,
    doc_type        TEXT,
    mime_type       TEXT,
    file_size       BIGINT,
    hash_sha256     TEXT,
    storage_key     TEXT NOT NULL,                -- S3/GCS path
    storage_provider TEXT DEFAULT 's3',
    current_version_no INT DEFAULT 1,
    is_locked       BOOLEAN DEFAULT FALSE,
    locked_by       UUID,
    locked_until    TIMESTAMPTZ,
    retention_policy TEXT,
    retention_until DATE,
    is_legal_hold   BOOLEAN DEFAULT FALSE,
    virus_scanned   BOOLEAN DEFAULT FALSE,
    virus_status    TEXT CHECK (virus_status IN ('clean','infected','pending','failed')),
    ocr_text        TEXT,
    search_tsv      tsvector,
    tags            TEXT[],
    metadata        JSONB,
    owner_user_id   UUID,
    created_at      TIMESTAMPTZ DEFAULT NOW(),
    updated_at      TIMESTAMPTZ DEFAULT NOW(),
    deleted_at      TIMESTAMPTZ
);

CREATE TABLE document.document_version (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    document_id     UUID NOT NULL REFERENCES document.document(id) ON DELETE CASCADE,
    version_no      INT NOT NULL,
    storage_key     TEXT NOT NULL,
    file_size       BIGINT,
    hash_sha256     TEXT,
    uploaded_by     UUID,
    uploaded_at     TIMESTAMPTZ DEFAULT NOW(),
    comment         TEXT,
    UNIQUE (document_id, version_no)
);

CREATE TABLE document.document_link (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    document_id     UUID NOT NULL REFERENCES document.document(id) ON DELETE CASCADE,
    entity_type     TEXT NOT NULL,
    entity_id       UUID NOT NULL,
    link_type       TEXT DEFAULT 'attachment',
    created_at      TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE (document_id, entity_type, entity_id)
);

CREATE TABLE document.signature_request (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID NOT NULL,
    document_id     UUID NOT NULL REFERENCES document.document(id),
    requested_by    UUID NOT NULL,
    status          TEXT DEFAULT 'pending' CHECK (status IN ('pending','in_progress','completed','declined','expired','cancelled')),
    expires_at      TIMESTAMPTZ,
    completed_at    TIMESTAMPTZ,
    signed_document_id UUID REFERENCES document.document(id),
    provider        TEXT,
    external_id     TEXT,
    created_at      TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE document.signature_signer (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    request_id      UUID NOT NULL REFERENCES document.signature_request(id) ON DELETE CASCADE,
    sequence_no     INT NOT NULL,
    name            TEXT NOT NULL,
    email           core.email_t NOT NULL,
    role            TEXT,
    user_id         UUID REFERENCES iam.user(id),
    signed_at       TIMESTAMPTZ,
    ip_address      INET,
    signature_image_url TEXT,
    status          TEXT DEFAULT 'pending'
);

CREATE TABLE document.access_log (
    id              BIGSERIAL PRIMARY KEY,
    document_id     UUID NOT NULL,
    user_id         UUID,
    action          TEXT CHECK (action IN ('view','download','upload','edit','delete','share','print')),
    ip_address      INET,
    user_agent      TEXT,
    created_at      TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE document.sharing (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    document_id     UUID NOT NULL REFERENCES document.document(id) ON DELETE CASCADE,
    shared_with_type TEXT CHECK (shared_with_type IN ('user','role','email','public_link')),
    shared_with_id  UUID,
    shared_email    TEXT,
    access_level    TEXT CHECK (access_level IN ('view','comment','edit','owner')),
    link_token      TEXT UNIQUE,
    expires_at      TIMESTAMPTZ,
    password_hash   TEXT,
    created_by      UUID,
    created_at      TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE document.workflow (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    document_id     UUID NOT NULL REFERENCES document.document(id) ON DELETE CASCADE,
    workflow_type   TEXT,
    current_step    INT,
    status          TEXT DEFAULT 'open',
    steps           JSONB
);

-- =====================================================================
-- INDEXES
-- =====================================================================
CREATE INDEX idx_document_folder       ON document.document(folder_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_document_tsv          ON document.document USING gin (search_tsv);
CREATE INDEX idx_document_tags         ON document.document USING gin (tags);
CREATE INDEX idx_document_hash         ON document.document(hash_sha256);
CREATE INDEX idx_document_link         ON document.document_link(entity_type, entity_id);
CREATE INDEX idx_sig_request_status    ON document.signature_request(status);
CREATE INDEX idx_access_log_doc_time   ON document.access_log(document_id, created_at DESC);
CREATE INDEX idx_document_retention    ON document.document(retention_until) WHERE retention_until IS NOT NULL;

-- =====================================================================
-- FUNCTIONS
-- =====================================================================
CREATE OR REPLACE FUNCTION document.fn_doc_tsv() RETURNS TRIGGER AS $$
BEGIN
    NEW.search_tsv := to_tsvector('english',
        coalesce(NEW.name,'')||' '||coalesce(NEW.description,'')||' '||
        coalesce(NEW.ocr_text,'')||' '||coalesce(array_to_string(NEW.tags,' '),''));
    RETURN NEW;
END; $$ LANGUAGE plpgsql;
CREATE TRIGGER trg_doc_tsv BEFORE INSERT OR UPDATE ON document.document
    FOR EACH ROW EXECUTE FUNCTION document.fn_doc_tsv();

CREATE OR REPLACE FUNCTION document.fn_new_version(p_doc UUID, p_key TEXT, p_size BIGINT, p_hash TEXT, p_user UUID, p_comment TEXT)
RETURNS INT AS $$
DECLARE v_ver INT;
BEGIN
    SELECT current_version_no + 1 INTO v_ver FROM document.document WHERE id = p_doc;
    INSERT INTO document.document_version(document_id, version_no, storage_key, file_size, hash_sha256, uploaded_by, comment)
    VALUES (p_doc, v_ver, p_key, p_size, p_hash, p_user, p_comment);
    UPDATE document.document SET current_version_no = v_ver, storage_key = p_key,
           file_size = p_size, hash_sha256 = p_hash, updated_at = NOW()
     WHERE id = p_doc;
    RETURN v_ver;
END; $$ LANGUAGE plpgsql;
