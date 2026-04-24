-- =============================================================================
-- triggers.sql — Step 6: Triggers
-- Trigger naming:  trg_<table>_<action>
-- Function naming: fn_<purpose>
-- =============================================================================

-- =============================================================================
-- AUDIT / UPDATED_AT AUTOMATION
-- =============================================================================

-- Generic updated_at setter (reused across all tables)
CREATE OR REPLACE FUNCTION core.fn_set_updated_at()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    NEW.updated_at := NOW();
    RETURN NEW;
END;
$$;

-- Macro helper: apply updated_at trigger to a table
-- We apply it explicitly to each table below for clarity.

-- core schema
CREATE TRIGGER trg_tenants_updated_at
    BEFORE UPDATE ON core.tenants
    FOR EACH ROW EXECUTE FUNCTION core.fn_set_updated_at();

CREATE TRIGGER trg_organizations_updated_at
    BEFORE UPDATE ON core.organizations
    FOR EACH ROW EXECUTE FUNCTION core.fn_set_updated_at();

CREATE TRIGGER trg_branches_updated_at
    BEFORE UPDATE ON core.branches
    FOR EACH ROW EXECUTE FUNCTION core.fn_set_updated_at();

CREATE TRIGGER trg_fiscal_years_updated_at
    BEFORE UPDATE ON core.fiscal_years
    FOR EACH ROW EXECUTE FUNCTION core.fn_set_updated_at();

-- iam schema
CREATE TRIGGER trg_users_updated_at
    BEFORE UPDATE ON iam.users
    FOR EACH ROW EXECUTE FUNCTION core.fn_set_updated_at();

CREATE TRIGGER trg_roles_updated_at
    BEFORE UPDATE ON iam.roles
    FOR EACH ROW EXECUTE FUNCTION core.fn_set_updated_at();

-- finance schema
CREATE TRIGGER trg_journal_entries_updated_at
    BEFORE UPDATE ON finance.journal_entries
    FOR EACH ROW EXECUTE FUNCTION core.fn_set_updated_at();

-- sales schema
CREATE TRIGGER trg_sales_orders_updated_at
    BEFORE UPDATE ON sales.sales_orders
    FOR EACH ROW EXECUTE FUNCTION core.fn_set_updated_at();

CREATE TRIGGER trg_sales_invoices_updated_at
    BEFORE UPDATE ON sales.sales_invoices
    FOR EACH ROW EXECUTE FUNCTION core.fn_set_updated_at();

-- purchase schema
CREATE TRIGGER trg_purchase_orders_updated_at
    BEFORE UPDATE ON purchase.purchase_orders
    FOR EACH ROW EXECUTE FUNCTION core.fn_set_updated_at();

-- hr schema
CREATE TRIGGER trg_employees_updated_at
    BEFORE UPDATE ON hr.employees
    FOR EACH ROW EXECUTE FUNCTION core.fn_set_updated_at();

-- payroll schema
CREATE TRIGGER trg_payroll_runs_updated_at
    BEFORE UPDATE ON payroll.payroll_runs
    FOR EACH ROW EXECUTE FUNCTION core.fn_set_updated_at();

CREATE TRIGGER trg_payslips_updated_at
    BEFORE UPDATE ON payroll.payslips
    FOR EACH ROW EXECUTE FUNCTION core.fn_set_updated_at();

-- inventory schema
CREATE TRIGGER trg_items_updated_at
    BEFORE UPDATE ON inventory.items
    FOR EACH ROW EXECUTE FUNCTION core.fn_set_updated_at();

CREATE TRIGGER trg_stock_balances_updated_at
    BEFORE UPDATE ON inventory.stock_balances
    FOR EACH ROW EXECUTE FUNCTION core.fn_set_updated_at();

-- assets schema
CREATE TRIGGER trg_assets_updated_at
    BEFORE UPDATE ON assets.assets
    FOR EACH ROW EXECUTE FUNCTION core.fn_set_updated_at();

-- projects schema
CREATE TRIGGER trg_projects_updated_at
    BEFORE UPDATE ON projects.projects
    FOR EACH ROW EXECUTE FUNCTION core.fn_set_updated_at();

-- =============================================================================
-- BUSINESS LOGIC TRIGGERS
-- =============================================================================

-- -----------------------------------------------------------------------------
-- trg_users_failed_login_lockout
-- Auto-locks user account after max failed login attempts
-- -----------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION iam.fn_enforce_lockout_policy()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
    v_policy iam.password_policies%ROWTYPE;
BEGIN
    IF NEW.failed_login_count = OLD.failed_login_count THEN
        RETURN NEW;
    END IF;

    SELECT * INTO v_policy
    FROM iam.password_policies
    WHERE tenant_id = NEW.tenant_id AND deleted_at IS NULL
    LIMIT 1;

    IF FOUND AND NEW.failed_login_count >= v_policy.max_failed_attempts THEN
        NEW.locked_until := NOW() + (v_policy.lockout_duration_minutes || ' minutes')::INTERVAL;
    END IF;

    RETURN NEW;
