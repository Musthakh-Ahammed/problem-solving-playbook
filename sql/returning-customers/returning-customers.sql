WITH cte_returning_customers AS (
    SELECT
        order_id,
        customer_id,
        order_date,
        previous_order_date,
        DATEDIFF(DAY, previous_order_date, order_date) AS gap_in_days
    FROM 
    (
        SELECT
            order_id,
            customer_id,
            order_date,
            LAG(order_date) OVER(PARTITION BY customer_id ORDER BY order_date) previous_order_date
        FROM orders
    ) AS t
)

SELECT 
    customer_id,
    order_id,
    order_date,
    previous_order_date,
    gap_in_days
FROM cte_returning_customers
WHERE gap_in_days > 60;
