/* ============================================================
   Problem:
   Identify orders that were placed after a product price drop.

   Definition:
   - A price drop occurs when the current price is lower than
     the previous price for the same product.
   - An order qualifies if it is placed after the price drop
     and before the next price change.

   Approach:
   1. Use window functions to detect price drops per product
   2. Create effective price windows for each price drop
   3. Join orders to the correct price window using date logic
   ============================================================ */

WITH cte_diffference AS (
    -- Step 1: Calculate price differences and identify
    -- the next price change date per product
    SELECT
        product_id,
        price,
        effective_dt,
        price - LAG(price) OVER (
            PARTITION BY product_id 
            ORDER BY effective_dt
        ) AS price_diff,
        LEAD(effective_dt) OVER (
            PARTITION BY product_id 
            ORDER BY effective_dt
        ) AS next_price_change
    FROM product_price_history
),

cte_reduced AS (
    -- Step 2: Keep only true price drops
    -- Handle the last price drop by assigning an open-ended window
    SELECT
        product_id,
        price,
        effective_dt,
        price_diff,
        ISNULL(
            next_price_change, 
            CAST('9999-01-01' AS DATE)
        ) AS next_price_change
    FROM cte_diffference
    WHERE price_diff < 0
)

-- Step 3: Join orders to the price-drop window
-- Use a half-open interval to avoid boundary overlaps
SELECT
    o.customer_id,
    o.product_id,
    o.order_id,
    o.order_date,
    r.price AS new_price
FROM orders AS o
JOIN cte_reduced AS r
    ON o.product_id = r.product_id
   AND o.order_date >= r.effective_dt
   AND o.order_date <  r.next_price_change;
