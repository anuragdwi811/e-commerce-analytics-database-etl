/*==============================================================
 Project     : E-Commerce Analytics Database
 Database    : PostgreSQL
 Module      : 04 - Data Profiling
 Description : Profile the imported staging data to understand
               data structure, completeness, uniqueness, and
               basic data quality before validation.
 Author      : Anurag Dwivedi
==============================================================*/



/*==============================================================
 Master Data - Profiling
==============================================================*/

/*--------------------------------------------------------------
 Customers
--------------------------------------------------------------*/


-- Total Customer Records
SELECT COUNT(*) AS total_customers
FROM staging.customers_raw;

-- Distinct Customer IDs
SELECT COUNT(DISTINCT(customer_id)) AS total_distinct_customers
FROM staging.customers_raw;

-- Customer Gender Distribution
SELECT gender, COUNT(*) AS total_customers
FROM staging.customers_raw
GROUP BY gender
ORDER BY total_customers DESC;

-- Customer Type Distribution
SELECT customer_type, COUNT(*) AS total_customers
FROM staging.customers_raw
GROUP BY customer_type
ORDER BY total_customers DESC;

-- Customer Segment Distribution
SELECT customer_segment, COUNT(*) AS total_customers
FROM staging.customers_raw
GROUP BY customer_segment
ORDER BY total_customers DESC;

-- Customer Status Distribution
SELECT customer_status, COUNT(*) AS total_customers
FROM staging.customers_raw
GROUP BY customer_status
ORDER BY total_customers DESC;

-- Acquisition Channel Distribution
SELECT acquisition_channel, COUNT(*) AS total_customers
FROM staging.customers_raw
GROUP BY acquisition_channel
ORDER BY total_customers DESC;

-- Customer Geographic Distribution
SELECT region,
	   state,
	   city,
	   COUNT(*) AS total_customers
FROM staging.customers_raw
GROUP BY region,
		 state,
		 city
ORDER BY total_customers DESC;

-- Date of Birth Range
SELECT MIN(CAST(date_of_birth AS DATE)) AS min_dob,
	   MAX(CAST(date_of_birth AS DATE)) AS max_dob
FROM staging.customers_raw;

-- Registration Date Range
SELECT MIN(registration_date::DATE) AS min_registration_date,
	   MAX(registration_date::DATE) AS max_registration_date
FROM staging.customers_raw;

-- Created/Updated Timestamp Range
SELECT MIN(created_at::TIMESTAMP) AS min_created_at,
	   MAX(created_at::TIMESTAMP) AS max_created_at,
	   MIN(updated_at::TIMESTAMP) AS min_updated_at,
	   MAX(updated_at::TIMESTAMP) AS max_updated_at
FROM staging.customers_raw;

-- Campaign Attribution Overview
SELECT COUNT(CASE 
				WHEN NULLIF(acquisition_campaign_id, 'NULL') IS NOT NULL
				THEN 1 END) AS customers_with_campaign,
	   COUNT(CASE 
	   			WHEN NULLIF(acquisition_campaign_id, 'NULL') IS NULL
				THEN 1 END) AS customers_without_campaign
FROM staging.customers_raw;


/*--------------------------------------------------------------
 Categories
--------------------------------------------------------------*/


-- Total Category Records
SELECT COUNT(*) AS total_categories
FROM staging.categories_raw;

-- Distinct Category IDs
SELECT COUNT(DISTINCT(category_id)) AS total_distinct_categories
FROM staging.categories_raw;

-- Department Distribution
SELECT department,
	   COUNT(*) AS total_categories
FROM staging.categories_raw
GROUP BY department
ORDER BY total_categories DESC;

-- Category Status Distribution
SELECT category_status,
	   COUNT(*) AS total_categories
FROM staging.categories_raw
GROUP BY category_status
ORDER BY total_categories DESC;

-- Categories by Department and Status
SELECT category_status,
	   department,
	   COUNT(*) AS total_categories
FROM staging.categories_raw
GROUP BY category_status,
		 department
ORDER BY total_categories DESC;


/*--------------------------------------------------------------
 Subcategories
--------------------------------------------------------------*/


-- Total Subcategory Records
SELECT COUNT(*) AS total_subcategories
FROM staging.subcategories_raw;

-- Distinct Subcategory IDs
SELECT COUNT(DISTINCT(subcategory_id)) AS total_distinct_subcategories
FROM staging.subcategories_raw;

-- Distinct Category IDs
SELECT COUNT(DISTINCT(category_id)) AS total_distinct_categories
FROM staging.subcategories_raw;

-- Subcategories by Category
SELECT category_id,
	   COUNT(*) AS total_subcategories
FROM staging.subcategories_raw
GROUP BY category_id
ORDER BY total_subcategories DESC;

-- Subcategory Status Distribution
SELECT subcategory_status,
	   COUNT(*) AS total_subcategories
FROM staging.subcategories_raw
GROUP BY subcategory_status
ORDER BY total_subcategories DESC;

-- Subcategories by Category and Status
SELECT subcategory_status,
		category_id,
		COUNT(*) AS total_subcategories
FROM staging.subcategories_raw
GROUP BY subcategory_status,
		 category_id
ORDER BY total_subcategories DESC;


