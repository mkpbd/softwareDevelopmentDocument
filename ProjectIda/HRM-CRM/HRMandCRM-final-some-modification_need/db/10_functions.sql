-- =============================================================================
-- functions.sql — Step 3: PL/pgSQL Functions
-- Naming: fn_<action>_<entity>
-- =============================================================================

-- -----------------------------------------------------------------------------
-- fn_generate_document_number
-- Returns the next formatted document number for a given type
-- -----------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION core.fn_generate_document_number(
    p_tenant_id     UUID,
    p_branch_id     UUID,
    p_document_type VARCHAR,
    p_fiscal_year_id UUID DEFAULT NULL
)
RETURNS VARCHAR
LANGUAGE plpgsql
AS $$
DECLARE
    v_seq       core.document_sequences%ROWTYPE;
    v_next_num  BIGINT;
    v_number    VARCHAR;
BEGIN
    SELECT * INTO v_seq
    FROM core.document_sequences
    WHERE tenant_id      = p_tenant_id
      AND branch_id      = p_branch_id
      AND document_type  = p_document_type
      AND (fiscal_year_id = p_fiscal_year_id OR (p_fiscal_year_id IS NULL AND fiscal_year_id IS NULL))
      AND deleted_at IS NULL
    FOR UPDATE;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Document sequence not configured for type: %', p_document_type;
    END IF;

    v_next_num := v_seq.current_number + 1;

    UPDATE core.document_sequences
    SET current_number = v_next_num,
        updated_at     = NOW()
    WHERE document_sequence_id = v_seq.document_sequence_id;

    v_number := COALESCE(v_seq.prefix, '')
             || LPAD(v_next_num::TEXT, v_seq.padding_length, '0')
             || COALESCE(v_seq.suffix, '');

    RETURN v_number;
END;
$$;

-- -----------------------------------------------------------------------------
-- fn_get_current_exchange_rate
-- Returns the most recent exchange rate for a currency pair on or before a date
-- -----------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION core.fn_get_current_exchange_rate(
    p_tenant_id         UUID,
    p_from_currency     VARCHAR,
    p_to_currency       VARCHAR,
    p_rate_date         DATE DEFAULT CURRENT_DATE
)
RETURNS NUMERIC
LANGUAGE plpgsql
AS $$
DECLARE
    v_rate NUMERIC;
BEGIN
    IF p_from_currency = p_to_currency THEN
        RETURN 1;
    END IF;

    SELECT rate INTO v_rate
    FROM core.exchange_rates
    WHERE tenant_id          = p_tenant_id
      AND from_currency_code = p_from_currency
      AND to_currency_code   = p_to_currency
      AND rate_date          <= p_rate_date
      AND deleted_at IS NULL
    ORDER BY rate_date DESC
    LIMIT 1;

    IF v_rate IS NULL THEN
        RAISE EXCEPTION 'No exchange rate found for % to % on or before %',
            p_from_currency, p_to_currency, p_rate_date;
    END IF;

    RETURN v_rate;
END;
$$;

-- -----------------------------------------------------------------------------
-- fn_get_current_fiscal_year
-- Returns the active fiscal year id for a tenant
-- -----------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION core.fn_get_current_fiscal_year(
    p_tenant_id UUID,
    p_date      DATE DEFAULT CURRENT_DATE
)
RETURNS UUID
LANGUAGE plpgsql
AS $$
DECLARE
    v_fy_id UUID;
BEGIN
    SELECT fiscal_year_id INTO v_fy_id
    FROM core.fiscal_years
    WHERE tenant_id  = p_tenant_id
      AND start_date <= p_date
      AND end_date   >= p_date
      AND deleted_at IS NULL
    ORDER BY start_date DESC
    LIMIT 1;

    RETURN v_fy_id;
END;
$$;

