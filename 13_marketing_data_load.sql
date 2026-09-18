/*==============================================================
 Project     : E-Commerce Analytics Database
 Database    : PostgreSQL
 Module      : 13 - Marketing Data Load
 Description : Clean, transform, and load the validated staging
               marketing data into the final marketing tables.
 Author      : Anurag Dwivedi
==============================================================*/



BEGIN;
/*--------------------------------------------------------------
 Campaigns
--------------------------------------------------------------*/

INSERT INTO marketing.campaigns (
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
SELECT 
	UPPER(TRIM(campaign_id)),
	INITCAP(TRIM(campaign_name)),
	INITCAP(TRIM(campaign_type)),
	INITCAP(TRIM(channel)),
	CAST(start_date AS DATE),
	CAST(end_date AS DATE),
	CAST(budget AS NUMERIC),
	CAST(actual_spend AS NUMERIC),
	TRIM(target_segment),
	INITCAP(TRIM(status))
FROM staging.campaigns_raw;


/*--------------------------------------------------------------
 Coupons
--------------------------------------------------------------*/

INSERT INTO marketing.coupons (
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
SELECT 
	UPPER(TRIM(coupon_id)),
	UPPER(TRIM(coupon_code)),
	INITCAP(TRIM(discount_type)),
	discount_value::NUMERIC,
	minimum_order_value::NUMERIC,
	maximum_discount::NUMERIC,
	start_date::DATE,
	end_date::DATE,
	usage_limit::INT,
	INITCAP(TRIM(status))
FROM staging.coupons_raw;



-- ROLLBACK;
-- COMMIT;
/*==============================================================
 MARKETING DATA LOAD COMPLETE
==============================================================

 The validated staging marketing data has been cleaned, transformed,
 and loaded into the corresponding final marketing tables.

==============================================================*/
