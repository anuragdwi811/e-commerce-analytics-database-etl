/*==============================================================
 Project     : E-Commerce Analytics Database
 Database    : PostgreSQL
 Module      : 06 - Sales Data Validation
 Description : Validate the imported sales data for completeness,
               uniqueness, valid values, ranges, logical
               consistency, and relationships before loading
               the final tables.
 Author      : Anurag Dwivedi
==============================================================*/



/*--------------------------------------------------------------
 Orders
--------------------------------------------------------------*/

-- NULL or Blank Order IDs
SELECT * FROM staging.orders_raw
WHERE order_id IS NULL
	OR TRIM(order_id) = ''
	OR order_id = 'NULL';
	
-- Duplicate Order IDs
SELECT order_id,
	   COUNT(*) AS duplicate_count
FROM staging.orders_raw
GROUP BY order_id
HAVING COUNT(*) > 1;

-- NULL or Blank Customer IDs
SELECT * FROM staging.orders_raw
WHERE customer_id IS NULL
	OR TRIM(customer_id) = ''
	OR customer_id = 'NULL';
	
-- NULL or Blank Order Dates
SELECT * FROM staging.orders_raw
WHERE order_date IS NULL
	OR TRIM(order_date) = ''
	OR order_date = 'NULL';
	
-- NULL or Blank Order Status
SELECT * FROM staging.orders_raw
WHERE order_status IS NULL
	OR TRIM(order_status) = ''
	OR order_status = 'NULL';
	
-- NULL or Blank Sales Channel
SELECT * FROM staging.orders_raw
WHERE sales_channel IS NULL
	OR TRIM(sales_channel) = ''
	OR sales_channel = 'NULL';

-- Invalid Order Date Format
SELECT * FROM staging.orders_raw
WHERE NULLIF(TRIM(order_date), '') IS NOT NULL
	AND NULLIF(order_date, 'NULL') IS NOT NULL
	AND NOT pg_input_is_valid(order_date, 'date');
	
-- Invalid Expected Delivery Date Format
SELECT * FROM staging.orders_raw
WHERE NULLIF(TRIM(expected_delivery_date), '') IS NOT NULL
	AND NULLIF(expected_delivery_date, 'NULL') IS NOT NULL
	AND NOT pg_input_is_valid(expected_delivery_date, 'date');
	
-- Invalid Cancellation Date Format
SELECT * FROM staging.orders_raw
WHERE NULLIF(TRIM(cancellation_date), '') IS NOT NULL
	AND NULLIF(cancellation_date, 'NULL') IS NOT NULL
	AND NOT pg_input_is_valid(cancellation_date, 'date');
	
-- Invalid Created Timestamp Format
SELECT * FROM staging.orders_raw
WHERE NULLIF(TRIM(created_at), '') IS NOT NULL
	AND NULLIF(created_at, 'NULL') IS NOT NULL
	AND NOT pg_input_is_valid(created_at, 'timestamp');
	
-- Invalid Updated Timestamp Format
SELECT * FROM staging.orders_raw
WHERE NULLIF(TRIM(updated_at), '') IS NOT NULL
	AND NULLIF(updated_at, 'NULL') IS NOT NULL
	AND NOT pg_input_is_valid(updated_at, 'timestamp');
	
-- Invalid Confirmed Timestamp Format
SELECT * FROM staging.orders_raw
WHERE NULLIF(TRIM(confirmed_at), '') IS NOT NULL
	AND NULLIF(confirmed_at, 'NULL') IS NOT NULL
	AND NOT pg_input_is_valid(confirmed_at, 'timestamp');
	
-- Invalid Packed Timestamp Format
SELECT * FROM staging.orders_raw
WHERE NULLIF(TRIM(packed_at), '') IS NOT NULL
	AND NULLIF(packed_at, 'NULL') IS NOT NULL
	AND NOT pg_input_is_valid(packed_at, 'timestamp');

-- Future Order Dates
SELECT * FROM staging.orders_raw
WHERE order_date::DATE > CURRENT_DATE;

-- Cancellation Date Before Order Date
SELECT * FROM staging.orders_raw
WHERE NULLIF(cancellation_date, 'NULL')::DATE < order_date::DATE;

-- Expected Delivery Date Before Order Date
SELECT * FROM staging.orders_raw
WHERE expected_delivery_date::DATE < order_date::DATE;

-- Confirmed Timestamp Before Order Timestamp
SELECT * FROM staging.orders_raw
WHERE NULLIF(confirmed_at, 'NULL')::TIMESTAMP < created_at::TIMESTAMP;

-- Packed Timestamp Before Confirmed Timestamp
SELECT * FROM staging.orders_raw
WHERE NULLIF(packed_at, 'NULL')::TIMESTAMP < NULLIF(confirmed_at, 'NULL')::TIMESTAMP;

