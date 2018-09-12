-- Cache per table analysis > 9.0
-- https://dba.stackexchange.com/questions/10946/how-to-calculate-cache-misses-for-postgresql
-- perform a "select pg_stat_reset();" when you want to reset counter statistics
-- From https://www.postgresql.org/docs/current/static/monitoring-stats.html:
-- cache_miss = "result_of" pg_stat_get_db_blocks_fetched(oid) - "result_of" pg_stat_get_db_blocks_hit(oid)

with 
all_tables as
(
SELECT  *
FROM    (
    SELECT  'all'::text as table_name, 
        sum( (coalesce(heap_blks_read,0) + coalesce(idx_blks_read,0) + coalesce(toast_blks_read,0) + coalesce(tidx_blks_read,0)) ) as from_disk, 
        sum( (coalesce(heap_blks_hit,0)  + coalesce(idx_blks_hit,0)  + coalesce(toast_blks_hit,0)  + coalesce(tidx_blks_hit,0))  ) as from_cache    
    FROM    pg_statio_all_tables  --> change to pg_statio_USER_tables if you want to check only user tables (excluding postgres's own tables)
    ) a
WHERE   (from_disk + from_cache) > 0 -- discard tables without hits
),
tables as 
(
SELECT  *
FROM    (
    SELECT  relname as table_name, 
        ( (coalesce(heap_blks_read,0) + coalesce(idx_blks_read,0) + coalesce(toast_blks_read,0) + coalesce(tidx_blks_read,0)) ) as from_disk, 
        ( (coalesce(heap_blks_hit,0)  + coalesce(idx_blks_hit,0)  + coalesce(toast_blks_hit,0)  + coalesce(tidx_blks_hit,0))  ) as from_cache    
    FROM    pg_statio_all_tables --> change to pg_statio_USER_tables if you want to check only user tables (excluding postgres's own tables)
    ) a
WHERE   (from_disk + from_cache) > 0 -- discard tables without hits
)
SELECT  table_name as "table name",
    from_disk as "disk hits",
    round((from_disk::numeric / (from_disk + from_cache)::numeric)*100.0,2) as "% disk hits",
    round((from_cache::numeric / (from_disk + from_cache)::numeric)*100.0,2) as "% cache hits",
    (from_disk + from_cache) as "total hits"
FROM    (SELECT * FROM all_tables UNION ALL SELECT * FROM tables) a
ORDER   BY (case when table_name = 'all' then 0 else 1 end), from_disk desc;