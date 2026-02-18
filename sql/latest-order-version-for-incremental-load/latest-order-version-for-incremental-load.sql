/* ============================================================
   Problem:
   Identify the latest version of each order from staging.

   Rules:
   1. Highest updated_ts wins
   2. If timestamps tie, highest batch_id wins
   3. One row per order_id
   4. Deterministic output
   ============================================================ */

WITH ranked_orders AS (
    SELECT
        order_id,
        customer_id,
        order_status,
        order_amount,
        updated_ts,
        ROW_NUMBER() OVER (
            PARTITION BY order_id
            ORDER BY 
                updated_ts DESC,
                batch_id DESC   -- correct tie-breaker
        ) AS rn
    FROM stg_orders
)

SELECT
    order_id,
    customer_id,
    order_status,
    order_amount,
    updated_ts
FROM ranked_orders
WHERE rn = 1;
