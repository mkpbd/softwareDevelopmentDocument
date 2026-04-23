-- =====================================================================
-- Optimization & Best Practices (Step 10) — production playbook.
-- Executable bits are wrapped in DO/COMMENT blocks; narrative in comments.
-- =====================================================================

-- ---------------------------------------------------------------------
-- 1. POSTGRES CONFIG BASELINE  (set in postgresql.conf / via Terraform)
-- ---------------------------------------------------------------------
-- shared_buffers            = 25% of RAM
-- effective_cache_size      = 60-70% of RAM
-- work_mem                  = 16MB (raise per-session for heavy reports)
-- maintenance_work_mem      = 512MB-1GB (index builds, VACUUM)
-- wal_level                 = replica
-- max_wal_size              = 8GB        -- reduce checkpoint pressure
-- checkpoint_timeout        = 15min
-- random_page_cost          = 1.1        -- SSD
-- effective_io_concurrency  = 200        -- NVMe
-- jit                       = off        -- typical OLTP; enable selectively
-- default_statistics_target = 200        -- better plans on large tables
-- autovacuum_max_workers    = 6
-- autovacuum_naptime        = 30s
-- track_io_timing           = on
-- shared_preload_libraries  = 'pg_stat_statements,auto_explain'
-- auto_explain.log_min_duration = '1s'

-- ---------------------------------------------------------------------
-- 2. PARTITIONING STRATEGY
-- ---------------------------------------------------------------------
-- Partitioned (by RANGE on posting_date / created_at, yearly — sub-partition
-- by month once monthly volume > 10M rows):
--   app.journal_entries, app.journal_lines
--   app.stock_ledger
--   ops.notification_queue, ops.webhook_deliveries, ops.sync_logs,
--   ops.performance_metrics, ops.api_access_log
--
-- Use declarative partitioning with DEFAULT partition for safety.
-- Automate new partition creation via pg_partman OR the helper below:

CREATE OR REPLACE PROCEDURE ops.ensure_partitions(p_parent regclass, p_year int)
LANGUAGE plpgsql AS $$
DECLARE
  v_schema text; v_name text; v_child text;
BEGIN
  SELECT n.nspname, c.relname INTO v_schema, v_name
    FROM pg_class c JOIN pg_namespace n ON n.oid=c.relnamespace WHERE c.oid=p_parent;
  v_child := v_name || '_' || p_year;
  IF NOT EXISTS (SELECT 1 FROM pg_class WHERE relname = v_child) THEN
    EXECUTE format('CREATE TABLE %I.%I PARTITION OF %I.%I
                    FOR VALUES FROM (%L) TO (%L)',
                   v_schema, v_child, v_schema, v_name,
                   make_date(p_year,1,1), make_date(p_year+1,1,1));
  END IF;
END $$;

-- Roll forward every year-end via cron:
-- CALL ops.ensure_partitions('app.journal_entries', extract(year from now())::int + 1);
-- CALL ops.ensure_partitions('app.journal_lines',   extract(year from now())::int + 1);
-- CALL ops.ensure_partitions('app.stock_ledger',    extract(year from now())::int + 1);
-- ... etc

-- ---------------------------------------------------------------------
-- 3. INDEX HYGIENE
-- ---------------------------------------------------------------------
-- A. Enable pg_stat_statements (already in bootstrap)
-- B. Find unused indexes periodically:
--    SELECT schemaname, relname AS table, indexrelname AS index,
--           idx_scan, pg_size_pretty(pg_relation_size(indexrelid)) size
--      FROM pg_stat_user_indexes WHERE idx_scan = 0
--       AND indexrelname NOT LIKE '%_pkey'
--     ORDER BY pg_relation_size(indexrelid) DESC;
-- C. Partial indexes for status-filtered hot paths already added
--    (e.g. sales_invoices.due_date WHERE amount_due > 0).
-- D. BRIN indexes for append-only timestamp columns at scale:
--    CREATE INDEX idx_sl_brin_date ON app.stock_ledger USING BRIN (posting_date);
-- E. REINDEX CONCURRENTLY quarterly for bloated indexes.

-- ---------------------------------------------------------------------
-- 4. VACUUM / ANALYZE TUNING FOR HOT TABLES
-- ---------------------------------------------------------------------
ALTER TABLE app.journal_lines      SET (autovacuum_vacuum_scale_factor = 0.05,
                                        autovacuum_analyze_scale_factor = 0.02);
ALTER TABLE app.stock_ledger       SET (autovacuum_vacuum_scale_factor = 0.05,
                                        autovacuum_analyze_scale_factor = 0.02);
ALTER TABLE app.sales_invoice_lines SET (autovacuum_vacuum_scale_factor = 0.05);
ALTER TABLE app.po_lines            SET (autovacuum_vacuum_scale_factor = 0.05);
ALTER TABLE ops.api_access_log      SET (autovacuum_vacuum_scale_factor = 0.10,
                                         autovacuum_analyze_scale_factor = 0.05);

