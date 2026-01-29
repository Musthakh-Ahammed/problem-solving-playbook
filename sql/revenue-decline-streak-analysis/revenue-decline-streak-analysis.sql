/* =========================================================
   Purpose:
   --------
   Identify consecutive revenue decline streaks per product
   and compute streak-level metrics.

   A decline streak is defined as:
   - Revenue strictly decreases day-over-day
   - Days are calendar-consecutive (no gaps)
   - Streak ends when revenue increases, stays the same,
     or a date gap occurs
   - Minimum streak length = 2 days

   Outputs:
   --------
   - product_id
   - streak_id (sequential per product)
   - streak_start_date
   - streak_end_date
   - streak_length_days
   - total_revenue_drop
   ========================================================= */


/* ---------------------------------------------------------
   Step 1: Compare each day with the previous day
   ---------------------------------------------------------
   - Capture previous revenue and previous date using LAG()
   - This enables strict decline and gap detection
*/
WITH comparison AS (
    SELECT
        product_id,
        revenue_date,
        revenue_amount,
        LAG(revenue_amount) OVER (
            PARTITION BY product_id
            ORDER BY revenue_date
        ) AS prev_revenue,
        LAG(revenue_date) OVER (
            PARTITION BY product_id
            ORDER BY revenue_date
        ) AS prev_date
    FROM daily_product_revenue
),


/* ---------------------------------------------------------
   Step 2: Flag valid decline days
   ---------------------------------------------------------
   A day is considered part of a decline if:
   - Revenue is strictly less than the previous day
   - The date is exactly one day after the previous date
*/
flagging AS (
    SELECT
        product_id,
        revenue_date,
        revenue_amount,
        CASE
            WHEN revenue_amount < prev_revenue
             AND DATEDIFF(DAY, prev_date, revenue_date) = 1
            THEN 1
            ELSE 0
        END AS is_decline
    FROM comparison
),


/* ---------------------------------------------------------
   Step 3: Create streak groups (Islands & Gaps)
   ---------------------------------------------------------
   - Each non-decline day increments the streak counter
   - Consecutive decline days share the same streak_id
*/
islands AS (
    SELECT
        product_id,
        revenue_date,
        revenue_amount,
        is_decline,
        SUM(
            CASE WHEN is_decline = 0 THEN 1 ELSE 0 END
        ) OVER (
            PARTITION BY product_id
            ORDER BY revenue_date
        ) AS streak_id
    FROM flagging
),


/* ---------------------------------------------------------
   Step 4: Keep only decline days
   ---------------------------------------------------------
   - Non-decline days are separators, not members
   - This ensures streaks start on the first decline day
*/
decline_days AS (
    SELECT
        product_id,
        revenue_date,
        revenue_amount,
        streak_id
    FROM islands
    WHERE is_decline = 1
),


/* ---------------------------------------------------------
   Step 5: Calculate day-over-day revenue drop within streaks
   ---------------------------------------------------------
   - Compute revenue loss per day inside each streak
*/
decline_with_drop AS (
    SELECT
        product_id,
        streak_id,
        revenue_date,
        revenue_amount,
        LAG(revenue_amount) OVER (
            PARTITION BY product_id, streak_id
            ORDER BY revenue_date
        ) - revenue_amount AS daily_revenue_drop
    FROM decline_days
)


/* ---------------------------------------------------------
   Step 6: Aggregate streak-level metrics
   ---------------------------------------------------------
   - Enforce minimum streak length (>= 2 days)
   - Compute total revenue drop across the streak
*/
SELECT
    product_id,
    streak_id,
    MIN(revenue_date) AS streak_start_date,
    MAX(revenue_date) AS streak_end_date,
    COUNT(*)          AS streak_length_days,
    SUM(daily_revenue_drop) AS total_revenue_drop
FROM decline_with_drop
GROUP BY
    product_id,
    streak_id
HAVING COUNT(*) >= 2
ORDER BY
    product_id,
    streak_id;
