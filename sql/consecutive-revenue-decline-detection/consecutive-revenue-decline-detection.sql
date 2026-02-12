
WITH cte_base AS (
    -- Step 1: Get previous revenue and previous month
    SELECT
        customer_id,
        revenue_month,
        revenue_amount,
        LAG(revenue_amount) OVER (
            PARTITION BY customer_id
            ORDER BY revenue_month
        ) AS prev_revenue,
        LAG(revenue_month) OVER (
            PARTITION BY customer_id
            ORDER BY revenue_month
        ) AS prev_month
    FROM monthly_customer_revenue
),

cte_decline_flag AS (
    -- Step 2: Flag valid decline transitions
    SELECT
        customer_id,
        revenue_month,
        CASE
            WHEN revenue_amount < prev_revenue
                 AND DATEDIFF(MONTH, prev_month, revenue_month) = 1
                THEN 1
            ELSE 0
        END AS decline_flag
    FROM cte_base
),

cte_streak_group AS (
    -- Step 3: Create streak groups
    -- New group starts whenever decline_flag = 0
    SELECT
        customer_id,
        revenue_month,
        decline_flag,
        SUM(CASE WHEN decline_flag = 0 THEN 1 ELSE 0 END)
            OVER (
                PARTITION BY customer_id
                ORDER BY revenue_month
                ROWS UNBOUNDED PRECEDING
            ) AS streak_id
    FROM cte_decline_flag
)

-- Step 4: Aggregate only valid decline rows
SELECT
    customer_id,
    MIN(revenue_month) AS decline_start_month,
    MAX(revenue_month) AS decline_end_month,
    COUNT(*) AS consecutive_declines
FROM cte_streak_group
WHERE decline_flag = 1
GROUP BY
    customer_id,
    streak_id
HAVING COUNT(*) >= 3
ORDER BY customer_id;