-- -----------------------------------------------------------------------------
-- fn_get_item_stock_balance
-- Returns available quantity for an item in a warehouse
-- -----------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION inventory.fn_get_item_stock_balance(
    p_tenant_id    UUID,
    p_item_id      UUID,
    p_warehouse_id UUID
)
RETURNS NUMERIC
LANGUAGE plpgsql
AS $$
DECLARE
    v_qty NUMERIC;
BEGIN
    SELECT COALESCE(SUM(quantity_available), 0) INTO v_qty
    FROM inventory.stock_balances
    WHERE tenant_id    = p_tenant_id
      AND item_id      = p_item_id
      AND warehouse_id = p_warehouse_id
      AND deleted_at IS NULL;

    RETURN v_qty;
END;
$$;

-- -----------------------------------------------------------------------------
-- fn_update_stock_balance
-- Upserts the stock_balances record after a stock ledger entry
-- -----------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION inventory.fn_update_stock_balance(
    p_tenant_id           UUID,
    p_branch_id           UUID,
    p_item_id             UUID,
    p_warehouse_id        UUID,
    p_warehouse_location_id UUID,
    p_batch_id            UUID,
    p_qty_delta           NUMERIC,
    p_valuation_rate      NUMERIC,
    p_system_user         UUID
)
RETURNS VOID
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO inventory.stock_balances (
        tenant_id, branch_id, item_id, warehouse_id,
        warehouse_location_id, batch_id,
        quantity_on_hand, valuation_rate, stock_value,
        last_updated_at, created_by, updated_by
    )
    VALUES (
        p_tenant_id, p_branch_id, p_item_id, p_warehouse_id,
        p_warehouse_location_id, p_batch_id,
        p_qty_delta, p_valuation_rate, p_qty_delta * p_valuation_rate,
        NOW(), p_system_user, p_system_user
    )
    ON CONFLICT (tenant_id, item_id, warehouse_id, warehouse_location_id, batch_id)
    DO UPDATE SET
        quantity_on_hand = inventory.stock_balances.quantity_on_hand + EXCLUDED.quantity_on_hand,
        valuation_rate   = CASE
            WHEN (inventory.stock_balances.quantity_on_hand + EXCLUDED.quantity_on_hand) > 0
            THEN (inventory.stock_balances.stock_value + EXCLUDED.stock_value)
                 / (inventory.stock_balances.quantity_on_hand + EXCLUDED.quantity_on_hand)
            ELSE 0
        END,
        stock_value      = GREATEST(0,
            inventory.stock_balances.stock_value + EXCLUDED.stock_value),
        last_updated_at  = NOW(),
        updated_by       = p_system_user,
        updated_at       = NOW();
END;
$$;

-- -----------------------------------------------------------------------------
-- fn_calculate_gst_amounts
-- Splits taxable amount into CGST/SGST/IGST based on supply type
-- -----------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION tax.fn_calculate_gst_amounts(
    p_taxable_amount NUMERIC,
    p_tax_rate_id    UUID,
    p_supply_type    VARCHAR  -- 'intrastate' or 'interstate'
)
RETURNS TABLE(cgst NUMERIC, sgst NUMERIC, igst NUMERIC, cess NUMERIC, total_tax NUMERIC)
LANGUAGE plpgsql
AS $$
DECLARE
    v_rate tax.tax_rates%ROWTYPE;
BEGIN
    SELECT * INTO v_rate FROM tax.tax_rates WHERE tax_rate_id = p_tax_rate_id;

    IF p_supply_type = 'intrastate' THEN
        cgst      := ROUND(p_taxable_amount * v_rate.cgst_rate / 100, 2);
        sgst      := ROUND(p_taxable_amount * v_rate.sgst_rate / 100, 2);
        igst      := 0;
    ELSE
        cgst      := 0;
        sgst      := 0;
        igst      := ROUND(p_taxable_amount * v_rate.igst_rate / 100, 2);
    END IF;

    cess      := ROUND(p_taxable_amount * v_rate.cess_rate / 100, 2);
    total_tax := cgst + sgst + igst + cess;

    RETURN NEXT;
