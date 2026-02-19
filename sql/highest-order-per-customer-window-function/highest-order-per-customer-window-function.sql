SELECT order_id,
       customer_name,
       total_amount
FROM (
    SELECT order_id,
           customer_name,
           total_amount,
           RANK() OVER (
               PARTITION BY customer_name
               ORDER BY total_amount DESC
           ) AS rnk
    FROM Orders
) ranked_orders
WHERE rnk = 1;
