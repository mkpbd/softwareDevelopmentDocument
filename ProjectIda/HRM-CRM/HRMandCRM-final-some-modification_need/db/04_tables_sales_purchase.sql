-- =============================================================================
-- tables.sql — Steps 5 & 6: Sales Management & Purchase Management
-- =============================================================================

-- =============================================================================
-- SHARED PARTY MASTER (Customers & Suppliers share contact/address structures)
-- =============================================================================

-- Addresses (reusable)
CREATE TABLE core.addresses (
    address_id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id           UUID         NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id           UUID         NOT NULL REFERENCES core.branches(branch_id),
    address_type        VARCHAR(50)  NOT NULL DEFAULT 'billing' CHECK (address_type IN ('billing','shipping','registered','correspondence','site')),
    line1               VARCHAR(255) NOT NULL,
    line2               VARCHAR(255),
    city                VARCHAR(100) NOT NULL,
    state_province      VARCHAR(100),
    country_code        VARCHAR(10)  NOT NULL DEFAULT 'IN',
    postal_code         VARCHAR(20),
    is_default          BOOLEAN      NOT NULL DEFAULT FALSE,
    created_by          UUID         NOT NULL,
    updated_by          UUID         NOT NULL,
    deleted_by          UUID,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    deleted_at          TIMESTAMPTZ
);

-- =============================================================================
-- STEP 5: SALES MANAGEMENT
-- =============================================================================

-- Customers
CREATE TABLE sales.customers (
    customer_id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id           UUID         NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id           UUID         NOT NULL REFERENCES core.branches(branch_id),
    customer_code       VARCHAR(50)  NOT NULL,
    customer_name       VARCHAR(255) NOT NULL,
    customer_type       VARCHAR(50)  NOT NULL DEFAULT 'business' CHECK (customer_type IN ('individual','business','government')),
    gstin               VARCHAR(20),
    pan_number          VARCHAR(20),
    email               VARCHAR(255),
    phone               VARCHAR(30),
    mobile              VARCHAR(30),
    website             VARCHAR(255),
    credit_limit        NUMERIC(20,2) NOT NULL DEFAULT 0,
    credit_days         SMALLINT     NOT NULL DEFAULT 30,
    outstanding_balance NUMERIC(20,2) NOT NULL DEFAULT 0,
    currency_code       VARCHAR(10)  NOT NULL DEFAULT 'INR',
    tax_category        VARCHAR(50)  NOT NULL DEFAULT 'registered' CHECK (tax_category IN ('registered','unregistered','composition','sez','export','government')),
    price_list_id       UUID,                          -- FK added after price_lists created
    payment_term_id     UUID,                          -- FK added after payment_terms created
    sales_person_id     UUID         REFERENCES iam.users(user_id),
    is_active           BOOLEAN      NOT NULL DEFAULT TRUE,
    notes               TEXT,
    created_by          UUID         NOT NULL,
    updated_by          UUID         NOT NULL,
    deleted_by          UUID,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    deleted_at          TIMESTAMPTZ,
    UNIQUE (tenant_id, customer_code)
);

-- Customer Addresses (link table)
CREATE TABLE sales.customer_addresses (
    customer_address_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id           UUID         NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id           UUID         NOT NULL REFERENCES core.branches(branch_id),
    customer_id         UUID         NOT NULL REFERENCES sales.customers(customer_id),
    address_id          UUID         NOT NULL REFERENCES core.addresses(address_id),
    address_type        VARCHAR(50)  NOT NULL DEFAULT 'billing',
    is_default          BOOLEAN      NOT NULL DEFAULT FALSE,
    created_by          UUID         NOT NULL,
    updated_by          UUID         NOT NULL,
    deleted_by          UUID,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    deleted_at          TIMESTAMPTZ
);

-- Payment Terms
CREATE TABLE sales.payment_terms (
    payment_term_id     UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id           UUID         NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id           UUID         NOT NULL REFERENCES core.branches(branch_id),
    term_code           VARCHAR(50)  NOT NULL,
    term_name           VARCHAR(200) NOT NULL,
    net_days            SMALLINT     NOT NULL DEFAULT 30,
    discount_days       SMALLINT     NOT NULL DEFAULT 0,
    discount_percentage NUMERIC(8,4) NOT NULL DEFAULT 0,
    is_active           BOOLEAN      NOT NULL DEFAULT TRUE,
    created_by          UUID         NOT NULL,
    updated_by          UUID         NOT NULL,
    deleted_by          UUID,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    deleted_at          TIMESTAMPTZ,
    UNIQUE (tenant_id, term_code)
);

-- Price Lists
CREATE TABLE sales.price_lists (
    price_list_id       UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id           UUID         NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id           UUID         NOT NULL REFERENCES core.branches(branch_id),
    price_list_code     VARCHAR(50)  NOT NULL,
    price_list_name     VARCHAR(200) NOT NULL,
    currency_code       VARCHAR(10)  NOT NULL DEFAULT 'INR',
    price_list_type     VARCHAR(20)  NOT NULL DEFAULT 'selling' CHECK (price_list_type IN ('selling','purchasing','transfer')),
    is_default          BOOLEAN      NOT NULL DEFAULT FALSE,
    valid_from          DATE,
    valid_until         DATE,
    is_active           BOOLEAN      NOT NULL DEFAULT TRUE,
    created_by          UUID         NOT NULL,
    updated_by          UUID         NOT NULL,
    deleted_by          UUID,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    deleted_at          TIMESTAMPTZ,
    UNIQUE (tenant_id, price_list_code)
);

