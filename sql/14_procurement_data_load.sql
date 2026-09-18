/*==============================================================
 Project     : E-Commerce Analytics Database
 Database    : PostgreSQL
 Module      : 14 - Procurement Data Load
 Description : Clean, transform, and load the validated staging
               procurement data into the final procurement tables.
 Author      : Anurag Dwivedi
==============================================================*/



BEGIN;
/*--------------------------------------------------------------
 Purchase Orders
--------------------------------------------------------------*/

INSERT INTO procurement.purchase_orders (
	purchase_order_id,
	supplier_id,
	warehouse_id,
	order_date,
	expected_date,
	received_date,
	status,
	total_amount)
SELECT
	UPPER(TRIM(purchase_order_id)),
	UPPER(TRIM(supplier_id)),
	UPPER(TRIM(warehouse_id)),
	CAST(order_date AS DATE),
	CAST(expected_date AS DATE),
	CAST(NULLIF(received_date, 'NULL') AS DATE),
	INITCAP(TRIM(status)),
	CAST(total_amount AS NUMERIC)
FROM staging.purchase_orders_raw
ON CONFLICT (purchase_order_id) DO NOTHING;

	

/*--------------------------------------------------------------
 Purchase Order Items
--------------------------------------------------------------*/

INSERT INTO procurement.purchase_order_items (
	purchase_order_item_id,
	purchase_order_id,
	product_id,
	quantity_ordered,
	quantity_received,
	unit_cost,
	defect_quantity)
SELECT
	UPPER(TRIM(purchase_order_item_id)),
	UPPER(TRIM(purchase_order_id)),
	UPPER(TRIM(product_id)),
	CAST(quantity_ordered AS INT),
	CAST(quantity_received AS INT),
	CAST(unit_cost AS NUMERIC),
	CASE defect_quantity
		WHEN 'Zero' THEN 0
		ELSE defect_quantity::INT
	END AS defect_quantity
FROM staging.purchase_order_items_raw;



-- ROLLBACK;
-- COMMIT;

/*==============================================================
 PROCUREMENT DATA LOAD COMPLETE
==============================================================

 The validated staging procurement data has been cleaned, transformed,
 and loaded into the corresponding final procurement tables.

==============================================================*/
