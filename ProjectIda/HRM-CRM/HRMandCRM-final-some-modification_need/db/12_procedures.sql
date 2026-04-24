-- =============================================================================
-- procedures.sql — Step 5: Stored Procedures
-- Naming: sp_<action>_<entity>
-- =============================================================================

-- -----------------------------------------------------------------------------
-- sp_confirm_sales_order
-- Confirms SO, checks credit limit, reserves stock
-- -----------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE sales.sp_confirm_sales_order(
    p_sales_order_id UUID,
    p_user_id        UUID
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_order     sales.sales_orders%ROWTYPE;
    v_line      RECORD;
    v_credit_ok BOOLEAN;
BEGIN
    SELECT * INTO v_order
    FROM sales.sales_orders
    WHERE sales_order_id = p_sales_order_id
      AND deleted_at IS NULL;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Sales order not found: %', p_sales_order_id;
    END IF;

    IF v_order.status <> 'draft' THEN
        RAISE EXCEPTION 'Sales order % is already %', v_order.order_number, v_order.status;
    END IF;

    -- Credit limit check
    v_credit_ok := sales.fn_check_credit_limit(
        v_order.tenant_id, v_order.customer_id, v_order.total_amount
    );

    IF NOT v_credit_ok THEN
        RAISE EXCEPTION 'Credit limit exceeded for customer on order %', v_order.order_number;
    END IF;

    -- Reserve stock for each line
    FOR v_line IN
        SELECT * FROM sales.sales_order_lines
        WHERE sales_order_id = p_sales_order_id AND deleted_at IS NULL
    LOOP
        IF v_line.warehouse_id IS NOT NULL THEN
            UPDATE inventory.stock_balances
            SET quantity_reserved = quantity_reserved + v_line.ordered_quantity,
                updated_at        = NOW(),
                updated_by        = p_user_id
            WHERE tenant_id    = v_order.tenant_id
              AND item_id      = v_line.item_id
              AND warehouse_id = v_line.warehouse_id
              AND deleted_at IS NULL;
        END IF;
    END LOOP;

    -- Update order status
    UPDATE sales.sales_orders
    SET status     = 'confirmed',
        updated_by = p_user_id,
        updated_at = NOW()
    WHERE sales_order_id = p_sales_order_id;

    COMMIT;
END;
$$;

-- -----------------------------------------------------------------------------
-- sp_process_grn
-- Receives GRN, posts stock ledger entries, and updates PO received qty
-- -----------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE purchase.sp_process_grn(
    p_grn_id    UUID,
    p_user_id   UUID
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_grn       purchase.goods_receipt_notes%ROWTYPE;
    v_line      RECORD;
    v_po_line   purchase.purchase_order_lines%ROWTYPE;
BEGIN
    SELECT * INTO v_grn
    FROM purchase.goods_receipt_notes
    WHERE grn_id = p_grn_id AND deleted_at IS NULL;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'GRN not found: %', p_grn_id;
    END IF;

    IF v_grn.status NOT IN ('draft','received') THEN
        RAISE EXCEPTION 'GRN % cannot be processed in status: %',
            v_grn.grn_number, v_grn.status;
    END IF;

    FOR v_line IN
        SELECT gl.*, pol.unit_price
        FROM purchase.grn_lines gl
        JOIN purchase.purchase_order_lines pol
          ON pol.po_line_id = gl.po_line_id
        WHERE gl.grn_id = p_grn_id AND gl.deleted_at IS NULL
    LOOP
        -- Post stock ledger entry for accepted quantity
        IF v_line.accepted_quantity > 0 THEN
            INSERT INTO inventory.stock_ledger (
                tenant_id, branch_id, posting_date,
                item_id, warehouse_id, batch_id,
                voucher_type, voucher_id, voucher_number,
                actual_quantity, qty_after_transaction,
                incoming_rate, valuation_rate, stock_value,
                created_by, updated_by
            )
            SELECT
                v_grn.tenant_id, v_grn.branch_id, CURRENT_DATE,
                v_line.item_id, v_grn.warehouse_id, v_line.batch_id,
                'GRN', v_grn.grn_id, v_grn.grn_number,
                v_line.accepted_quantity,
                COALESCE(
                    (SELECT qty_after_transaction FROM inventory.stock_ledger
                     WHERE item_id = v_line.item_id AND warehouse_id = v_grn.warehouse_id
                     ORDER BY created_at DESC LIMIT 1), 0
                ) + v_line.accepted_quantity,
                v_line.unit_price, v_line.unit_price,
                v_line.accepted_quantity * v_line.unit_price,
                p_user_id, p_user_id;

            -- Update stock balance
            PERFORM inventory.fn_update_stock_balance(
                v_grn.tenant_id, v_grn.branch_id,
                v_line.item_id, v_grn.warehouse_id,
                NULL, v_line.batch_id,
                v_line.accepted_quantity, v_line.unit_price,
                p_user_id
            );
        END IF;

        -- Update PO line received qty
        UPDATE purchase.purchase_order_lines
        SET received_quantity = received_quantity + v_line.accepted_quantity,
            updated_by        = p_user_id,
            updated_at        = NOW()
        WHERE po_line_id = v_line.po_line_id;
    END LOOP;

    -- Update GRN status
    UPDATE purchase.goods_receipt_notes
    SET status     = 'accepted',
        updated_by = p_user_id,
        updated_at = NOW()
    WHERE grn_id = p_grn_id;

    -- Update PO status
    UPDATE purchase.purchase_orders po
    SET status = CASE
        WHEN NOT EXISTS (
            SELECT 1 FROM purchase.purchase_order_lines
            WHERE purchase_order_id = po.purchase_order_id
              AND pending_quantity > 0
              AND deleted_at IS NULL
        ) THEN 'received'
        ELSE 'partially_received'
    END,
    updated_by = p_user_id,
    updated_at = NOW()
    WHERE purchase_order_id = v_grn.purchase_order_id;

    COMMIT;
END;
$$;

-- -----------------------------------------------------------------------------
-- sp_post_sales_invoice
-- Posts a sales invoice to GL and updates customer outstanding
-- -----------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE sales.sp_post_sales_invoice(
    p_invoice_id UUID,
    p_user_id    UUID
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_inv       sales.sales_invoices%ROWTYPE;
    v_je_id     UUID;
    v_je_number VARCHAR;
    v_ar_acct   UUID;
    v_rev_acct  UUID;
    v_tax_acct  UUID;
BEGIN
    SELECT * INTO v_inv
    FROM sales.sales_invoices
    WHERE sales_invoice_id = p_invoice_id AND deleted_at IS NULL;

    IF NOT FOUND THEN RAISE EXCEPTION 'Invoice not found: %', p_invoice_id; END IF;
    IF v_inv.status <> 'draft' THEN
        RAISE EXCEPTION 'Invoice % already posted or cancelled', v_inv.invoice_number;
    END IF;

    -- Get GL accounts (simplified — production would use account mapping config)
    SELECT account_id INTO v_ar_acct
    FROM finance.chart_of_accounts
    WHERE tenant_id = v_inv.tenant_id AND account_code = '1200' LIMIT 1;

    SELECT account_id INTO v_rev_acct
    FROM finance.chart_of_accounts
    WHERE tenant_id = v_inv.tenant_id AND account_code = '4100' LIMIT 1;

    -- Generate JE number
    v_je_number := core.fn_generate_document_number(
        v_inv.tenant_id, v_inv.branch_id, 'JOURNAL'
    );

    -- Create Journal Entry header
    INSERT INTO finance.journal_entries (
        tenant_id, branch_id, entry_number, fiscal_year_id,
        financial_period_id, entry_date, posting_date,
        entry_type, source_document_type, source_document_id,
        source_document_number, currency_code, exchange_rate,
        total_debit, total_credit, status,
        created_by, updated_by
    )
    SELECT
        v_inv.tenant_id, v_inv.branch_id, v_je_number,
        core.fn_get_current_fiscal_year(v_inv.tenant_id, v_inv.invoice_date::DATE),
        fp.financial_period_id,
        v_inv.invoice_date, v_inv.invoice_date,
        'system', 'SALES_INVOICE', v_inv.sales_invoice_id,
        v_inv.invoice_number, v_inv.currency_code, v_inv.exchange_rate,
        v_inv.total_amount, v_inv.total_amount, 'draft',
        p_user_id, p_user_id
    FROM core.financial_periods fp
    WHERE fp.tenant_id = v_inv.tenant_id
      AND v_inv.invoice_date BETWEEN fp.start_date AND fp.end_date
    LIMIT 1
    RETURNING journal_entry_id INTO v_je_id;

    -- AR debit line
    INSERT INTO finance.journal_entry_lines (
        tenant_id, branch_id, journal_entry_id, line_number,
        account_id, debit_amount, credit_amount,
        base_debit_amount, base_credit_amount,
        partner_type, partner_id, created_by, updated_by
    ) VALUES (
        v_inv.tenant_id, v_inv.branch_id, v_je_id, 1,
        v_ar_acct, v_inv.total_amount, 0,
        v_inv.total_amount * v_inv.exchange_rate, 0,
        'customer', v_inv.customer_id, p_user_id, p_user_id
    );

    -- Revenue credit line (taxable amount)
    INSERT INTO finance.journal_entry_lines (
        tenant_id, branch_id, journal_entry_id, line_number,
        account_id, debit_amount, credit_amount,
        base_debit_amount, base_credit_amount,
        created_by, updated_by
    ) VALUES (
        v_inv.tenant_id, v_inv.branch_id, v_je_id, 2,
        v_rev_acct, 0, v_inv.taxable_amount,
        0, v_inv.taxable_amount * v_inv.exchange_rate,
        p_user_id, p_user_id
    );

    -- GST liability line (tax amount)
    IF v_inv.total_tax_amount > 0 THEN
        INSERT INTO finance.journal_entry_lines (
            tenant_id, branch_id, journal_entry_id, line_number,
            account_id, debit_amount, credit_amount,
            base_debit_amount, base_credit_amount,
            created_by, updated_by
        ) VALUES (
            v_inv.tenant_id, v_inv.branch_id, v_je_id, 3,
            v_rev_acct, 0, v_inv.total_tax_amount,
            0, v_inv.total_tax_amount * v_inv.exchange_rate,
            p_user_id, p_user_id
        );
    END IF;

    -- Post JE
    PERFORM finance.fn_post_journal_entry(v_je_id, p_user_id);

    -- Update invoice
    UPDATE sales.sales_invoices
    SET status         = 'posted',
        posted_at      = NOW(),
        journal_entry_id = v_je_id,
        updated_by     = p_user_id,
        updated_at     = NOW()
    WHERE sales_invoice_id = p_invoice_id;

    -- Update customer outstanding balance
    UPDATE sales.customers
    SET outstanding_balance = outstanding_balance + v_inv.total_amount,
        updated_by          = p_user_id,
        updated_at          = NOW()
    WHERE customer_id = v_inv.customer_id;

    COMMIT;
END;
$$;

-- -----------------------------------------------------------------------------
-- sp_run_payroll
-- Processes payroll for all employees in a branch for a given month
-- -----------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE payroll.sp_run_payroll(
    p_payroll_run_id UUID,
    p_user_id        UUID
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_run         payroll.payroll_runs%ROWTYPE;
    v_emp         RECORD;
    v_assignment  payroll.employee_salary_assignments%ROWTYPE;
    v_payslip_id  UUID;
    v_payslip_num VARCHAR;
    v_gross       NUMERIC;
    v_deductions  NUMERIC;
    v_net         NUMERIC;
    v_paid_days   NUMERIC;
    v_working_days SMALLINT;
    v_component   RECORD;
BEGIN
    SELECT * INTO v_run FROM payroll.payroll_runs WHERE payroll_run_id = p_payroll_run_id;

    IF NOT FOUND THEN RAISE EXCEPTION 'Payroll run not found: %', p_payroll_run_id; END IF;
    IF v_run.status <> 'draft' THEN
        RAISE EXCEPTION 'Payroll run % already processed', v_run.run_number;
    END IF;

    UPDATE payroll.payroll_runs
    SET status = 'processing', updated_by = p_user_id, updated_at = NOW()
    WHERE payroll_run_id = p_payroll_run_id;

    -- Determine working days in the month
    v_working_days := 26; -- standard; production would calculate from calendar

    FOR v_emp IN
        SELECT e.employee_id
        FROM hr.employees e
        WHERE e.tenant_id  = v_run.tenant_id
          AND e.branch_id  = v_run.branch_id
          AND e.is_active  = TRUE
          AND e.deleted_at IS NULL
    LOOP
        -- Get active salary assignment
        SELECT * INTO v_assignment
        FROM payroll.employee_salary_assignments
        WHERE employee_id   = v_emp.employee_id
          AND is_active     = TRUE
          AND effective_from <= MAKE_DATE(v_run.payroll_year, v_run.payroll_month, 1)
          AND (effective_until IS NULL OR effective_until >= MAKE_DATE(v_run.payroll_year, v_run.payroll_month, 1))
          AND deleted_at IS NULL
        ORDER BY effective_from DESC
        LIMIT 1;

        CONTINUE WHEN NOT FOUND;

        -- Get paid days from attendance (simplified: assume full month)
        SELECT COALESCE(
            SUM(CASE WHEN ar.status IN ('present','work_from_home','on_duty') THEN 1
                     WHEN ar.status = 'half_day' THEN 0.5
                     ELSE 0 END), v_working_days
        )
        INTO v_paid_days
        FROM attendance.attendance_records ar
        WHERE ar.employee_id    = v_emp.employee_id
          AND EXTRACT(MONTH FROM ar.attendance_date) = v_run.payroll_month
          AND EXTRACT(YEAR  FROM ar.attendance_date) = v_run.payroll_year
          AND ar.deleted_at IS NULL;

        v_gross := 0; v_deductions := 0;

        -- Generate payslip number
        v_payslip_num := core.fn_generate_document_number(
            v_run.tenant_id, v_run.branch_id, 'PAYSLIP'
        );

        -- Create payslip skeleton
        INSERT INTO payroll.payslips (
            tenant_id, branch_id, payroll_run_id, employee_id,
            payslip_number, payroll_month, payroll_year,
            working_days, paid_days, gross_salary, total_deductions, net_salary,
            payment_status, created_by, updated_by
        ) VALUES (
            v_run.tenant_id, v_run.branch_id, p_payroll_run_id, v_emp.employee_id,
            v_payslip_num, v_run.payroll_month, v_run.payroll_year,
            v_working_days, v_paid_days, 0, 0, 0,
            'pending', p_user_id, p_user_id
        ) RETURNING payslip_id INTO v_payslip_id;

        -- Calculate and insert line items
        FOR v_component IN
            SELECT * FROM payroll.fn_calculate_payslip_components(
                v_assignment.salary_assignment_id, v_paid_days, v_working_days
            )
        LOOP
            INSERT INTO payroll.payslip_line_items (
                tenant_id, branch_id, payslip_id,
                salary_component_id, component_type, amount,
                created_by, updated_by
            ) VALUES (
                v_run.tenant_id, v_run.branch_id, v_payslip_id,
                v_component.salary_component_id, v_component.component_type,
                v_component.amount, p_user_id, p_user_id
            );

            IF v_component.component_type = 'earning' THEN
                v_gross := v_gross + v_component.amount;
            ELSE
                v_deductions := v_deductions + ABS(v_component.amount);
            END IF;
        END LOOP;

        v_net := v_gross - v_deductions;

        -- Update payslip totals
        UPDATE payroll.payslips
        SET gross_salary     = v_gross,
            total_deductions = v_deductions,
            net_salary       = v_net,
            updated_at       = NOW(),
            updated_by       = p_user_id
        WHERE payslip_id = v_payslip_id;
    END LOOP;

    -- Update run totals
    UPDATE payroll.payroll_runs pr
    SET status          = 'processed',
        total_employees = (SELECT COUNT(*) FROM payroll.payslips WHERE payroll_run_id = p_payroll_run_id),
        total_gross     = (SELECT COALESCE(SUM(gross_salary), 0)     FROM payroll.payslips WHERE payroll_run_id = p_payroll_run_id),
        total_deductions= (SELECT COALESCE(SUM(total_deductions), 0) FROM payroll.payslips WHERE payroll_run_id = p_payroll_run_id),
        total_net       = (SELECT COALESCE(SUM(net_salary), 0)       FROM payroll.payslips WHERE payroll_run_id = p_payroll_run_id),
        processed_at    = NOW(),
        updated_by      = p_user_id,
        updated_at      = NOW()
    WHERE payroll_run_id = p_payroll_run_id;

    COMMIT;
END;
$$;

-- -----------------------------------------------------------------------------
-- sp_close_financial_period
-- Closes a financial period (blocks new JEs against it)
-- -----------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE finance.sp_close_financial_period(
    p_financial_period_id UUID,
    p_user_id             UUID
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_period core.financial_periods%ROWTYPE;
    v_unposted_count INTEGER;
BEGIN
    SELECT * INTO v_period
    FROM core.financial_periods
    WHERE financial_period_id = p_financial_period_id;

    IF NOT FOUND THEN RAISE EXCEPTION 'Period not found: %', p_financial_period_id; END IF;
    IF v_period.is_closed THEN RAISE EXCEPTION 'Period already closed'; END IF;

    -- Check for unposted journal entries
    SELECT COUNT(*) INTO v_unposted_count
    FROM finance.journal_entries je
    WHERE je.tenant_id         = v_period.tenant_id
      AND je.financial_period_id = p_financial_period_id
      AND je.status             = 'draft'
      AND je.deleted_at IS NULL;

    IF v_unposted_count > 0 THEN
        RAISE EXCEPTION 'Cannot close period: % unposted journal entries exist', v_unposted_count;
    END IF;

    UPDATE core.financial_periods
    SET is_closed  = TRUE,
        closed_at  = NOW(),
        closed_by  = p_user_id,
        updated_by = p_user_id,
        updated_at = NOW()
    WHERE financial_period_id = p_financial_period_id;

    COMMIT;
END;
$$;

-- -----------------------------------------------------------------------------
-- sp_process_leave_application
-- Approves/rejects a leave application and updates leave balance
-- -----------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE attendance.sp_process_leave_application(
    p_leave_application_id UUID,
    p_action               VARCHAR, -- 'approve' or 'reject'
    p_reviewer_id          UUID,
    p_comments             TEXT DEFAULT NULL
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_app       attendance.leave_applications%ROWTYPE;
    v_balance   NUMERIC;
    v_fy_id     UUID;
BEGIN
    SELECT * INTO v_app
    FROM attendance.leave_applications
    WHERE leave_application_id = p_leave_application_id AND deleted_at IS NULL;

    IF NOT FOUND THEN RAISE EXCEPTION 'Leave application not found'; END IF;
    IF v_app.status <> 'pending' THEN
        RAISE EXCEPTION 'Application already %', v_app.status;
    END IF;

    IF p_action = 'approve' THEN
        v_fy_id := core.fn_get_current_fiscal_year(v_app.tenant_id, v_app.from_date);

        v_balance := attendance.fn_get_employee_leave_balance(
            v_app.tenant_id, v_app.employee_id, v_app.leave_type_id, v_fy_id
        );

        IF v_balance < v_app.number_of_days THEN
            RAISE EXCEPTION 'Insufficient leave balance: available=% requested=%',
                v_balance, v_app.number_of_days;
        END IF;

        -- Deduct balance
        UPDATE attendance.leave_balances
        SET taken      = taken + v_app.number_of_days,
            updated_by = p_reviewer_id,
            updated_at = NOW()
        WHERE tenant_id      = v_app.tenant_id
          AND employee_id    = v_app.employee_id
          AND leave_type_id  = v_app.leave_type_id
          AND fiscal_year_id = v_fy_id
          AND deleted_at IS NULL;

        UPDATE attendance.leave_applications
        SET status      = 'approved',
            reviewed_by = p_reviewer_id,
            reviewed_at = NOW(),
            updated_by  = p_reviewer_id,
            updated_at  = NOW()
        WHERE leave_application_id = p_leave_application_id;

    ELSIF p_action = 'reject' THEN
        UPDATE attendance.leave_applications
        SET status           = 'rejected',
            reviewed_by      = p_reviewer_id,
            reviewed_at      = NOW(),
            rejection_reason = p_comments,
            updated_by       = p_reviewer_id,
            updated_at       = NOW()
        WHERE leave_application_id = p_leave_application_id;
    ELSE
        RAISE EXCEPTION 'Invalid action: %. Use approve or reject.', p_action;
    END IF;

    COMMIT;
END;
$$;

-- -----------------------------------------------------------------------------
-- sp_depreciate_assets
-- Runs monthly depreciation for all active assets in a period
-- -----------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE assets.sp_depreciate_assets(
    p_tenant_id           UUID,
    p_branch_id           UUID,
    p_financial_period_id UUID,
    p_user_id             UUID
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_asset         RECORD;
    v_dep_amount    NUMERIC;
    v_closing_value NUMERIC;
BEGIN
    FOR v_asset IN
        SELECT a.asset_id, a.current_book_value, a.salvage_value,
               a.depreciation_rate, a.depreciation_method, a.useful_life_months
        FROM assets.assets a
        WHERE a.tenant_id  = p_tenant_id
          AND a.branch_id  = p_branch_id
          AND a.status     = 'active'
          AND a.current_book_value > a.salvage_value
          AND a.depreciation_start_date IS NOT NULL
          AND a.deleted_at IS NULL
          AND NOT EXISTS (
              SELECT 1 FROM assets.depreciation_entries
              WHERE asset_id           = a.asset_id
                AND financial_period_id = p_financial_period_id
          )
    LOOP
        -- Straight-line monthly depreciation
        v_dep_amount := CASE v_asset.depreciation_method
            WHEN 'straight_line' THEN
                LEAST(
                    v_asset.current_book_value - v_asset.salvage_value,
                    (v_asset.current_book_value / NULLIF(v_asset.useful_life_months, 0))
                )
            WHEN 'declining_balance' THEN
                v_asset.current_book_value * v_asset.depreciation_rate / 100 / 12
            ELSE 0
        END;

        v_dep_amount   := ROUND(GREATEST(v_dep_amount, 0), 2);
        v_closing_value := v_asset.current_book_value - v_dep_amount;

        INSERT INTO assets.depreciation_entries (
            tenant_id, branch_id, asset_id, financial_period_id,
            depreciation_date, opening_book_value,
            depreciation_amount, closing_book_value,
            created_by, updated_by
        ) VALUES (
            p_tenant_id, p_branch_id, v_asset.asset_id, p_financial_period_id,
            CURRENT_DATE, v_asset.current_book_value,
            v_dep_amount, v_closing_value,
            p_user_id, p_user_id
        );

        UPDATE assets.assets
        SET current_book_value = v_closing_value,
            updated_by         = p_user_id,
            updated_at         = NOW()
        WHERE asset_id = v_asset.asset_id;
    END LOOP;

    COMMIT;
END;
$$;
