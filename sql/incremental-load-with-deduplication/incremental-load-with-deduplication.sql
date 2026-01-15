WITH cte_latest_record_staging AS
(
    SELECT
        t.order_id,
        t.customer_id,
        t.order_status,
        t.order_amount,
        t.event_timestamp,
        t.load_date
    FROM
    (   SELECT
            order_id,
            customer_id,
            order_status,
            order_amount,
            event_timestamp,
            load_date,
            ROW_NUMBER() OVER(PARTITION BY order_id ORDER BY event_timestamp DESC) AS latest_event
        FROM stg_orders_raw
        WHERE load_date = '2024-01-02'
    )t
    WHERE t.latest_event = 1 
)

MERGE orders_fact AS f
USING cte_latest_record_staging AS s
    ON f.order_id = s.order_id
WHEN MATCHED AND f.last_updated_at < s.event_timestamp THEN
    UPDATE SET
        f.customer_id = s.customer_id,
        f.order_status = s.order_status,
        f.order_amount = s.order_amount,
        f.last_updated_at = s.event_timestamp
WHEN NOT MATCHED THEN
    INSERT (order_id, customer_id, order_status, order_amount, last_updated_at)
    VALUES (s.order_id, s.customer_id, s.order_status, s.order_amount, s.event_timestamp);
 
