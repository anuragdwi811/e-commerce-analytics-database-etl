/*==============================================================
 Project     : E-Commerce Analytics Database
 Database    : PostgreSQL
 Module      : 01 - Database & Schema Setup
 Description : Set up the database and schema structure for the
               e-commerce data preparation project.
 Author      : Anurag Dwivedi

 Pipeline    : CSV → Staging → Profiling → Validation
               → Final Tables → Clean & Transform → Load
               → Final Validation
==============================================================*/


-- ============================================================
-- 1. Create Database
-- ============================================================

/* Run this command from an existing PostgreSQL database,
   then connect to ecommerce_analytics_db before continuing.
   
   CREATE DATABASE ecommerce_analytics_db;			*/


-- ============================================================
-- 2. Create Schemas
-- ============================================================

-- Staging layer
-- Stores raw data imported from CSV files.
CREATE SCHEMA IF NOT EXISTS staging;


-- Master layer
-- Stores core reference and master data.
CREATE SCHEMA IF NOT EXISTS master;


-- Sales layer
-- Stores orders, order items, payments and after-sales data.
CREATE SCHEMA IF NOT EXISTS sales;


-- Operations layer
-- Stores inventory, logistics, digital activity and support data.
CREATE SCHEMA IF NOT EXISTS operations;


-- Marketing layer
-- Stores campaigns, coupons and campaign interactions.
CREATE SCHEMA IF NOT EXISTS marketing;


-- Procurement layer
-- Stores purchase orders and supplier-related transactions.
CREATE SCHEMA IF NOT EXISTS procurement;


-- Analytics layer
-- Reserved for future analytical views and derived datasets.
CREATE SCHEMA IF NOT EXISTS analytics;


-- ============================================================
-- DATABASE SETUP COMPLETE
-- ============================================================
--
-- Schema structure:
--
-- staging      → Raw CSV data
-- master       → Reference and master data
-- sales        → Sales and commercial data
-- operations   → Operational and fulfillment data
-- marketing    → Marketing and campaign data
-- procurement  → Procurement data
-- analytics    → Future analytical layer
--
-- Next step:
-- Run 02_staging_tables to create the raw staging tables.
-- ============================================================