END;
$$;

CREATE TRIGGER trg_users_failed_login_lockout
    BEFORE UPDATE OF failed_login_count ON iam.users
    FOR EACH ROW EXECUTE FUNCTION iam.fn_enforce_lockout_policy();

-- -----------------------------------------------------------------------------
-- trg_sales_invoice_lines_update_header
-- Recomputes invoice header totals when a line is inserted/updated/deleted
-- -----------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION sales.fn_sync_invoice_header_totals()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
    v_invoice_id UUID;
BEGIN
    v_invoice_id := COALESCE(NEW.sales_invoice_id, OLD.sales_invoice_id);

    UPDATE sales.sales_invoices
    SET subtotal         = agg.subtotal,
        discount_amount  = agg.discount_amount,
        taxable_amount   = agg.taxable_amount,
        cgst_amount      = agg.cgst,
        sgst_amount      = agg.sgst,
        igst_amount      = agg.igst,
        total_tax_amount = agg.total_tax,
        total_amount     = agg.subtotal - agg.discount_amount + agg.total_tax,
        updated_at       = NOW()
    FROM (
        SELECT
            SUM(quantity * unit_price)    AS subtotal,
            SUM(discount_amount)          AS discount_amount,
            SUM(taxable_amount)           AS taxable_amount,
            SUM(cgst_amount)              AS cgst,
            SUM(sgst_amount)              AS sgst,
            SUM(igst_amount)              AS igst,
            SUM(tax_amount)               AS total_tax
        FROM sales.sales_invoice_lines
        WHERE sales_invoice_id = v_invoice_id AND deleted_at IS NULL
    ) agg
    WHERE sales_invoice_id = v_invoice_id;

    RETURN COALESCE(NEW, OLD);
END;
$$;

CREATE TRIGGER trg_sales_invoice_lines_sync_header
    AFTER INSERT OR UPDATE OR DELETE ON sales.sales_invoice_lines
    FOR EACH ROW EXECUTE FUNCTION sales.fn_sync_invoice_header_totals();

-- -----------------------------------------------------------------------------
-- trg_purchase_order_lines_update_header
-- Recomputes PO header totals when lines change
-- -----------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION purchase.fn_sync_po_header_totals()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
    v_po_id UUID;
BEGIN
    v_po_id := COALESCE(NEW.purchase_order_id, OLD.purchase_order_id);

    UPDATE purchase.purchase_orders
    SET subtotal        = agg.subtotal,
        discount_amount = agg.discount_amount,
        taxable_amount  = agg.taxable_amount,
        tax_amount      = agg.tax_amount,
        total_amount    = agg.subtotal - agg.discount_amount + agg.tax_amount,
        updated_at      = NOW()
    FROM (
        SELECT
            SUM(ordered_quantity * unit_price) AS subtotal,
            SUM(discount_amount)               AS discount_amount,
            SUM(taxable_amount)                AS taxable_amount,
            SUM(tax_amount)                    AS tax_amount
        FROM purchase.purchase_order_lines
        WHERE purchase_order_id = v_po_id AND deleted_at IS NULL
    ) agg
    WHERE purchase_order_id = v_po_id;

    RETURN COALESCE(NEW, OLD);
END;
$$;

CREATE TRIGGER trg_po_lines_sync_header
    AFTER INSERT OR UPDATE OR DELETE ON purchase.purchase_order_lines
    FOR EACH ROW EXECUTE FUNCTION purchase.fn_sync_po_header_totals();

-- -----------------------------------------------------------------------------
-- trg_sales_order_lines_update_header
-- Recomputes SO header totals when lines change
-- -----------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION sales.fn_sync_so_header_totals()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
    v_so_id UUID;
BEGIN
    v_so_id := COALESCE(NEW.sales_order_id, OLD.sales_order_id);

    UPDATE sales.sales_orders
    SET subtotal        = agg.subtotal,
        discount_amount = agg.discount_amount,
        taxable_amount  = agg.taxable_amount,
        tax_amount      = agg.tax_amount,
        total_amount    = agg.subtotal - agg.discount_amount + agg.tax_amount,
        updated_at      = NOW()
    FROM (
        SELECT
            SUM(ordered_quantity * unit_price) AS subtotal,
            SUM(discount_amount)               AS discount_amount,
            SUM(taxable_amount)                AS taxable_amount,
            SUM(tax_amount)                    AS tax_amount
        FROM sales.sales_order_lines
        WHERE sales_order_id = v_so_id AND deleted_at IS NULL
    ) agg
    WHERE sales_order_id = v_so_id;

    RETURN COALESCE(NEW, OLD);
