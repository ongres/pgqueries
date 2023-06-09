-- Search for very large tables with not enough writes to invoce autovacuum (threshold might be reduced if used ratio) 9.0

select 
  schemaname, relname, 
  pg_size_pretty(pg_total_relation_size(('"'||schemaname||'"."'||relname||'"')::regclass)) as rank_size,
  rank() over ( order by pg_total_relation_size(('"'||schemaname||'"."'||relname||'"')::regclass) desc), 
  n_dead_tup, 
  -- n_dead_tup / extract('days' from clock_timestamp()-last_vacuum) as dead_by_day,
  -- extract('days' from clock_timestamp()-last_vacuum) as last_vacuum, 
  extract('days' from clock_timestamp()-last_autovacuum) as last_autovacuum,
  -- extract('days' from clock_timestamp()-last_analyze) as last_analyze,
  extract('days' from clock_timestamp()-last_autoanalyze) as last_autoanalyze,
  -- vacuum_count,
  autovacuum_count,
  -- analyze_count,
  autoanalyze_count 
from pg_stat_user_tables
 order by n_dead_tup desc, pg_relation_size(('"'||schemaname||'"."'||relname||'"')::regclass) desc;
