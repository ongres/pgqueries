-- Get blocking and blocked queries. 
-- 
WITH blocked_queries AS (
SELECT
  pid,
  query,
  array_agg( distinct pg_blocking_pids(pid)) as "BlockingPids",
  count(pl.*) as "NumLocks",
  array_agg( pl.mode) as "Modes"
FROM pg_stat_activity pa join pg_locks pl using (pid)
WHERE wait_event IS NOT NULL
   AND pg_blocking_pids(pid)<> '{}'
  group by pid,query
),
blocking_query AS (
    SELECT pid, query, array_agg(distinct pid),
    count(pl.*) as "NumLocks",
    array_agg(pl.mode) as "Modes"
    FROM pg_stat_activity pa JOIN pg_locks pl USING (pid)
    WHERE pid IN (select distinct unnest(pg_blocking_pids(pid)) FROM pg_stat_activity)
    group by pid, query
)
SELECT * FROM blocked_queries UNION SELECT * FROM blocking_query
;

