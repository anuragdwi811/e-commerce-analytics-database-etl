/*==============================================================
 Project     : E-Commerce Analytics Database
 Database    : PostgreSQL
 Module      : 10 - Final Table Creation
 Description : Create the final analysis-ready tables with
               appropriate data types, constraints, primary keys,
               foreign keys, and relational integrity.
 Author      : Anurag Dwivedi
==============================================================*/



/*==============================================================
 Marketing Data
==============================================================*/

/*--------------------------------------------------------------
 Campaigns
--------------------------------------------------------------*/

CREATE TABLE IF NOT EXISTS marketing.campaigns (
	campaign_id VARCHAR(10) PRIMARY KEY,
	campaign_name VARCHAR(250) NOT NULL,
	campaign_type VARCHAR(50) CHECK (campaign_type IN 
									('Acquisition', 'Seasonal', 'Retention', 'Promotional', 'Product Launch')),
	channel VARCHAR(50) CHECK (channel IN 
									('Meta Ads', 'Influencer', 'Google Ads', 'Email', 'Push Notification', 'Youtube')),
	start_date DATE NOT NULL,
	end_date DATE NOT NULL,
	budget NUMERIC(10,2) CHECK (budget >= 0),
	actual_spend NUMERIC(10,2) CHECK (actual_spend >= 0),
	target_segment VARCHAR(50) CHECK (target_segment IN ('VIP Customers', 'Inactive Customers', 'Premium Customers', 
							  'New Customers', 'Regular Customers', 'Lapsed Customers', 'All Customers')),
	status VARCHAR(50) NOT NULL,
	
	CONSTRAINT chk_campaign_dates CHECK (start_date <= end_date));

	
/*--------------------------------------------------------------
 Coupons
--------------------------------------------------------------*/

CREATE TABLE IF NOT EXISTS marketing.coupons (
	coupon_id VARCHAR(10) PRIMARY KEY,
	coupon_code VARCHAR(50) NOT NULL,
	discount_type VARCHAR(50) CHECK (discount_type IN ('Percentage', 'Fixed Amount')),
	discount_value NUMERIC(10,2) CHECK (discount_value >= 0),
	minimum_order_value NUMERIC(10,2) CHECK (minimum_order_value >= 0),
	maximum_discount NUMERIC(10,2) CHECK (maximum_discount >= 0),
	start_date DATE NOT NULL,
	end_date DATE NOT NULL,
	usage_limit INT NOT NULL CHECK (usage_limit >= 0),
	status VARCHAR(50) NOT NULL,
	
	CONSTRAINT chk_coupon_dates CHECK (start_date <= end_date));



/*==============================================================
 Master Data
==============================================================*/

/*--------------------------------------------------------------
 Customers
--------------------------------------------------------------*/

CREATE TABLE IF NOT EXISTS master.customers (
	customer_id VARCHAR(10) PRIMARY KEY,
	first_name VARCHAR(100) NOT NULL,
	last_name VARCHAR(100) NOT NULL,
	gender VARCHAR(10) CHECK (gender IN('Male', 'Female', 'Other')),
	date_of_birth DATE NOT NULL,
	email VARCHAR(250) UNIQUE NOT NULL,
	phone CHAR(10) UNIQUE NOT NULL,
	city VARCHAR(150) NOT NULL,
	state VARCHAR(150) NOT NULL,
	region VARCHAR(10) CHECK (region IN('South', 'North', 'West', 'East', 'Central')),
	country VARCHAR(10) CHECK (country IN('India')),
	pincode CHAR(6) NOT NULL,
	registration_date DATE NOT NULL,
	customer_type VARCHAR(10) CHECK(customer_type IN('Regular', 'Corporate', 'Premium', 'VIP')),
	customer_segment VARCHAR(10) CHECK(customer_segment IN('Priority', 'Business', 'Retail', 'Private', 'Premium')),
	acquisition_channel VARCHAR(20) CHECK(acquisition_channel IN
								('YouTube', 'Influencer', 'Meta Ads', 'Email', 'Google Ads', 'Push Notification')),
	acquisition_campaign_id VARCHAR(10),
	customer_status VARCHAR(10) CHECK(customer_status IN('Suspended', 'Active', 'Blocked', 'Inactive')),
	created_at TIMESTAMP NOT NULL,
	updated_at TIMESTAMP NOT NULL,
	
	CONSTRAINT fk_customer_acquisition_campaign
        FOREIGN KEY (acquisition_campaign_id) REFERENCES marketing.campaigns(campaign_id));


