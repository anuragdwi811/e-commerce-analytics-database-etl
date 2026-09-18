/*==============================================================
 Project     : E-Commerce Analytics Database
 Database    : PostgreSQL
 Module      : 05 - Master Data Validation
 Description : Validate the imported master data for completeness,
               uniqueness, data types, ranges, logical consistency,
               and relationships before loading the final tables.
 Author      : Anurag Dwivedi
==============================================================*/



/*--------------------------------------------------------------
 Customers
--------------------------------------------------------------*/

-- NULL or Blank Customer IDs
SELECT * FROM staging.customers_raw
WHERE customer_id IS NULL
	OR TRIM(customer_id) = ''
	OR customer_id = 'NULL';
	
-- Duplicate Customer IDs
SELECT customer_id,
	   COUNT(*) AS duplicate_count
FROM staging.customers_raw
GROUP BY customer_id
HAVING COUNT(*) > 1;

-- NULL or Blank First Names
SELECT * FROM staging.customers_raw
WHERE first_name IS NULL
	OR TRIM(first_name) = ''
	OR first_name = 'NULL';
	
-- NULL or Blank Last Names
SELECT * FROM staging.customers_raw
WHERE last_name IS NULL
	OR TRIM(last_name) = ''
	OR last_name = 'NULL';
	
-- Duplicate Email Addresses
SELECT email,
	   COUNT(*) AS duplicate_count
FROM staging.customers_raw
GROUP BY email
HAVING COUNT(*) > 1;

-- Duplicate Phone Number
SELECT phone,
	   COUNT(*) AS duplicate_count
FROM staging.customers_raw
GROUP BY phone
HAVING COUNT(*) > 1;

-- Invalid Date of Birth Format
SELECT * FROM staging.customers_raw
WHERE NULLIF(TRIM(date_of_birth), '') IS NOT NULL
  AND NULLIF(TRIM(date_of_birth), 'NULL') IS NOT NULL
  AND NOT pg_input_is_valid(TRIM(date_of_birth), 'date');
  
-- Invalid Registration Date Format
SELECT * FROM staging.customers_raw
WHERE NULLIF(TRIM(registration_date), '') IS NOT NULL
	AND registration_date <> 'NULL'
	AND NOT pg_input_is_valid (TRIM(registration_date), 'date');
	
-- Invalid Created Timestamp Format
SELECT * FROM staging.customers_raw
WHERE NULLIF(TRIM(created_at), '') IS NOT NULL
	AND created_at <> 'NULL'
	AND NOT pg_input_is_valid (TRIM(created_at), 'timestamp');
	
-- Invalid Updated Timestamp Format
SELECT * FROM staging.customers_raw
WHERE NULLIF(TRIM(updated_at), '') IS NOT NULL
	AND updated_at <> 'NULL'
	AND NOT pg_input_is_valid (TRIM(updated_at), 'timestamp');
	
-- Future Date of Birth
SELECT * FROM staging.customers_raw
WHERE CAST(date_of_birth AS DATE) > CURRENT_DATE;

-- Registration Date Before Date of Birth
SELECT * FROM staging.customers_raw
WHERE registration_date::DATE < date_of_birth::DATE;

-- Updated Timestamp Before Created Timestamp
SELECT * FROM staging.customers_raw
WHERE updated_at::TIMESTAMP < created_at::TIMESTAMP;

-- Acquisition Campaign IDs Not Found in Campaigns
SELECT * FROM staging.customers_raw c
WHERE NULLIF(TRIM(c.acquisition_campaign_id), '') IS NOT NULL
	AND c.acquisition_campaign_id <> 'NULL'
	AND NOT EXISTS (
				SELECT 1 FROM staging.campaigns_raw cm
				WHERE c.acquisition_campaign_id = cm.campaign_id);


/*--------------------------------------------------------------
 Categories
--------------------------------------------------------------*/

