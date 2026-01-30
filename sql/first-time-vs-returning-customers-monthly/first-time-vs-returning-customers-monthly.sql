/* =========================================================
   Purpose:
   --------
   Classify customers as First-Time or Returning on a
   monthly basis using order history.

   Definitions:
   ------------
   - First-Time Customer:
       A customer placing their first-ever order.
   - Returning Customer:
       A customer who has placed an order before the
       current month.

   Key Assumptions:
   ----------------
   - The dataset contains complete historical order data.
   - Customers are counted once per month regardless
     of how many orders they place.
   - Analysis is performed at the monthly grain.

   Outputs:
   --------
   - order_month
   - first_time_customers
   - returning_customers
   - total_customers
   ========================================================= */


/* ---------------------------------------------------------
   Step 1: Deduplicate to one row per customer per month
   ---------------------------------------------------------
   This ensures that customers are counted only once per
   month, even if they place multiple orders.
*/
WITH cte_distinct AS (
    SELECT DISTINCT
        customer_id,
        DATETRUNC(MONTH, order_date) AS order_month
    FROM orders
),


/* ---------------------------------------------------------
   Step 2: Identify the first order month per customer
   ---------------------------------------------------------
   ROW_NUMBER() assigns:
   - 1 to the first month a customer placed an order
   - >1 to subsequent months (returning behavior)
*/
cte_placed_orders AS (
    SELECT
        customer_id,
        order_month,
        ROW_NUMBER() OVER (
            PARTITION BY customer_id
            ORDER BY order_month
        ) AS order_place
    FROM cte_distinct
),


/* ---------------------------------------------------------
   Step 3: Flag first-time and returning customers
   ---------------------------------------------------------
   - First-time customers are flagged only in their
     first order month.
   - All subsequent months are flagged as returning.
*/
cte_flagging AS (
    SELECT
        order_month,
        customer_id,
        CASE 
            WHEN order_place = 1 THEN 1 
            ELSE 0
        END AS first_time_order,
        CASE 
            WHEN order_place > 1 THEN 1 
            ELSE 0
        END AS returning_order
    FROM cte_placed_orders
)


/* ---------------------------------------------------------
   Step 4: Aggregate monthly customer counts
   ---------------------------------------------------------
   - first_time_customers: customers placing their
     first-ever order in the month
   - returning_customers: customers who have ordered
     before the month
   - total_customers: total distinct customers per month
*/
SELECT
    order_month,
    SUM(first_time_order) AS first_time_customers,
    SUM(returning_order)  AS returning_customers,
    COUNT(DISTINCT customer_id) AS total_customers
FROM cte_flagging
GROUP BY order_month
ORDER BY order_month;