-- Updated Timestamp Before Created Timestamp
SELECT * FROM staging.orders_raw
WHERE updated_at::TIMESTAMP < created_at::TIMESTAMP;

-- Customer IDs Not Found in Customers
SELECT * FROM staging.orders_raw o
WHERE NOT EXISTS (
				SELECT 1 FROM staging.customers_raw c
				WHERE o.customer_id = c.customer_id);
				
-- Warehouse IDs Not Found in Warehouses
SELECT * FROM staging.orders_raw o
WHERE NOT EXISTS (
				SELECT 1 FROM staging.warehouses_raw w
				WHERE o.warehouse_id = w.warehouse_id);
				
-- Coupon IDs Not Found in Coupons
SELECT * FROM staging.orders_raw o
WHERE NULLIF(TRIM(o.coupon_id), '') IS NOT NULL
  	AND NULLIF(TRIM(o.coupon_id), 'NULL') IS NOT NULL
  	AND NOT EXISTS (
      			SELECT 1 FROM staging.coupons_raw c
      			WHERE TRIM(o.coupon_id) = TRIM(c.coupon_id));
				
-- Campaign IDs Not Found in Campaigns
SELECT * FROM staging.orders_raw o
WHERE NULLIF(TRIM(o.campaign_id), '') IS NOT NULL
  	AND NULLIF(TRIM(o.campaign_id), 'NULL') IS NOT NULL
  	AND NOT EXISTS (
      			SELECT 1 FROM staging.campaigns_raw c
      			WHERE TRIM(o.campaign_id) = TRIM(c.campaign_id));

-- Non-Numeric Subtotal
SELECT * FROM staging.orders_raw
WHERE NULLIF(TRIM(subtotal), '') IS NOT NULL
	AND NULLIF(subtotal, 'NULL') IS NOT NULL
	AND NOT pg_input_is_valid(subtotal, 'numeric');
	
-- Non-Numeric Discount Amount
SELECT * FROM staging.orders_raw
WHERE NULLIF(TRIM(discount_amount), '') IS NOT NULL
	AND NULLIF(discount_amount, 'NULL') IS NOT NULL
	AND NOT pg_input_is_valid(discount_amount, 'numeric');
	
-- Non-Numeric Shipping Fee
SELECT * FROM staging.orders_raw
WHERE NULLIF(TRIM(shipping_fee), '') IS NOT NULL
	AND NULLIF(shipping_fee, 'NULL') IS NOT NULL
	AND NOT pg_input_is_valid(shipping_fee, 'numeric');
	
-- Non-Numeric Tax Amount
SELECT * FROM staging.orders_raw
WHERE NULLIF(TRIM(tax_amount), '') IS NOT NULL
	AND NULLIF(tax_amount, 'NULL') IS NOT NULL
	AND NOT pg_input_is_valid(tax_amount, 'numeric');
	
-- Non-Numeric Total Amount
SELECT * FROM staging.orders_raw
WHERE NULLIF(TRIM(total_amount), '') IS NOT NULL
	AND NULLIF(total_amount, 'NULL') IS NOT NULL
	AND NOT pg_input_is_valid(total_amount, 'numeric');
	
-- Negative Subtotal
SELECT * FROM staging.orders_raw
WHERE subtotal::NUMERIC < 0;

-- Negative Discount Amount
SELECT * FROM staging.orders_raw
WHERE discount_amount::NUMERIC < 0;

-- Negative Shipping Fee
SELECT * FROM staging.orders_raw
WHERE shipping_fee::NUMERIC < 0;

-- Negative Tax Amount
SELECT * FROM staging.orders_raw
WHERE tax_amount::NUMERIC < 0;

-- Negative Total Amount
SELECT * FROM staging.orders_raw
WHERE total_amount::NUMERIC < 0;

-- Discount Amount Greater Than Subtotal
SELECT * FROM staging.orders_raw
WHERE discount_amount::NUMERIC > subtotal::NUMERIC;

-- Order Total Amount Calculation
/* oi.quantity column contain text value
WITH order_matrix AS (
		SELECT o.order_id,
			   ROUND(o.total_amount::NUMERIC, 0) AS total_amount,
			   ROUND(SUM((oi.quantity::INT * oi.unit_price::NUMERIC) - oi.discount_amount::NUMERIC), 0)
			   		AS cal_total_amount
		FROM staging.orders_raw o
		JOIN staging.order_items_raw oi
			ON o.order_id = oi.order_id
		GROUP BY o.order_id)
SELECT * FROM order_matrix
WHERE total_amount <> cal_total_amount; */



/*--------------------------------------------------------------
 Order Items
--------------------------------------------------------------*/

-- NULL or Blank Order Item IDs
SELECT * FROM staging.order_items_raw
WHERE order_item_id IS NULL
	OR TRIM(order_item_id) = ''
	OR order_item_id = 'NULL';
	
