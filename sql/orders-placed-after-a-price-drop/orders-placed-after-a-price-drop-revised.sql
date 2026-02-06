/* ============================================================
   Problem:
   Identify orders that were placed after a product price drop.

   Definition:
   - A price drop occurs when the current price is lower than
     the immediately previous price for the same product.
   - An order qualifies if the price effective at the order time
     is lower than the previous price.

   Approach (Point-in-Time Lookup):
   1. For each product, use LAG to get the previous price.
   2. For each order, find the latest price effective on or
      before the order date.
   3. Keep the order only if that price is lower than
      the previous price.
   ============================================================ */

WITH price_with_prev AS (
    -- Step 1: Capture each price along with its previous price
    SELECT
        product_id,
        price,
        effective_dt,
        LAG(price) OVER (
            PARTITION BY product_id
            ORDER BY effective_dt
        ) AS prev_price
    FROM product_price_history
),

order_price_match AS (
    -- Step 2: Match each order to the latest effective price
    -- at or before the order date
    SELECT
        o.customer_id,
        o.order_id,
        o.product_id,
        o.order_date,
        p.price,
        p.prev_price,
        ROW_NUMBER() OVER (
            PARTITION BY o.order_id
            ORDER BY p.effective_dt DESC
        ) AS rn
    FROM orders o
    JOIN price_with_prev p
        ON o.product_id = p.product_id
       AND p.effective_dt <= o.order_date
)

-- Step 3: Keep only orders placed after a true price drop
SELECT
    customer_id,
    product_id,
    order_id,
    order_date,
    price AS new_price
FROM order_price_match
WHERE
    rn = 1                 -- latest price at order time
    AND prev_price IS NOT NULL
    AND price < prev_price;
