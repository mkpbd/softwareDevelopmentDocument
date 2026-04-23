-- =====================================================================
-- STEP 9-10: Sample Queries & Optimization Notes
-- =====================================================================

-- ---------------------------------------------------------------------
-- SECTION A — CRUD SAMPLES
-- ---------------------------------------------------------------------

-- A1. Create tenant + first company
INSERT INTO core.tenant(code, name, subdomain) VALUES ('ACME','Acme Corp','acme')
RETURNING id \gset t_
INSERT INTO core.company(tenant_id, code, legal_name, country_code)
VALUES (:'t_id', 'ACME-IN', 'Acme Corp India Pvt Ltd', 'IN');

-- A2. Add a customer
INSERT INTO sales.customer(tenant_id, company_id, code, legal_name, display_name, email, currency_code)
VALUES ($1,$2,'C-0001','Foo Industries Pvt Ltd','Foo Industries','ar@foo.com','INR');

-- A3. Create sales order with lines (transaction)
BEGIN;
WITH so AS (
    INSERT INTO sales.sales_order(tenant_id, company_id, doc_no, doc_date, customer_id, currency_code, total)
    VALUES ($1,$2, core.fn_next_doc_number($1,'sales_order'), CURRENT_DATE, $3, 'INR', 0)
    RETURNING id
)
INSERT INTO sales.sales_order_line(sales_order_id, line_no, item_id, uom_id, qty, unit_price, line_total)
SELECT so.id, 1, $4, $5, 10, 1000, 10000 FROM so;
COMMIT;

-- A4. Update customer credit limit
UPDATE sales.customer SET credit_limit = 500000 WHERE code = 'C-0001';

-- A5. Soft-delete customer
UPDATE sales.customer SET deleted_at = NOW(), status = 'archived' WHERE code = 'C-0001';

-- ---------------------------------------------------------------------
-- SECTION B — REPORTING QUERIES
-- ---------------------------------------------------------------------

-- B1. Trial balance as of date
SELECT a.code, a.name, a.account_type,
       SUM(g.debit) debits, SUM(g.credit) credits,
       SUM(g.debit) - SUM(g.credit) balance
  FROM finance.account a
  JOIN finance.gl_entry g ON g.account_id = a.id
 WHERE g.company_id = $1 AND g.posting_date <= $2
 GROUP BY a.code, a.name, a.account_type ORDER BY a.code;

-- B2. Monthly P&L
SELECT to_char(posting_date,'YYYY-MM') AS month,
       SUM(CASE WHEN a.account_type='income' THEN credit - debit ELSE 0 END) revenue,
       SUM(CASE WHEN a.account_type='expense' THEN debit - credit ELSE 0 END) expense
  FROM finance.gl_entry g JOIN finance.account a ON a.id = g.account_id
 WHERE g.company_id = $1 AND g.posting_date BETWEEN $2 AND $3
 GROUP BY 1 ORDER BY 1;

-- B3. AR ageing
SELECT bucket, COUNT(*) invoices, SUM(balance_amount) outstanding
  FROM finance.v_ageing_ar WHERE company_id = $1 GROUP BY bucket;

-- B4. Top 10 customers MTD
SELECT * FROM sales.v_top_customers_mtd WHERE tenant_id_matches LIMIT 10;

-- B5. Sales pipeline value by stage
SELECT * FROM crm.v_sales_pipeline;

-- B6. Inventory valuation by warehouse
SELECT w.name warehouse, SUM(sb.on_hand_qty * sb.avg_cost) value
  FROM inventory.stock_balance sb JOIN inventory.warehouse w ON w.id = sb.warehouse_id
 WHERE sb.company_id = $1 GROUP BY w.name ORDER BY value DESC;

-- B7. Reorder list
SELECT * FROM inventory.v_low_stock;

-- B8. Expiring batches (next 30 days)
SELECT * FROM inventory.v_expiring_batches ORDER BY expiry_date;

-- B9. Attendance summary for a month
SELECT e.employee_no, e.full_name, s.*
  FROM attendance.v_monthly_summary s
  JOIN hr.employee e ON e.id = s.employee_id
 WHERE s.month = date_trunc('month', CURRENT_DATE);

-- B10. Open service tickets with SLA breach
SELECT t.doc_no, c.display_name customer, t.priority, t.status, t.sla_deadline,
       NOW() - t.raised_date AS age
  FROM service.service_ticket t
  LEFT JOIN sales.customer c ON c.id = t.customer_id
 WHERE t.status NOT IN ('resolved','closed') AND t.sla_deadline < NOW()
 ORDER BY t.priority DESC, t.sla_deadline;

