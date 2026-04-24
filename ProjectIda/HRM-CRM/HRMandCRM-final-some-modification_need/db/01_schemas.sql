-- =============================================================================
-- schema.sql — Step 1: Schema Definitions
-- HRMandCRM ERP — Production PostgreSQL Schema
-- =============================================================================

-- Enable required extensions
CREATE EXTENSION IF NOT EXISTS "pgcrypto";
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pg_trgm";
CREATE EXTENSION IF NOT EXISTS "btree_gin";

-- -----------------------------------------------------------------------------
-- Schema Definitions
-- Each schema maps to a PRD domain/step group
-- -----------------------------------------------------------------------------

CREATE SCHEMA IF NOT EXISTS core;       -- Step 1: Org, Config, Foundation
CREATE SCHEMA IF NOT EXISTS iam;        -- Step 2: Identity & Access Management
CREATE SCHEMA IF NOT EXISTS finance;    -- Step 3: Finance & Accounting
CREATE SCHEMA IF NOT EXISTS tax;        -- Step 4: Tax & Compliance
CREATE SCHEMA IF NOT EXISTS sales;      -- Step 5: Sales Management
CREATE SCHEMA IF NOT EXISTS purchase;   -- Step 6: Purchase Management
CREATE SCHEMA IF NOT EXISTS inventory;  -- Step 7: Inventory Management
CREATE SCHEMA IF NOT EXISTS mfg;        -- Step 8: Manufacturing / Production
CREATE SCHEMA IF NOT EXISTS quality;    -- Step 9: Quality Management
CREATE SCHEMA IF NOT EXISTS planning;   -- Step 10: Planning (MRP, S&OP)
CREATE SCHEMA IF NOT EXISTS crm;        -- Step 11: CRM
CREATE SCHEMA IF NOT EXISTS hr;         -- Step 12: Human Resources
CREATE SCHEMA IF NOT EXISTS attendance; -- Step 13: Time & Attendance
CREATE SCHEMA IF NOT EXISTS payroll;    -- Step 14: Payroll
CREATE SCHEMA IF NOT EXISTS assets;     -- Step 15: Asset Management
CREATE SCHEMA IF NOT EXISTS projects;   -- Step 16: Project Management
CREATE SCHEMA IF NOT EXISTS service;    -- Step 17: Service & Field Operations
CREATE SCHEMA IF NOT EXISTS logistics;  -- Step 18: Logistics & Warehouse
CREATE SCHEMA IF NOT EXISTS pos;        -- Step 19: Point of Sale
CREATE SCHEMA IF NOT EXISTS billing;    -- Step 20: Subscription & Recurring Billing
CREATE SCHEMA IF NOT EXISTS docs;       -- Step 21: Document Management
CREATE SCHEMA IF NOT EXISTS workflow;   -- Step 22: Workflow & Automation
CREATE SCHEMA IF NOT EXISTS notify;     -- Step 23: Notifications & Communications
CREATE SCHEMA IF NOT EXISTS integration;-- Step 24: Integration Platform
CREATE SCHEMA IF NOT EXISTS datamgmt;   -- Step 25: Data Management
CREATE SCHEMA IF NOT EXISTS reporting;  -- Step 26: Reporting & Analytics
CREATE SCHEMA IF NOT EXISTS bi;         -- Step 27: Business Intelligence & AI
CREATE SCHEMA IF NOT EXISTS security;   -- Step 28: Security & Data Protection
CREATE SCHEMA IF NOT EXISTS observability; -- Step 29: Performance & Observability
CREATE SCHEMA IF NOT EXISTS mobile;     -- Step 30: Mobile Strategy
CREATE SCHEMA IF NOT EXISTS portal;     -- Step 31: Portals
CREATE SCHEMA IF NOT EXISTS canteen;    -- Step 32: Canteen & Cafeteria
