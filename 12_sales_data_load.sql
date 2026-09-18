/*==============================================================
 Project     : E-Commerce Analytics Database
 Database    : PostgreSQL
 Module      : 12 - Sales Data Load
 Description : Clean, transform, and load the validated staging
               sales data into the final sales tables.
 Author      : Anurag Dwivedi
==============================================================*/



BEGIN;
/*--------------------------------------------------------------
 Orders
--------------------------------------------------------------*/

INSERT INTO sales.orders (
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
	confirmed_at,
	packed_at,
	updated_at)
SELECT
	UPPER(TRIM(order_id)),
	UPPER(TRIM(customer_id)),
	CAST(order_date AS DATE),
	INITCAP(TRIM(order_status)),
	INITCAP(TRIM(sales_channel)),
	UPPER(TRIM(warehouse_id)),
	TRIM(shipping_address),
	TRIM(billing_address),
	NULLIF(UPPER(TRIM(coupon_id)), 'NULL'),
	NULLIF(UPPER(TRIM(campaign_id)), 'NULL'),
	CAST(subtotal AS NUMERIC),
	CAST(discount_amount AS NUMERIC),
	CAST(shipping_fee AS NUMERIC),
	CAST(tax_amount AS NUMERIC),
	CAST(total_amount AS NUMERIC),
	NULLIF(INITCAP(TRIM(payment_status)), 'Null'),
	INITCAP(TRIM(fulfillment_status)),
	CAST(expected_delivery_date AS DATE),
	CAST(NULLIF(cancellation_date, 'NULL') AS DATE),
	NULLIF(INITCAP(TRIM(cancellation_reason)), 'NULL'),
	CAST(created_at AS TIMESTAMP),
	CAST(NULLIF(confirmed_at, 'NULL') AS TIMESTAMP),
	CAST(NULLIF(packed_at, 'NULL') AS TIMESTAMP),
	CAST(updated_at AS TIMESTAMP)
FROM staging.orders_raw
ON CONFLICT (order_id) DO NOTHING;



/*--------------------------------------------------------------
 Order Items
--------------------------------------------------------------*/

INSERT INTO sales.order_items (
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
SELECT
	UPPER(TRIM(order_item_id)),
	UPPER(TRIM(order_id)),
	UPPER(TRIM(product_id)),
	CASE LOWER(quantity)
		WHEN 'one' THEN 1
		ELSE CAST(quantity AS INT)
	END AS quantity,
	CAST(unit_price AS NUMERIC),
	CAST(mrp AS NUMERIC),
	CAST(NULLIF(discount_amount, 'NULL') AS NUMERIC),
	CAST(NULLIF(discount_percent, 'NULL') AS NUMERIC),
	CAST(tax_amount AS NUMERIC),
	CAST(item_revenue AS NUMERIC),
	CAST(unit_cost AS NUMERIC),
	CAST(item_cost AS NUMERIC),
	CAST(gross_profit AS NUMERIC),
	INITCAP(TRIM(item_status))
FROM staging.order_items_raw;



/*--------------------------------------------------------------
 Sales Targets
--------------------------------------------------------------*/

INSERT INTO sales.sales_targets (
	target_id,
	target_month,
	region,
	category_id,
	order_target,
	unit_target,
	sales_target)
SELECT
	UPPER(TRIM(target_id)),
	CAST(target_month AS DATE),
	CASE region
		WHEN 'S' THEN 'South'
		WHEN 'C' THEN 'Central'
		ELSE INITCAP(TRIM(region))
	END AS region,
	UPPER(TRIM(category_id)),
	CAST(order_target AS INT),
	CAST(unit_target AS INT),
	CAST(sales_target AS NUMERIC)
FROM staging.sales_targets_raw;



-- ROLLBACK;
-- COMMIT;

/*==============================================================
 SALES DATA LOAD COMPLETE
==============================================================

 The validated staging sales data has been cleaned, transformed,
 and loaded into the corresponding final sales tables.

==============================================================*/
