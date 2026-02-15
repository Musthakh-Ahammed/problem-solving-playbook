/* ============================================================
   Funnel Completion Validation

   A user qualifies if:
   1. VIEW_PRODUCT
   2. ADD_TO_CART (after VIEW_PRODUCT)
   3. PURCHASE (after ADD_TO_CART)
   ============================================================ */

WITH ordered_events AS (
    SELECT
        user_id,
        event_name,
        event_ts,
        event_id
    FROM user_events
),

first_view AS (
    -- Step 1: Find first VIEW_PRODUCT per user
    SELECT
        user_id,
        MIN(event_ts) AS first_view_ts
    FROM ordered_events
    WHERE event_name = 'VIEW_PRODUCT'
    GROUP BY user_id
),

add_to_cart_step AS (
    -- Step 2: Find first ADD_TO_CART after first VIEW_PRODUCT
    SELECT
        f.user_id,
        f.first_view_ts,
        MIN(e.event_ts) AS add_to_cart_ts
    FROM first_view f
    JOIN ordered_events e
        ON e.user_id = f.user_id
       AND e.event_name = 'ADD_TO_CART'
       AND e.event_ts > f.first_view_ts
    GROUP BY
        f.user_id,
        f.first_view_ts
),

purchase_step AS (
    -- Step 3: Find first PURCHASE after ADD_TO_CART
    SELECT
        a.user_id,
        a.first_view_ts,
        MIN(e.event_ts) AS purchase_ts
    FROM add_to_cart_step a
    JOIN ordered_events e
        ON e.user_id = a.user_id
       AND e.event_name = 'PURCHASE'
       AND e.event_ts > a.add_to_cart_ts
    GROUP BY
        a.user_id,
        a.first_view_ts
)

SELECT
    user_id,
    first_view_ts,
    purchase_ts
FROM purchase_step;
