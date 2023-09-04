-- Search for very large tables with not enough writes to invoce autovacuum (threshold might be reduced if used ratio) 9.0

select 
  schemaname, relname, 
  pg_size_pretty(pg_total_relation_size(('"'||schemaname||'"."'||relname||'"')::regclass)) as rank_size,
  rank() over ( order by pg_total_relation_size(('"'||schemaname||'"."'||relname||'"')::regclass) desc), 
  n_dead_tup, 
  -- n_dead_tup / now()-last_vacuum) as dead_by_day,
  now()-last_vacuum as last_vacuumdays, 
  now()-last_autovacuum as last_autovacuumdays,
  now()-last_analyze as last_analyzedays,
  now()-last_autoanalyze as last_autoanalyzedays,
  vacuum_count,
  autovacuum_count,
  analyze_count,
  autoanalyze_count 
from pg_stat_user_tables
 order by n_dead_tup desc, pg_relation_size(('"'||schemaname||'"."'||relname||'"')::regclass) desc;