/*--------------------------------------------------------------
 Products
--------------------------------------------------------------*/


-- Total Product Records
SELECT COUNT(*) AS total_products
FROM staging.products_raw;

-- Distinct Product IDs
SELECT COUNT(DISTINCT(product_id)) AS total_distinct_products
FROM staging.products_raw;

-- Distinct Categories
SELECT COUNT(DISTINCT(category_id)) AS total_distinct_categories
FROM staging.products_raw;

-- Distinct Subcategories
SELECT COUNT(DISTINCT(subcategory_id)) AS total_distinct_subcategories
FROM staging.products_raw;

-- Distinct Suppliers
SELECT COUNT(DISTINCT(supplier_id)) AS total_distinct_suppliers
FROM staging.products_raw;

-- Distinct Brands
SELECT COUNT(DISTINCT(brand)) AS total_distinct_brands
FROM staging.products_raw;

-- Products by Category
SELECT category_id,
	   COUNT(*) AS total_products
FROM staging.products_raw
GROUP BY category_id
ORDER BY total_products DESC;

-- Products by Subcategory
SELECT subcategory_id,
	   COUNT(*) AS total_products
FROM staging.products_raw
GROUP BY subcategory_id
ORDER BY total_products DESC;

-- Products by Brand
SELECT brand,
	   COUNT(*) AS total_products
FROM staging.products_raw
GROUP BY brand
ORDER BY total_products DESC;

-- Product Status Distribution
SELECT product_status,
	   COUNT(*) AS total_products
FROM staging.products_raw
GROUP BY product_status
ORDER BY total_products DESC;

-- Unit Cost Statistics
SELECT MIN(unit_cost::NUMERIC) AS min_unit_cost,
	   AVG(unit_cost::NUMERIC) AS avg_unit_cost,
	   MAX(unit_cost::NUMERIC) AS max_unit_cost
FROM staging.products_raw;

-- Selling Price Statistics
SELECT MIN(selling_price::NUMERIC) AS min_selling_price,
	   AVG(selling_price::NUMERIC) AS avg_selling_price,
	   MAX(selling_price::NUMERIC) AS max_selling_price
FROM staging.products_raw;

-- MRP Statistics
SELECT MIN(CAST(mrp AS NUMERIC)) AS min_mrp,
	   AVG(CAST(mrp AS NUMERIC)) AS avg_mrp,
	   MAX(CAST(mrp AS NUMERIC)) AS max_mrp
FROM staging.products_raw;

-- Product Weight Statistics
SELECT MIN(weight_kg::NUMERIC) AS min_weight,
	   AVG(weight_kg::NUMERIC) AS avg_weight,
	   MAX(weight_kg::NUMERIC) AS max_weight
FROM staging.products_raw;

-- Product Rating Statistics
SELECT MIN(rating::NUMERIC) AS min_rating,
	   AVG(rating::NUMERIC) AS avg_rating,
	   MAX(rating::NUMERIC) AS max_rating
FROM staging.products_raw;

-- Product Launch Date Range
SELECT MIN(launch_date::DATE) AS min_launch_date,
	   MAX(launch_date::DATE) AS max_launch_date
FROM staging.products_raw;

-- Product Launches by Year
SELECT EXTRACT(YEAR FROM launch_date::DATE) AS launch_year,
	   COUNT(*) AS total_product_launches
FROM staging.products_raw
GROUP BY launch_year
ORDER BY total_product_launches DESC;

-- Products by Supplier
SELECT supplier_id,
	   COUNT(*) AS total_products
FROM staging.products_raw
GROUP BY supplier_id
ORDER BY total_products DESC;

-- Products by Status and Category
SELECT product_status,
	   category_id,
	   COUNT(*) AS total_products
FROM staging.products_raw
GROUP BY product_status,
		 category_id
ORDER BY total_products DESC;


/*--------------------------------------------------------------
 Suppliers
--------------------------------------------------------------*/


-- Total Supplier Records
SELECT COUNT(*) AS total_suppliers
FROM staging.suppliers_raw;

-- Distinct Supplier IDs
SELECT COUNT(DISTINCT(supplier_id)) AS total_distinct_suppliers
FROM staging.suppliers_raw;

-- Supplier Type Distribution
SELECT supplier_type,
	   COUNT(*) AS total_suppliers
FROM staging.suppliers_raw
GROUP BY supplier_type
ORDER BY total_suppliers DESC;

-- Supplier Status Distribution
SELECT supplier_status,
	   COUNT(*) AS total_suppliers
FROM staging.suppliers_raw
GROUP BY supplier_status
ORDER BY total_suppliers DESC;

-- Suppliers by Region
SELECT region,
	   COUNT(*) AS total_suppliers
FROM staging.suppliers_raw
GROUP BY region
ORDER BY total_suppliers DESC;

-- Suppliers by State
SELECT state,
	   COUNT(*) AS total_suppliers
FROM staging.suppliers_raw
GROUP BY state
ORDER BY total_suppliers DESC;

-- Suppliers by City
SELECT city,
	   COUNT(*) AS total_suppliers
FROM staging.suppliers_raw
GROUP BY city
ORDER BY total_suppliers DESC;

