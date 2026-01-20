WITH deduped AS (
    SELECT
        customer_id,
        customer_name,
        city,
        moved_ts,
        LAG(city) OVER (
            PARTITION BY customer_id
            ORDER BY moved_ts
        ) AS prev_city
    FROM customer_location_history
),
filtered AS (
    SELECT *
    FROM deduped
    WHERE prev_city IS NULL OR city <> prev_city
)
SELECT
    f.customer_id,
    f.customer_name,
    f.city,
    f.moved_ts AS return_ts
FROM filtered f
WHERE EXISTS (
    SELECT 1
    FROM filtered h
    WHERE h.customer_id = f.customer_id
      AND h.city = f.city
      AND h.moved_ts < f.moved_ts
);