-- Sales Quotations
CREATE TABLE sales.sales_quotations (
    sales_quotation_id  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id           UUID         NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id           UUID         NOT NULL REFERENCES core.branches(branch_id),
    quotation_number    VARCHAR(50)  NOT NULL,
    quotation_date      DATE         NOT NULL,
    customer_id         UUID         NOT NULL REFERENCES sales.customers(customer_id),
    billing_address_id  UUID         REFERENCES core.addresses(address_id),
    shipping_address_id UUID         REFERENCES core.addresses(address_id),
    price_list_id       UUID         REFERENCES sales.price_lists(price_list_id),
    currency_code       VARCHAR(10)  NOT NULL DEFAULT 'INR',
    exchange_rate       NUMERIC(20,8) NOT NULL DEFAULT 1,
    validity_date       DATE,
    payment_term_id     UUID         REFERENCES sales.payment_terms(payment_term_id),
    sales_person_id     UUID         REFERENCES iam.users(user_id),
    opportunity_id      UUID,                          -- FK to crm.opportunities
    subtotal            NUMERIC(20,2) NOT NULL DEFAULT 0,
    discount_amount     NUMERIC(20,2) NOT NULL DEFAULT 0,
    taxable_amount      NUMERIC(20,2) NOT NULL DEFAULT 0,
    tax_amount          NUMERIC(20,2) NOT NULL DEFAULT 0,
    total_amount        NUMERIC(20,2) NOT NULL DEFAULT 0,
    status              VARCHAR(20)  NOT NULL DEFAULT 'draft' CHECK (status IN ('draft','sent','accepted','rejected','expired','converted')),
    notes               TEXT,
    terms_conditions    TEXT,
    created_by          UUID         NOT NULL,
    updated_by          UUID         NOT NULL,
    deleted_by          UUID,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    deleted_at          TIMESTAMPTZ,
    UNIQUE (tenant_id, branch_id, quotation_number)
);

-- Sales Quotation Lines
CREATE TABLE sales.sales_quotation_lines (
    sales_quotation_line_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id               UUID        NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id               UUID        NOT NULL REFERENCES core.branches(branch_id),
    sales_quotation_id      UUID        NOT NULL REFERENCES sales.sales_quotations(sales_quotation_id),
    line_number             SMALLINT    NOT NULL,
    item_id                 UUID        NOT NULL, -- FK to inventory.items
    item_description        TEXT,
    uom_id                  UUID        NOT NULL, -- FK to inventory.units_of_measure
    quantity                NUMERIC(20,4) NOT NULL CHECK (quantity > 0),
    unit_price              NUMERIC(20,4) NOT NULL DEFAULT 0,
    discount_percentage     NUMERIC(8,4) NOT NULL DEFAULT 0,
    discount_amount         NUMERIC(20,2) NOT NULL DEFAULT 0,
    taxable_amount          NUMERIC(20,2) NOT NULL DEFAULT 0,
    tax_rate_id             UUID        REFERENCES tax.tax_rates(tax_rate_id),
    tax_amount              NUMERIC(20,2) NOT NULL DEFAULT 0,
    line_total              NUMERIC(20,2) NOT NULL DEFAULT 0,
    created_by              UUID        NOT NULL,
    updated_by              UUID        NOT NULL,
    deleted_by              UUID,
    created_at              TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at              TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at              TIMESTAMPTZ,
    UNIQUE (tenant_id, sales_quotation_id, line_number)
);

-- Sales Orders
CREATE TABLE sales.sales_orders (
    sales_order_id      UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id           UUID         NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id           UUID         NOT NULL REFERENCES core.branches(branch_id),
    order_number        VARCHAR(50)  NOT NULL,
    order_date          DATE         NOT NULL,
    customer_id         UUID         NOT NULL REFERENCES sales.customers(customer_id),
    sales_quotation_id  UUID         REFERENCES sales.sales_quotations(sales_quotation_id),
    billing_address_id  UUID         REFERENCES core.addresses(address_id),
    shipping_address_id UUID         REFERENCES core.addresses(address_id),
    price_list_id       UUID         REFERENCES sales.price_lists(price_list_id),
    currency_code       VARCHAR(10)  NOT NULL DEFAULT 'INR',
    exchange_rate       NUMERIC(20,8) NOT NULL DEFAULT 1,
    requested_delivery_date DATE,
    payment_term_id     UUID         REFERENCES sales.payment_terms(payment_term_id),
    sales_person_id     UUID         REFERENCES iam.users(user_id),
    subtotal            NUMERIC(20,2) NOT NULL DEFAULT 0,
    discount_amount     NUMERIC(20,2) NOT NULL DEFAULT 0,
    taxable_amount      NUMERIC(20,2) NOT NULL DEFAULT 0,
    tax_amount          NUMERIC(20,2) NOT NULL DEFAULT 0,
    total_amount        NUMERIC(20,2) NOT NULL DEFAULT 0,
    delivered_amount    NUMERIC(20,2) NOT NULL DEFAULT 0,
    invoiced_amount     NUMERIC(20,2) NOT NULL DEFAULT 0,
    status              VARCHAR(30)  NOT NULL DEFAULT 'draft' CHECK (status IN ('draft','confirmed','processing','partially_delivered','delivered','invoiced','cancelled','on_hold')),
    notes               TEXT,
    terms_conditions    TEXT,
    created_by          UUID         NOT NULL,
    updated_by          UUID         NOT NULL,
    deleted_by          UUID,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    deleted_at          TIMESTAMPTZ,
    UNIQUE (tenant_id, branch_id, order_number)
);

