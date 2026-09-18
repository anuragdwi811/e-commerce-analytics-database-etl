/*==============================================================
 Project     : E-Commerce Analytics Database
 Database    : PostgreSQL
 Module      : 11 - Master Data Load
 Description : Clean, transform, and load the validated staging
               master data into the final master tables.
 Author      : Anurag Dwivedi
==============================================================*/


BEGIN;
/*--------------------------------------------------------------
 Customers
--------------------------------------------------------------*/

INSERT INTO master.customers (
	customer_id,
	first_name,
	last_name,
	gender,
	date_of_birth,
	email,
	phone,
	city,
	state,
	region,
	country,
	pincode,
	registration_date,
	customer_type,
	customer_segment,
	acquisition_channel,
	acquisition_campaign_id,
	customer_status,
	created_at,
	updated_at)
SELECT 
	UPPER(TRIM(customer_id)),
	INITCAP(TRIM(first_name)),
	INITCAP(TRIM(last_name)),
	CASE gender
		WHEN 'F' THEN 'Female'
		WHEN 'M' THEN 'Male'
		ELSE INITCAP(TRIM(gender))
	END AS gender,
	CAST(date_of_birth AS DATE),
	LOWER(TRIM(email)),
	TRIM(phone),
	INITCAP(TRIM(city)),
	INITCAP(TRIM(state)),
	INITCAP(TRIM(region)),
	CASE country
		WHEN 'IN' THEN 'India'
		ELSE INITCAP(TRIM(country))
	END AS country,
	LEFT(TRIM(pincode),6),
	CAST(registration_date AS DATE),
	TRIM(customer_type),
	INITCAP(TRIM(customer_segment)),
	TRIM(NULLIF(acquisition_channel, 'NULL')),
	UPPER(TRIM(NULLIF(acquisition_campaign_id, 'NULL'))),
	INITCAP(TRIM(customer_status)),
	created_at::TIMESTAMP,
	updated_at::TIMESTAMP
FROM staging.customers_raw
ON CONFLICT (customer_id) DO NOTHING;


/*--------------------------------------------------------------
 Categories
--------------------------------------------------------------*/

INSERT INTO master.categories (
	category_id,
	category_name,
	department,
	category_status)
SELECT 
	UPPER(TRIM(category_id)),
	INITCAP(TRIM(category_name)),
	INITCAP(TRIM(department)),
	INITCAP(TRIM(category_status))
FROM staging.categories_raw;
	

/*--------------------------------------------------------------
 Subcategories
--------------------------------------------------------------*/

INSERT INTO master.subcategories (
	subcategory_id,
	category_id,
	subcategory_name,
	subcategory_status)
SELECT 
	UPPER(TRIM(subcategory_id)),
	UPPER(TRIM(category_id)),
	TRIM(subcategory_name),
	INITCAP(TRIM(subcategory_status))
FROM staging.subcategories_raw;


/*--------------------------------------------------------------
 Suppliers
--------------------------------------------------------------*/

INSERT INTO master.suppliers (
	supplier_id,
	supplier_name,
	supplier_type,
	city,
	state,
	region,
	rating,
	payment_terms,
	lead_time_days,
	supplier_status)
SELECT 
	UPPER(TRIM(supplier_id)),
	TRIM(supplier_name),
	INITCAP(TRIM(supplier_type)),
	INITCAP(TRIM(city)),
	INITCAP(TRIM(state)),
	CASE region
		WHEN 'W' THEN 'West'
		WHEN 'S' THEN 'South'
		ELSE INITCAP(TRIM(region))
	END AS region,
	CAST(rating AS NUMERIC),
	INITCAP(TRIM(payment_terms)),
	CAST(lead_time_days AS INT),
	INITCAP(TRIM(supplier_status))
FROM staging.suppliers_raw;


/*--------------------------------------------------------------
 Products
--------------------------------------------------------------*/

INSERT INTO master.products (
	product_id,
	product_name,
	category_id,
	subcategory_id,
	brand,
	supplier_id,
	unit_cost,
	selling_price,
	mrp,
	launch_date,
	product_status,
	weight_kg,
	rating)
SELECT 
	UPPER(TRIM(product_id)),
	TRIM(product_name),
	UPPER(TRIM(category_id)),
	UPPER(TRIM(subcategory_id)),
	INITCAP(TRIM(brand)),
	UPPER(TRIM(supplier_id)),
	unit_cost::NUMERIC,
	selling_price::NUMERIC,
	mrp::NUMERIC,
	launch_date::DATE,
	INITCAP(TRIM(product_status)),
	weight_kg::NUMERIC,
	rating::NUMERIC
FROM staging.products_raw
ON CONFLICT (product_id) DO NOTHING;


/*--------------------------------------------------------------
 Warehouses
--------------------------------------------------------------*/

INSERT INTO master.warehouses (
	warehouse_id,
	warehouse_name,
	city,
	state,
	region,
	capacity,
	warehouse_type,
	opening_date,
	status)
SELECT 
	UPPER(TRIM(warehouse_id)),
	TRIM(warehouse_name),
	INITCAP(TRIM(city)),
	INITCAP(TRIM(state)),
	INITCAP(TRIM(region)),
	capacity::NUMERIC,
	INITCAP(TRIM(warehouse_type)),
	opening_date::DATE,
	INITCAP(TRIM(status))
FROM staging.warehouses_raw;


/*--------------------------------------------------------------
 Couriers
--------------------------------------------------------------*/

INSERT INTO master.couriers (
	courier_id,
	courier_name,
	service_type,
	rating,
	status)
SELECT 
	UPPER(TRIM(courier_id)),
	TRIM(courier_name),
	INITCAP(TRIM(service_type)),
	rating::NUMERIC,
	INITCAP(TRIM(status))
FROM staging.couriers_raw;



-- ROLLBACK;
-- COMMIT;

/*==============================================================
 MASTER DATA LOAD COMPLETE
==============================================================

 The validated staging master data has been cleaned, transformed,
 and loaded into the corresponding final master tables.

 Next Step:
 Load the validated sales data into the corresponding final
 sales tables.

==============================================================*/
