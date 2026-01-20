
-- We need to find the previous city to ignore consecutive duplicates.
-- (same city back-to-back is NOT a return)
WITH cte_prev_city AS (
    SELECT
        customer_id,
        customer_name,
        city,
        moved_ts,
        LAG(city) OVER(
                PARTITION BY customer_id 
                ORDER BY moved_ts
                ) AS prev_city,
        LAG(city) OVER(
                PARTITION BY customer_id, city
                ORDER BY moved_ts
                ) AS prev_visit
    FROM customer_location_history
)

SELECT
    customer_id,
    customer_name,
    city,
    moved_ts AS return_ts
FROM cte_return_flag
WHERE
    prev_city != city AND  -- Not a consecutive visit
    prev_visit = city;     -- Visiting the same city
