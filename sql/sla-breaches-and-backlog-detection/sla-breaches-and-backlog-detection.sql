/* =========================================================
   PROBLEM
   ---------------------------------------------------------
   Detect:
   1. Order-level SLA status
   2. Continuous backlog periods at system level

   DEFINITIONS
   ---------------------------------------------------------
   SLA Deadline  = order_date + 3 days

   SLA Status:
     - ON_TIME   : shipped on/before SLA deadline
     - BREACHED  : shipped after SLA deadline
     - PENDING   : not shipped and past SLA deadline

   Backlog:
     - A system-level state
     - Exists if at least one order is overdue & unshipped
     - Starts when overdue count goes 0 → >0
     - Ends when overdue count goes >0 → 0
     - End date is NULL if backlog is still active
   ========================================================= */


/* =========================================================
   PART 1 — ORDER-LEVEL SLA STATUS
   ========================================================= */

WITH cte_sla_status AS (
    SELECT
        o.order_id,
        o.order_date,
        s.shipped_date,
        DATEADD(DAY, 3, o.order_date) AS sla_deadline,
        CASE
            WHEN s.shipped_date IS NULL
                 AND DATEADD(DAY, 3, o.order_date) < CAST(GETDATE() AS DATE)
                THEN 'PENDING'
            WHEN s.shipped_date > DATEADD(DAY, 3, o.order_date)
                THEN 'BREACHED'
            ELSE 'ON_TIME'
        END AS sla_status
    FROM orders o
    LEFT JOIN shipments s
        ON o.order_id = s.order_id
)

SELECT *
FROM cte_sla_status;


/* =========================================================
   PART 2 — SYSTEM-LEVEL BACKLOG DETECTION
   ========================================================= */

/* ---------------------------------------------------------
   Step 1: Define overdue windows per order
   ---------------------------------------------------------
   An order contributes to backlog:
   - From: order_date + 4 (first overdue day)
   - To  : shipped_date (exclusive), or open-ended
*/
WITH cte_overdue_windows AS (
    SELECT
        o.order_id,
        DATEADD(DAY, 4, o.order_date) AS overdue_start_date,
        s.shipped_date
    FROM orders o
    LEFT JOIN shipments s
        ON o.order_id = s.order_id
),


/* ---------------------------------------------------------
   Step 2: Convert windows into backlog events
   ---------------------------------------------------------
   +1 : order enters backlog
   -1 : order exits backlog
*/
cte_events AS (
    SELECT
        overdue_start_date AS event_date,
        1 AS delta
    FROM cte_overdue_windows

    UNION ALL

    SELECT
        DATEADD(DAY, 1, shipped_date) AS event_date,
        -1 AS delta
    FROM cte_overdue_windows
    WHERE shipped_date IS NOT NULL
),


/* ---------------------------------------------------------
   Step 3: Running overdue count (system state)
   ---------------------------------------------------------
*/
cte_running_count AS (
    SELECT
        event_date,
        SUM(delta) OVER (
            ORDER BY event_date
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS overdue_count
    FROM cte_events
),


/* ---------------------------------------------------------
   Step 4: Detect backlog start/end transitions
   ---------------------------------------------------------
*/
cte_state_changes AS (
    SELECT
        event_date,
        overdue_count,
        LAG(overdue_count, 1, 0) OVER (ORDER BY event_date) AS prev_count
    FROM cte_running_count
),


/* ---------------------------------------------------------
   Step 5: Mark backlog boundaries
   ---------------------------------------------------------
*/
cte_markers AS (
    SELECT
        event_date,
        CASE
            WHEN prev_count = 0 AND overdue_count > 0 THEN 'START'
            WHEN prev_count > 0 AND overdue_count = 0 THEN 'END'
        END AS marker
    FROM cte_state_changes
    WHERE
        (prev_count = 0 AND overdue_count > 0)
        OR
        (prev_count > 0 AND overdue_count = 0)
),


/* ---------------------------------------------------------
   Step 6: Assign backlog IDs
   ---------------------------------------------------------
*/
cte_backlog_groups AS (
    SELECT
        event_date,
        marker,
        SUM(CASE WHEN marker = 'START' THEN 1 ELSE 0 END)
            OVER (ORDER BY event_date) AS backlog_id
    FROM cte_markers
)

SELECT
    backlog_id,
    MIN(CASE WHEN marker = 'START' THEN event_date END) AS backlog_start_date,
    MAX(CASE WHEN marker = 'END'
             THEN DATEADD(DAY, -1, event_date)
        END) AS backlog_end_date
FROM cte_backlog_groups
GROUP BY backlog_id
ORDER BY backlog_id;
