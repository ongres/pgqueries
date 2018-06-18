-- This function terminates all Postgres sessions which state have been changed "age" minutes ago.
-- Usage example:
--    select * from flush_connections(60);
--
-- Or just (but result will be less readable):
--    select flush_connections(60);
--
-- By default, terminates only sessions with "state = 'idle'".
-- If needed, you can terminate ALL sessions, regardless of their states:
--    select * from flush_connections(60, true);
--
drop function if exists flush_connections(int, boolean);
create function flush_connections(in age_minutes int, in any_status boolean default false)
  returns table (
    pid int,
    db name,
    usr name,
    state text,
    query_started_ago interval,
    state_changed_ago interval,
    terminated boolean)
as $$
  select
    pid,
    datname,
    usename,
    state,
    age(now(), query_start),
    age(now(), state_change),
    pg_terminate_backend(pid)
  from pg_stat_activity
  where
    state_change < now() - age_minutes * interval '1 minute'
    and (any_status or state = 'idle')
  order by state_change;
$$ language sql;