-- Supplier Rating Statistics
SELECT MIN(CAST(rating AS NUMERIC)) AS min_rating,
	   AVG(CAST(rating AS NUMERIC)) AS avg_rating,
	   MAX(CAST(rating AS NUMERIC)) AS max_rating
FROM staging.suppliers_raw;

-- Lead Time Statistics
SELECT MIN(lead_time_days::INT) AS min_lead_time_days,
	   AVG(lead_time_days::INT) AS avg_lead_time_days,
	   MAX(lead_time_days::INT) AS max_lead_time_days
FROM staging.suppliers_raw;

-- Payment Terms Distribution
SELECT payment_terms,
	   COUNT(*) AS total_suppliers
FROM staging.suppliers_raw
GROUP BY payment_terms
ORDER BY total_suppliers DESC;

-- Suppliers by Type and Status
SELECT supplier_status,
	   supplier_type,
	   COUNT(*) AS total_suppliers
FROM staging.suppliers_raw
GROUP BY supplier_status,
		 supplier_type
ORDER BY total_suppliers DESC;


/*--------------------------------------------------------------
 Warehouses
--------------------------------------------------------------*/


-- Total Warehouse Records
SELECT COUNT(*) AS total_warehouses
FROM staging.warehouses_raw;

-- Distinct Warehouse IDs
SELECT COUNT(DISTINCT(warehouse_id)) AS total_distinct_warehouses
FROM staging.warehouses_raw;

-- Warehouse Type Distribution
SELECT warehouse_type,
	   COUNT(*) AS total_warehouses
FROM staging.warehouses_raw
GROUP BY warehouse_type
ORDER BY total_warehouses DESC;

-- Warehouse Status Distribution
SELECT status,
	   COUNT(*) AS total_warehouses
FROM staging.warehouses_raw
GROUP BY status
ORDER BY total_warehouses DESC;

-- Warehouses by Region
SELECT region,
	   COUNT(*) AS total_warehouses
FROM staging.warehouses_raw
GROUP BY region
ORDER BY total_warehouses DESC;

-- Warehouses by State
SELECT state,
	   COUNT(*) AS total_warehouses
FROM staging.warehouses_raw
GROUP BY state
ORDER BY total_warehouses DESC;

-- Warehouses by City
SELECT city,
	   COUNT(*) AS total_warehouses
FROM staging.warehouses_raw
GROUP BY city
ORDER BY total_warehouses DESC;

-- Warehouse Capacity Statistics
SELECT MIN(capacity::INT) AS min_capacity,
	   AVG(capacity::INT) AS avg_capacity,
	   MAX(capacity::INT) AS max_capacity
FROM staging.warehouses_raw;

-- Warehouse Opening Date Range
SELECT MIN(opening_date::DATE) AS min_opening_date,
	   MAX(opening_date::DATE) AS max_opening_date
FROM staging.warehouses_raw;

-- Warehouses by Type and Status
SELECT status,
	   warehouse_type,
	   COUNT(*) AS total_warehouses
FROM staging.warehouses_raw
GROUP BY status,
		 warehouse_type
ORDER BY total_warehouses DESC;


/*--------------------------------------------------------------
 Couriers
--------------------------------------------------------------*/


-- Total Courier Records
SELECT COUNT(*) AS total_couriers
FROM staging.couriers_raw;

-- Distinct Courier IDs
SELECT COUNT(DISTINCT(courier_id)) AS total_distinct_couriers
FROM staging.couriers_raw;

-- Service Type Distribution
SELECT service_type,
	   COUNT(*) AS total_couriers
FROM staging.couriers_raw
GROUP BY service_type
ORDER BY total_couriers DESC;

-- Courier Status Distribution
SELECT status,
	   COUNT(*) AS total_couriers
FROM staging.couriers_raw
GROUP BY status
ORDER BY total_couriers DESC;

-- Courier Rating Statistics
SELECT MIN(CAST(rating AS NUMERIC)) AS min_rating,
	   AVG(CAST(rating AS NUMERIC)) AS avg_rating,
	   MAX(CAST(rating AS NUMERIC)) AS max_rating
FROM staging.couriers_raw;

-- Couriers by Service Type and Status
SELECT status,
	   service_type,
	   COUNT(*) AS total_couriers
FROM staging.couriers_raw
GROUP BY status,
		 service_type
ORDER BY total_couriers DESC;

-- Average Rating by Service Type
SELECT service_type,
	   ROUND(AVG(rating::NUMERIC),2) AS avg_rating
FROM staging.couriers_raw
GROUP BY service_type
ORDER BY avg_rating DESC;



/*==============================================================
 Sales Data - Profiling
==============================================================*/

/*--------------------------------------------------------------
 Orders
--------------------------------------------------------------*/


-- Total Order Records
SELECT COUNT(*) AS total_orders
FROM staging.orders_raw;

-- Distinct Order IDs
SELECT COUNT(DISTINCT(order_id)) AS total_distinct_orders
FROM staging.orders_raw;

-- Order Status Distribution
SELECT order_status,
	   COUNT(*) AS total_orders
FROM staging.orders_raw
GROUP BY order_status
ORDER BY total_orders DESC;

-- Sales Channel Distribution
SELECT sales_channel,
	   COUNT(*) AS total_orders
FROM staging.orders_raw
GROUP BY sales_channel
ORDER BY total_orders DESC;

