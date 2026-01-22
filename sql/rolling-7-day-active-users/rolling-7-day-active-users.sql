/* =========================================================
   Purpose:
   --------
   Calculate rolling 7-day active users (DAU-7) from
   event-level user activity data.

   Definition:
   -----------
   A user is considered active on a given day if they have
   at least one event on that day.

   Rolling 7-day active users for a date D =
   Count of distinct users with activity between
   D-6 and D (inclusive).

   Notes:
   ------
   - Handles days with no activity by generating a
     complete calendar date spine.
   - Deduplicates user activity to one record per
     user per day for performance.
   - Uses date-based logic (not row-based windows),
     which is required for correct rolling metrics
     in SQL Server.
   ========================================================= */


/* ---------------------------------------------------------
   Step 1: Determine the date range of available data
   ---------------------------------------------------------
   Find the minimum and maximum activity dates from the
   user_events table to build a complete calendar.
*/
DECLARE 
    @start_date DATE,
    @end_date   DATE;

SELECT
    @start_date = MIN(CAST(event_time AS DATE)),
    @end_date   = MAX(CAST(event_time AS DATE))
FROM user_events;


/* ---------------------------------------------------------
   Step 2: Generate a calendar (date spine)
   ---------------------------------------------------------
   Create one row per calendar date between the earliest
   and latest event dates. This ensures that days with
   no activity are still included in the output.
*/
WITH cte_calendar AS (
    SELECT @start_date AS activity_date
    UNION ALL
    SELECT
        DATEADD(DAY, 1, activity_date)
    FROM cte_calendar
    WHERE activity_date < @end_date
),


/* ---------------------------------------------------------
   Step 3: Deduplicate user activity to daily grain
   ---------------------------------------------------------
   Reduce event-level data to one record per user per day.
   This improves performance and ensures each user is
   counted only once per day.
*/
cte_user_event_per_day AS (
    SELECT DISTINCT
        user_id,
        CAST(event_time AS DATE) AS event_date
    FROM user_events
)


/* ---------------------------------------------------------
   Step 4: Calculate rolling 7-day active users
   ---------------------------------------------------------
   For each calendar date:
   - Look back 6 days + current day
   - Count distinct users active in that date range
*/
SELECT
    cl.activity_date,
    COUNT(DISTINCT ue.user_id) AS rolling_7_day_active_users
FROM cte_calendar AS cl
LEFT JOIN cte_user_event_per_day AS ue
    ON ue.event_date BETWEEN DATEADD(DAY, -6, cl.activity_date)
                         AND cl.activity_date
GROUP BY cl.activity_date

-- OPTION (MAXRECURSION 0); -- Uncomment if date range is large
;
