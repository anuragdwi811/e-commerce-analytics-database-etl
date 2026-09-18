/*==============================================================
 Project     : E-Commerce Analytics Database
 Database    : PostgreSQL
 Module      : 08 - Procurement Data Validation
 Description : Validate the imported procurement data for
               completeness, uniqueness, valid values, ranges,
               logical consistency, and relationships before
               loading the final tables.
 Author      : Anurag Dwivedi
==============================================================*/



/*--------------------------------------------------------------
 Purchase Orders
--------------------------------------------------------------*/

-- NULL or Blank Purchase Order IDs
SELECT * FROM staging.purchase_orders_raw
WHERE purchase_order_id IS NULL
	OR TRIM(purchase_order_id) = ''
	OR purchase_order_id = 'NULL';
	
-- Duplicate Purchase Order IDs
SELECT purchase_order_id,
	   COUNT(*) AS duplicate_count
FROM staging.purchase_orders_raw
GROUP BY purchase_order_id
HAVING COUNT(*) > 1;

-- NULL or Blank Supplier IDs
SELECT * FROM staging.purchase_orders_raw
WHERE supplier_id IS NULL
	OR TRIM(supplier_id) = ''
	OR supplier_id = 'NULL';
	
-- NULL or Blank Warehouse IDs
SELECT * FROM staging.purchase_orders_raw
WHERE warehouse_id IS NULL
	OR TRIM(warehouse_id) = ''
	OR warehouse_id = 'NULL';
	
-- NULL or Blank Order Dates
SELECT * FROM staging.purchase_orders_raw
WHERE order_date IS NULL
	OR TRIM(order_date) = ''
	OR order_date = 'NULL';
	
-- NULL or Blank Status
SELECT * FROM staging.purchase_orders_raw
WHERE status IS NULL
	OR TRIM(status) = ''
	OR status = 'NULL';

-- Invalid Order Date Format
SELECT * FROM staging.purchase_orders_raw
WHERE NULLIF(TRIM(order_date), '') IS NOT NULL
	AND NULLIF(TRIM(order_date), 'NULL') IS NOT NULL
	AND NOT pg_input_is_valid(order_date, 'date');
	
-- Invalid Expected Date Format
SELECT * FROM staging.purchase_orders_raw
WHERE NULLIF(TRIM(expected_date), '') IS NOT NULL
	AND NULLIF(TRIM(expected_date), 'NULL') IS NOT NULL
	AND NOT pg_input_is_valid(expected_date, 'date');
	
-- Invalid Received Date Format
SELECT * FROM staging.purchase_orders_raw
WHERE NULLIF(TRIM(received_date), '') IS NOT NULL
	AND NULLIF(TRIM(received_date), 'NULL') IS NOT NULL
	AND NOT pg_input_is_valid(received_date, 'date');

-- Expected Date Before Order Date
SELECT * FROM staging.purchase_orders_raw
WHERE expected_date::DATE < order_date::DATE;

-- Received Date Before Order Date
SELECT * FROM staging.purchase_orders_raw
WHERE NULLIF(received_date, 'NULL')::DATE < order_date::DATE;

-- Non-Numeric Total Amount
SELECT * FROM staging.purchase_orders_raw
WHERE NULLIF(TRIM(total_amount), '') IS NOT NULL
	AND NULLIF(TRIM(total_amount), 'NULL') IS NOT NULL
	AND NOT pg_input_is_valid(total_amount, 'numeric');

-- Negative Total Amount
SELECT * FROM staging.purchase_orders_raw
WHERE total_amount::NUMERIC < 0;

-- Supplier IDs Not Found in Suppliers
SELECT * FROM staging.purchase_orders_raw po
WHERE NOT EXISTS (
				SELECT 1 FROM staging.suppliers_raw s
				WHERE po.supplier_id = s.supplier_id);
				
-- Warehouse IDs Not Found in Warehouses
SELECT * FROM staging.purchase_orders_raw po
WHERE NOT EXISTS (
				SELECT 1 FROM staging.warehouses_raw w
				WHERE po.warehouse_id = w.warehouse_id);
				

/*--------------------------------------------------------------
 Purchase Order Items
--------------------------------------------------------------*/

-- NULL or Blank Purchase Order Item IDs
SELECT * FROM staging.purchase_order_items_raw
WHERE purchase_order_item_id IS NULL
	OR TRIM(purchase_order_item_id) = ''
	OR purchase_order_item_id = 'NULL';
	
