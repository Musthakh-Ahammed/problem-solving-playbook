/* ============================================================
   Problem:
   Identify customers whose total monthly spending is
   strictly increasing for at least 3 consecutive months.
   
   Approach:
   1. Normalize transactions to calendar months
   2. Aggregate spend per customer per month
   3. Compare each month with the previous month
   4. Flag valid month-over-month increases
   5. Use gap-and-island logic to group consecutive increases
   6. Select groups representing at least 3 consecutive months
   ============================================================ */

WITH cte_payment_month AS (
    -- Step 1: Normalize each payment to its calendar month
    SELECT
        customer_id,
        payment_date,
        amount,
        DATETRUNC(MONTH, payment_date) AS payment_month
    FROM customer_payments
),

cte_grp_customer_month AS (
    -- Step 2: Aggregate total spend per customer per month
    SELECT
        customer_id,
        payment_month,
        SUM(amount) AS total_amount
    FROM cte_payment_month
    GROUP BY 
        customer_id,
        payment_month
),

cte_prev_amount AS (
    -- Step 3: Retrieve previous month and previous month's total
    -- for month-over-month comparison
    SELECT
        customer_id,
        payment_month,
        total_amount,
        LAG(payment_month) OVER (
            PARTITION BY customer_id 
            ORDER BY payment_month
        ) AS prev_month,
        LAG(total_amount) OVER (
            PARTITION BY customer_id 
            ORDER BY payment_month
        ) AS prev_amount
    FROM cte_grp_customer_month
),

cte_amt_compare AS (
    -- Step 4: Flag valid increases
    -- Conditions:
    -- 1. Spend strictly increases
    -- 2. Months are consecutive (no gaps)
    SELECT
        customer_id,
        payment_month,
        total_amount,
        prev_amount,
        CASE 
            WHEN 
                total_amount > prev_amount
                AND DATEDIFF(MONTH, prev_month, payment_month) = 1                  
            THEN 1
            ELSE 0
        END AS compare_flag
    FROM cte_prev_amount
),

cte_flag_sum AS (
    -- Step 5: Gap-and-island logic
    -- Increment grp_id whenever:
    -- - spend does not increase
    -- - months are not consecutive
    -- This groups consecutive increasing months together
    SELECT
        customer_id,
        payment_month,
        total_amount,
        prev_amount,
        compare_flag,
        SUM(
            CASE 
                WHEN compare_flag = 1 THEN 0 
                ELSE 1 
            END
        ) OVER (
            PARTITION BY customer_id 
            ORDER BY payment_month
        ) AS grp_id
    FROM cte_amt_compare
),

cte_grouping AS (
    -- Step 6: Prepare grouped sequences
    -- Each grp_id represents one continuous trend segment
    SELECT
        customer_id,
        payment_month,
        total_amount,
        prev_amount,
        compare_flag,
        grp_id
    FROM cte_flag_sum
),

cte_high_growth_customer AS (
    -- Step 7: Identify valid high-growth segments
    -- Requirement:
    -- 2 consecutive increases => 3 consecutive months
    SELECT
        customer_id,
        grp_id,
        SUM(compare_flag) AS sum_compare_flag,
        MIN(payment_month) AS start_month,
        MAX(payment_month) AS end_month
    FROM cte_grouping
    GROUP BY 
        customer_id,
        grp_id
    HAVING SUM(compare_flag) >= 2
)

-- Final Output:
-- Customers whose spend increased for at least 3 consecutive months
SELECT
    customer_id,
    start_month,
    end_month
FROM cte_high_growth_customer;


/* ============================================================
   Reference: Intermediate Output (After compare_flag & grp_id)

   Column meanings:
   customer_id   : Customer identifier
   payment_month : Calendar month of payment
   prev_month    : Previous month for the same customer
   total_amount  : Total spend for the month
   prev_amount   : Previous month's total spend
   compare_flag  : 1 = valid consecutive increase, 0 otherwise
   grp_id        : Group id for consecutive increasing sequences
   row_num       : Order of rows per customer (for understanding)

   ------------------------------------------------------------
   Customer 201
   ------------------------------------------------------------
   | customer_id | payment_month | prev_month  | total_amount | prev_amount | compare_flag | grp_id | row_num |
   |-------------|---------------|-------------|--------------|-------------|--------------|--------|---------|
   | 201         | 2024-01-01    | NULL        | 500.00       | NULL        | 0            | 1      | 1       |
   | 201         | 2024-02-01    | 2024-01-01  | 600.00       | 500.00      | 1            | 1      | 2       |
   | 201         | 2024-03-01    | 2024-02-01  | 800.00       | 600.00      | 1            | 1      | 3       |

   ------------------------------------------------------------
   Customer 202
   ------------------------------------------------------------
   | customer_id | payment_month | prev_month  | total_amount | prev_amount | compare_flag | grp_id | row_num |
   |-------------|---------------|-------------|--------------|-------------|--------------|--------|---------|
   | 202         | 2024-01-01    | NULL        | 500.00       | NULL        | 0            | 1      | 1       |
   | 202         | 2024-02-01    | 2024-01-01  | 400.00       | 500.00      | 0            | 2      | 2       |
   | 202         | 2024-03-01    | 2024-02-01  | 600.00       | 400.00      | 1            | 2      | 3       |

   ------------------------------------------------------------
   Customer 203
   ------------------------------------------------------------
   | customer_id | payment_month | prev_month  | total_amount | prev_amount | compare_flag | grp_id | row_num |
   |-------------|---------------|-------------|--------------|-------------|--------------|--------|---------|
   | 203         | 2024-01-01    | NULL        | 100.00       | NULL        | 0            | 1      | 1       |
   | 203         | 2024-02-01    | 2024-01-01  | 200.00       | 100.00      | 1            | 1      | 2       |
   | 203         | 2024-03-01    | 2024-02-01  | 300.00       | 200.00      | 1            | 1      | 3       |

   ============================================================ */
