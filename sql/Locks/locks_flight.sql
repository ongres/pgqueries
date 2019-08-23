-- See locks in fligh view with the parent blocking pids
WITH blocked_queries AS ( 
SELECT
  pid,
  query,
  array_agg( distinct pg_blocking_pids(pid)) as "BlockingPids",
  count(pl.*) as "NumLocks",
  array_agg( pl.mode) as "Modes",
  now() - xact_start  as "Running time"
FROM pg_stat_activity pa join pg_locks pl using (pid)
WHERE application_name ~ 'sidekiq'
  and wait_event IS NOT NULL
  group by pid,query, xact_start 
),
blocking_query AS (
    SELECT pid, query, array_agg(distinct pid), 
    count(pl.*) as "NumLocks",
    array_agg(pl.mode) as "Modes",
    '0 seconds'::interval
    FROM pg_stat_activity pa JOIN pg_locks pl USING (pid)
    WHERE pid IN (select distinct unnest(pg_blocking_pids(pid)) FROM pg_stat_activity)
    group by pid, query
)
SELECT * FROM blocked_queries UNION SELECT * FROM blocking_query;
  