-- Sales Order Lines
CREATE TABLE sales.sales_order_lines (
    sales_order_line_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id           UUID         NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id           UUID         NOT NULL REFERENCES core.branches(branch_id),
    sales_order_id      UUID         NOT NULL REFERENCES sales.sales_orders(sales_order_id),
    line_number         SMALLINT     NOT NULL,
    item_id             UUID         NOT NULL,
    item_description    TEXT,
    uom_id              UUID         NOT NULL,
    ordered_quantity    NUMERIC(20,4) NOT NULL CHECK (ordered_quantity > 0),
    delivered_quantity  NUMERIC(20,4) NOT NULL DEFAULT 0,
    invoiced_quantity   NUMERIC(20,4) NOT NULL DEFAULT 0,
    pending_quantity    NUMERIC(20,4) GENERATED ALWAYS AS (ordered_quantity - delivered_quantity) STORED,
    unit_price          NUMERIC(20,4) NOT NULL DEFAULT 0,
    discount_percentage NUMERIC(8,4)  NOT NULL DEFAULT 0,
    discount_amount     NUMERIC(20,2) NOT NULL DEFAULT 0,
    taxable_amount      NUMERIC(20,2) NOT NULL DEFAULT 0,
    tax_rate_id         UUID         REFERENCES tax.tax_rates(tax_rate_id),
    tax_amount          NUMERIC(20,2) NOT NULL DEFAULT 0,
    line_total          NUMERIC(20,2) NOT NULL DEFAULT 0,
    requested_delivery_date DATE,
    warehouse_id        UUID,                          -- FK to inventory.warehouses
    created_by          UUID         NOT NULL,
    updated_by          UUID         NOT NULL,
    deleted_by          UUID,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    deleted_at          TIMESTAMPTZ,
    UNIQUE (tenant_id, sales_order_id, line_number)
);

-- Delivery Notes
CREATE TABLE sales.delivery_notes (
    delivery_note_id    UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id           UUID         NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id           UUID         NOT NULL REFERENCES core.branches(branch_id),
    delivery_number     VARCHAR(50)  NOT NULL,
    delivery_date       DATE         NOT NULL,
    sales_order_id      UUID         NOT NULL REFERENCES sales.sales_orders(sales_order_id),
    customer_id         UUID         NOT NULL REFERENCES sales.customers(customer_id),
    shipping_address_id UUID         REFERENCES core.addresses(address_id),
    warehouse_id        UUID,
    vehicle_number      VARCHAR(30),
    driver_name         VARCHAR(100),
    eway_bill_id        UUID         REFERENCES tax.eway_bills(eway_bill_id),
    status              VARCHAR(20)  NOT NULL DEFAULT 'draft' CHECK (status IN ('draft','dispatched','delivered','cancelled')),
    dispatched_at       TIMESTAMPTZ,
    delivered_at        TIMESTAMPTZ,
    notes               TEXT,
    created_by          UUID         NOT NULL,
    updated_by          UUID         NOT NULL,
    deleted_by          UUID,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    deleted_at          TIMESTAMPTZ,
    UNIQUE (tenant_id, branch_id, delivery_number)
);

-- Delivery Note Lines
CREATE TABLE sales.delivery_note_lines (
    delivery_note_line_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id             UUID        NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id             UUID        NOT NULL REFERENCES core.branches(branch_id),
    delivery_note_id      UUID        NOT NULL REFERENCES sales.delivery_notes(delivery_note_id),
    sales_order_line_id   UUID        NOT NULL REFERENCES sales.sales_order_lines(sales_order_line_id),
    line_number           SMALLINT    NOT NULL,
    item_id               UUID        NOT NULL,
    uom_id                UUID        NOT NULL,
    ordered_quantity      NUMERIC(20,4) NOT NULL,
    delivered_quantity    NUMERIC(20,4) NOT NULL CHECK (delivered_quantity >= 0),
    batch_number          VARCHAR(100),
    serial_numbers        JSONB,
    created_by            UUID        NOT NULL,
    updated_by            UUID        NOT NULL,
    deleted_by            UUID,
    created_at            TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at            TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at            TIMESTAMPTZ
);

