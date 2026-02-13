/* ============================================================
   SCD Type 2 Integrity Validation

   Violations:
   1. MULTIPLE_CURRENT → More than one record with is_current = 1
   2. OVERLAP         → Effective date ranges intersect
   3. DATE_GAP        → Previous end_date != next start_date - 1

   Assumptions:
   - NULL effective_end_date represents an active record
   - Records are evaluated per customer_id
   ============================================================ */

WITH normalized AS (
    -- Normalize NULL end dates to a far future date for comparison
    SELECT
        customer_id,
        customer_sk,
        effective_start_date,
        ISNULL(effective_end_date, '9999-12-31') AS effective_end_date,
        is_current
    FROM dim_customer
),

ordered AS (
    -- Order records per customer for date comparison
    SELECT
        customer_id,
        customer_sk,
        effective_start_date,
        effective_end_date,
        is_current,
        LAG(effective_end_date) OVER (
            PARTITION BY customer_id
            ORDER BY effective_start_date
        ) AS prev_end_date
    FROM normalized
),

multiple_current AS (
    -- Detect more than one current record
    SELECT
        customer_id,
        'MULTIPLE_CURRENT' AS violation_type
    FROM normalized
    WHERE is_current = 1
    GROUP BY customer_id
    HAVING COUNT(*) > 1
),

overlap_check AS (
    -- Detect overlapping ranges
    SELECT
        customer_id,
        'OVERLAP' AS violation_type
    FROM ordered
    WHERE prev_end_date IS NOT NULL
      AND effective_start_date <= prev_end_date
    GROUP BY customer_id
),

date_gap_check AS (
    -- Detect non-continuous dates (gap)
    SELECT
        customer_id,
        'DATE_GAP' AS violation_type
    FROM ordered
    WHERE prev_end_date IS NOT NULL
      AND effective_start_date > DATEADD(DAY, 1, prev_end_date)
    GROUP BY customer_id
)

-- Combine all violations
SELECT customer_id, violation_type FROM multiple_current
UNION ALL
SELECT customer_id, violation_type FROM overlap_check
UNION ALL
SELECT customer_id, violation_type FROM date_gap_check;
