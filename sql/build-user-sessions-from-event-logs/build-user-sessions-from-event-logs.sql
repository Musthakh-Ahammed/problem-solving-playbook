/* ============================================================
   Reconstruct User Sessions (30-Minute Gap Rule)

   Logic:
   1. Use LAG to compare previous event timestamp
   2. Flag new session when:
        - First event per user
        - OR time gap > 30 minutes
   3. Use cumulative SUM to generate session_id
   4. Aggregate per session
   ============================================================ */

WITH ordered_events AS (
    SELECT
        user_id,
        event_ts,
        LAG(event_ts) OVER (
            PARTITION BY user_id
            ORDER BY event_ts
        ) AS prev_event_ts
    FROM user_events
),

session_flags AS (
    SELECT
        user_id,
        event_ts,
        CASE
            WHEN prev_event_ts IS NULL THEN 1
            WHEN DATEDIFF(MINUTE, prev_event_ts, event_ts) > 30 THEN 1
            ELSE 0
        END AS new_session_flag
    FROM ordered_events
),

session_numbering AS (
    SELECT
        user_id,
        event_ts,
        SUM(new_session_flag) OVER (
            PARTITION BY user_id
            ORDER BY event_ts
            ROWS UNBOUNDED PRECEDING
        ) AS session_id
    FROM session_flags
)

SELECT
    user_id,
    session_id,
    MIN(event_ts) AS session_start_ts,
    MAX(event_ts) AS session_end_ts,
    COUNT(*) AS event_count
FROM session_numbering
GROUP BY
    user_id,
    session_id
ORDER BY
    user_id,
    session_id;
