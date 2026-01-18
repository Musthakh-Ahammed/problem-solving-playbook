WITH cte_prev_order AS (
    SELECT
        order_id,
        customer_id,
        order_date,
        LAG(order_date) OVER(PARTITION BY customer_id ORDER BY order_date) AS previous_order_date
    FROM orders
),
cte_days_between_last_order AS (
    SELECT 
        order_id,
        customer_id,
        order_date,
        previous_order_date,
        DATEDIFF(DAY, previous_order_date, order_date) AS days_since_last_order
    FROM cte_prev_order
),
cte_order_gap_flag AS (
    SELECT
        order_id,
        customer_id,
        order_date,
        previous_order_date,
        days_since_last_order,
        CASE 
            WHEN days_since_last_order IS NULL THEN 'FIRST_ORDER'
            WHEN days_since_last_order > 30 THEN 'GAP_GT_30_DAYS'
            ELSE 'NORMAL'
        END AS order_gap_flag
    FROM cte_days_between_last_order
)

SELECT 
    order_id,
    customer_id,
    order_date,
    previous_order_date,
    days_since_last_order,
    order_gap_flag
FROM cte_order_gap_flag
ORDER BY 
    customer_id,
    order_date;