-- Sales Invoices
CREATE TABLE sales.sales_invoices (
    sales_invoice_id    UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id           UUID         NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id           UUID         NOT NULL REFERENCES core.branches(branch_id),
    invoice_number      VARCHAR(50)  NOT NULL,
    invoice_date        DATE         NOT NULL,
    due_date            DATE         NOT NULL,
    customer_id         UUID         NOT NULL REFERENCES sales.customers(customer_id),
    sales_order_id      UUID         REFERENCES sales.sales_orders(sales_order_id),
    delivery_note_id    UUID         REFERENCES sales.delivery_notes(delivery_note_id),
    billing_address_id  UUID         REFERENCES core.addresses(address_id),
    shipping_address_id UUID         REFERENCES core.addresses(address_id),
    currency_code       VARCHAR(10)  NOT NULL DEFAULT 'INR',
    exchange_rate       NUMERIC(20,8) NOT NULL DEFAULT 1,
    payment_term_id     UUID         REFERENCES sales.payment_terms(payment_term_id),
    subtotal            NUMERIC(20,2) NOT NULL DEFAULT 0,
    discount_amount     NUMERIC(20,2) NOT NULL DEFAULT 0,
    taxable_amount      NUMERIC(20,2) NOT NULL DEFAULT 0,
    cgst_amount         NUMERIC(20,2) NOT NULL DEFAULT 0,
    sgst_amount         NUMERIC(20,2) NOT NULL DEFAULT 0,
    igst_amount         NUMERIC(20,2) NOT NULL DEFAULT 0,
    cess_amount         NUMERIC(20,2) NOT NULL DEFAULT 0,
    total_tax_amount    NUMERIC(20,2) NOT NULL DEFAULT 0,
    total_amount        NUMERIC(20,2) NOT NULL DEFAULT 0,
    amount_paid         NUMERIC(20,2) NOT NULL DEFAULT 0,
    amount_outstanding  NUMERIC(20,2) GENERATED ALWAYS AS (total_amount - amount_paid) STORED,
    supply_type         VARCHAR(20)  NOT NULL DEFAULT 'intrastate' CHECK (supply_type IN ('intrastate','interstate','import','export','sez')),
    irn                 TEXT,
    eway_bill_id        UUID         REFERENCES tax.eway_bills(eway_bill_id),
    status              VARCHAR(20)  NOT NULL DEFAULT 'draft' CHECK (status IN ('draft','posted','partially_paid','paid','cancelled','written_off')),
    posted_at           TIMESTAMPTZ,
    journal_entry_id    UUID         REFERENCES finance.journal_entries(journal_entry_id),
    notes               TEXT,
    created_by          UUID         NOT NULL,
    updated_by          UUID         NOT NULL,
    deleted_by          UUID,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    deleted_at          TIMESTAMPTZ,
    UNIQUE (tenant_id, branch_id, invoice_number)
);

-- Sales Invoice Lines
CREATE TABLE sales.sales_invoice_lines (
    sales_invoice_line_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id             UUID        NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id             UUID        NOT NULL REFERENCES core.branches(branch_id),
    sales_invoice_id      UUID        NOT NULL REFERENCES sales.sales_invoices(sales_invoice_id),
    line_number           SMALLINT    NOT NULL,
    item_id               UUID        NOT NULL,
    item_description      TEXT,
    hsn_sac_code_id       UUID        REFERENCES tax.hsn_sac_codes(hsn_sac_code_id),
    uom_id                UUID        NOT NULL,
    quantity              NUMERIC(20,4) NOT NULL CHECK (quantity > 0),
    unit_price            NUMERIC(20,4) NOT NULL DEFAULT 0,
    discount_percentage   NUMERIC(8,4)  NOT NULL DEFAULT 0,
    discount_amount       NUMERIC(20,2) NOT NULL DEFAULT 0,
    taxable_amount        NUMERIC(20,2) NOT NULL DEFAULT 0,
    tax_rate_id           UUID        REFERENCES tax.tax_rates(tax_rate_id),
    cgst_amount           NUMERIC(20,2) NOT NULL DEFAULT 0,
    sgst_amount           NUMERIC(20,2) NOT NULL DEFAULT 0,
    igst_amount           NUMERIC(20,2) NOT NULL DEFAULT 0,
    cess_amount           NUMERIC(20,2) NOT NULL DEFAULT 0,
    tax_amount            NUMERIC(20,2) NOT NULL DEFAULT 0,
    line_total            NUMERIC(20,2) NOT NULL DEFAULT 0,
    created_by            UUID        NOT NULL,
    updated_by            UUID        NOT NULL,
    deleted_by            UUID,
    created_at            TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at            TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at            TIMESTAMPTZ,
    UNIQUE (tenant_id, sales_invoice_id, line_number)
);

