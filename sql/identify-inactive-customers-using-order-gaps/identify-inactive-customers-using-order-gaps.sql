cte_prev_order_date AS (
    SELECT
        customer_id,
        order_date,
        LAG(order_date) OVER(
                PARTITION BY customer_id 
                ORDER BY order_date
            ) AS prev_order_date
    FROM customer_orders
),
cte_gap_in_days AS (
    SELECT
        customer_id,
        prev_order_date,
        order_date,
        DATEDIFF(DAY, prev_order_date, order_date) AS gap_in_days
    FROM cte_prev_order_date
)

SELECT
    customer_id,
    prev_order_date AS last_order_date,
    order_date AS next_order_date,
    gap_in_days
FROM cte_gap_in_days
WHERE gap_in_days >= 30
