-- =============================================================================
-- views.sql — Step 4: Optimized Views
-- Naming: vw_<purpose>
-- =============================================================================

-- -----------------------------------------------------------------------------
-- vw_active_users — Users with their roles (active only)
-- -----------------------------------------------------------------------------
CREATE OR REPLACE VIEW iam.vw_active_users AS
SELECT
    u.user_id,
    u.tenant_id,
    u.branch_id,
    u.username,
    u.email,
    u.full_name,
    u.display_name,
    u.is_active,
    u.last_login_at,
    ARRAY_AGG(r.role_code) FILTER (WHERE r.role_code IS NOT NULL) AS roles,
    ARRAY_AGG(r.role_name) FILTER (WHERE r.role_name IS NOT NULL) AS role_names
FROM iam.users u
LEFT JOIN iam.user_roles ur ON ur.user_id = u.user_id AND ur.deleted_at IS NULL
LEFT JOIN iam.roles r       ON r.role_id  = ur.role_id AND r.deleted_at IS NULL
WHERE u.deleted_at IS NULL
  AND u.is_active = TRUE
GROUP BY u.user_id, u.tenant_id, u.branch_id, u.username,
         u.email, u.full_name, u.display_name, u.is_active, u.last_login_at;

-- -----------------------------------------------------------------------------
-- vw_accounts_receivable_aging — AR aging buckets per customer
-- -----------------------------------------------------------------------------
CREATE OR REPLACE VIEW sales.vw_accounts_receivable_aging AS
SELECT
    si.tenant_id,
    si.branch_id,
    si.customer_id,
    c.customer_code,
    c.customer_name,
    COUNT(si.sales_invoice_id)                                  AS invoice_count,
    SUM(si.amount_outstanding)                                  AS total_outstanding,
    SUM(CASE WHEN CURRENT_DATE - si.due_date <= 0
             THEN si.amount_outstanding ELSE 0 END)             AS current_amount,
    SUM(CASE WHEN CURRENT_DATE - si.due_date BETWEEN 1  AND 30
             THEN si.amount_outstanding ELSE 0 END)             AS overdue_1_30,
    SUM(CASE WHEN CURRENT_DATE - si.due_date BETWEEN 31 AND 60
             THEN si.amount_outstanding ELSE 0 END)             AS overdue_31_60,
    SUM(CASE WHEN CURRENT_DATE - si.due_date BETWEEN 61 AND 90
             THEN si.amount_outstanding ELSE 0 END)             AS overdue_61_90,
    SUM(CASE WHEN CURRENT_DATE - si.due_date > 90
             THEN si.amount_outstanding ELSE 0 END)             AS overdue_90_plus
FROM sales.sales_invoices si
JOIN sales.customers c ON c.customer_id = si.customer_id
WHERE si.deleted_at IS NULL
  AND si.status NOT IN ('cancelled', 'paid')
GROUP BY si.tenant_id, si.branch_id, si.customer_id,
         c.customer_code, c.customer_name;

-- -----------------------------------------------------------------------------
-- vw_accounts_payable_aging — AP aging buckets per supplier
-- -----------------------------------------------------------------------------
CREATE OR REPLACE VIEW purchase.vw_accounts_payable_aging AS
SELECT
    pi.tenant_id,
    pi.branch_id,
    pi.supplier_id,
    s.supplier_code,
    s.supplier_name,
    COUNT(pi.supplier_invoice_id)                               AS invoice_count,
    SUM(pi.amount_outstanding)                                  AS total_outstanding,
    SUM(CASE WHEN CURRENT_DATE - pi.due_date <= 0
             THEN pi.amount_outstanding ELSE 0 END)             AS current_amount,
    SUM(CASE WHEN CURRENT_DATE - pi.due_date BETWEEN 1  AND 30
             THEN pi.amount_outstanding ELSE 0 END)             AS overdue_1_30,
    SUM(CASE WHEN CURRENT_DATE - pi.due_date BETWEEN 31 AND 60
             THEN pi.amount_outstanding ELSE 0 END)             AS overdue_31_60,
    SUM(CASE WHEN CURRENT_DATE - pi.due_date > 60
             THEN pi.amount_outstanding ELSE 0 END)             AS overdue_60_plus
