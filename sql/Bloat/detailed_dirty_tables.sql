-- Get a curated list of dirty tables, filtering by those that have more than 
-- 5% of bloat, ordered by dead tuples. 
select schemaname || '.' || quote_ident(relname) as tablefqdn, 
       n_live_tup, n_dead_tup,
       round((100*n_dead_tup) / n_live_tup) as dirty_perc,
       pg_size_pretty(pg_relation_size(schemaname || '.' || quote_ident(relname))) as size
FROM pg_stat_user_tables
WHERE n_dead_tup > 0 AND ((100*n_dead_tup) / n_live_tup) > 5  
ORDER BY n_dead_tup desc, dirty_perc desc;
