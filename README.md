# E-Commerce Analytics Database ETL Pipeline

## Project Overview

An end-to-end PostgreSQL ETL pipeline that transforms raw e-commerce CSV data into a clean, validated, relational, and analysis-ready database.

The project focuses on data ingestion, profiling, validation, transformation, relational database design, and final data loading. The resulting database is designed as a reusable foundation for downstream SQL, Power BI, and business analytics projects.

## Project Objective

The objective of this project is to demonstrate how raw CSV data can be systematically converted into a structured PostgreSQL database through a complete data preparation and ETL workflow.

The pipeline covers:

- CSV data ingestion
- Staging layer creation
- Data profiling
- Data quality validation
- Relational table design
- Primary and foreign key implementation
- Data cleaning and transformation
- Loading data into final tables
- Final database validation
- Creation of an analysis-ready database

## Data Pipeline

The project follows the following data preparation workflow:

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
