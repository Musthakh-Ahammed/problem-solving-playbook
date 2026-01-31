/* =========================================================
   Purpose:
   --------
   Identify customers who churned immediately after their
   first purchase — i.e., customers who placed exactly
   one order and never returned.

   Definitions:
   ------------
   - Churned Customer:
       A customer with exactly ONE order in the dataset.
   - Since there is only one order:
       That order is both the first and the last.

   Assumptions:
   ------------
   - The dataset contains complete historical order data.
   - Each order represents a completed purchase.
   - Analysis is customer-centric (not order-centric).

   Output:
   -------
   - customer_id
   - first_order_month (YYYY-MM)
   - first_order_amount
   ========================================================= */


/* ---------------------------------------------------------
   Step 1: Count total purchases per customer
   ---------------------------------------------------------
   COUNT() OVER is used to compute the total number of
   orders for each customer without collapsing rows.
*/
WITH cte_purchases AS (
    SELECT
        order_id,
        customer_id,
        order_date,
        order_amount,
        COUNT(order_id) OVER (
            PARTITION BY customer_id
        ) AS total_purchases
    FROM orders
)


/* ---------------------------------------------------------
   Step 2: Filter customers with exactly one purchase
   ---------------------------------------------------------
   - total_purchases = 1 guarantees:
       • Only one order exists
       • Customer never returned
   - Since only one row exists per customer:
       • order_date is the first order date
       • order_amount is the first order amount
*/
SELECT
    customer_id,
    CONVERT(char(7), order_date, 120) AS first_order_month,
    order_amount AS first_order_amount
FROM cte_purchases
WHERE total_purchases = 1
ORDER BY customer_id;
