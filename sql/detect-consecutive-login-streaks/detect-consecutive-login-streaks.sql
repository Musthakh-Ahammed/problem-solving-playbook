/* ============================================================
   Problem:
   Identify users who logged in for at least 3 consecutive
   calendar days.

   Approach:
   1. Use LAG to compare each login date with the previous one
   2. Flag whether the login is consecutive (day difference = 1)
   3. Apply gap-and-island logic to form streak groups
   4. Aggregate streaks and keep only those with length >= 3
   ============================================================ */

WITH cte_logins AS (
    -- Step 1: Get previous login date per user
    SELECT
        user_id,
        login_date,
        LAG(login_date) OVER (
            PARTITION BY user_id 
            ORDER BY login_date
        ) AS prev_login
    FROM user_logins
),

cte_flagging AS (
    -- Step 2: Flag consecutive logins
    -- login_flag = 1 if the user logged in exactly 1 day after
    -- the previous login, otherwise 0
    SELECT
        user_id,
        login_date,
        CASE 
            WHEN DATEDIFF(DAY, prev_login, login_date) = 1 
            THEN 1 
            ELSE 0
        END AS login_flag
    FROM cte_logins
),

cte_streak AS (
    -- Step 3: Gap-and-island logic
    -- Increment streak_id whenever the login is NOT consecutive
    -- This groups consecutive login days together
    SELECT
        user_id,
        login_date,
        SUM(
            CASE 
                WHEN login_flag = 1 THEN 0 
                ELSE 1 
            END
        ) OVER (
            PARTITION BY user_id 
            ORDER BY login_date
        ) AS streak_id
    FROM cte_flagging
),

cte_grouping AS (
    -- Step 4: Aggregate each streak
    -- COUNT(*) represents the number of days in the streak
    SELECT
        user_id,
        streak_id,
        MIN(login_date) AS start_date,
        MAX(login_date) AS end_date
    FROM cte_streak
    GROUP BY 
        user_id,
        streak_id
    HAVING 
        COUNT(*) >= 3
)

-- Final Output:
-- Users with login streaks of at least 3 consecutive days
SELECT
    user_id,
    start_date,
    end_date
FROM cte_grouping;
