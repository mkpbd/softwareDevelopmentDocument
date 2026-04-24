-- =============================================================================
-- HRMandCRM ERP — Master SQL Runner
-- Execute this file in psql or any PostgreSQL client to build the full schema.
--
-- Usage:
--   psql -U postgres -d hrmcrm -f 00_master_runner.sql
--
-- Or run each file individually in the order shown below.
-- =============================================================================

\set ON_ERROR_STOP on
\set ECHO all

\echo '=== Step 1: Schemas ==='
\i 01_schemas.sql

\echo '=== Step 2a: Core & IAM Tables ==='
\i 02_tables_core.sql

\echo '=== Step 2b: Finance & Tax Tables ==='
\i 03_tables_finance.sql

\echo '=== Step 2c: Sales & Purchase Tables ==='
\i 04_tables_sales_purchase.sql

\echo '=== Step 2d: Inventory, Manufacturing, Quality, Planning ==='
\i 05_tables_inventory_mfg.sql

\echo '=== Step 2e: CRM, HR, Attendance, Payroll ==='
\i 06_tables_crm_hr.sql

\echo '=== Step 2f: Assets, Projects, Service ==='
\i 07_tables_assets_projects_service.sql

\echo '=== Step 2g: Platform (Logistics → Canteen) ==='
\i 08_tables_platform.sql

\echo '=== Step 3: Functions ==='
\i 10_functions.sql

\echo '=== Step 4: Views ==='
\i 11_views.sql

\echo '=== Step 5: Stored Procedures ==='
\i 12_procedures.sql

\echo '=== Step 6: Triggers ==='
\i 13_triggers.sql

\echo '=== DONE: HRMandCRM schema fully deployed ==='