-- Payment Status Distribution
SELECT payment_status,
	   COUNT(*) AS total_orders
FROM staging.orders_raw
GROUP BY payment_status
ORDER BY total_orders DESC;

-- Fulfillment Status Distribution
SELECT fulfillment_status,
	   COUNT(*) AS total_orders
FROM staging.orders_raw
GROUP BY fulfillment_status
ORDER BY total_orders DESC;

-- Orders by Order Status and Sales Channel
SELECT order_status,
	   sales_channel,
	   COUNT(*) AS total_orders
FROM staging.orders_raw
GROUP BY order_status,
		 sales_channel
ORDER BY total_orders DESC;

-- Orders by Customer
SELECT customer_id,
	   COUNT(*) AS total_orders
FROM staging.orders_raw
GROUP BY customer_id
ORDER BY total_orders DESC;

-- Orders by Warehouse
SELECT warehouse_id,
	   COUNT(*) AS total_orders
FROM staging.orders_raw
GROUP BY warehouse_id
ORDER BY total_orders DESC;

-- Orders by Coupon
SELECT coupon_id,
	   COUNT(*) AS total_orders
FROM staging.orders_raw
GROUP BY coupon_id
ORDER BY total_orders DESC;

-- Orders by Campaign
SELECT campaign_id,
	   COUNT(*) AS total_orders
FROM staging.orders_raw
GROUP BY campaign_id
ORDER BY total_orders DESC;

-- Order Date Range
SELECT MIN(order_date::DATE) AS min_order_date,
	   MAX(order_date::DATE) AS max_order_date
FROM staging.orders_raw;

-- Expected Delivery Date Range
SELECT MIN(expected_delivery_date::DATE) AS min_expected_delivery_date,
	   MAX(expected_delivery_date::DATE) AS max_expected_delivery_date
FROM staging.orders_raw;

-- Cancellation Date Range
SELECT MIN(NULLIF(cancellation_date, 'NULL')::DATE) AS min_cancellation_date,
	   MAX(NULLIF(cancellation_date, 'NULL')::DATE) AS max_cancellation_date
FROM staging.orders_raw;

-- Created and Updated Timestamp Range
SELECT MIN(created_at::TIMESTAMP) AS min_created_at,
	   MAX(created_at::TIMESTAMP) AS max_created_at,
	   MIN(updated_at::TIMESTAMP) AS min_updated_at,
	   MAX(updated_at::TIMESTAMP) AS max_updated_at
FROM staging.orders_raw;

-- Confirmed and Packed Timestamp Range
SELECT MIN(NULLIF(confirmed_at,'NULL')::TIMESTAMP) AS min_confirmed_at,
	   MAX(NULLIF(confirmed_at,'NULL')::TIMESTAMP) AS max_confirmed_at,
	   MIN(NULLIF(packed_at,'NULL')::TIMESTAMP) AS min_packed_at,
	   MAX(NULLIF(packed_at,'NULL')::TIMESTAMP) AS max_packed_at
FROM staging.orders_raw;

-- Subtotal Statistics
SELECT MIN(subtotal::NUMERIC) AS min_subtotal,
	   AVG(subtotal::NUMERIC) AS avg_subtotal,
	   MAX(subtotal::NUMERIC) AS max_subtotal
FROM staging.orders_raw;

-- Discount Amount Statistics
SELECT MIN(discount_amount::NUMERIC) AS min_discount_amount,
	   AVG(discount_amount::NUMERIC) AS avg_discount_amount,
	   MAX(discount_amount::NUMERIC) AS max_discount_amount
FROM staging.orders_raw;

-- Shipping Fee Statistics
SELECT MIN(shipping_fee::NUMERIC) AS min_shipping_fee,
	   AVG(shipping_fee::NUMERIC) AS avg_shipping_fee,
	   MAX(shipping_fee::NUMERIC) AS max_shipping_fee
FROM staging.orders_raw;

-- Tax Amount Statistics
SELECT MIN(tax_amount::NUMERIC) AS min_tax_amount,
	   AVG(tax_amount::NUMERIC) AS avg_tax_amount,
	   MAX(tax_amount::NUMERIC) AS max_tax_amount
FROM staging.orders_raw;

-- Total Amount Statistics
SELECT MIN(total_amount::NUMERIC) AS min_total_amount,
	   AVG(total_amount::NUMERIC) AS avg_total_amount,
	   MAX(total_amount::NUMERIC) AS max_total_amount
FROM staging.orders_raw;

-- Orders by Month
SELECT DATE_TRUNC('month', order_date::DATE) AS order_month,
	   COUNT(*) AS total_orders
FROM staging.orders_raw
GROUP BY order_month
ORDER BY total_orders DESC;

-- Orders by Customer and Order Status
SELECT order_status,
	   customer_id,
	   COUNT(*) AS total_orders
FROM staging.orders_raw
GROUP BY order_status,
		 customer_id
ORDER BY total_orders DESC;


/*--------------------------------------------------------------
 Order Items
--------------------------------------------------------------*/


-- Total Order Item Records
SELECT COUNT(*) AS total_order_items
FROM staging.order_items_raw;

