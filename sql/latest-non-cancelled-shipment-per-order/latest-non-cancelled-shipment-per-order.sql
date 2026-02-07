/* ============================================================
   Problem:
   Identify the latest valid (non-cancelled) shipment per order.

   Definition:
   - A valid shipment is any shipment where status != 'CANCELLED'
   - Orders with only cancelled shipments must be excluded

   Approach:
   1. Filter out cancelled shipments first
   2. Rank remaining shipments per order by latest timestamp
   3. Select the top-ranked shipment per order
   ============================================================ */

SELECT
    t.order_id,
    t.shipment_id,
    t.shipment_ts,
    t.status
FROM (
    -- Step 1 & 2: Keep only valid shipments and rank them
    SELECT
        shipment_id,
        order_id,
        shipment_ts,
        status,
        ROW_NUMBER() OVER (
            PARTITION BY order_id
            ORDER BY shipment_ts DESC
        ) AS latest_order
    FROM order_shipments
    WHERE status != 'CANCELLED'
) AS t
-- Step 3: Select the latest valid shipment per order
WHERE latest_order = 1;
