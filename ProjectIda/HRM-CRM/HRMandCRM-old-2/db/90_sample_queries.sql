-- =====================================================================
-- Sample Queries (Step 9) — CRUD + reporting, real-world shape.
-- Every session must set tenant context first:
--   SELECT set_config('app.tenant_id', '<tenant-uuid>', false);
--   SELECT set_config('app.user_id',   '<user-uuid>',   false);
-- =====================================================================

-- ---------------------------------------------------------------------
-- A) Tenant bootstrap (platform admin, bypass RLS with superuser or BYPASSRLS role)
-- ---------------------------------------------------------------------

-- 1. Provision tenant + org + company + branch
WITH t AS (
  INSERT INTO app.tenants(code,name,plan_id)
  SELECT 'acme', 'Acme Corp', id FROM app.plans WHERE code='PRO'
  RETURNING id
), ctx AS (
  SELECT set_config('app.tenant_id', (SELECT id::text FROM t), false)
), org AS (
  INSERT INTO app.organizations(tenant_id,code,legal_name,base_currency)
  SELECT id,'ACME','Acme Private Limited','INR' FROM t
  RETURNING id, tenant_id
), comp AS (
  INSERT INTO app.companies(tenant_id,organization_id,code,legal_name,gstin,base_currency)
  SELECT tenant_id, id, 'ACME01','Acme Pvt Ltd','29ABCDE1234F1Z5','INR' FROM org
  RETURNING id, tenant_id
)
INSERT INTO app.branches(tenant_id,company_id,code,name,branch_type)
SELECT tenant_id, id, 'HQ','Head Office','hq' FROM comp;

-- 2. Create a user
INSERT INTO app.users(tenant_id,email,display_name,password_hash,status)
VALUES (core.current_tenant_id(),'admin@acme.in','Admin', crypt('ChangeMe123!', gen_salt('bf',12)),'active');

-- ---------------------------------------------------------------------
-- B) CRM/Sales flow
-- ---------------------------------------------------------------------

-- 3. Create a customer
INSERT INTO app.customers(tenant_id,company_id,code,name,email,phone,gstin,credit_limit,credit_days,default_currency)
VALUES (core.current_tenant_id(),
        (SELECT id FROM app.companies LIMIT 1),
        'CUST-0001','Globex Corporation','ap@globex.in','+919999000011','29GLOBE1234F1Z7',500000,30,'INR');

-- 4. Create a sales order with lines
WITH so AS (
  INSERT INTO app.sales_orders(tenant_id,company_id,order_number,order_date,customer_id,currency_code)
  VALUES (core.current_tenant_id(),
          (SELECT id FROM app.companies LIMIT 1),
          core.next_doc_number('SO'),
          CURRENT_DATE,
          (SELECT id FROM app.customers WHERE code='CUST-0001'),
          'INR')
  RETURNING id
)
INSERT INTO app.sales_order_lines(tenant_id,sales_order_id,line_no,item_id,description,uom_code,
       qty_ordered,unit_price,tax_rate_percent)
SELECT core.current_tenant_id(), so.id, 1,
       (SELECT id FROM app.items LIMIT 1),
       'Premium Widget', 'PCS', 10, 1500, 18
  FROM so;

-- 5. Submit SO (credit check + auto-approve or route to approval)
CALL app.submit_sales_order((SELECT id FROM app.sales_orders ORDER BY created_at DESC LIMIT 1));

-- 6. Post sales invoice
CALL app.post_sales_invoice((SELECT id FROM app.sales_invoices ORDER BY created_at DESC LIMIT 1));

-- 7. Record customer receipt + allocate to invoices
CALL app.record_customer_receipt(
  p_company_id      => (SELECT id FROM app.companies LIMIT 1),
  p_customer_id     => (SELECT id FROM app.customers WHERE code='CUST-0001'),
  p_bank_account_id => (SELECT id FROM app.bank_accounts LIMIT 1),
  p_amount          => 17700,
  p_currency        => 'INR',
  p_mode            => 'bank_transfer',
  p_reference       => 'UTRN20260423001',
  p_date            => CURRENT_DATE,
  p_invoice_ids     => ARRAY[(SELECT id FROM app.sales_invoices ORDER BY invoice_date DESC LIMIT 1)],
  p_allocations     => ARRAY[17700::numeric]
);