-- Distinct Order Item IDs
SELECT COUNT(DISTINCT(order_item_id)) AS total_distinct_order_items
FROM staging.order_items_raw;

-- Distinct Order IDs
SELECT COUNT(DISTINCT(order_id)) AS total_distinct_order_ids
FROM staging.order_items_raw;

-- Distinct Product IDs
SELECT COUNT(DISTINCT(product_id)) AS total_distinct_product_ids
FROM staging.order_items_raw;

-- Item Status Distribution
SELECT item_status,
	   COUNT(*) AS total_order_items
FROM staging.order_items_raw
GROUP BY item_status
ORDER BY total_order_items DESC;

-- Quantity Statistics
/* Not executed because quantity contains non-numeric text values.
SELECT MIN(quantity::INT) AS min_quantity,
	   AVG(quantity::INT) AS avg_quantity,
	   MAX(quantity::INT) AS max_quantity
FROM staging.order_items_raw; */

-- Unit Price Statistics
SELECT MIN(unit_price::NUMERIC) AS min_unit_price,
	   AVG(unit_price::NUMERIC) AS avg_unit_price,
	   MAX(unit_price::NUMERIC) AS max_unit_price
FROM staging.order_items_raw;

-- MRP Statistics
SELECT MIN(mrp::NUMERIC) AS min_mrp,
	   AVG(mrp::NUMERIC) AS avg_mrp,
	   MAX(mrp::NUMERIC) AS max_mrp
FROM staging.order_items_raw;

-- Discount Amount Statistics
SELECT MIN(NULLIF(discount_amount, 'NULL')::NUMERIC) AS min_discount_amount,
	   AVG(NULLIF(discount_amount, 'NULL')::NUMERIC) AS avg_discount_amount,
	   MAX(NULLIF(discount_amount, 'NULL')::NUMERIC) AS max_discount_amount
FROM staging.order_items_raw;

-- Discount Percent Statistics
SELECT MIN(NULLIF(discount_percent, 'NULL')::NUMERIC) AS min_discount_percent,
	   AVG(NULLIF(discount_percent, 'NULL')::NUMERIC) AS avg_discount_percent,
	   MAX(NULLIF(discount_percent, 'NULL')::NUMERIC) AS max_discount_percent
FROM staging.order_items_raw;

-- Tax Amount Statistics
SELECT MIN(tax_amount::NUMERIC) AS min_tax_amount,
	   AVG(tax_amount::NUMERIC) AS avg_tax_amount,
	   MAX(tax_amount::NUMERIC) AS max_tax_amount
FROM staging.order_items_raw;

-- Item Revenue Statistics
SELECT MIN(item_revenue::NUMERIC) AS min_item_revenue,
	   AVG(item_revenue::NUMERIC) AS avg_item_revenue,
	   MAX(item_revenue::NUMERIC) AS max_item_revenue
FROM staging.order_items_raw;

-- Unit Cost Statistics
SELECT MIN(unit_cost::NUMERIC) AS min_cost_price,
	   AVG(unit_cost::NUMERIC) AS avg_cost_price,
	   MAX(unit_cost::NUMERIC) AS max_cost_price
FROM staging.order_items_raw;

-- Item Cost Statistics
SELECT MIN(item_cost::NUMERIC) AS min_item_cost,
	   AVG(item_cost::NUMERIC) AS avg_item_cost,
	   MAX(item_cost::NUMERIC) AS max_item_cost
FROM staging.order_items_raw;

-- Gross Profit Statistics
SELECT MIN(gross_profit::NUMERIC) AS min_gross_profit,
	   AVG(gross_profit::NUMERIC) AS avg_gross_profit,
	   MAX(gross_profit::NUMERIC) AS max_gross_profit
FROM staging.order_items_raw;

-- Order Items by Product
SELECT product_id,
	   COUNT(*) AS total_order_items
FROM staging.order_items_raw
GROUP BY product_id
ORDER BY total_order_items DESC;

-- Quantity Sold by Product
/*SELECT product_id,
	   SUM(quantity::INT) AS total_quantity
FROM staging.order_items_raw
GROUP BY product_id
ORDER BY total_quantity DESC;	--quantity column contain text value.*/

-- Revenue by Product
SELECT product_id,
	   SUM(item_revenue::NUMERIC) AS total_revenue
FROM staging.order_items_raw
GROUP BY product_id
ORDER BY total_revenue DESC;

-- Gross Profit by Product
SELECT product_id,
	   SUM(CAST(gross_profit AS NUMERIC)) AS total_gross_profit
FROM staging.order_items_raw
GROUP BY product_id
ORDER BY total_gross_profit DESC;


/*--------------------------------------------------------------
 Sales Targets
--------------------------------------------------------------*/


-- Total Sales Target Records
SELECT COUNT(*) AS total_sales_targets
FROM staging.sales_targets_raw;

-- Distinct Target IDs
SELECT COUNT(DISTINCT(target_id)) AS total_distinct_targets
FROM staging.sales_targets_raw;

-- Distinct Target Months
SELECT COUNT(DISTINCT(target_month)) AS total_distinct_target_months
FROM staging.sales_targets_raw;

-- Distinct Regions
SELECT COUNT(DISTINCT(region)) AS total_distinct_regions
FROM staging.sales_targets_raw;