/*--------------------------------------------------------------
 Categories
--------------------------------------------------------------*/

CREATE TABLE IF NOT EXISTS master.categories (
	category_id VARCHAR(10) PRIMARY KEY,
	category_name VARCHAR(150) NOT NULL,
	department VARCHAR(100) NOT NULL,
	category_status VARCHAR(20) NOT NULL);


/*--------------------------------------------------------------
 Subcategories
--------------------------------------------------------------*/

CREATE TABLE IF NOT EXISTS master.subcategories (
	subcategory_id VARCHAR(10) PRIMARY KEY,
	category_id VARCHAR(10) NOT NULL,
	subcategory_name VARCHAR(150) NOT NULL,
	subcategory_status VARCHAR(20) NOT NULL,
	
	CONSTRAINT fk_subcategory_category_id
    FOREIGN KEY (category_id) REFERENCES master.categories(category_id));

	
/*--------------------------------------------------------------
 Suppliers
--------------------------------------------------------------*/

CREATE TABLE IF NOT EXISTS master.suppliers (
	supplier_id VARCHAR(10) PRIMARY KEY,
	supplier_name VARCHAR(250) NOT NULL,
	supplier_type VARCHAR(100) CHECK (supplier_type IN
								('Wholesaler', 'Brand Partner', 'Distributor', 'Manufacturer', 'Importer')),
	city VARCHAR(100) NOT NULL,
	state VARCHAR(100) NOT NULL,
	region VARCHAR(10) CHECK (region IN('South', 'Central', 'North', 'West', 'East')),
	rating NUMERIC(2,1) NOT NULL,
	payment_terms VARCHAR(20) CHECK (payment_terms IN('Net 15', 'Net 30', 'Net 45', 'Net 60', 'Advance')),
	lead_time_days INT NOT NULL,
	supplier_status VARCHAR(20) NOT NULL);


/*--------------------------------------------------------------
 Products
--------------------------------------------------------------*/

CREATE TABLE IF NOT EXISTS master.products (
	product_id VARCHAR(10) PRIMARY KEY,
	product_name VARCHAR(250) NOT NULL,
	category_id VARCHAR(10) NOT NULL,
	subcategory_id VARCHAR(10) NOT NULL,
	brand VARCHAR(100) NOT NULL,
	supplier_id VARCHAR(10) NOT NULL,
	unit_cost NUMERIC(10,2) CHECK (unit_cost > 0),
	selling_price NUMERIC(10,2) CHECK (selling_price > 0),
	mrp NUMERIC(10,2) CHECK (mrp > 0),
	launch_date DATE NOT NULL,
	product_status VARCHAR(20) NOT NULL,
	weight_kg NUMERIC(10,3) CHECK (weight_kg > 0),
	rating NUMERIC(2,1) NOT NULL,

	CONSTRAINT fk_product_category
        FOREIGN KEY (category_id) REFERENCES master.categories(category_id),

	CONSTRAINT fk_product_subcategory
        FOREIGN KEY (subcategory_id) REFERENCES master.subcategories(subcategory_id),

	CONSTRAINT fk_product_supplier
        FOREIGN KEY (supplier_id) REFERENCES master.suppliers(supplier_id));

	
/*--------------------------------------------------------------
 Warehouses
--------------------------------------------------------------*/