-- B11. Payroll cost by department
SELECT d.name dept, SUM(ps.gross_earnings) gross_cost
  FROM payroll.payslip ps
  JOIN hr.employee e ON e.id = ps.employee_id
  JOIN hr.department d ON d.id = e.department_id
 WHERE ps.period_start = $1
 GROUP BY d.name ORDER BY gross_cost DESC;

-- B12. Canteen monthly subsidy
SELECT ca.name canteen, cs.month, cs.subsidy, cs.meal_count
  FROM canteen.v_subsidy_spend cs JOIN canteen.canteen ca ON ca.id = cs.canteen_id
 WHERE cs.month = date_trunc('month', CURRENT_DATE);

-- B13. Open work orders vs planned end (overdue)
SELECT wo.doc_no, i.name item, wo.qty_to_produce, wo.qty_produced, wo.planned_end
  FROM manufacturing.work_order wo JOIN inventory.item i ON i.id = wo.item_id
 WHERE wo.status IN ('released','in_progress') AND wo.planned_end < CURRENT_DATE;

-- B14. GSTR-3B summary for a period
SELECT * FROM tax.v_gstr3b_summary WHERE company_id = $1 AND period = '042026';

-- B15. Project profitability
SELECT p.code, p.name, (project.fn_project_pnl(p.id)).*
  FROM project.project p WHERE p.status='active';

-- B16. Leave liability per employee
SELECT e.employee_no, e.full_name, lt.name leave_type, lb.balance
  FROM attendance.leave_balance lb
  JOIN hr.employee e ON e.id = lb.employee_id
  JOIN attendance.leave_type lt ON lt.id = lb.leave_type_id
 WHERE lb.year = EXTRACT(YEAR FROM CURRENT_DATE) AND lb.balance > 0;

-- B17. Recurring subscription MRR
SELECT subscription.fn_mrr($1) AS mrr;

-- B18. Asset register summary
SELECT ac.name category, COUNT(a.id) count, SUM(a.total_cost) cost,
       SUM(a.accumulated_depr) depr, SUM(a.book_value) book_value
  FROM asset.asset a LEFT JOIN asset.asset_category ac ON ac.id = a.category_id
 WHERE a.status='in_use' GROUP BY ac.name;

-- B19. Top items by revenue (YTD)
SELECT i.code, i.name, SUM(sil.line_total) revenue, SUM(sil.qty) qty
  FROM sales.sales_invoice si
  JOIN sales.sales_invoice_line sil ON sil.sales_invoice_id = si.id
  JOIN inventory.item i ON i.id = sil.item_id
 WHERE si.status='posted' AND si.doc_date >= date_trunc('year', CURRENT_DATE)
 GROUP BY i.code, i.name ORDER BY revenue DESC LIMIT 20;

-- B20. Customer 360
SELECT * FROM crm.v_customer_360 WHERE id = $1;

-- ---------------------------------------------------------------------
-- SECTION C — BUSINESS OPERATIONS (calling functions)
-- ---------------------------------------------------------------------

-- C1. Post a sales invoice
SELECT sales.fn_post_sales_invoice('11111111-1111-1111-1111-111111111111', current_setting('app.current_user_id')::uuid);

-- C2. Convert lead to customer + opportunity
SELECT * FROM crm.fn_convert_lead('22222222-2222-2222-2222-222222222222', current_setting('app.current_user_id')::uuid, TRUE);

-- C3. Run payroll for April 2026
INSERT INTO payroll.payroll_run(tenant_id, company_id, period_start, period_end, pay_date, currency_code)
VALUES ($1, $2, '2026-04-01','2026-04-30','2026-05-05','INR') RETURNING id \gset pr_
SELECT payroll.fn_run_payroll(:'pr_id');

-- C4. Book canteen meal
SELECT canteen.fn_book_meal($1, $2, $3, CURRENT_DATE + 1, 1);

-- C5. Three-way match PI
SELECT purchase.fn_three_way_match($1);

-- C6. Post monthly depreciation
SELECT asset.fn_post_depreciation_run($1, date_trunc('month', CURRENT_DATE)::date, current_setting('app.current_user_id')::uuid);

-- C7. Explode BOM for 100 units
SELECT * FROM manufacturing.fn_explode_bom($1, 100);

-- C8. Semantic search across documents
SELECT * FROM bi_ai.fn_semantic_search($1, $2::vector, ARRAY['document','knowledge_article'], 10);