-- Credit Notes
CREATE TABLE sales.credit_notes (
    credit_note_id      UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id           UUID         NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id           UUID         NOT NULL REFERENCES core.branches(branch_id),
    credit_note_number  VARCHAR(50)  NOT NULL,
    credit_note_date    DATE         NOT NULL,
    customer_id         UUID         NOT NULL REFERENCES sales.customers(customer_id),
    sales_invoice_id    UUID         REFERENCES sales.sales_invoices(sales_invoice_id),
    reason              VARCHAR(100) NOT NULL CHECK (reason IN ('return','price_correction','discount','damaged','quality_issue','other')),
    currency_code       VARCHAR(10)  NOT NULL DEFAULT 'INR',
    total_amount        NUMERIC(20,2) NOT NULL DEFAULT 0,
    tax_amount          NUMERIC(20,2) NOT NULL DEFAULT 0,
    status              VARCHAR(20)  NOT NULL DEFAULT 'draft' CHECK (status IN ('draft','issued','applied','cancelled')),
    applied_amount      NUMERIC(20,2) NOT NULL DEFAULT 0,
    notes               TEXT,
    journal_entry_id    UUID         REFERENCES finance.journal_entries(journal_entry_id),
    created_by          UUID         NOT NULL,
    updated_by          UUID         NOT NULL,
    deleted_by          UUID,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    deleted_at          TIMESTAMPTZ,
    UNIQUE (tenant_id, branch_id, credit_note_number)
);

-- =============================================================================
-- STEP 6: PURCHASE MANAGEMENT
-- =============================================================================

-- Suppliers
CREATE TABLE purchase.suppliers (
    supplier_id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id           UUID         NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id           UUID         NOT NULL REFERENCES core.branches(branch_id),
    supplier_code       VARCHAR(50)  NOT NULL,
    supplier_name       VARCHAR(255) NOT NULL,
    supplier_type       VARCHAR(50)  NOT NULL DEFAULT 'goods' CHECK (supplier_type IN ('goods','services','both')),
    gstin               VARCHAR(20),
    pan_number          VARCHAR(20),
    email               VARCHAR(255),
    phone               VARCHAR(30),
    mobile              VARCHAR(30),
    website             VARCHAR(255),
    credit_limit        NUMERIC(20,2) NOT NULL DEFAULT 0,
    credit_days         SMALLINT     NOT NULL DEFAULT 30,
    outstanding_balance NUMERIC(20,2) NOT NULL DEFAULT 0,
    currency_code       VARCHAR(10)  NOT NULL DEFAULT 'INR',
    tax_category        VARCHAR(50)  NOT NULL DEFAULT 'registered',
    payment_term_id     UUID         REFERENCES sales.payment_terms(payment_term_id),
    bank_account_number VARCHAR(100),
    bank_ifsc           VARCHAR(20),
    bank_name           VARCHAR(255),
    rating              NUMERIC(3,2) CHECK (rating BETWEEN 0 AND 5),
    kyc_status          VARCHAR(20)  NOT NULL DEFAULT 'pending' CHECK (kyc_status IN ('pending','under_review','approved','rejected')),
    kyc_verified_at     TIMESTAMPTZ,
    is_active           BOOLEAN      NOT NULL DEFAULT TRUE,
    notes               TEXT,
    created_by          UUID         NOT NULL,
    updated_by          UUID         NOT NULL,
    deleted_by          UUID,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    deleted_at          TIMESTAMPTZ,
    UNIQUE (tenant_id, supplier_code)
);

-- Purchase Requisitions
CREATE TABLE purchase.purchase_requisitions (
    purchase_requisition_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id               UUID        NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id               UUID        NOT NULL REFERENCES core.branches(branch_id),
    requisition_number      VARCHAR(50) NOT NULL,
    requisition_date        DATE        NOT NULL,
    requested_by            UUID        NOT NULL REFERENCES iam.users(user_id),
    department_cost_center_id UUID      REFERENCES finance.cost_centers(cost_center_id),
    required_by_date        DATE,
    priority                VARCHAR(20) NOT NULL DEFAULT 'normal' CHECK (priority IN ('low','normal','high','urgent')),
    purpose                 TEXT,
    total_estimated_amount  NUMERIC(20,2) NOT NULL DEFAULT 0,
    status                  VARCHAR(30) NOT NULL DEFAULT 'draft' CHECK (status IN ('draft','submitted','approved','rejected','partially_ordered','ordered','cancelled')),
    approved_at             TIMESTAMPTZ,
    approved_by             UUID        REFERENCES iam.users(user_id),
    rejection_reason        TEXT,
    created_by              UUID        NOT NULL,
    updated_by              UUID        NOT NULL,
    deleted_by              UUID,
    created_at              TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at              TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at              TIMESTAMPTZ,
    UNIQUE (tenant_id, branch_id, requisition_number)
);

