/* ============================================================
   Detect New or Changed Orders for Incremental Processing

   Logic:
   - New record  → Exists in staging but not in fact
   - Changed record → At least one business column differs
   - NULL-safe comparisons required
   ============================================================ */

SELECT
    s.order_id,
    s.customer_id,
    s.order_status,
    s.order_amount,
    s.updated_ts
FROM stg_orders AS s
LEFT JOIN fact_orders AS f
    ON s.order_id = f.order_id
WHERE
    f.order_id IS NULL          -- New records
    OR
    ISNULL(s.customer_id, -1)      <> ISNULL(f.customer_id, -1)      -- Changed records (NULL-safe comparison)
    OR ISNULL(s.order_status, '')  <> ISNULL(f.order_status, '')
    OR ISNULL(s.order_amount, -1)  <> ISNULL(f.order_amount, -1);