-- Duplicate Order Item IDs
SELECT order_item_id,
	   COUNT(*) AS duplicate_count
FROM staging.order_items_raw
GROUP BY order_item_id
HAVING COUNT(*) > 1;

-- NULL or Blank Order IDs
SELECT * FROM staging.order_items_raw
WHERE order_id IS NULL
	OR TRIM(order_id) = ''
	OR order_id = 'NULL';
	
-- NULL or Blank Product IDs
SELECT * FROM staging.order_items_raw
WHERE product_id IS NULL
	OR TRIM(product_id) = ''
	OR product_id = 'NULL';
	
-- NULL or Blank Quantity
SELECT * FROM staging.order_items_raw
WHERE quantity IS NULL
	OR TRIM(quantity) = ''
	OR quantity = 'NULL';
	
-- NULL or Blank Unit Price
SELECT * FROM staging.order_items_raw
WHERE unit_price IS NULL
	OR TRIM(unit_price) = ''
	OR unit_price = 'NULL';

-- Non-Numeric Quantity
SELECT * FROM staging.order_items_raw
WHERE NULLIF(TRIM(quantity), '') IS NOT NULL
	AND NULLIF(quantity, 'NULL') IS NOT NULL
	AND NOT pg_input_is_valid(quantity, 'numeric');
	
-- Non-Numeric Unit Price
SELECT * FROM staging.order_items_raw
WHERE NULLIF(TRIM(unit_price), '') IS NOT NULL
	AND NULLIF(unit_price, 'NULL') IS NOT NULL
	AND NOT pg_input_is_valid(unit_price, 'numeric');
	
-- Non-Numeric MRP
SELECT * FROM staging.order_items_raw
WHERE NULLIF(TRIM(mrp), '') IS NOT NULL
	AND NULLIF(mrp, 'NULL') IS NOT NULL
	AND NOT pg_input_is_valid(mrp, 'numeric');
	
-- Non-Numeric Discount Amount
SELECT * FROM staging.order_items_raw
WHERE NULLIF(TRIM(discount_amount), '') IS NOT NULL
	AND NULLIF(discount_amount, 'NULL') IS NOT NULL
	AND NOT pg_input_is_valid(discount_amount, 'numeric');
	
-- Non-Numeric Discount Percent
SELECT * FROM staging.order_items_raw
WHERE NULLIF(TRIM(discount_percent), '') IS NOT NULL
	AND NULLIF(discount_percent, 'NULL') IS NOT NULL
	AND NOT pg_input_is_valid(discount_percent, 'numeric');
	
-- Non-Numeric Tax Amount
SELECT * FROM staging.order_items_raw
WHERE NULLIF(TRIM(tax_amount), '') IS NOT NULL
	AND NULLIF(tax_amount, 'NULL') IS NOT NULL
	AND NOT pg_input_is_valid(tax_amount, 'numeric');
	
-- Non-Numeric Item Revenue
SELECT * FROM staging.order_items_raw
WHERE NULLIF(TRIM(item_revenue), '') IS NOT NULL
	AND NULLIF(item_revenue, 'NULL') IS NOT NULL
	AND NOT pg_input_is_valid(item_revenue, 'numeric');
	
-- Non-Numeric Unit Cost
SELECT * FROM staging.order_items_raw
WHERE NULLIF(TRIM(unit_cost), '') IS NOT NULL
	AND NULLIF(unit_cost, 'NULL') IS NOT NULL
	AND NOT pg_input_is_valid(unit_cost, 'numeric');
	
-- Non-Numeric Item Cost
SELECT * FROM staging.order_items_raw
WHERE NULLIF(TRIM(item_cost), '') IS NOT NULL
	AND NULLIF(item_cost, 'NULL') IS NOT NULL
	AND NOT pg_input_is_valid(item_cost, 'numeric');
	
-- Non-Numeric Gross Profit
SELECT * FROM staging.order_items_raw
WHERE NULLIF(TRIM(gross_profit), '') IS NOT NULL
	AND NULLIF(gross_profit, 'NULL') IS NOT NULL
	AND NOT pg_input_is_valid(gross_profit, 'numeric');

-- Zero or Negative Quantity
/* quantity column contain text value
SELECT * FROM staging.order_items_raw
WHERE quantity::INT <= 0; */

-- Negative Unit Price
SELECT * FROM staging.order_items_raw
WHERE unit_price::NUMERIC < 0;

-- Negative MRP
SELECT * FROM staging.order_items_raw
WHERE mrp::NUMERIC < 0;

-- Negative Discount Amount
SELECT * FROM staging.order_items_raw
WHERE NULLIF(discount_amount, 'NULL')::NUMERIC < 0;

