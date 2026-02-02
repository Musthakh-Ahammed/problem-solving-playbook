/* =========================================================
   Problem:
   --------
   Identify customer reactivation events where a customer
   was inactive for at least 60 consecutive days and then
   placed a new order.

   Definition:
   -----------
   - Reactivation Event:
       A new order placed after ≥ 60 days of inactivity.
   - Inactivity is measured strictly between consecutive
     orders for the same customer.

   Output:
   -------
   - customer_id
   - last_active_date
   - reactivation_date
   - inactive_days

   Assumptions:
   ------------
   - Order history is complete
   - First order of a customer cannot be a reactivation
   - Multiple reactivations per customer are allowed
   ========================================================= */


/* ---------------------------------------------------------
   Step 1: Identify the previous order date for each order
   ---------------------------------------------------------
   - LAG() is used to fetch the immediately previous order
     for the same customer
   - Orders are ordered chronologically per customer
*/
WITH cte_last_order AS (
    SELECT
        order_id,
        customer_id,
        order_date,
        LAG(order_date) OVER (
            PARTITION BY customer_id
            ORDER BY order_date
        ) AS prev_order
    FROM orders
),


/* ---------------------------------------------------------
   Step 2: Calculate inactivity duration between orders
   ---------------------------------------------------------
   - DATEDIFF calculates the number of days between
     consecutive orders
   - For the first order, prev_order is NULL and the
     difference will also be NULL
*/
cte_gaps AS (
    SELECT
        customer_id,
        order_date,
        prev_order,
        DATEDIFF(DAY, prev_order, order_date) AS gaps_in_between
    FROM cte_last_order
),


/* ---------------------------------------------------------
   Step 3: Filter only valid reactivation events
   ---------------------------------------------------------
   - A reactivation occurs when inactivity is ≥ 60 days
   - First orders are automatically excluded since their
     prev_order is NULL
*/
cte_flagging AS (
    SELECT
        customer_id,
        order_date,
        prev_order,
        gaps_in_between
    FROM cte_gaps
    WHERE gaps_in_between >= 60
)


/* ---------------------------------------------------------
   Step 4: Return final reactivation details
   ---------------------------------------------------------
   - One row per reactivation event
   - Multiple events per customer are allowed
*/
SELECT
    customer_id,
    prev_order     AS last_active_date,
    order_date     AS reactivation_date,
    gaps_in_between AS inactive_days
FROM cte_flagging
ORDER BY customer_id, reactivation_date;