CREATE TABLE IF NOT EXISTS master.warehouses (
	warehouse_id VARCHAR(10) PRIMARY KEY,
	warehouse_name VARCHAR(250) NOT NULL,
	city VARCHAR(100) NOT NULL,
	state VARCHAR(100) NOT NULL,
	region VARCHAR(20) NOT NULL,
	capacity NUMERIC(10,2) NOT NULL,
	warehouse_type VARCHAR(100) CHECK (warehouse_type IN('Regional', 'Distribution', 'Fulfillment', 'Hub')),
	opening_date DATE NOT NULL,
	status VARCHAR(50) NOT NULL);
	

/*--------------------------------------------------------------
 Couriers
--------------------------------------------------------------*/

CREATE TABLE IF NOT EXISTS master.couriers (
	courier_id VARCHAR(10) PRIMARY KEY,
	courier_name VARCHAR(200) NOT NULL,
	service_type VARCHAR(20) CHECK (service_type IN
								('Standard', 'Next Day', 'Express', 'Economy', 'Same Day', 'Premium')),
	rating NUMERIC(2,1) NOT NULL,
	status VARCHAR(20) NOT NULL);
	

/*==============================================================
 Sales Data
==============================================================*/

/*--------------------------------------------------------------
 Orders
--------------------------------------------------------------*/

CREATE TABLE IF NOT EXISTS sales.orders (
	order_id VARCHAR(10) PRIMARY KEY,
	customer_id VARCHAR(10) NOT NULL,
	order_date DATE NOT NULL,
	order_status VARCHAR(20) CHECK (order_status IN('Delivered', 'Shipped', 'Processing', 'Cancelled', 'Confirmed')),
	sales_channel VARCHAR(20) CHECK (sales_channel IN('Marketplace', 'Mobile App', 'Website')),
	warehouse_id VARCHAR(10) NOT NULL,
	shipping_address TEXT NOT NULL,
	billing_address TEXT NOT NULL,
	coupon_id VARCHAR(10),
	campaign_id VARCHAR(10),
	subtotal NUMERIC(10,2) CHECK (subtotal >= 0),
	discount_amount NUMERIC(10,2) CHECK (discount_amount >= 0),
	shipping_fee NUMERIC(10,2) CHECK (shipping_fee >= 0),
	tax_amount NUMERIC(10,2) CHECK (tax_amount >= 0),
	total_amount NUMERIC(10,2) CHECK (total_amount >= 0),
	payment_status VARCHAR(20) CHECK (payment_status IN('Paid', 'Pending')),
	fulfillment_status VARCHAR(20) CHECK (fulfillment_status IN
										('Unfulfilled', 'Processing', 'Cancelled', 'Fulfilled')),
	expected_delivery_date DATE NOT NULL,
	cancellation_date DATE,
	cancellation_reason VARCHAR(250),
	created_at TIMESTAMP NOT NULL,
	confirmed_at TIMESTAMP,
	packed_at TIMESTAMP,	
	updated_at TIMESTAMP NOT NULL,

	CONSTRAINT fk_orders_customer_id
		FOREIGN KEY (customer_id) REFERENCES master.customers(customer_id),

	CONSTRAINT fk_orders_warehouse_id
		FOREIGN KEY (warehouse_id) REFERENCES master.warehouses(warehouse_id),

	CONSTRAINT fk_orders_coupon_id
		FOREIGN KEY (coupon_id) REFERENCES marketing.coupons(coupon_id),

	CONSTRAINT fk_orders_campaign_id
		FOREIGN KEY (campaign_id) REFERENCES marketing.campaigns(campaign_id));



/*--------------------------------------------------------------
 Order Items
--------------------------------------------------------------*/