-- Distinct Category IDs
SELECT COUNT(DISTINCT category_id) AS total_distinct_category_ids
FROM staging.sales_targets_raw;

-- Sales Target Statistics
SELECT MIN(CAST(sales_target AS NUMERIC)) AS min_sales_target,
	   AVG(CAST(sales_target AS NUMERIC)) AS avg_sales_target,
	   MAX(CAST(sales_target AS NUMERIC)) AS max_sales_target
FROM staging.sales_targets_raw;

-- Order Target Statistics
SELECT MIN(CAST(order_target AS NUMERIC)) AS min_order_target,
	   AVG(CAST(order_target AS NUMERIC)) AS avg_order_target,
	   MAX(CAST(order_target AS NUMERIC)) AS max_order_target
FROM staging.sales_targets_raw;

-- Unit Target Statistics
SELECT MIN(CAST(unit_target AS NUMERIC)) AS min_unit_target,
	   AVG(CAST(unit_target AS NUMERIC)) AS avg_unit_target,
	   MAX(CAST(unit_target AS NUMERIC)) AS max_unit_target
FROM staging.sales_targets_raw;

-- Sales Targets by Month
SELECT target_month,
	   SUM(sales_target::NUMERIC) AS total_sales_target
FROM staging.sales_targets_raw
GROUP BY target_month
ORDER BY total_sales_target DESC;

-- Sales Targets by Region
SELECT region,
	   SUM(sales_target::NUMERIC) AS total_sales_target
FROM staging.sales_targets_raw
GROUP BY region
ORDER BY total_sales_target DESC;

-- Sales Targets by Category
SELECT category_id,
	   SUM(sales_target::NUMERIC) AS total_sales_target
FROM staging.sales_targets_raw
GROUP BY category_id
ORDER BY total_sales_target DESC;

-- Sales Targets by Month and Region
SELECT target_month,
	   region,
	   SUM(sales_target::NUMERIC) AS total_sales_target
FROM staging.sales_targets_raw
GROUP BY target_month,
		 region
ORDER BY total_sales_target DESC;

-- Sales Targets by Month and Category
SELECT target_month,
	   category_id,
	   SUM(sales_target::NUMERIC) AS total_sales_target
FROM staging.sales_targets_raw
GROUP BY target_month,
		 category_id
ORDER BY total_sales_target DESC;



/*==============================================================
 Procurement Data - Profiling
==============================================================*/

/*--------------------------------------------------------------
 Purchase Orders
--------------------------------------------------------------*/


-- Total Purchase Order Records
SELECT COUNT(*) AS total_purchase_orders
FROM staging.purchase_orders_raw;

-- Distinct Purchase Order IDs
SELECT COUNT(DISTINCT purchase_order_id) AS total_distinct_purchase_orders
FROM staging.purchase_orders_raw;

-- Distinct Supplier IDs
SELECT COUNT(DISTINCT supplier_id) AS total_distinct_supplier_ids
FROM staging.purchase_orders_raw;

-- Distinct Warehouse IDs
SELECT COUNT(DISTINCT warehouse_id) AS total_distinct_warehouse_ids
FROM staging.purchase_orders_raw;

-- Purchase Order Status Distribution
SELECT status,
	   COUNT(*) AS total_purchase_orders
FROM staging.purchase_orders_raw
GROUP BY status
ORDER BY total_purchase_orders DESC;

-- Purchase Order Date Range
SELECT MIN(order_date::DATE) AS min_order_date,
	   MAX(order_date::DATE) AS max_order_date
FROM staging.purchase_orders_raw;

-- Expected Date Range
SELECT MIN(expected_date::DATE) AS min_expected_date,
	   MAX(expected_date::DATE) AS max_expected_date
FROM staging.purchase_orders_raw;

-- Received Date Range
SELECT MIN(NULLIF(received_date, 'NULL')::DATE) AS min_received_date,
	   MAX(NULLIF(received_date, 'NULL')::DATE) AS max_received_date
FROM staging.purchase_orders_raw;

-- Purchase Order Amount Statistics
SELECT MIN(total_amount::NUMERIC) AS min_order_amount,
	   AVG(total_amount::NUMERIC) AS avg_order_amount,
	   MAX(total_amount::NUMERIC) AS max_order_amount
FROM staging.purchase_orders_raw;

-- Purchase Orders by Supplier
SELECT supplier_id,
	   COUNT(*) AS total_orders
FROM staging.purchase_orders_raw
GROUP BY supplier_id
ORDER BY total_orders DESC;

-- Purchase Orders by Warehouse
SELECT warehouse_id,
	   COUNT(*) AS total_orders
FROM staging.purchase_orders_raw
GROUP BY warehouse_id
ORDER BY total_orders DESC;

-- Purchase Orders by Supplier and Status
SELECT supplier_id,
	   status,
	   COUNT(*) AS total_orders
FROM staging.purchase_orders_raw
GROUP BY supplier_id,
		 status
ORDER BY total_orders DESC;

-- Purchase Orders by Month
SELECT DATE_TRUNC('month', order_date::DATE) AS order_month,
	   COUNT(*) AS total_orders
FROM staging.purchase_orders_raw
GROUP BY order_month
ORDER BY total_orders DESC;


