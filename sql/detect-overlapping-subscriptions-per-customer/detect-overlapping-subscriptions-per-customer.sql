/* ============================================================
   Problem:
   Identify overlapping subscription periods per customer.

   Definition:
   Two subscriptions overlap if:
   - They belong to the same customer
   - Their date ranges intersect
   - Back-to-back subscriptions are NOT overlaps

   Approach:
   1. Normalize end_date (NULL = active until today)
   2. Self-join subscriptions per customer
   3. Detect true range intersections
   4. Return both subscriptions involved in overlaps
   ============================================================ */

WITH normalized_subs AS (
    SELECT
        subscription_id,
        customer_id,
        plan_name,
        start_date,
        ISNULL(end_date, CAST(GETDATE() AS DATE)) AS end_date
    FROM customer_subscriptions
)

SELECT DISTINCT
    s1.customer_id,
    s1.subscription_id,
    s1.plan_name,
    s1.start_date,
    s1.end_date
FROM normalized_subs s1
JOIN normalized_subs s2
    ON s1.customer_id = s2.customer_id
   AND s1.subscription_id <> s2.subscription_id
   AND s1.start_date < s2.end_date               -- overlap condition
   AND s2.start_date < s1.end_date               -- overlap condition
   AND s1.start_date <> s2.end_date              -- exclude back-to-back
   AND s2.start_date <> s1.end_date;