-- NULL or Blank Category IDs
SELECT * FROM staging.categories_raw
WHERE category_id IS NULL
	OR TRIM(category_id) = ''
	OR category_id = 'NULL';
	
-- Duplicate Category IDs
SELECT category_id,
	   COUNT(*) AS duplicate_count
FROM staging.categories_raw
GROUP BY category_id
HAVING COUNT(*) > 1;

-- NULL or Blank Category Names
SELECT * FROM staging.categories_raw
WHERE category_name IS NULL
	OR TRIM(category_name) = ''
	OR category_name = 'NULL';
	
-- Duplicate Category Names
SELECT category_name,
	   COUNT(*) AS duplicate_count
FROM staging.categories_raw
GROUP BY category_name
HAVING COUNT(*) > 1;


/*--------------------------------------------------------------
 Subcategories
--------------------------------------------------------------*/

-- NULL or Blank Subcategory IDs
SELECT * FROM staging.subcategories_raw
WHERE subcategory_id IS NULL
	OR TRIM(subcategory_id) = ''
	OR subcategory_id = 'NULL';
	
-- Duplicate Subcategory IDs
SELECT subcategory_id,
	   COUNT(*) AS duplicate_count
FROM staging.subcategories_raw
GROUP BY subcategory_id
HAVING COUNT(*) > 1;

-- NULL or Blank Category IDs
SELECT * FROM staging.subcategories_raw
WHERE category_id IS NULL
	OR TRIM(category_id) = ''
	OR category_id = 'NULL';
	
-- NULL or Blank Subcategory Names
SELECT * FROM staging.subcategories_raw
WHERE subcategory_name IS NULL
	OR TRIM(subcategory_name) = ''
	OR subcategory_name = 'NULL';

-- Duplicate Subcategory Names Within Category
SELECT category_id,
	   subcategory_name,
	   COUNT(*) AS duplicate_count
FROM staging.subcategories_raw
GROUP BY category_id,
		 subcategory_name
HAVING COUNT(*) > 1;

-- Category IDs Not Found in Categories
SELECT * FROM staging.subcategories_raw s
WHERE NOT EXISTS (
				SELECT 1 FROM staging.categories_raw c
				WHERE s.category_id = c.category_id);
				

/*--------------------------------------------------------------
 Suppliers
--------------------------------------------------------------*/

-- NULL or Blank Supplier IDs
SELECT * FROM staging.suppliers_raw
WHERE supplier_id IS NULL
	OR TRIM(supplier_id) = ''
	OR supplier_id = 'NULL';
	
-- Duplicate Supplier IDs
SELECT supplier_id,
	   COUNT(*) AS duplicate_count
FROM staging.suppliers_raw
GROUP BY supplier_id
HAVING COUNT(*) > 1;

-- NULL or Blank Supplier Names
SELECT * FROM staging.suppliers_raw
WHERE supplier_name IS NULL
	OR TRIM(supplier_name) = ''
	OR supplier_name = 'NULL';
	
-- Duplicate Supplier Names
SELECT supplier_name,
	   COUNT(*) AS duplicate_count
FROM staging.suppliers_raw
GROUP BY supplier_name
HAVING COUNT(*) > 1;

-- Invalid Supplier Rating Format
SELECT * FROM staging.suppliers_raw
WHERE NULLIF(TRIM(rating), '') IS NOT NULL
  AND NULLIF(TRIM(rating), 'NULL') IS NOT NULL
  AND NOT pg_input_is_valid(TRIM(rating), 'numeric');
  
-- Supplier Ratings Outside Valid Range
SELECT * FROM staging.suppliers_raw
WHERE rating::NUMERIC NOT BETWEEN 1 AND 5;

-- Invalid Lead Time Format
SELECT * FROM staging.suppliers_raw
WHERE NULLIF(TRIM(lead_time_days), '') IS NOT NULL
  AND NULLIF(TRIM(lead_time_days), 'NULL') IS NOT NULL
  AND NOT pg_input_is_valid(TRIM(lead_time_days), 'integer');

