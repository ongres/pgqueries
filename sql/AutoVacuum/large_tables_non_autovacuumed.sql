-- Search for very large tables with not enough writes to invoce autovacuum (threshold might be reduced if used ratio) 9.0

select 
  relname, 
  pg_size_pretty(pg_total_relation_size(relname::regclass)) as rank_size,
  rank() over ( order by pg_total_relation_size(relname::regclass) desc), 
  n_dead_tup, 
  -- n_dead_tup / extract('days' from now()-last_vacuum) as dead_by_day,
  -- extract('days' from now()-last_vacuum) as last_vacuum, 
  extract('days' from now()-last_autovacuum) as last_autovacuum,
  -- extract('days' from now()-last_analyze) as last_analyze,
  extract('days' from now()-last_autoanalyze) as last_autoanalyze,
  -- vacuum_count,
  autovacuum_count,
  -- analyze_count,
  autoanalyze_count 
from pg_stat_user_tables
 order by n_dead_tup desc, pg_relation_size(relid) desc;