-- Purchase Requisition Lines
CREATE TABLE purchase.purchase_requisition_lines (
    pr_line_id              UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id               UUID        NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id               UUID        NOT NULL REFERENCES core.branches(branch_id),
    purchase_requisition_id UUID        NOT NULL REFERENCES purchase.purchase_requisitions(purchase_requisition_id),
    line_number             SMALLINT    NOT NULL,
    item_id                 UUID        NOT NULL,
    item_description        TEXT,
    uom_id                  UUID        NOT NULL,
    required_quantity       NUMERIC(20,4) NOT NULL CHECK (required_quantity > 0),
    ordered_quantity        NUMERIC(20,4) NOT NULL DEFAULT 0,
    estimated_unit_price    NUMERIC(20,4) NOT NULL DEFAULT 0,
    estimated_total         NUMERIC(20,2) NOT NULL DEFAULT 0,
    preferred_supplier_id   UUID        REFERENCES purchase.suppliers(supplier_id),
    specifications          TEXT,
    created_by              UUID        NOT NULL,
    updated_by              UUID        NOT NULL,
    deleted_by              UUID,
    created_at              TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at              TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at              TIMESTAMPTZ,
    UNIQUE (tenant_id, purchase_requisition_id, line_number)
);

-- Purchase Orders
CREATE TABLE purchase.purchase_orders (
    purchase_order_id   UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id           UUID         NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id           UUID         NOT NULL REFERENCES core.branches(branch_id),
    po_number           VARCHAR(50)  NOT NULL,
    po_date             DATE         NOT NULL,
    supplier_id         UUID         NOT NULL REFERENCES purchase.suppliers(supplier_id),
    purchase_requisition_id UUID     REFERENCES purchase.purchase_requisitions(purchase_requisition_id),
    billing_address_id  UUID         REFERENCES core.addresses(address_id),
    delivery_address_id UUID         REFERENCES core.addresses(address_id),
    currency_code       VARCHAR(10)  NOT NULL DEFAULT 'INR',
    exchange_rate       NUMERIC(20,8) NOT NULL DEFAULT 1,
    payment_term_id     UUID         REFERENCES sales.payment_terms(payment_term_id),
    expected_delivery_date DATE,
    subtotal            NUMERIC(20,2) NOT NULL DEFAULT 0,
    discount_amount     NUMERIC(20,2) NOT NULL DEFAULT 0,
    taxable_amount      NUMERIC(20,2) NOT NULL DEFAULT 0,
    tax_amount          NUMERIC(20,2) NOT NULL DEFAULT 0,
    total_amount        NUMERIC(20,2) NOT NULL DEFAULT 0,
    received_amount     NUMERIC(20,2) NOT NULL DEFAULT 0,
    billed_amount       NUMERIC(20,2) NOT NULL DEFAULT 0,
    po_type             VARCHAR(20)  NOT NULL DEFAULT 'standard' CHECK (po_type IN ('standard','blanket','scheduled','subcontract')),
    status              VARCHAR(30)  NOT NULL DEFAULT 'draft' CHECK (status IN ('draft','submitted','approved','rejected','sent','acknowledged','partially_received','received','billed','closed','cancelled')),
    approved_at         TIMESTAMPTZ,
    approved_by         UUID,
    notes               TEXT,
    terms_conditions    TEXT,
    created_by          UUID         NOT NULL,
    updated_by          UUID         NOT NULL,
    deleted_by          UUID,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    deleted_at          TIMESTAMPTZ,
    UNIQUE (tenant_id, branch_id, po_number)
);

-- Purchase Order Lines
CREATE TABLE purchase.purchase_order_lines (
    po_line_id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id           UUID         NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id           UUID         NOT NULL REFERENCES core.branches(branch_id),
    purchase_order_id   UUID         NOT NULL REFERENCES purchase.purchase_orders(purchase_order_id),
    pr_line_id          UUID         REFERENCES purchase.purchase_requisition_lines(pr_line_id),
    line_number         SMALLINT     NOT NULL,
    item_id             UUID         NOT NULL,
    item_description    TEXT,
    hsn_sac_code_id     UUID         REFERENCES tax.hsn_sac_codes(hsn_sac_code_id),
    uom_id              UUID         NOT NULL,
    ordered_quantity    NUMERIC(20,4) NOT NULL CHECK (ordered_quantity > 0),
    received_quantity   NUMERIC(20,4) NOT NULL DEFAULT 0,
    billed_quantity     NUMERIC(20,4) NOT NULL DEFAULT 0,
    pending_quantity    NUMERIC(20,4) GENERATED ALWAYS AS (ordered_quantity - received_quantity) STORED,
    unit_price          NUMERIC(20,4) NOT NULL DEFAULT 0,
    discount_percentage NUMERIC(8,4)  NOT NULL DEFAULT 0,
    discount_amount     NUMERIC(20,2) NOT NULL DEFAULT 0,
    taxable_amount      NUMERIC(20,2) NOT NULL DEFAULT 0,
    tax_rate_id         UUID         REFERENCES tax.tax_rates(tax_rate_id),
    tax_amount          NUMERIC(20,2) NOT NULL DEFAULT 0,
    line_total          NUMERIC(20,2) NOT NULL DEFAULT 0,
    warehouse_id        UUID,
    expected_delivery_date DATE,
    created_by          UUID         NOT NULL,
    updated_by          UUID         NOT NULL,
    deleted_by          UUID,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    deleted_at          TIMESTAMPTZ,
    UNIQUE (tenant_id, purchase_order_id, line_number)
);

