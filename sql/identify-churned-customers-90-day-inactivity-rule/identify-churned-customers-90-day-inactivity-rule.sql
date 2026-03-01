/* ============================================================
   Identify Churned Customers (90-Day Inactivity Rule)

   Logic:
   1. Compute last_order_date per customer
   2. Calculate days since last order using GETDATE()
   3. Filter customers inactive for more than 90 days
   ============================================================ */

WITH last_orders AS (
    SELECT
        customer_id,
        MAX(order_date) AS last_order_date
    FROM customer_orders
    GROUP BY customer_id
)

SELECT
    customer_id,
    last_order_date,
    DATEDIFF(DAY, last_order_date, GETDATE()) AS days_since_last_order
FROM last_orders
WHERE DATEDIFF(DAY, last_order_date, GETDATE()) > 90
ORDER BY customer_id;
