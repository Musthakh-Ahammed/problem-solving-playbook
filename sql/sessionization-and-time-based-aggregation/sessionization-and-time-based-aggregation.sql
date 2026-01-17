WITH cte_prev_event_time AS (
    SELECT 
        user_id,
        event_time,
        LAG(event_time) OVER(PARTITION BY user_id ORDER BY event_time) AS prev_event_time
    FROM web_events
),
cte_session_flag AS(
    SELECT 
        user_id,
        event_time,
        CASE 
            WHEN prev_event_time IS NULL THEN 1
            WHEN DATEDIFF(MINUTE, prev_event_time, event_time) > 30 THEN 1
            ELSE 0
        END AS new_session_flag
    FROM cte_prev_event_time
),
cte_session AS (
    SELECT
        user_id,
        event_time,
        SUM(new_session_flag) OVER(PARTITION BY user_id 
                                   ORDER BY event_time 
                                   ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
                                   ) AS session_id
    FROM cte_session_flag
)

SELECT
    user_id,
    session_id,
    MIN(event_time) AS session_start_time,
    MAX(event_time) AS session_end_time,
    COUNT(*) AS total_events
FROM cte_session
GROUP BY 
    user_id,
    session_id
ORDER BY
    user_id,
    session_id;
