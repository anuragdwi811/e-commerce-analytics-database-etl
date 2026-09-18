/*==============================================================
 Project     : E-Commerce Analytics Database
 Database    : PostgreSQL
 Module      : 16 - Final Data Validation
 Description : Validate the final tables after data loading to
               confirm data integrity, constraints, relationships,
               and analysis readiness.
 Author      : Anurag Dwivedi
==============================================================*/



/*==============================================================
 Master Data
==============================================================*/

/*--------------------------------------------------------------
 Products
--------------------------------------------------------------*/

-- Unit Cost < Selling Price < MRP
SELECT * FROM master.products
WHERE unit_cost >= selling_price
   OR selling_price >= mrp;


/*==============================================================
 Sales Data
==============================================================*/

/*--------------------------------------------------------------
 Orders
--------------------------------------------------------------*/

-- Expected Delivery Date >= Order Date
SELECT * FROM sales.orders
WHERE expected_delivery_date < order_date;

-- Cancellation Date >= Order Date
SELECT * FROM sales.orders
WHERE cancellation_date < order_date;

-- Confirmed Timestamp >= Created Timestamp
SELECT * FROM sales.orders
WHERE confirmed_at < created_at;

-- Packed Timestamp >= Confirmed Timestamp
SELECT * FROM sales.orders
WHERE packed_at < confirmed_at;

-- Updated Timestamp >= Created Timestamp
SELECT * FROM sales.orders
WHERE updated_at < created_at;

-- Discount Amount <= Subtotal
SELECT * FROM sales.orders
WHERE discount_amount > subtotal;


/*--------------------------------------------------------------
 Order Items
--------------------------------------------------------------*/

-- Unit Price <= MRP
SELECT * FROM sales.order_items
WHERE unit_price > mrp;

-- Discount Amount <= Item Value
SELECT * FROM sales.order_items
WHERE discount_amount > (quantity * unit_price);

-- Item Revenue Reconciliation
SELECT * FROM sales.order_items
WHERE item_revenue <> 
      ROUND((quantity * unit_price) - discount_amount, 2);

-- Item Cost Reconciliation
SELECT * FROM sales.order_items
WHERE item_cost <> 
      ROUND(quantity * unit_cost, 2);

-- Gross Profit Reconciliation
SELECT * FROM sales.order_items
WHERE gross_profit <> 
      ROUND(item_revenue - item_cost, 2);



/*==============================================================
 Procurement Data
==============================================================*/

/*--------------------------------------------------------------
 Purchase Orders
--------------------------------------------------------------*/

-- Expected Date >= Order Date
SELECT * FROM procurement.purchase_orders
WHERE expected_date < order_date;

-- Received Date >= Order Date
SELECT * FROM procurement.purchase_orders
WHERE received_date < order_date;

-- Purchase Order Total Reconciliation
SELECT po.purchase_order_id,
       po.total_amount,
       SUM(poi.quantity_ordered * poi.unit_cost) AS calculated_total
FROM procurement.purchase_orders po
JOIN procurement.purchase_order_items poi
    ON po.purchase_order_id = poi.purchase_order_id
GROUP BY po.purchase_order_id,
         po.total_amount
HAVING ROUND(po.total_amount, 2) <>
       ROUND(SUM(poi.quantity_ordered * poi.unit_cost), 2);


/*--------------------------------------------------------------
 Purchase Order Items
--------------------------------------------------------------*/

-- Quantity Received <= Quantity Ordered
SELECT * FROM procurement.purchase_order_items
WHERE quantity_received > quantity_ordered;

-- Defect Quantity <= Quantity Received
SELECT * FROM procurement.purchase_order_items
WHERE defect_quantity > quantity_received;



/*==============================================================
 Cross-Table Consistency
==============================================================*/

-- Orders Without Order Items
SELECT o.* FROM sales.orders o
WHERE NOT EXISTS (
    SELECT 1
    FROM sales.order_items oi
    WHERE oi.order_id = o.order_id);

-- Purchase Orders Without Purchase Order Items
SELECT po.* FROM procurement.purchase_orders po
WHERE NOT EXISTS (
    SELECT 1
    FROM procurement.purchase_order_items poi
    WHERE poi.purchase_order_id = po.purchase_order_id);

-- Order Item Unit Cost vs Product Unit Cost
SELECT oi.* FROM sales.order_items oi
JOIN master.products p
    ON oi.product_id = p.product_id
WHERE oi.unit_cost <> p.unit_cost;

-- Purchase Order Item Unit Cost vs Product Unit Cost
SELECT poi.* FROM procurement.purchase_order_items poi
JOIN master.products p
    ON poi.product_id = p.product_id
WHERE poi.unit_cost <> p.unit_cost;



/*==============================================================
 Load Reconciliation
==============================================================*/

-- Staging vs Final Row Count Reconciliation

SELECT 'customers' AS table_name,
       (SELECT COUNT(*) FROM staging.customers_raw) AS staging_count,
       (SELECT COUNT(*) FROM master.customers) AS final_count

UNION ALL

SELECT 'categories',
       (SELECT COUNT(*) FROM staging.categories_raw),
       (SELECT COUNT(*) FROM master.categories)

UNION ALL

SELECT 'subcategories',
       (SELECT COUNT(*) FROM staging.subcategories_raw),
       (SELECT COUNT(*) FROM master.subcategories)

UNION ALL

SELECT 'suppliers',
       (SELECT COUNT(*) FROM staging.suppliers_raw),
       (SELECT COUNT(*) FROM master.suppliers)

UNION ALL

SELECT 'warehouses',
       (SELECT COUNT(*) FROM staging.warehouses_raw),
       (SELECT COUNT(*) FROM master.warehouses)

UNION ALL

SELECT 'couriers',
       (SELECT COUNT(*) FROM staging.couriers_raw),
       (SELECT COUNT(*) FROM master.couriers)

UNION ALL

SELECT 'products',
       (SELECT COUNT(*) FROM staging.products_raw),
       (SELECT COUNT(*) FROM master.products)

UNION ALL

SELECT 'campaigns',
       (SELECT COUNT(*) FROM staging.campaigns_raw),
       (SELECT COUNT(*) FROM marketing.campaigns)

UNION ALL

SELECT 'coupons',
       (SELECT COUNT(*) FROM staging.coupons_raw),
       (SELECT COUNT(*) FROM marketing.coupons)

UNION ALL

SELECT 'orders',
       (SELECT COUNT(*) FROM staging.orders_raw),
       (SELECT COUNT(*) FROM sales.orders)

UNION ALL

SELECT 'order_items',
       (SELECT COUNT(*) FROM staging.order_items_raw),
       (SELECT COUNT(*) FROM sales.order_items)

UNION ALL

SELECT 'sales_targets',
       (SELECT COUNT(*) FROM staging.sales_targets_raw),
       (SELECT COUNT(*) FROM sales.sales_targets)

UNION ALL

SELECT 'purchase_orders',
       (SELECT COUNT(*) FROM staging.purchase_orders_raw),
       (SELECT COUNT(*) FROM procurement.purchase_orders)

UNION ALL

SELECT 'purchase_order_items',
       (SELECT COUNT(*) FROM staging.purchase_order_items_raw),
       (SELECT COUNT(*) FROM procurement.purchase_order_items);



/*==============================================================
 FINAL DATA VALIDATION COMPLETE
==============================================================

 The final tables have been validated after data loading to
 confirm data integrity, constraints, relationships, and
 analysis readiness.

==============================================================*/
