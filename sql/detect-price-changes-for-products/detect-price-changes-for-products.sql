WITH cte_price_rank AS(
    SELECT
        product_id,
        price,
        effective_dt,
        LAG(price) OVER(PARTITION BY product_id ORDER BY effective_dt) AS old_price
    FROM product_price_history
)

SELECT
    product_id,
    old_price,
    price AS new_price,
    effective_dt
FROM cte_price_rank
WHERE 
    price != old_price AND 
    old_price IS NOT NULL;
