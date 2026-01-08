-- =========================================
-- 2Market Customer & Marketing Analysis
-- =========================================

-- 1. Total spend per customer
SELECT
    id,
    (amtliq + amtvege + amtnonveg + amtpesc + amtchocolates + amtcomm) AS total_spend
FROM marketing_data
ORDER BY total_spend DESC;


-- 2. Average spend by education level
SELECT
    education,
    ROUND(
        AVG(amtliq + amtvege + amtnonveg + amtpesc + amtchocolates + amtcomm),
        2
    ) AS avg_spend
FROM marketing_data
GROUP BY education
ORDER BY avg_spend DESC;


-- 3. Campaign response rate by country
SELECT
    country,
    COUNT(*) AS total_customers,
    SUM(response) AS responses,
    ROUND(SUM(response)::NUMERIC / COUNT(*) * 100, 2) AS response_rate_pct
FROM marketing_data
GROUP BY country
ORDER BY response_rate_pct DESC;


-- 4. Advertising channel effectiveness
SELECT
    SUM(bulkmail_ad)  AS bulkmail_conversions,
    SUM(twitter_ad)   AS twitter_conversions,
    SUM(instagram_ad) AS instagram_conversions,
    SUM(facebook_ad)  AS facebook_conversions,
    SUM(brochure_ad)  AS brochure_conversions
FROM ad_data;


-- 5. Income band vs campaign response
SELECT
    CASE
        WHEN income < 30000 THEN 'Low Income'
        WHEN income BETWEEN 30000 AND 70000 THEN 'Mid Income'
        ELSE 'High Income'
    END AS income_band,
    COUNT(*) AS customers,
    SUM(response) AS responses
FROM marketing_data
GROUP BY income_band
ORDER BY income_band;


-- =========================================
-- ADVANCED SQL
-- =========================================

-- 6. CTE: Customer spend by education
WITH customer_spend AS (
    SELECT
        id,
        education,
        country,
        (amtliq + amtvege + amtnonveg + amtpesc + amtchocolates + amtcomm) AS total_spend
    FROM marketing_data
)
SELECT
    education,
    COUNT(*) AS customers,
    ROUND(AVG(total_spend), 2) AS avg_spend
FROM customer_spend
GROUP BY education
ORDER BY avg_spend DESC;


-- 7. Window function: Rank customers by spend
WITH customer_spend AS (
    SELECT
        id,
        country,
        (amtliq + amtvege + amtnonveg + amtpesc + amtchocolates + amtcomm) AS total_spend
    FROM marketing_data
)
SELECT
    id,
    country,
    total_spend,
    RANK() OVER (ORDER BY total_spend DESC) AS spend_rank
FROM customer_spend
ORDER BY spend_rank;


-- 8. Top 3 customers per country
WITH customer_spend AS (
    SELECT
        id,
        country,
        (amtliq + amtvege + amtnonveg + amtpesc + amtchocolates + amtcomm) AS total_spend
    FROM marketing_data
)
SELECT
    id,
    country,
    total_spend
FROM (
    SELECT
        id,
        country,
        total_spend,
        ROW_NUMBER() OVER (PARTITION BY country ORDER BY total_spend DESC) AS rn
    FROM customer_spend
) ranked
WHERE rn <= 3;


-- 9. Ad exposure vs campaign response
WITH ad_exposure AS (
    SELECT
        id,
        (bulkmail_ad + twitter_ad + instagram_ad + facebook_ad + brochure_ad) AS ad_touchpoints
    FROM ad_data
)
SELECT
    ae.ad_touchpoints,
    COUNT(*) AS customers,
    SUM(m.response) AS responses,
    ROUND(SUM(m.response)::NUMERIC / COUNT(*) * 100, 2) AS response_rate_pct
FROM ad_exposure ae
JOIN marketing_data m
    ON ae.id = m.id
GROUP BY ae.ad_touchpoints
ORDER BY ae.ad_touchpoints;
