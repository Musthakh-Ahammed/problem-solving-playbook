WITH cte_insert_ranked AS
(
    SELECT
        order_id,
        customer_id,
        order_date,
        order_amount,
        order_status,
        inserted_at,
        ROW_NUMBER() OVER (
            PARTITION BY order_id
            ORDER BY inserted_at DESC
        ) AS insert_rank
    FROM Orders
)
SELECT
    customer_id,
    CAST(order_date AS DATE) AS order_date,
    COUNT(order_id) AS total_orders,
    SUM(order_amount) AS total_amount
FROM cte_insert_ranked
WHERE order_status = 'Completed'
  AND insert_rank = 1
GROUP BY
    customer_id,
    CAST(order_date AS DATE);
