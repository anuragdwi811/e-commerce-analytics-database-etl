/*==============================================================
 Project     : E-Commerce Analytics Database
 Database    : PostgreSQL
 Module      : 03 - CSV Data Import
 Description : Import raw data from source CSV files into the
               corresponding staging tables.
 Author      : Anurag Dwivedi
==============================================================*/


BEGIN;
/*==============================================================
 Master Data - CSV Import
==============================================================*/

-- Customers Table
COPY staging.customers_raw (
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
FROM 'D:\Projects\DATA\Ecommerce Dataset\Customers.csv'
WITH (
	FORMAT CSV,
	HEADER TRUE,
	DELIMITER ','
);


-- Categories Table
COPY staging.categories_raw (
	category_id,
	category_name,
	department,
	category_status)
FROM 'D:\Projects\DATA\Ecommerce Dataset\Categories.csv'
WITH (
	FORMAT CSV,
	HEADER TRUE,
	DELIMITER ','
);


-- Subcategories Table
COPY staging.subcategories_raw (
	subcategory_id,
	category_id,
	subcategory_name,
	subcategory_status)
FROM 'D:\Projects\DATA\Ecommerce Dataset\Subcategories.csv'
WITH (
	FORMAT CSV,
	HEADER TRUE,
	DELIMITER ','
);


-- Products Table
COPY staging.products_raw (
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
FROM 'D:\Projects\DATA\Ecommerce Dataset\Products.csv'
WITH (
	FORMAT CSV,
	HEADER TRUE,
	DELIMITER ','
);


-- Suppliers Table
COPY staging.suppliers_raw (
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
FROM 'D:\Projects\DATA\Ecommerce Dataset\Suppliers.csv'
WITH (
	FORMAT CSV,
	HEADER TRUE,
	DELIMITER ','
);


-- Warehouses Table
COPY staging.warehouses_raw (
	warehouse_id,
	warehouse_name,
	city,
	state,
	region,
	capacity,
	warehouse_type,
	opening_date,
	status)
FROM 'D:\Projects\DATA\Ecommerce Dataset\Warehouses.csv'
WITH (
	FORMAT CSV,
	HEADER TRUE,
	DELIMITER ','
);


-- Couriers Table
COPY staging.couriers_raw (
	courier_id,
	courier_name,
	service_type,
	rating,
	status)
FROM 'D:\Projects\DATA\Ecommerce Dataset\Couriers.csv'
WITH (
	FORMAT CSV,
	HEADER TRUE,
	DELIMITER ','
);


/*==============================================================
 Sales Data - CSV Import
==============================================================*/

-- Orders Table
COPY staging.orders_raw (
	order_id,
	customer_id,
	order_date,
	order_status,
	sales_channel,
	warehouse_id,
	shipping_address,
	billing_address,
	coupon_id,
	campaign_id,
	subtotal,
	discount_amount,
	shipping_fee,
	tax_amount,
	total_amount,
	payment_status,
	fulfillment_status,
	expected_delivery_date,
	cancellation_date,
	cancellation_reason,
	created_at,
	updated_at,
	confirmed_at,
	packed_at)
FROM 'D:\Projects\DATA\Ecommerce Dataset\Orders.csv'
WITH (
	FORMAT CSV,
	HEADER TRUE,
	DELIMITER ','
);


-- Order Items Table
COPY staging.order_items_raw (
	order_item_id,
	order_id,
	product_id,
	quantity,
	unit_price,
	mrp,
	discount_amount,
	discount_percent,
	tax_amount,
	item_revenue,
	unit_cost,
	item_cost,
	gross_profit,
	item_status)
FROM 'D:\Projects\DATA\Ecommerce Dataset\Order Items.csv'
WITH (
	FORMAT CSV,
	HEADER TRUE,
	DELIMITER ','
);


-- Sales Targets Table
COPY staging.sales_targets_raw (
	target_id,
	target_month,
	region,
	category_id,
	order_target,
	unit_target,
	sales_target)
FROM 'D:\Projects\DATA\Ecommerce Dataset\Sales Targets.csv'
WITH (
	FORMAT CSV,
	HEADER TRUE,
	DELIMITER ','
);


/*==============================================================
 Procurement Data - CSV Import
==============================================================*/

-- Purchase Orders Table
COPY staging.purchase_orders_raw (
	purchase_order_id,
	supplier_id,
	warehouse_id,
	order_date,
	expected_date,
	received_date,
	status,
	total_amount)
FROM 'D:\Projects\DATA\Ecommerce Dataset\Purchase Orders.csv'
WITH (
	FORMAT CSV,
	HEADER TRUE,
	DELIMITER ','
);


-- Purchase Order Items Table
COPY staging.purchase_order_items_raw (
	purchase_order_item_id,
	purchase_order_id,
	product_id,
	quantity_ordered,
	quantity_received,
	unit_cost,
	defect_quantity)
FROM 'D:\Projects\DATA\Ecommerce Dataset\Purchase Order Items.csv'
WITH (
	FORMAT CSV,
	HEADER TRUE,
	DELIMITER ','
);


/*==============================================================
 Marketing Data - CSV Import
==============================================================*/

-- Campaigns Table
COPY staging.campaigns_raw (
	campaign_id,
	campaign_name,
	campaign_type,
	channel,
	start_date,
	end_date,
	budget,
	actual_spend,
	target_segment,
	status)
FROM 'D:\Projects\DATA\Ecommerce Dataset\Campaigns.csv'
WITH (
	FORMAT CSV,
	HEADER TRUE,
	DELIMITER ','
);


-- Coupons Table
COPY staging.coupons_raw (
	coupon_id,
	coupon_code,
	discount_type,
	discount_value,
	minimum_order_value,
	maximum_discount,
	start_date,
	end_date,
	usage_limit,
	status)
FROM 'D:\Projects\DATA\Ecommerce Dataset\Coupons.csv'
WITH (
	FORMAT CSV,
	HEADER TRUE,
	DELIMITER ','
);


-- ROLLBACK;
-- COMMIT;

/*==============================================================
 CSV IMPORT COMPLETE
==============================================================

 Raw CSV data has been imported into the corresponding
 staging tables.

 Next Step:
 Profile the imported data using 04_data_profiling.

==============================================================*/