-- Negative Lead Time
SELECT * FROM staging.suppliers_raw
WHERE lead_time_days::INT < 0;


/*--------------------------------------------------------------
 Products
--------------------------------------------------------------*/

-- NULL or Blank Product IDs
SELECT * FROM staging.products_raw
WHERE product_id IS NULL
	OR TRIM(product_id) = ''
	OR product_id = 'NULL';
	
-- Duplicate Product IDs
SELECT product_id,
	   COUNT(*) AS duplicate_count
FROM staging.products_raw
GROUP BY product_id
HAVING COUNT(*) > 1;

-- NULL or Blank Product Names
SELECT * FROM staging.products_raw
WHERE product_name IS NULL
	OR TRIM(product_name) = ''
	OR product_name = 'NULL';
	
-- NULL or Blank Category IDs
SELECT * FROM staging.products_raw
WHERE category_id IS NULL
	OR TRIM(category_id) = ''
	OR category_id = 'NULL';
	
-- NULL or Blank Subcategory IDs
SELECT * FROM staging.products_raw
WHERE subcategory_id IS NULL
	OR TRIM(subcategory_id) = ''
	OR subcategory_id = 'NULL';
	
-- NULL or Blank Supplier IDs
SELECT * FROM staging.products_raw
WHERE supplier_id IS NULL
	OR TRIM(supplier_id) = ''
	OR supplier_id = 'NULL';

-- Category IDs Not Found in Categories
SELECT * FROM staging.products_raw p
WHERE NOT EXISTS (
				SELECT 1 FROM staging.categories_raw c
				WHERE p.category_id = c.category_id);
				
-- Subcategory IDs Not Found in Subcategories
SELECT * FROM staging.products_raw p
WHERE NOT EXISTS (
				SELECT 1 FROM staging.subcategories_raw s
				WHERE p.subcategory_id = s.subcategory_id);
				
-- Supplier IDs Not Found in Suppliers
SELECT * FROM staging.products_raw p
WHERE NOT EXISTS (
				SELECT 1 FROM staging.suppliers_raw s
				WHERE p.supplier_id = s.supplier_id);

-- Non-Numeric Unit Costs
SELECT * FROM staging.products_raw
WHERE NULLIF(TRIM(unit_cost), '') IS NOT NULL
	AND NULLIF(TRIM(unit_cost), 'NULL') IS NOT NULL
	AND NOT pg_input_is_valid(unit_cost, 'numeric');
	
-- Non-Numeric Selling Prices
SELECT * FROM staging.products_raw
WHERE NULLIF(TRIM(selling_price), '') IS NOT NULL
	AND NULLIF(TRIM(selling_price), 'NULL') IS NOT NULL
	AND NOT pg_input_is_valid(selling_price, 'numeric');
	
-- Non-Numeric MRP Values
SELECT * FROM staging.products_raw
WHERE NULLIF(TRIM(mrp), '') IS NOT NULL
	AND NULLIF(TRIM(mrp), 'NULL') IS NOT NULL
	AND NOT pg_input_is_valid(mrp, 'numeric');
	
-- Non-Numeric Product Weights
SELECT * FROM staging.products_raw
WHERE NULLIF(TRIM(weight_kg), '') IS NOT NULL
	AND NULLIF(TRIM(weight_kg), 'NULL') IS NOT NULL
	AND NOT pg_input_is_valid(weight_kg, 'numeric');
	
-- Non-Numeric Product Ratings
SELECT * FROM staging.products_raw
WHERE NULLIF(TRIM(rating), '') IS NOT NULL
	AND NULLIF(TRIM(rating), 'NULL') IS NOT NULL
	AND NOT pg_input_is_valid(rating, 'numeric');

-- Negative Unit Costs
SELECT * FROM staging.products_raw
WHERE unit_cost::NUMERIC < 0;