-- ---------------------------------------------------------------------
-- C) Purchase flow
-- ---------------------------------------------------------------------

-- 8. Create PO
INSERT INTO app.purchase_orders(tenant_id,company_id,po_number,po_date,supplier_id,currency_code)
VALUES (core.current_tenant_id(),
        (SELECT id FROM app.companies LIMIT 1),
        core.next_doc_number('PO'),
        CURRENT_DATE,
        (SELECT id FROM app.suppliers LIMIT 1),
        'INR');

-- 9. Receive GRN against PO (see procedure)
CALL app.receive_grn((SELECT id FROM app.grns ORDER BY created_at DESC LIMIT 1));

-- 10. Post supplier invoice
CALL app.post_supplier_invoice((SELECT id FROM app.supplier_invoices ORDER BY created_at DESC LIMIT 1));

-- ---------------------------------------------------------------------
-- D) Inventory
-- ---------------------------------------------------------------------

-- 11. Stock on hand by warehouse
SELECT * FROM app.v_stock_on_hand WHERE warehouse_id = (SELECT id FROM app.warehouses LIMIT 1);

-- 12. Reorder suggestions
SELECT * FROM app.reorder_suggestions((SELECT id FROM app.companies LIMIT 1));

-- 13. ABC classification
SELECT v.abc_class, COUNT(*) item_count, SUM(v.value) total_value
  FROM app.v_abc_analysis v
 GROUP BY v.abc_class ORDER BY v.abc_class;

-- 14. Batches expiring in next 30 days
SELECT * FROM app.expiring_batches(30);

-- 15. Stock transfer
INSERT INTO app.stock_transfers(tenant_id,transfer_number,transfer_date,from_warehouse,to_warehouse)
VALUES (core.current_tenant_id(), core.next_doc_number('STN'), CURRENT_DATE,
        (SELECT id FROM app.warehouses ORDER BY created_at LIMIT 1),
        (SELECT id FROM app.warehouses ORDER BY created_at DESC LIMIT 1));
CALL app.execute_stock_transfer((SELECT id FROM app.stock_transfers ORDER BY created_at DESC LIMIT 1));

-- ---------------------------------------------------------------------
-- E) Finance reporting
-- ---------------------------------------------------------------------

-- 16. Trial balance for current period
WITH p AS (
  SELECT period_id FROM core.period_for_date(
    (SELECT id FROM app.companies LIMIT 1), CURRENT_DATE)
)
SELECT * FROM app.trial_balance((SELECT id FROM app.companies LIMIT 1), (SELECT period_id FROM p));

-- 17. Customer ledger
SELECT * FROM app.customer_ledger(
  (SELECT id FROM app.customers WHERE code='CUST-0001'),
  CURRENT_DATE);

-- 18. AR aging
SELECT * FROM app.v_ar_aging ORDER BY current_bucket DESC;

-- 19. AP aging
SELECT * FROM app.ap_aging((SELECT id FROM app.companies LIMIT 1));

-- 20. P&L (view)
SELECT * FROM app.v_pnl WHERE company_id = (SELECT id FROM app.companies LIMIT 1);

-- 21. Overdue invoices (p95 payment days)
SELECT c.name,
       si.invoice_number, si.invoice_date, si.due_date, si.amount_due,
       CURRENT_DATE - si.due_date AS days_overdue
  FROM app.sales_invoices si
  JOIN app.customers c ON c.id = si.customer_id
 WHERE si.amount_due > 0 AND si.due_date < CURRENT_DATE
 ORDER BY days_overdue DESC, si.amount_due DESC
 LIMIT 50;

-- 22. Sales performance last 12 months (uses MV)
SELECT period, invoice_count, gross_sales, net_sales
  FROM app.mv_monthly_sales
 WHERE period >= CURRENT_DATE - interval '12 months'
 ORDER BY period;

