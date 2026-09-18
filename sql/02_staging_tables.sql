/*==============================================================
 Project     : E-Commerce Analytics Database
 Database    : PostgreSQL
 Module      : 02 - Staging Table Creation
 Description : Create staging tables to store raw data imported
               from the source CSV files.
 Author      : Anurag Dwivedi
==============================================================*/


/*==============================================================
 Master Data - Staging Tables
==============================================================*/

-- Customers Table
CREATE TABLE IF NOT EXISTS staging.customers_raw (
	customer_id TEXT,
	first_name TEXT,
	last_name TEXT,
	gender TEXT,
	date_of_birth TEXT,
	email TEXT,
	phone TEXT,
	city TEXT,
	state TEXT,
	region TEXT,
	country TEXT,
	pincode TEXT,
	registration_date TEXT,
	customer_type TEXT,
	customer_segment TEXT,
	acquisition_channel TEXT,
	acquisition_campaign_id TEXT,
	customer_status TEXT,
	created_at TEXT,
	updated_at TEXT);

-- Categories Table
CREATE TABLE IF NOT EXISTS staging.categories_raw (
	category_id TEXT,
	category_name TEXT,
	department TEXT,
	category_status TEXT);

-- Subcategories Table
CREATE TABLE IF NOT EXISTS staging.subcategories_raw (
	subcategory_id TEXT,
	category_id TEXT,
	subcategory_name TEXT,
	subcategory_status TEXT);

-- Products Table
CREATE TABLE IF NOT EXISTS staging.products_raw (
	product_id TEXT,
	product_name TEXT,
	category_id TEXT,
	subcategory_id TEXT,
	brand TEXT,
	supplier_id TEXT,
	unit_cost TEXT,
	selling_price TEXT,
	mrp TEXT,
	launch_date TEXT,
	product_status TEXT,
	weight_kg TEXT,
	rating TEXT);

-- Suppliers Table
CREATE TABLE IF NOT EXISTS staging.suppliers_raw (
	supplier_id TEXT,
	supplier_name TEXT,
	supplier_type TEXT,
	city TEXT,
	state TEXT,
	region TEXT,
	rating TEXT,
	payment_terms TEXT,
	lead_time_days TEXT,
	supplier_status TEXT);

-- Warehouses Table
CREATE TABLE IF NOT EXISTS staging.warehouses_raw (
	warehouse_id TEXT,
	warehouse_name TEXT,
	city TEXT,
	state TEXT,
	region TEXT,
	capacity TEXT,
	warehouse_type TEXT,
	opening_date TEXT,
	status TEXT);

-- Couriers Table
CREATE TABLE IF NOT EXISTS staging.couriers_raw (
	courier_id TEXT,
	courier_name TEXT,
	service_type TEXT,
	rating TEXT,
	status TEXT);


/*==============================================================
 Sales Data - Staging Tables
==============================================================*/

-- Orders Table
CREATE TABLE IF NOT EXISTS staging.orders_raw (
	order_id TEXT,
	customer_id TEXT,
	order_date TEXT,
	order_status TEXT,
	sales_channel TEXT,
	warehouse_id TEXT,
	shipping_address TEXT,
	billing_address TEXT,
	coupon_id TEXT,
	campaign_id TEXT,
	subtotal TEXT,
	discount_amount TEXT,
	shipping_fee TEXT,
	tax_amount TEXT,
	total_amount TEXT,
	payment_status TEXT,
	fulfillment_status TEXT,
	expected_delivery_date TEXT,
	cancellation_date TEXT,
	cancellation_reason TEXT,
	created_at TEXT,
	updated_at TEXT,
	confirmed_at TEXT,
	packed_at TEXT);

-- Order Items Table
CREATE TABLE IF NOT EXISTS staging.order_items_raw (
	order_item_id TEXT,
	order_id TEXT,
	product_id TEXT,
	quantity TEXT,
	unit_price TEXT,
	mrp TEXT,
	discount_amount TEXT,
	discount_percent TEXT,
	tax_amount TEXT,
	item_revenue TEXT,
	unit_cost TEXT,
	item_cost TEXT,
	gross_profit TEXT,
	item_status TEXT);

-- Sales Targets Table
CREATE TABLE IF NOT EXISTS staging.sales_targets_raw (
	target_id TEXT,
	target_month TEXT,
	region TEXT,
	category_id TEXT,
	order_target TEXT,
	unit_target TEXT,
	sales_target TEXT);


/*==============================================================
 Procurement Data - Staging Tables
==============================================================*/

-- Purchase Orders Table
CREATE TABLE IF NOT EXISTS staging.purchase_orders_raw (
	purchase_order_id TEXT,
	supplier_id TEXT,
	warehouse_id TEXT,
	order_date TEXT,
	expected_date TEXT,
	received_date TEXT,
	status TEXT,
	total_amount TEXT);

-- Purchase Order Items Table
CREATE TABLE IF NOT EXISTS staging.purchase_order_items_raw (
	purchase_order_item_id TEXT,
	purchase_order_id TEXT,
	product_id TEXT,
	quantity_ordered TEXT,
	quantity_received TEXT,
	unit_cost TEXT,
	defect_quantity TEXT);


/*==============================================================
 Marketing Data - Staging Tables
==============================================================*/

-- Campaigns Table
CREATE TABLE IF NOT EXISTS staging.campaigns_raw (
	campaign_id TEXT,
	campaign_name TEXT,
	campaign_type TEXT,
	channel TEXT,
	start_date TEXT,
	end_date TEXT,
	budget TEXT,
	actual_spend TEXT,
	target_segment TEXT,
	status TEXT);

-- Coupons Table
CREATE TABLE IF NOT EXISTS staging.coupons_raw (
	coupon_id TEXT,
	coupon_code TEXT,
	discount_type TEXT,
	discount_value TEXT,
	minimum_order_value TEXT,
	maximum_discount TEXT,
	start_date TEXT,
	end_date TEXT,
	usage_limit TEXT,
	status TEXT);




/*==============================================================
 STAGING TABLE SETUP
==============================================================

 The staging layer contains raw data imported from the source
 CSV files. No cleaning or transformation is applied at this
 stage.

 Next Step:
 Import the source CSV data into the corresponding staging
 tables using 03_csv_import.

==============================================================*/