-- Goods Receipt Notes (GRN)
CREATE TABLE purchase.goods_receipt_notes (
    grn_id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id           UUID         NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id           UUID         NOT NULL REFERENCES core.branches(branch_id),
    grn_number          VARCHAR(50)  NOT NULL,
    grn_date            DATE         NOT NULL,
    purchase_order_id   UUID         NOT NULL REFERENCES purchase.purchase_orders(purchase_order_id),
    supplier_id         UUID         NOT NULL REFERENCES purchase.suppliers(supplier_id),
    warehouse_id        UUID         NOT NULL,
    vehicle_number      VARCHAR(30),
    supplier_dc_number  VARCHAR(100),
    supplier_dc_date    DATE,
    quality_check_required BOOLEAN   NOT NULL DEFAULT FALSE,
    quality_checked_at  TIMESTAMPTZ,
    quality_checked_by  UUID,
    status              VARCHAR(20)  NOT NULL DEFAULT 'draft' CHECK (status IN ('draft','received','quality_checked','accepted','rejected','partially_accepted')),
    notes               TEXT,
    created_by          UUID         NOT NULL,
    updated_by          UUID         NOT NULL,
    deleted_by          UUID,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    deleted_at          TIMESTAMPTZ,
    UNIQUE (tenant_id, branch_id, grn_number)
);

-- GRN Lines
CREATE TABLE purchase.grn_lines (
    grn_line_id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id           UUID         NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id           UUID         NOT NULL REFERENCES core.branches(branch_id),
    grn_id              UUID         NOT NULL REFERENCES purchase.goods_receipt_notes(grn_id),
    po_line_id          UUID         NOT NULL REFERENCES purchase.purchase_order_lines(po_line_id),
    line_number         SMALLINT     NOT NULL,
    item_id             UUID         NOT NULL,
    uom_id              UUID         NOT NULL,
    ordered_quantity    NUMERIC(20,4) NOT NULL,
    received_quantity   NUMERIC(20,4) NOT NULL CHECK (received_quantity >= 0),
    accepted_quantity   NUMERIC(20,4) NOT NULL DEFAULT 0,
    rejected_quantity   NUMERIC(20,4) NOT NULL DEFAULT 0,
    batch_number        VARCHAR(100),
    expiry_date         DATE,
    serial_numbers      JSONB,
    rejection_reason    TEXT,
    created_by          UUID         NOT NULL,
    updated_by          UUID         NOT NULL,
    deleted_by          UUID,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    deleted_at          TIMESTAMPTZ
);

-- Supplier Invoices (Purchase Invoices)
CREATE TABLE purchase.supplier_invoices (
    supplier_invoice_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id           UUID         NOT NULL REFERENCES core.tenants(tenant_id),
    branch_id           UUID         NOT NULL REFERENCES core.branches(branch_id),
    internal_ref_number VARCHAR(50)  NOT NULL,
    supplier_invoice_number VARCHAR(100),
    invoice_date        DATE         NOT NULL,
    due_date            DATE         NOT NULL,
    supplier_id         UUID         NOT NULL REFERENCES purchase.suppliers(supplier_id),
    purchase_order_id   UUID         REFERENCES purchase.purchase_orders(purchase_order_id),
    grn_id              UUID         REFERENCES purchase.goods_receipt_notes(grn_id),
    currency_code       VARCHAR(10)  NOT NULL DEFAULT 'INR',
    exchange_rate       NUMERIC(20,8) NOT NULL DEFAULT 1,
    subtotal            NUMERIC(20,2) NOT NULL DEFAULT 0,
    discount_amount     NUMERIC(20,2) NOT NULL DEFAULT 0,
    taxable_amount      NUMERIC(20,2) NOT NULL DEFAULT 0,
    cgst_amount         NUMERIC(20,2) NOT NULL DEFAULT 0,
    sgst_amount         NUMERIC(20,2) NOT NULL DEFAULT 0,
    igst_amount         NUMERIC(20,2) NOT NULL DEFAULT 0,
    tds_amount          NUMERIC(20,2) NOT NULL DEFAULT 0,
    total_amount        NUMERIC(20,2) NOT NULL DEFAULT 0,
    amount_paid         NUMERIC(20,2) NOT NULL DEFAULT 0,
    amount_outstanding  NUMERIC(20,2) GENERATED ALWAYS AS (total_amount - amount_paid - tds_amount) STORED,
    three_way_matched   BOOLEAN      NOT NULL DEFAULT FALSE,
    status              VARCHAR(20)  NOT NULL DEFAULT 'draft' CHECK (status IN ('draft','posted','partially_paid','paid','disputed','cancelled')),
    posted_at           TIMESTAMPTZ,
    journal_entry_id    UUID         REFERENCES finance.journal_entries(journal_entry_id),
    notes               TEXT,
    created_by          UUID         NOT NULL,
    updated_by          UUID         NOT NULL,
    deleted_by          UUID,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    deleted_at          TIMESTAMPTZ,
    UNIQUE (tenant_id, branch_id, internal_ref_number)
);

