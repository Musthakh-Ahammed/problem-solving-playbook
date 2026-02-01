/* =========================================================
   Step 1: Aggregate monthly spend per customer
   ========================================================= */
WITH monthly_spend AS (
    SELECT
        customer_id,
        DATETRUNC(MONTH, order_date) AS month_year,
        SUM(order_amount) AS total_amount
    FROM orders
    GROUP BY
        customer_id,
        DATETRUNC(MONTH, order_date)
),

/* =========================================================
   Step 2: Compare each month with the immediately
           previous real month for the same customer
   ========================================================= */
month_comparison AS (
    SELECT
        customer_id,
        month_year,
        total_amount,
        LAG(total_amount) OVER (
            PARTITION BY customer_id
            ORDER BY month_year
        ) AS prev_amount,
        LAG(month_year) OVER (
            PARTITION BY customer_id
            ORDER BY month_year
        ) AS prev_month
    FROM monthly_spend
),

/* =========================================================
   Step 3: Keep only valid month-over-month increases
           (strict increase + calendar-consecutive month)
   ========================================================= */
valid_increases AS (
    SELECT
        customer_id,
        month_year
    FROM month_comparison
    WHERE
        total_amount > prev_amount
        AND DATEDIFF(MONTH, prev_month, month_year) = 1
),

/* =========================================================
   Step 4: Assign streak IDs over consecutive increase months
   ========================================================= */
increase_streaks AS (
    SELECT
        customer_id,
        month_year,
        SUM(
            CASE
                WHEN DATEDIFF(
                         MONTH,
                         LAG(month_year) OVER (
                             PARTITION BY customer_id
                             ORDER BY month_year
                         ),
                         month_year
                     ) = 1
                THEN 0
                ELSE 1
            END
        ) OVER (
            PARTITION BY customer_id
            ORDER BY month_year
        ) AS streak_id
    FROM valid_increases
),

/* =========================================================
   Step 5: Calculate streak boundaries and length
           (3 increases = qualifying streak)
   ========================================================= */
final_result AS (
    SELECT
        customer_id,
        streak_id,
        MIN(month_year) AS trend_start_month,
        MAX(month_year) AS trend_end_month,
        COUNT(*) AS consecutive_increases
    FROM increase_streaks
    GROUP BY
        customer_id,
        streak_id
    HAVING COUNT(*) >= 3
)

SELECT
    customer_id,
    trend_start_month,
    trend_end_month,
    consecutive_increases
FROM final_result
ORDER BY customer_id;