FROM purchase.supplier_invoices pi
JOIN purchase.suppliers s ON s.supplier_id = pi.supplier_id
WHERE pi.deleted_at IS NULL
  AND pi.status NOT IN ('cancelled', 'paid')
GROUP BY pi.tenant_id, pi.branch_id, pi.supplier_id,
         s.supplier_code, s.supplier_name;

-- -----------------------------------------------------------------------------
-- vw_stock_position — Current stock across warehouses with low-stock flag
-- -----------------------------------------------------------------------------
CREATE OR REPLACE VIEW inventory.vw_stock_position AS
SELECT
    sb.tenant_id,
    sb.branch_id,
    sb.item_id,
    i.item_code,
    i.item_name,
    sb.warehouse_id,
    w.warehouse_code,
    w.warehouse_name,
    sb.batch_id,
    sb.quantity_on_hand,
    sb.quantity_reserved,
    sb.quantity_available,
    sb.quantity_on_order,
    sb.valuation_rate,
    sb.stock_value,
    i.reorder_point,
    CASE WHEN sb.quantity_available <= i.reorder_point
         THEN TRUE ELSE FALSE END                               AS is_below_reorder,
    sb.last_updated_at
FROM inventory.stock_balances sb
JOIN inventory.items     i ON i.item_id     = sb.item_id
JOIN inventory.warehouses w ON w.warehouse_id = sb.warehouse_id
WHERE sb.deleted_at IS NULL
  AND i.deleted_at  IS NULL
  AND w.deleted_at  IS NULL;

-- -----------------------------------------------------------------------------
-- vw_sales_order_status — Sales orders with delivery and invoice progress
-- -----------------------------------------------------------------------------
CREATE OR REPLACE VIEW sales.vw_sales_order_status AS
SELECT
    so.tenant_id,
    so.branch_id,
    so.sales_order_id,
    so.order_number,
    so.order_date,
    so.customer_id,
    c.customer_code,
    c.customer_name,
    so.total_amount,
    so.delivered_amount,
    so.invoiced_amount,
    so.status,
    so.sales_person_id,
    u.full_name                                                  AS sales_person_name,
    (so.total_amount - so.invoiced_amount)                       AS pending_invoice_amount,
    so.created_at
FROM sales.sales_orders so
JOIN sales.customers c ON c.customer_id = so.customer_id
LEFT JOIN iam.users u  ON u.user_id = so.sales_person_id
WHERE so.deleted_at IS NULL;

-- -----------------------------------------------------------------------------
-- vw_purchase_order_status — POs with GRN and billing progress
-- -----------------------------------------------------------------------------
CREATE OR REPLACE VIEW purchase.vw_purchase_order_status AS
SELECT
    po.tenant_id,
    po.branch_id,
    po.purchase_order_id,
    po.po_number,
    po.po_date,
    po.supplier_id,
    s.supplier_code,
    s.supplier_name,
    po.total_amount,
    po.received_amount,
    po.billed_amount,
    po.status,
    po.expected_delivery_date,
    (po.total_amount - po.billed_amount)                        AS pending_billing_amount
FROM purchase.purchase_orders po
JOIN purchase.suppliers s ON s.supplier_id = po.supplier_id
WHERE po.deleted_at IS NULL;

-- -----------------------------------------------------------------------------
-- vw_employee_master — Full employee profile for HR dashboards
-- -----------------------------------------------------------------------------
CREATE OR REPLACE VIEW hr.vw_employee_master AS
SELECT
    e.tenant_id,
    e.branch_id,
    e.employee_id,
    e.employee_number,
    e.first_name || ' ' || e.last_name                          AS full_name,
    e.work_email,
    e.work_phone,
    e.gender,
    e.date_of_joining,
    e.employment_type,
    e.is_active,
    d.department_code,
    d.department_name,
    des.designation_code,
    des.designation_name,
    des.grade,
    des.band,
    mgr.first_name || ' ' || mgr.last_name                     AS reporting_manager_name,
    e.date_of_leaving,
    EXTRACT(YEAR FROM AGE(COALESCE(e.date_of_leaving, CURRENT_DATE), e.date_of_joining))
        || ' yr'                                                AS tenure