-- ---------------------------------------------------------------------
-- SECTION D — PARTITION MAINTENANCE (monthly auto-creation)
-- ---------------------------------------------------------------------
CREATE OR REPLACE FUNCTION core.fn_ensure_monthly_partition(p_parent REGCLASS, p_month DATE)
RETURNS VOID AS $$
DECLARE
    v_start DATE := date_trunc('month', p_month)::date;
    v_end   DATE := (date_trunc('month', p_month) + INTERVAL '1 month')::date;
    v_name  TEXT := replace(p_parent::text,'.','_') || '_' || to_char(v_start,'YYYYMM');
BEGIN
    EXECUTE format('CREATE TABLE IF NOT EXISTS %I PARTITION OF %s FOR VALUES FROM (%L) TO (%L)',
                   v_name, p_parent, v_start, v_end);
END; $$ LANGUAGE plpgsql;

-- Example: ensure audit partitions for next 6 months
SELECT core.fn_ensure_monthly_partition('audit.audit_log', CURRENT_DATE + (n || ' month')::interval)
  FROM generate_series(0,5) n;
SELECT core.fn_ensure_monthly_partition('finance.gl_entry', CURRENT_DATE + (n || ' month')::interval)
  FROM generate_series(0,5) n;
SELECT core.fn_ensure_monthly_partition('inventory.stock_ledger', CURRENT_DATE + (n || ' month')::interval)
  FROM generate_series(0,5) n;

-- ---------------------------------------------------------------------
-- SECTION E — OPTIMIZATION & BEST PRACTICES
-- ---------------------------------------------------------------------
/*
1. PARTITIONING
   - Range-by-date: audit_log, gl_entry, stock_ledger, notify.message, mobile.analytics_event,
     observability.metric/log/trace, tax.tax_transaction, iam.auth_event, integration.api_request_log,
     subscription.usage_record.
   - Hash-by-tenant for truly multi-tenant heavy tables when row counts per tenant diverge
     significantly.
   - Automate partition creation via core.fn_ensure_monthly_partition + pg_cron.

2. INDEXING
   - BRIN on time-series partitioned tables (low overhead, huge scan benefit):
       CREATE INDEX ON finance.gl_entry USING brin(posting_date);
   - GIN for tsvector, JSONB, tags[].
   - ivfflat (pgvector) for embeddings; re-run ANALYZE after bulk insert.
   - Partial indexes on "active" rows (WHERE deleted_at IS NULL, WHERE status='active')
     to keep hot indexes small.
   - Composite indexes matching WHERE + ORDER BY of top 20 queries (EXPLAIN ANALYZE).

3. CACHING
   - Redis for session tokens, permission graphs (iam.fn_user_permissions),
     price list resolution, tax rate lookups, exchange rates.
   - Postgres materialized views (reporting.mv_*) refreshed CONCURRENTLY for dashboards.

4. READ REPLICAS
   - All reporting/BI queries to replicas; route via app config.
   - Keep replicas lagging no more than 30s; pg_stat_replication monitored.

5. TENANT ISOLATION
   - RLS policies set with SET app.tenant_id = ...; per connection.
   - PgBouncer with app-level tenant routing for high connection counts.
   - Enterprise tier: DB-per-tenant or schema-per-tenant with separate Kafka topics.

6. ARCHIVAL
   - Attach old partitions to a cheaper tablespace, then DETACH + compress + move to S3 via pg_dump.
   - data_mgmt.retention_policy + scheduled job to evict/anonymize.

7. VACUUM & BLOAT
   - autovacuum_vacuum_cost_limit up to 2000 on OLTP nodes.
   - Manual VACUUM (ANALYZE, FULL) after large bulk imports (data_mgmt.import_job).
   - pg_repack for no-downtime cleanup of wide tables.

8. PERFORMANCE TARGETS (from PRD)
   - p50 < 150ms, p95 < 500ms: require connection pooler, statement timeout, and indexes
     on every FK + every status/date column used in dashboards.
   - Reporting over MV; heavy exports via COPY to object store, not in request path.

9. SECURITY
   - pgcrypto for column-level encryption (PII, bank_details, secrets).
   - pg_audit for DDL + role change logging.
   - No superuser app role; scoped roles per module with SECURITY DEFINER for posting functions.

10. OPERATIONAL
    - pg_stat_statements + pg_stat_kcache for slow query capture → observability.db_slow_query.
    - PITR via WAL-G to S3; RPO 15 min/RTO 1 hour matches PRD targets.
    - Blue-green: logical replication (pglogical) for zero-downtime schema swap.
    - Large schema changes: pg_repack / gh-ost-style (for non-trivial migrations) or pt-online-schema-change where applicable.
*/