-- Negative Selling Prices
SELECT * FROM staging.products_raw
WHERE selling_price::NUMERIC < 0;

-- Negative MRP Values
SELECT * FROM staging.products_raw
WHERE mrp::NUMERIC < 0;

-- Negative Product Weights
SELECT * FROM staging.products_raw
WHERE weight_kg::NUMERIC < 0;

-- Product Ratings Outside Valid Range
SELECT * FROM staging.products_raw
WHERE NOT rating::NUMERIC BETWEEN 1 AND 5;

-- Unit Cost Greater Than Selling Price
SELECT * FROM staging.products_raw
WHERE unit_cost::NUMERIC > selling_price::NUMERIC;

-- Selling Price Greater Than MRP
SELECT * FROM staging.products_raw
WHERE selling_price::NUMERIC > mrp::NUMERIC;


/*--------------------------------------------------------------
 Warehouses
--------------------------------------------------------------*/

-- NULL or Blank Warehouse IDs
SELECT * FROM staging.warehouses_raw
WHERE warehouse_id IS NULL
	OR TRIM(warehouse_id) = ''
	OR warehouse_id = 'NULL';
	
-- Duplicate Warehouse IDs
SELECT warehouse_id,
	   COUNT(*) AS duplicate_count
FROM staging.warehouses_raw
GROUP BY warehouse_id
HAVING COUNT(*) > 1;

-- NULL or Blank Warehouse Names
SELECT * FROM staging.warehouses_raw
WHERE warehouse_name IS NULL
	OR TRIM(warehouse_name) = ''
	OR warehouse_name = 'NULL';
	
-- Duplicate Warehouse Names
SELECT warehouse_name,
	   COUNT(*) AS duplicate_count
FROM staging.warehouses_raw
GROUP BY warehouse_name
HAVING COUNT(*) > 1;

-- Non-Numeric Warehouse Capacity
SELECT * FROM staging.warehouses_raw
WHERE NULLIF(TRIM(capacity), '') IS NOT NULL
	AND NULLIF(TRIM(capacity), 'NULL') IS NOT NULL
	AND NOT pg_input_is_valid(capacity, 'numeric');
	
-- Negative Warehouse Capacity
SELECT * FROM staging.warehouses_raw
WHERE capacity::NUMERIC < 0;


/*--------------------------------------------------------------
 Couriers
--------------------------------------------------------------*/

-- NULL or Blank Courier IDs
SELECT * FROM staging.couriers_raw
WHERE courier_id IS NULL
	OR TRIM(courier_id) = ''
	OR courier_id = 'NULL';
	
-- Duplicate Courier IDs
SELECT courier_id,
	   COUNT(*) AS duplicate_count
FROM staging.couriers_raw
GROUP BY courier_id
HAVING COUNT(*) > 1;

-- NULL or Blank Courier Names
SELECT * FROM staging.couriers_raw
WHERE courier_name IS NULL
	OR TRIM(courier_name) = ''
	OR courier_name = 'NULL';
	
-- Duplicate Courier Names
SELECT courier_name,
	   COUNT(*) AS duplicate_count
FROM staging.couriers_raw
GROUP BY courier_name
HAVING COUNT(*) > 1;

-- Non-Numeric Courier Ratings
SELECT * FROM staging.couriers_raw
WHERE NULLIF(TRIM(rating), '') IS NOT NULL
	AND NULLIF(TRIM(rating), 'NULL') IS NOT NULL
	AND NOT pg_input_is_valid(rating, 'numeric');

-- Courier Ratings Outside Valid Range
SELECT * FROM staging.couriers_raw
WHERE NOT rating::NUMERIC BETWEEN 1 AND 5;



/*==============================================================
 MASTER DATA VALIDATION COMPLETE
==============================================================

 The staging master data has been validated for completeness,
 uniqueness, data types, ranges, logical consistency, and
 relationships.

 Next Step:
 Create the final master tables with appropriate data types,
 constraints, and relational integrity.

==============================================================*/