/*--------------------------------------------------------------
 Purchase Order Items
--------------------------------------------------------------*/


-- Total Purchase Order Item Records
SELECT COUNT(*) AS total_purchase_order_items
FROM staging.purchase_order_items_raw;

-- Distinct Purchase Order Item IDs
SELECT COUNT(DISTINCT purchase_order_item_id) AS total_distinct_purchase_order_items
FROM staging.purchase_order_items_raw;

-- Distinct Purchase Order IDs
SELECT COUNT(DISTINCT(purchase_order_id)) AS total_distinct_purchase_orders
FROM staging.purchase_order_items_raw;

-- Distinct Product IDs
SELECT COUNT(DISTINCT product_id) AS total_distinct_product_ids
FROM staging.purchase_order_items_raw;

-- Quantity Ordered Statistics
SELECT MIN(quantity_ordered::INT) AS min_quantity_ordered,
	   AVG(quantity_ordered::INT) AS avg_quantity_ordered,
	   MAX(quantity_ordered::INT) AS max_quantity_ordered
FROM staging.purchase_order_items_raw;

-- Quantity Received Statistics
SELECT MIN(quantity_received::INT) AS min_quantity_received,
	   AVG(quantity_received::INT) AS avg_quantity_received,
	   MAX(quantity_received::INT) AS max_quantity_received
FROM staging.purchase_order_items_raw;

-- Unit Cost Statistics
SELECT MIN(unit_cost::NUMERIC) AS min_unit_cost,
	   AVG(unit_cost::NUMERIC) AS avg_unit_cost,
	   MAX(unit_cost::NUMERIC) AS max_unit_cost
FROM staging.purchase_order_items_raw;

-- Defect Quantity Statistics
/* defect_quantity column contains text values
SELECT MIN(defect_quantity::INT) AS min_defect_quantity,
	   AVG(defect_quantity::INT) AS avg_defect_quantity,
	   MAX(defect_quantity::INT) AS max_defect_quantity
FROM staging.purchase_order_items_raw; */

-- Purchase Order Items by Product
SELECT product_id,
	   COUNT(*) AS total_purchase_order_items
FROM staging.purchase_order_items_raw
GROUP BY product_id
ORDER BY total_purchase_order_items DESC;

-- Purchase Order Items by Purchase Order
SELECT purchase_order_id,
	   COUNT(*) AS total_purchase_order_items
FROM staging.purchase_order_items_raw
GROUP BY purchase_order_id
ORDER BY total_purchase_order_items DESC;

-- Quantity Ordered by Product
SELECT product_id,
	   SUM(quantity_ordered::INT) AS total_quantity_ordered
FROM staging.purchase_order_items_raw
GROUP BY product_id
ORDER BY total_quantity_ordered DESC;

-- Quantity Received by Product
SELECT product_id,
	   SUM(quantity_received::INT) AS total_quantity_received
FROM staging.purchase_order_items_raw
GROUP BY product_id
ORDER BY total_quantity_received DESC;

-- Defect Quantity by Product
/* defect_quantity column contains text values
SELECT product_id,
	   SUM(defect_quantity::INT) AS total_defect_quantity
FROM staging.purchase_order_items_raw
GROUP BY product_id
ORDER BY total_defect_quantity DESC; */

-- Purchase Order Items by Product and Purchase Order
SELECT purchase_order_id,
   	   product_id,
	   COUNT(*) AS total_purchase_order_items
FROM staging.purchase_order_items_raw
GROUP BY purchase_order_id,
		 product_id
ORDER BY total_purchase_order_items DESC;



/*==============================================================
 Marketing Data - Profiling
==============================================================*/

/*--------------------------------------------------------------
 Campaigns
--------------------------------------------------------------*/


-- Total Campaign Records
SELECT COUNT(*) AS total_campaigns
FROM staging.campaigns_raw;

-- Distinct Campaign IDs
SELECT COUNT(DISTINCT(campaign_id)) AS total_distinct_campaign_ids
FROM staging.campaigns_raw;

-- Campaign Type Distribution
SELECT campaign_type,
	   COUNT(*) AS total_campaigns
FROM staging.campaigns_raw
GROUP BY campaign_type
ORDER BY total_campaigns DESC;

-- Campaign Channel Distribution
SELECT channel,
	   COUNT(*) AS total_campaigns
FROM staging.campaigns_raw
GROUP BY channel
ORDER BY total_campaigns DESC;

-- Target Segment Distribution
SELECT target_segment,
	   COUNT(*) AS total_campaigns
FROM staging.campaigns_raw
GROUP BY target_segment
ORDER BY total_campaigns DESC;

-- Campaign Status Distribution
SELECT status,
	   COUNT(*) AS total_campaigns
FROM staging.campaigns_raw
GROUP BY status
ORDER BY total_campaigns DESC;

-- Campaigns by Type and Channel
SELECT campaign_type,
	   channel,
	   COUNT(*) AS total_campaigns
FROM staging.campaigns_raw
GROUP BY campaign_type,
		 channel
ORDER BY total_campaigns DESC;

-- Campaigns by Channel and Status
SELECT channel,
	   status,
	   COUNT(*) AS total_campaigns
FROM staging.campaigns_raw
GROUP BY channel,
		 status
ORDER BY total_campaigns DESC;