-- Duplicate Purchase Order Item IDs
SELECT purchase_order_item_id,
	   COUNT(*) AS duplicate_count
FROM staging.purchase_order_items_raw
GROUP BY purchase_order_item_id
HAVING COUNT(*) > 1;

-- NULL or Blank Purchase Order IDs
SELECT * FROM staging.purchase_order_items_raw
WHERE purchase_order_id IS NULL
	OR TRIM(purchase_order_id) = ''
	OR purchase_order_id = 'NULL';
	
-- NULL or Blank Product IDs
SELECT * FROM staging.purchase_order_items_raw
WHERE product_id IS NULL
	OR TRIM(product_id) = ''
	OR product_id = 'NULL';
	
-- NULL or Blank Quantity Ordered
SELECT * FROM staging.purchase_order_items_raw
WHERE quantity_ordered IS NULL
	OR TRIM(quantity_ordered) = ''
	OR quantity_ordered = 'NULL';
	
-- NULL or Blank Quantity Received
SELECT * FROM staging.purchase_order_items_raw
WHERE quantity_received IS NULL
	OR TRIM(quantity_received) = ''
	OR quantity_received = 'NULL';

-- Non-Numeric Quantity Ordered
SELECT * FROM staging.purchase_order_items_raw
WHERE NULLIF(TRIM(quantity_ordered), '') IS NOT NULL
	AND NULLIF(TRIM(quantity_ordered), 'NULL') IS NOT NULL
	AND NOT pg_input_is_valid(quantity_ordered, 'int');
	
-- Non-Numeric Quantity Received
SELECT * FROM staging.purchase_order_items_raw
WHERE NULLIF(TRIM(quantity_received), '') IS NOT NULL
	AND NULLIF(TRIM(quantity_received), 'NULL') IS NOT NULL
	AND NOT pg_input_is_valid(quantity_received, 'int');

-- Non-Numeric Unit Cost
SELECT * FROM staging.purchase_order_items_raw
WHERE NULLIF(TRIM(unit_cost), '') IS NOT NULL
	AND NULLIF(TRIM(unit_cost), 'NULL') IS NOT NULL
	AND NOT pg_input_is_valid(unit_cost, 'numeric');
	
-- Non-Numeric Defect Quantity
SELECT * FROM staging.purchase_order_items_raw
WHERE NULLIF(TRIM(defect_quantity), '') IS NOT NULL
	AND NULLIF(TRIM(defect_quantity), 'NULL') IS NOT NULL
	AND NOT pg_input_is_valid(defect_quantity, 'int');	--defect_quantity conten text value

-- Zero or Negative Quantity Ordered
SELECT * FROM staging.purchase_order_items_raw
WHERE quantity_ordered::INT <= 0;

-- Negative Quantity Received
SELECT * FROM staging.purchase_order_items_raw
WHERE quantity_received::INT < 0;

-- Zero or Negative Unit Cost
SELECT * FROM staging.purchase_order_items_raw
WHERE unit_cost::NUMERIC <= 0;

-- Negative Defect Quantity
/* defect_quantity column contain text value
SELECT * FROM staging.purchase_order_items_raw
WHERE defect_quantity::INT < 0; */

-- Quantity Received Greater Than Quantity Ordered
SELECT * FROM staging.purchase_order_items_raw
WHERE quantity_received::INT > quantity_ordered::INT;

-- Defect Quantity Greater Than Quantity Received
/* defect_quantity column contain text value
SELECT * FROM staging.purchase_order_items_raw
WHERE defect_quantity::INT > quantity_received::INT; */

-- Purchase Order IDs Not Found in Purchase Orders
SELECT * FROM staging.purchase_order_items_raw poi
WHERE NOT EXISTS (
				SELECT 1 FROM staging.purchase_orders_raw po
				WHERE poi.purchase_order_id = po.purchase_order_id);
				
-- Product IDs Not Found in Products
SELECT * FROM staging.purchase_order_items_raw poi
WHERE NOT EXISTS (
				SELECT 1 FROM staging.products_raw p
				WHERE poi.product_id = p.product_id);



/*==============================================================
 PROCUREMENT DATA VALIDATION COMPLETE
==============================================================

 The staging procurement data has been validated for
 completeness, uniqueness, valid values, ranges,
 logical consistency, and relationships.

 Next Step:
 Create the final procurement tables with appropriate data
 types, constraints, and relational integrity.

==============================================================*/