-- Invalid Discount Percent
SELECT * FROM staging.order_items_raw
WHERE NULLIF(discount_percent, 'NULL')::NUMERIC NOT BETWEEN 0 AND 100;

-- Negative Tax Amount
SELECT * FROM staging.order_items_raw
WHERE tax_amount::NUMERIC < 0;

-- Negative Item Revenue
SELECT * FROM staging.order_items_raw
WHERE item_revenue::NUMERIC < 0;

-- Negative Unit Cost
SELECT * FROM staging.order_items_raw
WHERE unit_cost::NUMERIC < 0;

-- Negative Item Cost
SELECT * FROM staging.order_items_raw
WHERE item_cost::NUMERIC < 0;

-- Unit Price Greater Than MRP
SELECT * FROM staging.order_items_raw
WHERE unit_price::NUMERIC > mrp::NUMERIC;

-- Discount Amount Greater Than Item Value (quantity contain text value)
-- Item Revenue Calculation (quantity contain text value)
-- Gross Profit Calculation (quantity contain text value)
-- Item Cost Calculation (quantity contain text value)

-- Order IDs Not Found in Orders
SELECT * FROM staging.order_items_raw oi
WHERE NOT EXISTS (
				SELECT 1 FROM staging.orders_raw o
				WHERE oi.order_id = o.order_id);
				
-- Product IDs Not Found in Products
SELECT * FROM staging.order_items_raw oi
WHERE NOT EXISTS (
				SELECT 1 FROM staging.products_raw p
				WHERE oi.product_id = p.product_id);
				


/*--------------------------------------------------------------
 Sales Targets
--------------------------------------------------------------*/

-- NULL or Blank Target IDs
SELECT * FROM staging.sales_targets_raw
WHERE target_id IS NULL
	OR TRIM(target_id) = ''
	OR target_id = 'NULL';
	
-- Duplicate Target IDs
SELECT target_id,
	   COUNT(*) AS duplicate_count
FROM staging.sales_targets_raw
GROUP BY target_id
HAVING COUNT(*) > 1;

-- NULL or Blank Target Months
SELECT * FROM staging.sales_targets_raw
WHERE target_month IS NULL
	OR TRIM(target_month) = ''
	OR target_month = 'NULL';
	
-- NULL or Blank Regions
SELECT * FROM staging.sales_targets_raw
WHERE region IS NULL
	OR TRIM(region) = ''
	OR region = 'NULL';
	
-- NULL or Blank Category IDs
SELECT * FROM staging.sales_targets_raw
WHERE category_id IS NULL
	OR TRIM(category_id) = ''
	OR category_id = 'NULL';

-- Invalid Target Month Format
SELECT * FROM staging.sales_targets_raw
WHERE NULLIF(TRIM(target_month), '') IS NOT NULL
	AND NULLIF(TRIM(target_month), 'NULL') IS NOT NULL
	AND NOT pg_input_is_valid (target_month, 'date');
	
-- Non-Numeric Order Targets
SELECT * FROM staging.sales_targets_raw
WHERE NULLIF(TRIM(order_target), '') IS NOT NULL
	AND NULLIF(TRIM(order_target), 'NULL') IS NOT NULL
	AND NOT pg_input_is_valid (order_target, 'numeric');
	
-- Non-Numeric Unit Targets
SELECT * FROM staging.sales_targets_raw
WHERE NULLIF(TRIM(unit_target), '') IS NOT NULL
	AND NULLIF(TRIM(unit_target), 'NULL') IS NOT NULL
	AND NOT pg_input_is_valid (unit_target, 'numeric');
	
-- Non-Numeric Sales Targets
SELECT * FROM staging.sales_targets_raw
WHERE NULLIF(TRIM(sales_target), '') IS NOT NULL
	AND NULLIF(TRIM(sales_target), 'NULL') IS NOT NULL
	AND NOT pg_input_is_valid (sales_target, 'numeric');

-- Zero or Negative Order Targets
SELECT * FROM staging.sales_targets_raw
WHERE order_target::NUMERIC <= 0;

-- Zero or Negative Unit Targets
SELECT * FROM staging.sales_targets_raw
WHERE unit_target::NUMERIC <= 0;

-- Zero or Negative Sales Targets
SELECT * FROM staging.sales_targets_raw
WHERE sales_target::NUMERIC <= 0;

-- Category IDs Not Found in Categories
SELECT * FROM staging.sales_targets_raw st
WHERE NOT EXISTS (
				SELECT * FROM staging.categories_raw c
				WHERE st.category_id = c.category_id);




/*==============================================================
 SALES DATA VALIDATION COMPLETE
==============================================================

 The staging sales data has been validated for completeness,
 uniqueness, valid values, ranges, logical consistency,
 and relationships.

 Next Step:
 Create the final sales tables with appropriate data types,
 constraints, and relational integrity.

==============================================================*/
