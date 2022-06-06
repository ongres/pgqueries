-- This query returns the storage options of the significant tables and some extras
-- Useful for verifying that there is (or not) per-table settings (autovacuum being one of them)
select relnamespace::regnamespace, relname, reloptions, 
       relfrozenxid, relminmxid, relpages, reltuples, 
       round(reltuples/relpages) as tup_per_block, pg_size_pretty(pg_total_relation_size(relfilenode::regclass)) 
  from pg_class 
  where relname ~ 'test_av_sett' and relpages > 0 
order by relfrozenxid::text::int desc;