-- Campaign Start Date Range
SELECT MIN(CAST(start_date AS DATE)) AS min_start_date,
	   MAX(CAST(start_date AS DATE)) AS max_start_date
FROM staging.campaigns_raw;

-- Campaign End Date Range
SELECT MIN(CAST(end_date AS DATE)) AS min_end_date,
	   MAX(CAST(end_date AS DATE)) AS max_end_date
FROM staging.campaigns_raw;

-- Campaign Duration
SELECT
	MIN((end_date::DATE)-(start_date::DATE)) AS min_campaign_duration,
	AVG((end_date::DATE)-(start_date::DATE)) AS avg_campaign_duration,
	MAX((end_date::DATE)-(start_date::DATE)) AS max_campaign_duration
FROM staging.campaigns_raw;

-- Campaign Budget Statistics
SELECT MIN(budget::NUMERIC) AS min_budget,
	   AVG(budget::NUMERIC) AS avg_budget,
	   MAX(budget::NUMERIC) AS max_budget
FROM staging.campaigns_raw;

-- Campaign Actual Spend Statistics
SELECT MIN(actual_spend::NUMERIC) AS min_actual_spend,
	   AVG(actual_spend::NUMERIC) AS avg_actual_spend,
	   MAX(actual_spend::NUMERIC) AS max_actual_spend
FROM staging.campaigns_raw;

-- Budget and Actual Spend by Campaign Type
SELECT campaign_type,
	   SUM(budget::NUMERIC) AS total_budget,
	   SUM(actual_spend::NUMERIC) AS total_actual_spend
FROM staging.campaigns_raw
GROUP BY campaign_type;

-- Campaigns by Target Segment and Status
SELECT target_segment,
       status,
       COUNT(*) AS total_campaigns
FROM staging.campaigns_raw
GROUP BY target_segment,
         status
ORDER BY total_campaigns DESC;


/*--------------------------------------------------------------
 Coupons
--------------------------------------------------------------*/


-- Total Coupon Records
SELECT COUNT(*) AS total_coupons
FROM staging.coupons_raw;

-- Distinct Coupon IDs
SELECT COUNT(DISTINCT(coupon_id)) AS total_distinct_coupon_ids
FROM staging.coupons_raw;

-- Distinct Coupon Codes
SELECT COUNT(DISTINCT(coupon_code)) AS total_distinct_coupon_codes
FROM staging.coupons_raw;

-- Discount Type Distribution
SELECT discount_type,
	   COUNT(*) AS total_coupons
FROM staging.coupons_raw
GROUP BY discount_type
ORDER BY total_coupons DESC;

-- Coupon Status Distribution
SELECT status,
	   COUNT(*) AS total_coupons
FROM staging.coupons_raw
GROUP BY status
ORDER BY total_coupons DESC;

-- Coupon Start Date Range
SELECT MIN(CAST(start_date AS DATE)) AS min_start_date,
	   MAX(CAST(start_date AS DATE)) AS max_start_date
FROM staging.coupons_raw;

-- Coupon End Date Range
SELECT MIN(CAST(end_date AS DATE)) AS min_end_date,
	   MAX(CAST(end_date AS DATE)) AS max_end_date
FROM staging.coupons_raw;

-- Discount Value Statistics
SELECT MIN(discount_value::NUMERIC) AS min_discount_value,
	   AVG(discount_value::NUMERIC) AS avg_discount_value,
	   MAX(discount_value::NUMERIC) AS max_discount_value
FROM staging.coupons_raw;

-- Minimum Order Value Statistics
SELECT MIN(minimum_order_value::NUMERIC) AS min_minimum_order_value,
	   AVG(minimum_order_value::NUMERIC) AS avg_minimum_order_value,
	   MAX(minimum_order_value::NUMERIC) AS max_minimum_order_value
FROM staging.coupons_raw;

-- Maximum Discount Statistics
SELECT MIN(maximum_discount::NUMERIC) AS min_maximum_discount,
	   AVG(maximum_discount::NUMERIC) AS avg_maximum_discount,
	   MAX(maximum_discount::NUMERIC) AS max_maximum_discount
FROM staging.coupons_raw;

-- Usage Limit Statistics
SELECT MIN(usage_limit::INT) AS min_usage_limit,
	   AVG(usage_limit::INT) AS avg_usage_limit,
	   MAX(usage_limit::INT) AS max_usage_limit
FROM staging.coupons_raw;

-- Coupons by Discount Type and Status
SELECT status,
	   discount_type,
	   COUNT(*) AS total_coupons
FROM staging.coupons_raw
GROUP BY status,
		 discount_type
ORDER BY total_coupons DESC;

-- Coupon Duration
SELECT 
	MIN(end_date::DATE - start_date::DATE) AS min_coupon_duration,
	AVG(end_date::DATE - start_date::DATE) AS avg_coupon_duration,
	MAX(end_date::DATE - start_date::DATE) AS max_coupon_duration
FROM staging.coupons_raw;





/*==============================================================
 DATA PROFILING COMPLETE
==============================================================

 The staging data has been profiled for structure, completeness,
 uniqueness, and basic data quality.

 Next Step:
 Validate the profiled data using the domain-specific
 validation scripts.

==============================================================*/
