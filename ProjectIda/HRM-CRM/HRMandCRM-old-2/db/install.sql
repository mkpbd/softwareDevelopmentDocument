-- =====================================================================
-- install.sql — orchestrator. Runs all module files in dependency order.
-- Usage:
--   psql -h <host> -U <super> -d <db> -v ON_ERROR_STOP=1 -f install.sql
-- =====================================================================

\echo '== 00 bootstrap =='
\ir 00_bootstrap.sql

\echo '== 01 org_config =='
\ir 01_org_config.sql

\echo '== 02 iam =='
\ir 02_iam.sql

\echo '== 03 finance =='
\ir 03_finance.sql

\echo '== 21 documents =='
\ir 21_documents.sql

\echo '== 22 workflow =='
\ir 22_workflow.sql

\echo '== 23 notifications =='
\ir 23_notifications.sql

\echo '== 05 sales =='
\ir 05_sales.sql

\echo '== 06 purchase =='
\ir 06_purchase.sql

\echo '== 07 inventory =='
\ir 07_inventory.sql

\echo '== 08 manufacturing =='
\ir 08_manufacturing.sql

\echo '== 09 quality =='
\ir 09_quality.sql

\echo '== 10 planning =='
\ir 10_planning.sql

\echo '== 11 crm =='
\ir 11_crm.sql

\echo '== 12 hr =='
\ir 12_hr.sql

\echo '== 13 time_attendance =='
\ir 13_time_attendance.sql

\echo '== 14 payroll =='
\ir 14_payroll.sql

\echo '== 15 assets =='
\ir 15_assets.sql

\echo '== 16 projects =='
\ir 16_projects.sql

\echo '== 17 service =='
\ir 17_service.sql

\echo '== 18 logistics =='
\ir 18_logistics.sql

\echo '== 19 pos =='
\ir 19_pos.sql

\echo '== 20 subscription =='
\ir 20_subscription.sql

\echo '== 24 integration =='
\ir 24_integration.sql

\echo '== 25 data_mgmt =='
\ir 25_data_mgmt.sql

\echo '== 26 reporting =='
\ir 26_reporting.sql

\echo '== 27 bi_ai =='
\ir 27_bi_ai.sql

\echo '== 28 security =='
\ir 28_security.sql

\echo '== 29 observability =='
\ir 29_observability.sql

\echo '== 30 mobile =='
\ir 30_mobile.sql

\echo '== 31 portals =='
\ir 31_portals.sql

\echo '== 32 canteen =='
\ir 32_canteen.sql

\echo '== 91 optimization =='
\ir 91_optimization.sql

\echo '== install complete =='
-- 90_sample_queries.sql is illustrative only, do not run here.
