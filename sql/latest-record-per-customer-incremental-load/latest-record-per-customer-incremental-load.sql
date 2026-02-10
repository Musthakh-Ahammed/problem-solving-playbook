SELECT
    t.customer_id,
    t.customer_name,
    t.email,
    t.updated_ts
FROM (
    SELECT
        customer_id,
        customer_name,
        email,
        updated_ts,
        ROW_NUMBER() OVER(PARTITION BY customer_id ORDER BY updated_ts DESC, batch_id DESC) AS rn
    FROM customer_profile_staging
) AS t
WHERE rn = 1
