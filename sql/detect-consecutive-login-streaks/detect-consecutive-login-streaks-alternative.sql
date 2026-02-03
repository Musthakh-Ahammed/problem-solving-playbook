/* ============================================================
   Problem:
   Identify users who logged in for at least 3 consecutive
   calendar days.

   Alternative Approach (Simpler Pattern):
   - Assign a row number to each login per user
   - Subtract the row number from the login date
   - Consecutive dates produce the same derived grouping key
   - Any gap automatically breaks the streak
   ============================================================ */

WITH ranked_logins AS (
    -- Step 1: Assign a sequential number to each login per user
    -- and compute a derived grouping key
    SELECT
        user_id,
        login_date,
        DATEADD(
            DAY,
            -ROW_NUMBER() OVER (
                PARTITION BY user_id
                ORDER BY login_date
            ),
            login_date
        ) AS streak_key
    FROM user_logins
)

-- Step 2: Group by the derived streak_key
-- Each group represents one consecutive login streak
SELECT
    user_id,
    MIN(login_date) AS start_date,
    MAX(login_date) AS end_date
FROM ranked_logins
GROUP BY
    user_id,
    streak_key
HAVING COUNT(*) >= 3;
