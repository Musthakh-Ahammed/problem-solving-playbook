/* ============================================================
   Problem:
   Identify customers whose monthly spend exceeded 10,000
   for at least 3 consecutive calendar months.

   Approach:
   1. Aggregate transactions to monthly totals
   2. Filter months where total > 10,000
   3. Use gap-and-island logic to detect consecutive months
   4. Return streaks with length >= 3
   ============================================================ */

WITH monthly_spend AS (
    -- Step 1: Aggregate to monthly totals
    SELECT
        customer_id,
        DATETRUNC(MONTH, transaction_dt) AS spend_month,
        SUM(amount) AS total_amount
    FROM customer_transactions
    GROUP BY
        customer_id,
        DATETRUNC(MONTH, transaction_dt)
),

qualified_months AS (
    -- Step 2: Keep only months exceeding threshold
    SELECT
        customer_id,
        spend_month
    FROM monthly_spend
    WHERE total_amount > 10000
),

streak_grouping AS (
    -- Step 3: Gap-and-island pattern
    -- Consecutive months will produce the same grouping key
    SELECT
        customer_id,
        spend_month,
        DATEADD(
            MONTH,
            -ROW_NUMBER() OVER (
                PARTITION BY customer_id
                ORDER BY spend_month
            ),
            spend_month
        ) AS grp_key
    FROM qualified_months
)

-- Step 4: Aggregate streaks and filter length >= 3
SELECT
    customer_id,
    MIN(spend_month) AS start_month,
    MAX(spend_month) AS end_month
FROM streak_grouping
GROUP BY
    customer_id,
    grp_key
HAVING COUNT(*) >= 3;
