-- This simple query uses pg_stat_activity + pg_blocking_pids() to see which queries are getiing blocked, and which is the pid that causes the block
SELECT datname
, usename
, wait_event_type
, wait_event
, pg_blocking_pids(pid) AS blocked_by
, p1.query as blocked_query
, p2.query as blocking_query
FROM pg_stat_activity p1
left join lateral (select query from pg_stat_activity where pid = any(pg_blocking_pids(p1.pid))) p2 on true
WHERE wait_event IS NOT NULL;