END;
$$;

CREATE TRIGGER trg_so_lines_sync_header
    AFTER INSERT OR UPDATE OR DELETE ON sales.sales_order_lines
    FOR EACH ROW EXECUTE FUNCTION sales.fn_sync_so_header_totals();

-- -----------------------------------------------------------------------------
-- trg_journal_entry_lines_block_posted
-- Prevents modification of lines on posted journal entries
-- -----------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION finance.fn_block_posted_je_modification()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
    v_status VARCHAR;
BEGIN
    SELECT status INTO v_status
    FROM finance.journal_entries
    WHERE journal_entry_id = COALESCE(NEW.journal_entry_id, OLD.journal_entry_id);

    IF v_status = 'posted' THEN
        RAISE EXCEPTION 'Cannot modify lines of a posted journal entry';
    END IF;

    RETURN COALESCE(NEW, OLD);
END;
$$;

CREATE TRIGGER trg_jel_block_posted
    BEFORE INSERT OR UPDATE OR DELETE ON finance.journal_entry_lines
    FOR EACH ROW EXECUTE FUNCTION finance.fn_block_posted_je_modification();

-- -----------------------------------------------------------------------------
-- trg_stock_ledger_update_balance
-- Updates stock_balances after each new stock ledger entry
-- -----------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION inventory.fn_propagate_stock_ledger()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    PERFORM inventory.fn_update_stock_balance(
        NEW.tenant_id,
        NEW.branch_id,
        NEW.item_id,
        NEW.warehouse_id,
        NEW.warehouse_location_id,
        NEW.batch_id,
        NEW.actual_quantity,
        NEW.valuation_rate,
        NEW.created_by
    );
    RETURN NEW;
END;
$$;

CREATE TRIGGER trg_stock_ledger_propagate_balance
    AFTER INSERT ON inventory.stock_ledger
    FOR EACH ROW EXECUTE FUNCTION inventory.fn_propagate_stock_ledger();

-- -----------------------------------------------------------------------------
-- trg_leave_application_block_overlap
-- Prevents overlapping approved leave for same employee
-- -----------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION attendance.fn_block_overlapping_leave()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
    v_overlap_count INTEGER;
BEGIN
    IF NEW.status NOT IN ('pending','approved') THEN
        RETURN NEW;
    END IF;

    SELECT COUNT(*) INTO v_overlap_count
    FROM attendance.leave_applications
    WHERE employee_id          = NEW.employee_id
      AND leave_application_id <> NEW.leave_application_id
      AND status               = 'approved'
      AND deleted_at IS NULL
      AND (from_date, to_date) OVERLAPS (NEW.from_date, NEW.to_date);

    IF v_overlap_count > 0 THEN
        RAISE EXCEPTION 'Overlapping approved leave exists for employee % between % and %',
            NEW.employee_id, NEW.from_date, NEW.to_date;
    END IF;

    RETURN NEW;
END;
$$;

CREATE TRIGGER trg_leave_application_block_overlap
    BEFORE INSERT OR UPDATE ON attendance.leave_applications
    FOR EACH ROW EXECUTE FUNCTION attendance.fn_block_overlapping_leave();

-- -----------------------------------------------------------------------------
-- trg_asset_validate_salvage
-- Ensures salvage_value never exceeds purchase_value
-- -----------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION assets.fn_validate_asset_values()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    IF NEW.salvage_value > NEW.purchase_value THEN
        RAISE EXCEPTION 'Asset salvage value (%) cannot exceed purchase value (%)',
            NEW.salvage_value, NEW.purchase_value;
    END IF;

    IF NEW.current_book_value < 0 THEN
        NEW.current_book_value := 0;
    END IF;

    RETURN NEW;
END;
$$;

CREATE TRIGGER trg_assets_validate_values
    BEFORE INSERT OR UPDATE ON assets.assets
    FOR EACH ROW EXECUTE FUNCTION assets.fn_validate_asset_values();

-- -----------------------------------------------------------------------------
-- trg_customer_update_outstanding
-- Keeps customers.outstanding_balance in sync on invoice payment updates
-- -----------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION sales.fn_sync_customer_outstanding()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    -- Only fire when amount_paid changes
    IF TG_OP = 'UPDATE' AND OLD.amount_paid = NEW.amount_paid THEN
        RETURN NEW;
    END IF;

    UPDATE sales.customers
    SET outstanding_balance = (
        SELECT COALESCE(SUM(amount_outstanding), 0)
        FROM sales.sales_invoices
        WHERE customer_id = NEW.customer_id
          AND status NOT IN ('cancelled', 'paid')
          AND deleted_at IS NULL
    ),
    updated_at = NOW()
    WHERE customer_id = NEW.customer_id;

    RETURN NEW;
END;
$$;

