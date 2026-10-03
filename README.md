# E-Commerce Analytics Database ETL Pipeline

## Project Overview

An end-to-end PostgreSQL ETL pipeline that transforms raw e-commerce CSV data into a clean, validated, relational, and analysis-ready database.

The project focuses on data ingestion, data profiling, data validation, relational database design, data cleaning and transformation, and final data loading.

The resulting PostgreSQL database is designed as a reusable data foundation for downstream SQL, Power BI, and business analytics projects.

---

## Project Objective

The objective of this project is to demonstrate how raw CSV data can be systematically converted into a structured and analysis-ready PostgreSQL database through a complete ETL and data-quality workflow.

The project covers:

- Raw CSV data ingestion
- PostgreSQL database and schema setup
- Staging table creation
- Data profiling
- NULL and duplicate checks
- Data quality and business-rule validation
- Relational table design
- Primary key and foreign key implementation
- Data type and constraint definition
- Data cleaning and transformation
- Loading validated data into final tables
- Referential integrity checks
- Final database validation
- Creation of an analysis-ready database

---

## Data Pipeline

The ETL workflow follows a structured sequence from raw CSV files to the final PostgreSQL database.

```text
Raw CSV Data
     ↓
Database & Schema Setup
     ↓
Staging Table Creation
     ↓
CSV Import
     ↓
Data Profiling
     ↓
Data Validation
     ↓
Final Table Creation
     ↓
Clean + Transform + Load
     ↓
Final Database Validation
     ↓
Analysis-Ready PostgreSQL Database