-- ---------------------------------------------------------------------
-- 5. READ REPLICAS & REPORTING ISOLATION
-- ---------------------------------------------------------------------
-- * Physical streaming replica for BI / heavy reporting; set
--   hot_standby_feedback = on on replica to avoid query cancellation.
-- * Route read-heavy reports / exports to replica via separate
--   connection string (application-side).
-- * Materialized views (app.mv_monthly_sales, app.mv_top_customers)
--   refresh on replica via REFRESH ... CONCURRENTLY on a schedule.
--   Scheduled job:
--     SELECT app.refresh_reporting_mvs();

-- ---------------------------------------------------------------------
-- 6. CACHING STRATEGY
-- ---------------------------------------------------------------------
-- * Redis for: session tokens, rate-limit counters (move from ops.rate_limit_buckets
--   to Redis at scale), permission-bitmap cache per user (15-min TTL),
--   reference-data cache (price_lists, GST rates).
-- * Application-layer cache invalidation via LISTEN/NOTIFY on mutation triggers
--   for master data (customers, suppliers, items).

-- ---------------------------------------------------------------------
-- 7. CONNECTION POOLING
-- ---------------------------------------------------------------------
-- * PgBouncer in transaction mode in front of Postgres.
-- * Target: max_connections <= 300 on DB; PgBouncer pool_size tuned per app pod.
-- * Never set app.tenant_id / app.user_id via session-level SET in transaction
--   pooling mode — use SET LOCAL or set_config(..., true) inside each txn.

-- ---------------------------------------------------------------------
-- 8. BACKUP & RECOVERY
-- ---------------------------------------------------------------------
-- * pg_basebackup + continuous WAL archiving to S3 (pgBackRest / WAL-G).
-- * PITR enabled; RPO 15 min, RTO 1 hour per NFRs.
-- * Nightly full + hourly WAL ship; cross-region replication for DR.
-- * Weekly restore drill to staging.

-- ---------------------------------------------------------------------
-- 9. RLS PERFORMANCE NOTES
-- ---------------------------------------------------------------------
-- * RLS policy predicate (tenant_id = core.current_tenant_id()) leverages
--   (tenant_id,*) leading composite indexes everywhere — keep it so.
-- * Avoid SELECT ... FROM table WHERE ... ORDER BY (without tenant leading
--   index) — planner must still prune by RLS first.
-- * For cross-tenant admin queries, use a BYPASSRLS role, not SECURITY DEFINER.

-- ---------------------------------------------------------------------
-- 10. DATA ARCHIVING
-- ---------------------------------------------------------------------
-- * Old partitions: DETACH + move to cold storage (e.g., ZFS snapshot, S3 parquet).
-- * audit.change_log: prune > 7 years; archive > 2 years offline.
-- * ops.api_access_log: aggregate hourly rollups to a smaller table, drop raw > 90d.
-- * Scheduled job:
--     SELECT app.apply_retention_policies();
--     SELECT app.purge_expired_documents();

-- ---------------------------------------------------------------------
-- 11. SCALING LEVERS (IN PRIORITY ORDER)
-- ---------------------------------------------------------------------
-- 1. Bigger box + tuned config (easy win up to ~300 GB working set).
-- 2. Read replicas for reporting/exports.
-- 3. Partitioning hot tables (already done for ledger/log tables).
-- 4. Citus / Hydra for horizontal sharding on tenant_id once single
--    primary saturates (> 5 TB or > 20k TPS sustained).
-- 5. OLAP offload: logical-replicate to ClickHouse for BI-heavy queries
--    on stock_ledger, journal_lines, api_access_log.
-- 6. Queues (notifications, webhooks) move off Postgres onto Kafka/NATS
--    at high volume; keep outbox table for idempotency.

-- ---------------------------------------------------------------------
-- 12. SAMPLE MAINTENANCE SCRIPTS (run via pg_cron / external scheduler)
-- ---------------------------------------------------------------------
-- Daily:
--   VACUUM (ANALYZE) app.journal_lines, app.stock_ledger;
--   REINDEX (CONCURRENTLY) INDEX idx_si_due_overdue;
--   SELECT app.refresh_reporting_mvs();
--   SELECT app.retry_failed_notifications();
--   SELECT app.escalate_overdue_tasks();
--
-- Weekly:
--   ANALYZE;
--   SELECT app.apply_retention_policies();
--   SELECT app.purge_expired_documents();
--
-- Yearly (Dec):
--   CALL ops.ensure_partitions('app.journal_entries', next_year);
--   CALL ops.ensure_partitions('app.journal_lines', next_year);
--   CALL ops.ensure_partitions('app.stock_ledger', next_year);
--   CALL ops.ensure_partitions('ops.notification_queue', next_year);
--   CALL ops.ensure_partitions('ops.api_access_log', next_year);
--   CALL ops.ensure_partitions('ops.performance_metrics', next_year);
--   CALL ops.ensure_partitions('ops.webhook_deliveries', next_year);
--   CALL ops.ensure_partitions('ops.sync_logs', next_year);
