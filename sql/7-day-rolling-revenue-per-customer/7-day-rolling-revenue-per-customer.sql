/* ============================================================
   7-Day Rolling Revenue per Customer

   Definition:
   For each order_date, compute total revenue for:
   current date and previous 6 calendar days.

   Window:
   [order_date - 6 days, order_date]
   ============================================================ */

SELECT
    o1.customer_id,
    o1.order_date,
    SUM(o2.order_amount) AS rolling_7_day_revenue
FROM customer_orders o1
JOIN customer_orders o2
    ON o1.customer_id = o2.customer_id
   AND o2.order_date BETWEEN DATEADD(DAY, -6, o1.order_date)
                         AND o1.order_date
GROUP BY
    o1.customer_id,
    o1.order_date
ORDER BY
    o1.customer_id,
    o1.order_date;
