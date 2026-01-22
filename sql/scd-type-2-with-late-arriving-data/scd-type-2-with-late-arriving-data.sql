
-- ------------------
-- Joining the tables
-- ------------------
WITH cte_lastest_data_combined AS (
    SELECT
        customer_id,
        customer_name, 
        city,
        update_ts AS effective_from
    FROM stg_customer_updates
    UNION ALL
    SELECT
        customer_id,
        customer_name, 
        city,
        effective_from
    FROM dim_customer
),

-- -------------------------------------
-- Checking the changes in city and name
-- -------------------------------------
cte_prev_city AS (
    SELECT
        customer_id,
        customer_name,
        city,
        effective_from,
        LAG(city) OVER(
                PARTITION BY customer_id
                ORDER BY effective_from
            ) AS prev_city,
        LAG(customer_name) OVER(
                PARTITION BY customer_id
                ORDER BY effective_from
            ) AS prev_name
    FROM cte_lastest_data_combined
),

-- -----------------------
-- Removing the duplicates
-- -----------------------
cte_deduplicated_history AS (
    SELECT
        customer_id,
        customer_name,
        city,
        effective_from
    FROM cte_prev_city
    WHERE 
        prev_name IS NULL OR            -- First row
        customer_name <> prev_name OR   -- Name changed
        city != prev_city               -- City changed
),

-- -----------------------
-- Calculating date ranges
-- -----------------------
cte_date_period AS (
    SELECT
        customer_id,
        customer_name,
        city,
        effective_from,
        LEAD(effective_from) OVER(
                PARTITION BY customer_id 
                ORDER BY effective_from
            ) AS effective_to
    FROM cte_deduplicated_history
),

-- ---------------------------
-- Creating latest record flag
-- ---------------------------
cte_updated_scd AS (
    SELECT
        customer_id,
        customer_name,
        city,
        effective_from,
        ISNULL(effective_to, CAST('9999-12-31 23:59:59.999' AS DATETIME)) AS effective_to,
        CASE 
            WHEN effective_to IS NULL THEN 1
            ELSE 0 
        END AS is_current
    FROM cte_date_period
)

-- -----------------------
-- Updating changed ranges
-- -----------------------
UPDATE dim
SET 
    dim.effective_to = scd.effective_to,
    dim.is_current = scd.is_current
FROM dim_customer AS dim
JOIN cte_updated_scd AS scd
    ON dim.customer_id = scd.customer_id and
       dim.effective_from = scd.effective_from;

-- ---------------------
-- Inserting new records
-- ---------------------
INSERT INTO dim_customer (
    customer_id,
    customer_name,
    city,
    effective_from,
    effective_to,
    is_current
)
SELECT 
    scd.customer_id,
    scd.customer_name,
    scd.city,
    scd.effective_from,
    scd.effective_to,
    scd.is_current
FROM cte_updated_scd AS scd
LEFT JOIN dim_customer AS dim
    ON 
        dim.customer_id = scd.customer_id AND
        dim.effective_from = scd.effective_from
        -- If this (customer_id, effective_from) state does not already exist, insert it.
WHERE dim.customer_id IS NULL;
