
-- WIP: This query intends to estimate the Effective CPU usage _heuristically_ considering 
-- a few parameters focusing on the current amount of active connections and extrapolating 
-- with the load average reported by the system (or any script to extract the pid usage 
-- and aggregate).
WITH active_backends as (
    SELECT  state, xact_start, state_change, 
            backend_xid, 
            -- backend_xmin does not update if there is no new transactions doing writes,
            -- so it is possible to see older xmin in backend than the oldest reported 
            backend_xmin::text::numeric, 
            wait_event, wait_event_type,
            current_setting('max_connections') as max_conn,
            txid_snapshot_xmin(txid_current_snapshot()) as oldest_xmin
    FROM pg_stat_activity
    WHERE state in ('active', 'idle in transaction')
      and backend_type in ('client backend', 'parallel worker')
)
SELECT  count(*),
        sum(CASE WHEN backend_xmin > oldest_xmin THEN   1  ELSE  0  END ),
        max(extract ('epoch' from (clock_timestamp() - xact_start))),
        stddev(extract ('epoch' from (clock_timestamp() - xact_start)))
FROM active_backends
