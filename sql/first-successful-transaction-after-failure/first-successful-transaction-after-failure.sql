/* ============================================================
   Problem:
   Identify the first successful transaction that occurs
   after one or more failed transactions for each customer.

   Approach:
   1. Use LAG to identify the previous transaction status
   2. Filter rows where a SUCCESS immediately follows a FAILED
   3. Rank such recovery events per customer
   4. Return only the earliest recovery per customer
   ============================================================ */

WITH cte_prev_status AS (
    -- Step 1: For each customer, get the previous transaction status
    -- ordered by transaction timestamp
    SELECT
        transaction_id,
        customer_id,
        transaction_ts,
        status,
        LAG(status) OVER (
            PARTITION BY customer_id 
            ORDER BY transaction_ts
        ) AS prev_status
    FROM payment_transactions
),

cte_rownumber AS (
    -- Step 2: Identify recovery events
    -- A recovery event is defined as:
    -- current status = SUCCESS
    -- previous status = FAILED
    -- Assign row numbers to pick the first recovery per customer
    SELECT
        customer_id,
        transaction_id,
        transaction_ts,
        ROW_NUMBER() OVER (
            PARTITION BY customer_id 
            ORDER BY transaction_ts
        ) AS rn
    FROM cte_prev_status
    WHERE 
        status = 'SUCCESS'
        AND prev_status = 'FAILED'
)

-- Step 3: Select only the first recovery per customer
SELECT
    customer_id,
    transaction_id,
    transaction_ts
FROM cte_rownumber
WHERE rn = 1;
