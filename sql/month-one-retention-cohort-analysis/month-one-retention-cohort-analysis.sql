/* ============================================================
   Month 1 Retention Calculation

   Definition:
   - Cohort month = DATETRUNC(MONTH, signup_date)
   - A user is retained if they have ≥1 activity in:
       signup_month + 1 month

   Output:
   - cohort_month
   - total_users
   - retained_users
   - retention_rate
   ============================================================ */

WITH signed_ups AS (
    SELECT
        user_id,
        DATETRUNC(MONTH, signup_date) AS signup_month
    FROM users
),

activity_months AS (
    -- Precompute activity month for index efficiency
    SELECT DISTINCT
        user_id,
        DATETRUNC(MONTH, activity_dt) AS activity_month
    FROM user_activity
)

SELECT
    s.signup_month AS cohort_month,
    COUNT(DISTINCT s.user_id) AS total_users,
    COUNT(DISTINCT a.user_id) AS retained_users,
    CAST(COUNT(DISTINCT a.user_id) AS DECIMAL(10,4))
        / NULLIF(COUNT(DISTINCT s.user_id), 0) AS retention_rate
FROM signed_ups s
LEFT JOIN activity_months a
    ON s.user_id = a.user_id
   AND a.activity_month = DATEADD(MONTH, 1, s.signup_month)
GROUP BY s.signup_month
ORDER BY s.signup_month;