FROM hr.employees e
LEFT JOIN hr.departments  d   ON d.department_id   = e.department_id
LEFT JOIN hr.designations des ON des.designation_id = e.designation_id
LEFT JOIN hr.employees    mgr ON mgr.employee_id   = e.reporting_to
WHERE e.deleted_at IS NULL;

-- -----------------------------------------------------------------------------
-- vw_attendance_monthly_summary — Monthly attendance KPIs per employee
-- -----------------------------------------------------------------------------
CREATE OR REPLACE VIEW attendance.vw_attendance_monthly_summary AS
SELECT
    ar.tenant_id,
    ar.branch_id,
    ar.employee_id,
    e.employee_number,
    e.first_name || ' ' || e.last_name                          AS full_name,
    DATE_TRUNC('month', ar.attendance_date)::DATE               AS attendance_month,
    COUNT(*)                                                     AS total_days,
    SUM(CASE WHEN ar.status = 'present' THEN 1 ELSE 0 END)      AS present_days,
    SUM(CASE WHEN ar.status = 'absent'  THEN 1 ELSE 0 END)      AS absent_days,
    SUM(CASE WHEN ar.status = 'leave'   THEN 1 ELSE 0 END)      AS leave_days,
    SUM(CASE WHEN ar.status = 'half_day' THEN 0.5 ELSE 0 END)   AS half_days,
    SUM(ar.overtime_hours)                                       AS total_overtime_hours,
    SUM(ar.working_hours)                                        AS total_working_hours,
    AVG(ar.late_by_minutes)                                      AS avg_late_minutes
FROM attendance.attendance_records ar
JOIN hr.employees e ON e.employee_id = ar.employee_id
WHERE ar.deleted_at IS NULL
GROUP BY ar.tenant_id, ar.branch_id, ar.employee_id,
         e.employee_number, e.first_name, e.last_name,
         DATE_TRUNC('month', ar.attendance_date)::DATE;

-- -----------------------------------------------------------------------------
-- vw_payroll_summary — Payroll run totals by month/branch
-- -----------------------------------------------------------------------------
CREATE OR REPLACE VIEW payroll.vw_payroll_summary AS
SELECT
    pr.tenant_id,
    pr.branch_id,
    pr.payroll_run_id,
    pr.run_number,
    pr.payroll_year,
    pr.payroll_month,
    TO_CHAR(MAKE_DATE(pr.payroll_year, pr.payroll_month, 1), 'Mon YYYY') AS period_label,
    pr.payment_date,
    pr.total_employees,
    pr.total_gross,
    pr.total_deductions,
    pr.total_net,
    pr.total_employer_pf,
    pr.total_employer_esi,
    pr.status,
    pr.approved_at
FROM payroll.payroll_runs pr
WHERE pr.deleted_at IS NULL;

-- -----------------------------------------------------------------------------
-- vw_crm_pipeline — Opportunity pipeline with weighted values
-- -----------------------------------------------------------------------------
CREATE OR REPLACE VIEW crm.vw_crm_pipeline AS
SELECT
    o.tenant_id,
    o.branch_id,
    o.opportunity_id,
    o.opportunity_number,
    o.opportunity_name,
    o.stage,
    o.probability_percent,
    o.expected_revenue,
    ROUND(o.expected_revenue * o.probability_percent / 100, 2)  AS weighted_revenue,
    o.currency_code,
    o.expected_close_date,
    o.customer_id,
    c.customer_name,
    o.assigned_to,
    u.full_name                                                  AS owner_name,
    o.created_at
FROM crm.opportunities o
JOIN sales.customers c ON c.customer_id = o.customer_id
LEFT JOIN iam.users u  ON u.user_id = o.assigned_to
WHERE o.deleted_at IS NULL
  AND o.stage NOT IN ('closed_won', 'closed_lost');