END;
$$;

-- -----------------------------------------------------------------------------
-- fn_get_employee_leave_balance
-- Returns current leave balance for employee/leave type/fiscal year
-- -----------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION attendance.fn_get_employee_leave_balance(
    p_tenant_id     UUID,
    p_employee_id   UUID,
    p_leave_type_id UUID,
    p_fiscal_year_id UUID
)
RETURNS NUMERIC
LANGUAGE plpgsql
AS $$
DECLARE
    v_balance NUMERIC;
BEGIN
    SELECT balance INTO v_balance
    FROM attendance.leave_balances
    WHERE tenant_id      = p_tenant_id
      AND employee_id    = p_employee_id
      AND leave_type_id  = p_leave_type_id
      AND fiscal_year_id = p_fiscal_year_id
      AND deleted_at IS NULL;

    RETURN COALESCE(v_balance, 0);
END;
$$;

-- -----------------------------------------------------------------------------
-- fn_calculate_payslip_components
-- Computes each salary component amount for an employee payslip
-- -----------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION payroll.fn_calculate_payslip_components(
    p_salary_assignment_id UUID,
    p_paid_days            NUMERIC,
    p_working_days         SMALLINT
)
RETURNS TABLE(
    salary_component_id UUID,
    component_type      VARCHAR,
    amount              NUMERIC
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_assignment    payroll.employee_salary_assignments%ROWTYPE;
    v_component     RECORD;
    v_basic         NUMERIC;
    v_amount        NUMERIC;
    v_pay_factor    NUMERIC;
BEGIN
    SELECT * INTO v_assignment
    FROM payroll.employee_salary_assignments
    WHERE salary_assignment_id = p_salary_assignment_id;

    v_pay_factor := CASE WHEN p_working_days > 0
                    THEN p_paid_days / p_working_days
                    ELSE 1 END;

    v_basic := v_assignment.basic_amount * v_pay_factor;

    FOR v_component IN
        SELECT sc.*, ssc.amount_or_rate
        FROM payroll.salary_structure_components ssc
        JOIN payroll.salary_components sc
          ON sc.salary_component_id = ssc.salary_component_id
        WHERE ssc.salary_structure_id = v_assignment.salary_structure_id
          AND sc.is_active = TRUE
          AND ssc.deleted_at IS NULL
        ORDER BY ssc.sequence_number
    LOOP
        v_amount := CASE v_component.calculation_type
            WHEN 'fixed'               THEN v_component.amount_or_rate * v_pay_factor
            WHEN 'percentage_of_basic' THEN v_basic * v_component.amount_or_rate / 100
            WHEN 'percentage_of_ctc'   THEN v_assignment.ctc_amount * v_component.amount_or_rate / 100 * v_pay_factor
            ELSE 0
        END;

        salary_component_id := v_component.salary_component_id;
        component_type      := v_component.component_type;
        amount              := ROUND(v_amount, 2);

        RETURN NEXT;
    END LOOP;
END;
$$;

-- -----------------------------------------------------------------------------
-- fn_get_outstanding_receivables
-- Returns total outstanding for a customer
-- -----------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION sales.fn_get_outstanding_receivables(
    p_tenant_id   UUID,
    p_customer_id UUID
)
RETURNS NUMERIC
LANGUAGE plpgsql
AS $$
DECLARE
    v_outstanding NUMERIC;
BEGIN
    SELECT COALESCE(SUM(amount_outstanding), 0) INTO v_outstanding
    FROM sales.sales_invoices
    WHERE tenant_id   = p_tenant_id
      AND customer_id = p_customer_id
      AND status NOT IN ('cancelled','paid')
      AND deleted_at IS NULL;

    RETURN v_outstanding;
END;
$$;

-- -----------------------------------------------------------------------------
-- fn_get_outstanding_payables
-- Returns total outstanding for a supplier
-- -----------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION purchase.fn_get_outstanding_payables(
    p_tenant_id   UUID,
    p_supplier_id UUID
)
RETURNS NUMERIC
LANGUAGE plpgsql
AS $$
DECLARE
    v_outstanding NUMERIC;
BEGIN
    SELECT COALESCE(SUM(amount_outstanding), 0) INTO v_outstanding
    FROM purchase.supplier_invoices
    WHERE tenant_id   = p_tenant_id
      AND supplier_id = p_supplier_id
      AND status NOT IN ('cancelled','paid')
      AND deleted_at IS NULL;

    RETURN v_outstanding;
END;
$$;

-- -----------------------------------------------------------------------------
-- fn_check_credit_limit
-- Returns TRUE if customer has sufficient credit, FALSE if limit exceeded
-- -----------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION sales.fn_check_credit_limit(
    p_tenant_id      UUID,
    p_customer_id    UUID,
    p_new_order_amount NUMERIC
)
RETURNS BOOLEAN
LANGUAGE plpgsql
AS $$
DECLARE
    v_customer sales.customers%ROWTYPE;
    v_outstanding NUMERIC;
BEGIN
    SELECT * INTO v_customer
    FROM sales.customers
    WHERE tenant_id   = p_tenant_id
      AND customer_id = p_customer_id;

    IF v_customer.credit_limit = 0 THEN
        RETURN TRUE;
    END IF;

    v_outstanding := sales.fn_get_outstanding_receivables(p_tenant_id, p_customer_id);

    RETURN (v_outstanding + p_new_order_amount) <= v_customer.credit_limit;
END;
$$;

-- -----------------------------------------------------------------------------
-- fn_post_journal_entry
-- Posts a journal entry and validates debit = credit balance
-- -----------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION finance.fn_post_journal_entry(
    p_journal_entry_id UUID,
    p_posted_by        UUID
)
RETURNS VOID
LANGUAGE plpgsql
AS $$
DECLARE
    v_total_debit  NUMERIC;
    v_total_credit NUMERIC;
BEGIN
    SELECT SUM(debit_amount), SUM(credit_amount)
    INTO v_total_debit, v_total_credit
    FROM finance.journal_entry_lines
    WHERE journal_entry_id = p_journal_entry_id
      AND deleted_at IS NULL;

    IF ROUND(v_total_debit, 2) <> ROUND(v_total_credit, 2) THEN
        RAISE EXCEPTION 'Journal entry is unbalanced: debit=% credit=%',
            v_total_debit, v_total_credit;
    END IF;

    UPDATE finance.journal_entries
    SET status         = 'posted',
        total_debit    = v_total_debit,
        total_credit   = v_total_credit,
        posted_at      = NOW(),
        posted_by      = p_posted_by,
        updated_at     = NOW(),
        updated_by     = p_posted_by
    WHERE journal_entry_id = p_journal_entry_id
      AND status           = 'draft';

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Journal entry not found or already posted: %', p_journal_entry_id;
    END IF;
END;
$$;

-- -----------------------------------------------------------------------------
-- fn_get_project_profitability
-- Returns billed vs cost for a project
-- -----------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION projects.fn_get_project_profitability(
    p_project_id UUID
)
RETURNS TABLE(
    billed_amount   NUMERIC,
    actual_cost     NUMERIC,
    gross_margin    NUMERIC,
    margin_percent  NUMERIC
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_proj projects.projects%ROWTYPE;
BEGIN
    SELECT * INTO v_proj FROM projects.projects WHERE project_id = p_project_id;

    billed_amount  := v_proj.billed_amount;
    actual_cost    := v_proj.actual_cost;
    gross_margin   := v_proj.billed_amount - v_proj.actual_cost;
    margin_percent := CASE WHEN v_proj.billed_amount > 0
                     THEN ROUND((v_proj.billed_amount - v_proj.actual_cost) / v_proj.billed_amount * 100, 2)
                     ELSE 0 END;

    RETURN NEXT;
END;
$$;
