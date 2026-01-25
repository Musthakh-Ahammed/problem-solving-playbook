WITH cte_revenue AS (
    SELECT
        order_date,
        product_id,
        SUM(quantity * unit_price) AS total_revenue
    FROM sales_transactions
    GROUP BY 
        order_date, 
        product_id
),
cte_ranked_revenue AS (
    SELECT
        order_date,
        product_id,
        total_revenue,
        ROW_NUMBER() OVER(PARTITION BY order_date ORDER BY total_revenue DESC) AS rn
    FROM cte_revenue
)

SELECT
    order_date,
    product_id,
    total_revenue
FROM cte_ranked_revenue
WHERE rn = 1
