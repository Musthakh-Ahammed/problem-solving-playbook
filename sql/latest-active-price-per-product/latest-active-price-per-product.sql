DECLARE @as_of_date DATE = '2024-02-28';

SELECT product_id, price, effective_date
FROM (
    SELECT product_id, price, effective_date,
           ROW_NUMBER() OVER (
               PARTITION BY product_id
               ORDER BY effective_date DESC
           ) AS latest_price_rank
    FROM product_price_history
    WHERE effective_date <= @as_of_date
) AS t
WHERE latest_price_rank = 1;