-- -----------------------------------------------------------------------------
-- vw_asset_register — Asset book values with depreciation status
-- -----------------------------------------------------------------------------
CREATE OR REPLACE VIEW assets.vw_asset_register AS
SELECT
    a.tenant_id,
    a.branch_id,
    a.asset_id,
    a.asset_number,
    a.asset_name,
    ac.category_code,
    ac.category_name,
    a.purchase_date,
    a.purchase_value,
    a.salvage_value,
    a.current_book_value,
    a.purchase_value - a.current_book_value                     AS accumulated_depreciation,
    a.depreciation_method,
    a.useful_life_months,
    a.status,
    a.condition,
    e.first_name || ' ' || e.last_name                         AS assigned_to_name,
    a.insurance_policy_number,
    a.insurance_expiry,
    a.next_maintenance_date
FROM assets.assets a
JOIN assets.asset_categories ac ON ac.asset_category_id = a.asset_category_id
LEFT JOIN hr.employees e        ON e.employee_id = a.assigned_to
WHERE a.deleted_at IS NULL;

-- -----------------------------------------------------------------------------
-- vw_expiring_batches — Batches expiring in next 90 days with stock quantity
-- -----------------------------------------------------------------------------
CREATE OR REPLACE VIEW inventory.vw_expiring_batches AS
SELECT
    b.tenant_id,
    b.branch_id,
    b.batch_id,
    b.batch_number,
    b.item_id,
    i.item_code,
    i.item_name,
    b.expiry_date,
    b.expiry_date - CURRENT_DATE                               AS days_to_expiry,
    sb.quantity_on_hand,
    sb.warehouse_id,
    w.warehouse_name
FROM inventory.batches b
JOIN inventory.items i ON i.item_id = b.item_id
LEFT JOIN inventory.stock_balances sb ON sb.batch_id = b.batch_id AND sb.deleted_at IS NULL
LEFT JOIN inventory.warehouses w      ON w.warehouse_id = sb.warehouse_id
WHERE b.deleted_at IS NULL
  AND b.status = 'active'
  AND b.expiry_date IS NOT NULL
  AND b.expiry_date <= CURRENT_DATE + INTERVAL '90 days'
  AND sb.quantity_on_hand > 0;

-- -----------------------------------------------------------------------------
-- vw_pending_approvals — Pending workflow tasks across all entities
-- -----------------------------------------------------------------------------
CREATE OR REPLACE VIEW workflow.vw_pending_approvals AS
SELECT
    wt.tenant_id,
    wt.branch_id,
    wt.workflow_task_id,
    wt.assigned_to,
    u.full_name                                                 AS approver_name,
    wt.step_name,
    wi.entity_type,
    wi.entity_id,
    wi.entity_number,
    wt.due_at,
    CASE WHEN wt.due_at < NOW() THEN TRUE ELSE FALSE END        AS is_overdue,
    wi.initiated_by,
    iu.full_name                                                AS initiator_name,
    wt.created_at
FROM workflow.workflow_tasks wt
JOIN workflow.workflow_instances wi ON wi.workflow_instance_id = wt.workflow_instance_id
JOIN iam.users u                    ON u.user_id = wt.assigned_to
JOIN iam.users iu                   ON iu.user_id = wi.initiated_by
WHERE wt.deleted_at IS NULL
  AND wt.status = 'pending';

-- -----------------------------------------------------------------------------
-- vw_gst_summary — Monthly GST summary for filing
-- -----------------------------------------------------------------------------
CREATE OR REPLACE VIEW tax.vw_gst_filing_summary AS
SELECT
    si.tenant_id,
    si.branch_id,
    DATE_TRUNC('month', si.invoice_date)::DATE                  AS tax_month,
    COUNT(*)                                                     AS invoice_count,
    SUM(si.taxable_amount)                                       AS total_taxable,
    SUM(si.cgst_amount)                                          AS total_cgst,
    SUM(si.sgst_amount)                                          AS total_sgst,
    SUM(si.igst_amount)                                          AS total_igst,
    SUM(si.cess_amount)                                          AS total_cess,
    SUM(si.total_tax_amount)                                     AS total_tax,
    SUM(si.total_amount)                                         AS total_invoice_value
FROM sales.sales_invoices si
WHERE si.deleted_at IS NULL
  AND si.status NOT IN ('draft', 'cancelled')
GROUP BY si.tenant_id, si.branch_id,
         DATE_TRUNC('month', si.invoice_date)::DATE;
