-- Measure of cache effectivity (one row per database)
-- The `blks_read` column does not take into account that those blocks may have actually
-- been returned by the OS cache

select datname, blks_hit, blks_read, blks_hit::float / (blks_hit + blks_read) * 100 as cache_hit_percentaje 
from pg_stat_database 
where datname not in ('template0', 'template1','postgres');