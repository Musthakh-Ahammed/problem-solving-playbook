/* ============================================================
   Build SCD Type 2 from Snapshot Data

   Logic:
   1. Detect city changes using LAG
   2. Remove consecutive duplicates
   3. Use LEAD to determine next version start date
   4. Compute effective_end_date
   5. Flag latest record as current
   ============================================================ */

WITH change_detection AS (
    SELECT
        customer_id,
        customer_name,
        city,
        snapshot_dt,
        LAG(city) OVER (
            PARTITION BY customer_id
            ORDER BY snapshot_dt
        ) AS prev_city
    FROM stg_customer_attributes
),

filtered_changes AS (
    -- Keep only first record per customer
    -- OR rows where city actually changed
    SELECT
        customer_id,
        customer_name,
        city,
        snapshot_dt AS effective_start_date
    FROM change_detection
    WHERE prev_city IS NULL
       OR city <> prev_city
),

effective_ranges AS (
    SELECT
        customer_id,
        customer_name,
        city,
        effective_start_date,
        LEAD(effective_start_date) OVER (
            PARTITION BY customer_id
            ORDER BY effective_start_date
        ) AS next_start_date
    FROM filtered_changes
)

SELECT
    customer_id,
    customer_name,
    city,
    effective_start_date,
    DATEADD(DAY, -1, next_start_date) AS effective_end_date,
    CASE
        WHEN next_start_date IS NULL THEN 1
        ELSE 0
    END AS is_current
FROM effective_ranges
ORDER BY customer_id, effective_start_date;
