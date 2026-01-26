WITH cte_customer_orders AS (
    SELECT
        order_id,
        customer_id,
        order_date,
        LAG(order_date) OVER(PARTITION BY customer_id ORDER BY order_date) AS prev_order_date
    FROM customer_orders
),

cte_days_in_between AS (
    SELECT
        customer_id,
        order_date,
        prev_order_date,
        DATEDIFF(DAY, prev_order_date,  order_date) AS days_between_orders
    FROM cte_customer_orders 
)

SELECT
    customer_id,
    prev_order_date, 
    order_date AS repeat_order_date,
    days_between_orders
FROM cte_days_in_between
WHERE days_between_orders <= 7