CREATE TABLE IF NOT EXISTS sales.order_items (
	order_item_id VARCHAR(10) PRIMARY KEY,
	order_id VARCHAR(10) NOT NULL,
	product_id VARCHAR(10) NOT NULL,
	quantity INT NOT NULL CHECK (quantity > 0),
	unit_price NUMERIC(10,2) NOT NULL CHECK (unit_price > 0),
	mrp NUMERIC(10,2) NOT NULL CHECK (mrp > 0),
	discount_amount NUMERIC(10,2),
	discount_percent NUMERIC(10,2),
	tax_amount NUMERIC(10,2),
	item_revenue NUMERIC(10,2) NOT NULL,
	unit_cost NUMERIC(10,2) NOT NULL CHECK (unit_cost > 0),
	item_cost NUMERIC(10,2) NOT NULL CHECK (item_cost > 0),
	gross_profit NUMERIC(10,2) NOT NULL,
	item_status VARCHAR(20) NOT NULL,
	
	CONSTRAINT fk_order_items_order_id
		FOREIGN KEY (order_id) REFERENCES sales.orders(order_id),

	CONSTRAINT fk_order_items_product_id
		FOREIGN KEY (product_id) REFERENCES master.products(product_id));


	
/*--------------------------------------------------------------
 Sales Targets
--------------------------------------------------------------*/

CREATE TABLE IF NOT EXISTS sales.sales_targets (
	target_id VARCHAR(10) PRIMARY KEY,
	target_month DATE NOT NULL,
	region VARCHAR(20) CHECK (region IN ('South', 'Central', 'West', 'North', 'East')),
	category_id VARCHAR(10) NOT NULL,
	order_target INT NOT NULL CHECK (order_target > 0),
	unit_target INT NOT NULL CHECK (unit_target > 0),
	sales_target NUMERIC(10,2) NOT NULL CHECK (sales_target > 0),
	
	CONSTRAINT fk_sales_targets_category_id
		FOREIGN KEY (category_id) REFERENCES master.categories(category_id));



/*==============================================================
 Procurement Data
==============================================================*/

/*--------------------------------------------------------------
 Purchase Orders
--------------------------------------------------------------*/

CREATE TABLE IF NOT EXISTS procurement.purchase_orders (
	purchase_order_id VARCHAR(10) PRIMARY KEY,
	supplier_id VARCHAR(10) NOT NULL,
	warehouse_id VARCHAR(10) NOT NULL,
	order_date DATE NOT NULL,
	expected_date DATE NOT NULL,
	received_date DATE,
	status VARCHAR(50) CHECK(status IN('Received', 'Cancelled', 'Pending', 'Partially Received')),
	total_amount NUMERIC(10,2) CHECK (total_amount > 0),
	
	CONSTRAINT fk_purchase_orders_supplier_id
		FOREIGN KEY (supplier_id) REFERENCES master.suppliers(supplier_id),
		
	CONSTRAINT fk_purchase_orders_warehouse_id
		FOREIGN KEY (warehouse_id) REFERENCES master.warehouses(warehouse_id));
	
	
/*--------------------------------------------------------------
 Purchase Order Items
--------------------------------------------------------------*/

CREATE TABLE IF NOT EXISTS procurement.purchase_order_items (
	purchase_order_item_id VARCHAR(10) PRIMARY KEY,
	purchase_order_id VARCHAR(10) NOT NULL,
	product_id VARCHAR(10) NOT NULL,
	quantity_ordered INT NOT NULL CHECK (quantity_ordered > 0),
	quantity_received INT,
	unit_cost NUMERIC(10,2) CHECK (unit_cost > 0),
	defect_quantity INT,
	
	CONSTRAINT fk_purchase_order_items_purchase_order_id
		FOREIGN KEY (purchase_order_id) REFERENCES procurement.purchase_orders(purchase_order_id),
		
	CONSTRAINT fk_purchase_order_items_product_id
		FOREIGN KEY (product_id) REFERENCES master.products(product_id));
	


/*==============================================================
 FINAL TABLE CREATION COMPLETE
==============================================================

 The final tables have been created with appropriate data types,
 constraints, primary keys, foreign keys, and relational
 integrity.

 Next Step:
 Clean, transform, and load the validated staging data into
 the corresponding final tables.

==============================================================*/