CREATE TRIGGER trg_sales_invoice_sync_customer_outstanding
    AFTER INSERT OR UPDATE OF amount_paid, status ON sales.sales_invoices
    FOR EACH ROW EXECUTE FUNCTION sales.fn_sync_customer_outstanding();

-- -----------------------------------------------------------------------------
-- trg_document_sequence_fiscal_year_reset
-- Auto-resets document sequence counter at fiscal year boundary
-- -----------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION core.fn_reset_sequence_on_fiscal_year()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    -- Triggered when a fiscal year is marked current
    IF NEW.is_current = TRUE AND OLD.is_current = FALSE THEN
        -- Unset previous current year
        UPDATE core.fiscal_years
        SET is_current = FALSE, updated_at = NOW()
        WHERE tenant_id     = NEW.tenant_id
          AND fiscal_year_id <> NEW.fiscal_year_id
          AND is_current    = TRUE;

        -- Reset yearly sequences for this tenant
        UPDATE core.document_sequences
        SET current_number = 0,
            last_reset_at  = NOW(),
            updated_at     = NOW()
        WHERE tenant_id       = NEW.tenant_id
          AND reset_frequency = 'yearly'
          AND deleted_at IS NULL;
    END IF;

    RETURN NEW;
END;
$$;

CREATE TRIGGER trg_fiscal_years_reset_sequences
    AFTER UPDATE OF is_current ON core.fiscal_years
    FOR EACH ROW EXECUTE FUNCTION core.fn_reset_sequence_on_fiscal_year();

-- -----------------------------------------------------------------------------
-- trg_data_access_audit
-- Records every UPDATE/DELETE on sensitive tables to security.data_access_logs
-- (applied to hr.employees as demonstration — extend to other tables)
-- -----------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION security.fn_audit_sensitive_data()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO security.data_access_logs (
        tenant_id, branch_id, user_id,
        entity_type, entity_id, action,
        is_pii_access, old_values, new_values,
        created_by, updated_by
    ) VALUES (
        COALESCE(NEW.tenant_id, OLD.tenant_id),
        COALESCE(NEW.branch_id, OLD.branch_id),
        COALESCE(NEW.updated_by, OLD.updated_by),
        TG_TABLE_SCHEMA || '.' || TG_TABLE_NAME,
        COALESCE(NEW.employee_id, OLD.employee_id),
        TG_OP,
        TRUE,
        row_to_json(OLD)::jsonb,
        row_to_json(NEW)::jsonb,
        COALESCE(NEW.updated_by, OLD.updated_by),
        COALESCE(NEW.updated_by, OLD.updated_by)
    );

    RETURN COALESCE(NEW, OLD);
END;
$$;

CREATE TRIGGER trg_employees_audit
    AFTER UPDATE OR DELETE ON hr.employees
    FOR EACH ROW EXECUTE FUNCTION security.fn_audit_sensitive_data();

-- Also audit payslips (contains financial PII)
CREATE OR REPLACE FUNCTION security.fn_audit_payslip_data()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO security.data_access_logs (
        tenant_id, branch_id, user_id,
        entity_type, entity_id, action,
        is_pii_access, old_values, new_values,
        created_by, updated_by
    ) VALUES (
        COALESCE(NEW.tenant_id, OLD.tenant_id),
        COALESCE(NEW.branch_id, OLD.branch_id),
        COALESCE(NEW.updated_by, OLD.updated_by),
        'payroll.payslips',
        COALESCE(NEW.payslip_id, OLD.payslip_id),
        TG_OP,
        TRUE,
        row_to_json(OLD)::jsonb,
        row_to_json(NEW)::jsonb,
        COALESCE(NEW.updated_by, OLD.updated_by),
        COALESCE(NEW.updated_by, OLD.updated_by)
    );
    RETURN COALESCE(NEW, OLD);
END;
$$;

CREATE TRIGGER trg_payslips_audit
    AFTER UPDATE OR DELETE ON payroll.payslips
    FOR EACH ROW EXECUTE FUNCTION security.fn_audit_payslip_data();

-- =============================================================================
-- COMMENTS on key objects
-- =============================================================================

COMMENT ON FUNCTION core.fn_generate_document_number IS
    'Thread-safe sequence generator using FOR UPDATE lock on document_sequences';
COMMENT ON FUNCTION inventory.fn_update_stock_balance IS
    'Upserts stock_balances using weighted-average valuation on incoming goods';
COMMENT ON PROCEDURE sales.sp_confirm_sales_order IS
    'Validates credit limit and reserves stock before confirming a sales order';
COMMENT ON PROCEDURE payroll.sp_run_payroll IS
    'Processes payroll for all active employees, computing components per salary structure';
COMMENT ON TRIGGER trg_jel_block_posted ON finance.journal_entry_lines IS
    'Hard guard — posted JEs are immutable; reversal required instead of edit';
