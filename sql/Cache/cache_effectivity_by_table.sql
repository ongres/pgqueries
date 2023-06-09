-- Shows the cache effectivity on each table (1 row per table)
-- "_hits" and "_reads" includes "regular" blocks, indexes blocks, toast and tidx blocks

select
    schemaname, relname, 
	heap_blks_read as heap_read,
	heap_blks_hit  as heap_hit,
	heap_blks_hit / (heap_blks_hit + heap_blks_read::float) as ratio
from
	pg_statio_user_tables
where (heap_blks_hit + heap_blks_read) > 0;
