/* ============================================================
   Incremental Load Using Watermark (High-Water Mark Pattern)

   Logic:
   1. Retrieve last_processed_ts from etl_watermark
   2. Filter source_orders where updated_ts > watermark
   3. Ensure deterministic ordering
   ============================================================ */

SELECT
    s.order_id,
    s.customer_id,
    s.order_amount,
    s.updated_ts
FROM source_orders AS s
WHERE s.updated_ts > (
        SELECT last_processed_ts
        FROM etl_watermark
        WHERE pipeline_name = 'orders_pipeline'
      )
ORDER BY s.updated_ts, s.order_id;
