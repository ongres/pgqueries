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
  
  
-- gitlabhq_production=# SELECT * FROM pg_stat_activity limit 1;
-- -[ RECORD 1 ]----+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- datid            | 12407
-- datname          | postgres
-- pid              | 1435
-- usesysid         | 162501984
-- usename          | gitlab-superuser
-- application_name | Patroni
-- client_addr      | 127.0.0.1
-- client_hostname  | 
-- client_port      | 37906
-- backend_start    | 2019-07-17 07:34:59.434831+00
-- xact_start       | 
-- query_start      | 2019-08-05 14:20:21.394741+00
-- state_change     | 2019-08-05 14:20:21.395118+00
-- wait_event_type  | 
-- wait_event       | 
-- state            | idle
-- backend_xid      | 
-- backend_xmin     | 
-- query            | SELECT CASE WHEN pg_is_in_recovery() THEN 0 ELSE ('x' || SUBSTR(pg_xlogfile_name(pg_current_xlog_location()), 1, 8))::bit(32)::int END, CASE WHEN pg_is_in_recovery() THEN GREATEST( pg_xlog_location_diff(COALESCE(pg_last_xlog_receive_location(), '0/0'), '0/0')::bigint, pg_xlog_location_diff(pg_last_xlog_replay_location(), '0/0')::bigint)ELSE pg_xlog_location_diff(pg_current_xlog_location(), '0/0')::bigint END

-- gitlabhq_production=# SELECT * FROM pg_locks limit 1;
-- -[ RECORD 1 ]------+--------------
-- locktype           | virtualxid
-- database           | 
-- relation           | 
-- page               | 
-- tuple              | 
-- virtualxid         | 49/317778208
-- transactionid      | 
-- classid            | 
-- objid              | 
-- objsubid           | 
-- virtualtransaction | 49/317778208
-- pid                | 57696
-- mode               | ExclusiveLock
-- granted            | t
-- fastpath           | t