-- 23. Top 10 customers by revenue (MV)
SELECT c.name, mt.revenue, mt.invoice_count, mt.last_invoice_date
  FROM app.mv_top_customers mt
  JOIN app.customers c ON c.id = mt.customer_id
 ORDER BY mt.revenue DESC LIMIT 10;

-- 24. Three-way match status
SELECT * FROM app.v_three_way_match WHERE three_way_match_status = 'mismatch';

-- 25. Cash flow — net by month (simplistic, receipts/payments)
SELECT date_trunc('month', payment_date)::date AS month,
       SUM(CASE WHEN payment_type='receipt' THEN amount ELSE 0 END) inflow,
       SUM(CASE WHEN payment_type='payment' THEN amount ELSE 0 END) outflow,
       SUM(CASE WHEN payment_type='receipt' THEN amount ELSE -amount END) net
  FROM app.payments
 WHERE status = 'posted'
 GROUP BY 1 ORDER BY 1;

-- ---------------------------------------------------------------------
-- F) Workflow / Approvals
-- ---------------------------------------------------------------------

-- 26. Pending approvals for current user
SELECT * FROM app.v_pending_approvals
 WHERE assignee_user_id = core.current_user_id()
 ORDER BY due_at NULLS LAST;

-- 27. Act on approval task
CALL app.act_on_task(
  p_task_id  => '00000000-0000-0000-0000-000000000000'::uuid,
  p_action   => 'approve',
  p_comments => 'LGTM');

-- 28. SLA report
SELECT * FROM app.v_workflow_sla;

-- ---------------------------------------------------------------------
-- G) Security & Ops
-- ---------------------------------------------------------------------

-- 29. Unread in-app notifications per user
SELECT * FROM app.v_unread_notifications_count
 WHERE user_id = core.current_user_id();

-- 30. Data access audit — user activity past 24h
SELECT resource_type, action, COUNT(*) AS n
  FROM audit.data_access_log
 WHERE user_id = core.current_user_id()
   AND occurred_at >= now() - interval '24 hours'
 GROUP BY 1,2 ORDER BY n DESC;

-- 31. API latency p50/p95/p99 past hour
SELECT * FROM ops.api_latency_percentiles(interval '1 hour') ORDER BY p95 DESC LIMIT 20;

-- 32. Slow query candidates (pg_stat_statements)
SELECT substring(query,1,80) AS query, calls, round(mean_exec_time::numeric,2) AS avg_ms,
       round((100*total_exec_time/SUM(total_exec_time) OVER())::numeric,2) AS pct_time
  FROM pg_stat_statements
 ORDER BY total_exec_time DESC LIMIT 20;

-- 33. Currently open alerts
SELECT * FROM ops.v_alerts_open;

-- 34. Tenant storage footprint
SELECT schemaname, relname AS table,
       pg_size_pretty(pg_total_relation_size(schemaname||'.'||relname)) AS size
  FROM pg_stat_user_tables
 WHERE schemaname IN ('app','audit','ops')
 ORDER BY pg_total_relation_size(schemaname||'.'||relname) DESC
 LIMIT 25;

-- ---------------------------------------------------------------------
-- H) CTE / Window example: invoice payment days (p50)
-- ---------------------------------------------------------------------
WITH settled AS (
  SELECT si.id, si.customer_id,
         si.invoice_date,
         MAX(p.payment_date) AS fully_paid_on,
         MAX(p.payment_date) - si.invoice_date AS days_to_pay
    FROM app.sales_invoices si
    JOIN app.payment_allocations pa ON pa.invoice_type='sales' AND pa.invoice_id = si.id
    JOIN app.payments p ON p.id = pa.payment_id AND p.status='posted'
   WHERE si.status IN ('paid','partial_paid')
   GROUP BY si.id, si.customer_id, si.invoice_date
  HAVING si.amount_due = 0
)
SELECT customer_id,
       COUNT(*) invoices,
       percentile_cont(0.5)  WITHIN GROUP (ORDER BY days_to_pay) p50_days,
       percentile_cont(0.95) WITHIN GROUP (ORDER BY days_to_pay) p95_days
  FROM settled
 GROUP BY customer_id
 ORDER BY p95_days DESC NULLS LAST LIMIT 20;
