/* =========================================================
   Customer Retention & Revenue Analysis
   Full Solution Script (2025)
   ========================================================= */

/* =========================================================
   1. Monthly New vs Returning Customers
   ========================================================= */

WITH first_order AS (
    SELECT
        customer_id,
        DATE_TRUNC('month', MIN(order_date)) AS first_order_month
    FROM orders
    GROUP BY customer_id
),
monthly_activity AS (
    SELECT DISTINCT
        DATE_TRUNC('month', order_date) AS month,
        customer_id
    FROM orders
)
SELECT
    ma.month,
    COUNT(CASE WHEN fo.first_order_month = ma.month THEN 1 END) AS new_customers,
    COUNT(CASE WHEN fo.first_order_month < ma.month THEN 1 END) AS returning_customers
FROM monthly_activity ma
JOIN first_order fo
    ON ma.customer_id = fo.customer_id
GROUP BY ma.month
ORDER BY ma.month;


/* =========================================================
   2. Monthly Revenue Metrics
   ========================================================= */

SELECT
    DATE_TRUNC('month', order_date) AS month,
    SUM(amount) AS total_revenue,
    COUNT(order_id) AS total_orders,
    ROUND(AVG(amount), 2) AS avg_order_value
FROM orders
GROUP BY DATE_TRUNC('month', order_date)
ORDER BY month;


/* =========================================================
   3. Monthly Retention Rate
   ========================================================= */

WITH monthly_customers AS (
    SELECT DISTINCT
        DATE_TRUNC('month', order_date) AS month,
        customer_id
    FROM orders
),
previous_month_counts AS (
    SELECT
        month,
        COUNT(DISTINCT customer_id) AS customer_count
    FROM monthly_customers
    GROUP BY month
)
SELECT
    curr.month,
    ROUND(
        COUNT(DISTINCT curr.customer_id)::decimal
        / NULLIF(prev.customer_count, 0),
        2
    ) AS retention_rate
FROM monthly_customers curr
JOIN monthly_customers prev_month
    ON curr.customer_id = prev_month.customer_id
    AND curr.month = prev_month.month + INTERVAL '1 month'
JOIN previous_month_counts prev
    ON prev.month = curr.month - INTERVAL '1 month'
GROUP BY curr.month, prev.customer_count
ORDER BY curr.month;


/* =========================================================
   4. Top 3 Customers by Revenue (2025)
   ========================================================= */

SELECT
    c.customer_id,
    c.customer_name,
    COUNT(o.order_id) AS total_orders,
    SUM(o.amount) AS total_revenue
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
WHERE o.order_date BETWEEN '2025-01-01' AND '2025-12-31'
GROUP BY c.customer_id, c.customer_name
ORDER BY total_revenue DESC
LIMIT 3;