-- =============================================================================
-- INDEXES — Sales & Purchase
-- =============================================================================

CREATE INDEX idx_customers_tenant ON sales.customers(tenant_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_customers_code ON sales.customers(tenant_id, customer_code) WHERE deleted_at IS NULL;
CREATE INDEX idx_so_customer ON sales.sales_orders(customer_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_so_status ON sales.sales_orders(tenant_id, status) WHERE deleted_at IS NULL;
CREATE INDEX idx_so_date ON sales.sales_orders(tenant_id, order_date) WHERE deleted_at IS NULL;
CREATE INDEX idx_si_customer ON sales.sales_invoices(customer_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_si_status ON sales.sales_invoices(tenant_id, status) WHERE deleted_at IS NULL;
CREATE INDEX idx_si_due_date ON sales.sales_invoices(tenant_id, due_date) WHERE deleted_at IS NULL AND status NOT IN ('paid','cancelled');
CREATE INDEX idx_suppliers_tenant ON purchase.suppliers(tenant_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_po_supplier ON purchase.purchase_orders(supplier_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_po_status ON purchase.purchase_orders(tenant_id, status) WHERE deleted_at IS NULL;
CREATE INDEX idx_grn_po ON purchase.goods_receipt_notes(purchase_order_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_supplier_inv_status ON purchase.supplier_invoices(tenant_id, status) WHERE deleted_at IS NULL;
CREATE INDEX idx_supplier_inv_due ON purchase.supplier_invoices(tenant_id, due_date) WHERE deleted_at IS NULL AND status NOT IN ('paid','cancelled');

-- =============================================================================
-- MINIMAL DUMMY DATA — Sales & Purchase
-- =============================================================================

DO $$
DECLARE
    v_tenant_id   UUID := 'a0000000-0000-0000-0000-000000000001';
    v_branch_id   UUID := 'b0000000-0000-0000-0000-000000000001';
    v_system_user UUID := '00000000-0000-0000-0000-000000000001';
BEGIN
    INSERT INTO sales.payment_terms (tenant_id, branch_id, term_code, term_name, net_days, discount_days, discount_percentage, created_by, updated_by)
    VALUES
        (v_tenant_id, v_branch_id, 'NET15',  'Net 15 Days',          15,  0,   0, v_system_user, v_system_user),
        (v_tenant_id, v_branch_id, 'NET30',  'Net 30 Days',          30,  0,   0, v_system_user, v_system_user),
        (v_tenant_id, v_branch_id, 'NET45',  'Net 45 Days',          45,  0,   0, v_system_user, v_system_user),
        (v_tenant_id, v_branch_id, 'NET60',  'Net 60 Days',          60,  0,   0, v_system_user, v_system_user),
        (v_tenant_id, v_branch_id, 'COD',    'Cash on Delivery',      0,  0,   0, v_system_user, v_system_user),
        (v_tenant_id, v_branch_id, '2/10N30','2% 10 Net 30',         30, 10, 2.0, v_system_user, v_system_user)
    ON CONFLICT DO NOTHING;

    INSERT INTO sales.price_lists (tenant_id, branch_id, price_list_code, price_list_name, currency_code, is_default, created_by, updated_by)
    VALUES
        (v_tenant_id, v_branch_id, 'RETAIL',     'Retail Price List',    'INR', TRUE,  v_system_user, v_system_user),
        (v_tenant_id, v_branch_id, 'WHOLESALE',  'Wholesale Price List', 'INR', FALSE, v_system_user, v_system_user),
        (v_tenant_id, v_branch_id, 'EXPORT',     'Export Price List',    'USD', FALSE, v_system_user, v_system_user)
    ON CONFLICT DO NOTHING;

    INSERT INTO sales.customers (tenant_id, branch_id, customer_code, customer_name, customer_type, credit_limit, credit_days, created_by, updated_by)
    VALUES
        (v_tenant_id, v_branch_id, 'CUST-001', 'Acme Industries Ltd',     'business',  500000, 30, v_system_user, v_system_user),
        (v_tenant_id, v_branch_id, 'CUST-002', 'Global Trade Corp',       'business', 1000000, 45, v_system_user, v_system_user),
        (v_tenant_id, v_branch_id, 'CUST-003', 'Retail Walk-in Customer', 'individual',  0,  0, v_system_user, v_system_user)
    ON CONFLICT DO NOTHING;

    INSERT INTO purchase.suppliers (tenant_id, branch_id, supplier_code, supplier_name, supplier_type, credit_days, kyc_status, created_by, updated_by)
    VALUES
        (v_tenant_id, v_branch_id, 'SUPP-001', 'Prime Supplies Pvt Ltd',  'goods',    30, 'approved', v_system_user, v_system_user),
        (v_tenant_id, v_branch_id, 'SUPP-002', 'Tech Solutions Ltd',      'services', 15, 'approved', v_system_user, v_system_user),
        (v_tenant_id, v_branch_id, 'SUPP-003', 'Raw Material Corp',       'goods',    60, 'approved', v_system_user, v_system_user)
    ON CONFLICT DO NOTHING;
END $$;
