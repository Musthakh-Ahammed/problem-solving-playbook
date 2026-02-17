/* ============================================================
   Problem:
   Reconstruct the current inventory level per product
   from an event-based inventory table.

   Business Logic:
   - STOCK_IN  → increases inventory
   - STOCK_OUT → decreases inventory
   - Inventory may go negative
   - One row per product is required

   Approach:
   1. Convert event types into signed quantities.
   2. Aggregate per product using SUM.
   3. Return current stock level.
   ============================================================ */

SELECT
    product_id,
    SUM(
        CASE 
            WHEN event_type = 'STOCK_IN'  THEN quantity
            WHEN event_type = 'STOCK_OUT' THEN -quantity
            ELSE 0
        END
    ) AS current_stock
FROM inventory_events
GROUP BY product_id;
