/*==============================================================
 Project     : E-Commerce Analytics Database
 Database    : PostgreSQL
 Module      : 07 - Marketing Data Validation
 Description : Validate the imported marketing data for
               completeness, uniqueness, valid values, ranges,
               logical consistency, and relationships before
               loading the final tables.
 Author      : Anurag Dwivedi
==============================================================*/



/*--------------------------------------------------------------
 Campaigns
--------------------------------------------------------------*/

-- NULL or Blank Campaign IDs
SELECT * FROM staging.campaigns_raw
WHERE campaign_id IS NULL
	OR TRIM(campaign_id) = ''
	OR campaign_id = 'NULL';
	
-- Duplicate Campaign IDs
SELECT campaign_id,
	   COUNT(*) AS duplicate_count
FROM staging.campaigns_raw
GROUP BY campaign_id
HAVING COUNT(*) > 1;

-- NULL or Blank Campaign Names
SELECT * FROM staging.campaigns_raw
WHERE campaign_name IS NULL
	OR TRIM(campaign_name) = ''
	OR campaign_name = 'NULL';
	
-- Duplicate Campaign Names
SELECT campaign_name,
	   COUNT(*) AS duplicate_count
FROM staging.campaigns_raw
GROUP BY campaign_name
HAVING COUNT(*) > 1;

-- NULL or Blank Campaign Type
SELECT * FROM staging.campaigns_raw
WHERE campaign_type IS NULL
	OR TRIM(campaign_type) = ''
	OR campaign_type = 'NULL';
	
-- NULL or Blank Channel
SELECT * FROM staging.campaigns_raw
WHERE channel IS NULL
	OR TRIM(channel) = ''
	OR channel = 'NULL';
	
-- NULL or Blank Target Segment
SELECT * FROM staging.campaigns_raw
WHERE target_segment IS NULL
	OR TRIM(target_segment) = ''
	OR target_segment = 'NULL';
	
-- NULL or Blank Status
SELECT * FROM staging.campaigns_raw
WHERE status IS NULL
	OR TRIM(status) = ''
	OR status = 'NULL';

-- End Date Before Start Date
SELECT * FROM staging.campaigns_raw
WHERE start_date::DATE > end_date::DATE;
	
-- Negative Campaign Budget
SELECT * FROM staging.campaigns_raw
WHERE budget::NUMERIC < 0;

-- Negative Actual Spend
SELECT * FROM staging.campaigns_raw
WHERE CAST(actual_spend AS NUMERIC) < 0;

-- Actual Spend Greater Than Budget
SELECT * FROM staging.campaigns_raw
WHERE actual_spend::NUMERIC > budget::NUMERIC;


/*--------------------------------------------------------------
 Coupons
--------------------------------------------------------------*/

-- NULL or Blank Coupon IDs
SELECT * FROM staging.coupons_raw
WHERE coupon_id IS NULL
	OR TRIM(coupon_id) = ''
	OR coupon_id = 'NULL';
	
-- Duplicate Coupon IDs
SELECT coupon_id,
	   COUNT(*) AS duplicate_count
FROM staging.coupons_raw
GROUP BY coupon_id
HAVING COUNT(*) > 1;

-- NULL or Blank Coupon Codes
SELECT * FROM staging.coupons_raw
WHERE coupon_code IS NULL
	OR TRIM(coupon_code) = ''
	OR coupon_code = 'NULL';
	
-- Duplicate Coupon Codes
SELECT coupon_code,
	   COUNT(*) AS duplicate_count
FROM staging.coupons_raw
GROUP BY coupon_code
HAVING COUNT(*) > 1;

-- NULL or Blank Discount Type
SELECT * FROM staging.coupons_raw
WHERE discount_type IS NULL
	OR TRIM(discount_type) = ''
	OR discount_type = 'NULL';
	
-- NULL or Blank Status
SELECT * FROM staging.coupons_raw
WHERE status IS NULL
	OR TRIM(status) = ''
	OR status = 'NULL';

-- Negative Discount Values
SELECT * FROM staging.coupons_raw
WHERE discount_value::NUMERIC < 0;

-- Negative Minimum Order Values
SELECT * FROM staging.coupons_raw
WHERE minimum_order_value::NUMERIC < 0;

-- Negative Maximum Discount
SELECT * FROM staging.coupons_raw
WHERE maximum_discount::NUMERIC < 0;

-- Negative Usage Limits
SELECT * FROM staging.coupons_raw
WHERE usage_limit::NUMERIC < 0;

-- Maximum Discount Less Than Discount Value
SELECT * FROM staging.coupons_raw
WHERE maximum_discount::NUMERIC < discount_value::NUMERIC;

-- End Date Before Start Date
SELECT * FROM staging.coupons_raw
WHERE start_date::DATE > end_date::DATE;



/*==============================================================
 MARKETING DATA VALIDATION COMPLETE
==============================================================

 The staging marketing data has been validated for
 completeness, uniqueness, valid values, ranges,
 logical consistency, and relationships.

 Next Step:
 Create the final marketing tables with appropriate data
 types, constraints, and relational integrity.

==============================================================*/
