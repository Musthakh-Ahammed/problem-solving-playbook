/* ============================================================
   Detect Duplicate Payments (5-Minute Rule)

   Logic:
   1. Partition by customer_id and amount
   2. Order transactions by timestamp
   3. Use LAG to get previous matching transaction
   4. Compute time difference
   5. Return only duplicates (<= 5 minutes)
   ============================================================ */

WITH ordered_txns AS (
    SELECT
        transaction_id,
        customer_id,
        amount,
        transaction_ts,
        LAG(transaction_ts) OVER (
            PARTITION BY customer_id, amount
            ORDER BY transaction_ts
        ) AS previous_transaction_ts
    FROM payment_transactions
)

SELECT
    transaction_id,
    customer_id,
    amount,
    transaction_ts,
    previous_transaction_ts,
    DATEDIFF(
        MINUTE,
        previous_transaction_ts,
        transaction_ts
    ) AS minutes_difference
FROM ordered_txns
WHERE
    previous_transaction_ts IS NOT NULL
    AND DATEDIFF(
            MINUTE,
            previous_transaction_ts,
            transaction_ts
        ) <= 5
ORDER BY
    customer_id,
    transaction_ts;
