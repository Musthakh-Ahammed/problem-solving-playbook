WITH ranked_orders AS (
    SELECT
        customer_id,
        product_id,
        order_id,
        order_date,
        ROW_NUMBER() OVER (
            PARTITION BY customer_id, product_id
            ORDER BY order_date, order_id
        ) AS rn
    FROM order_items
)
SELECT
    customer_id,
    product_id,
    order_date AS first_purchase_date,
    order_id AS first_order_id
FROM ranked_orders
WHERE rn = 1;
