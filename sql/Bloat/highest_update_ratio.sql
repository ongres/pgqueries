-- This query focus on those tables with heaviest update ratio. Those are 
-- 1.- Candidate to have bloat
-- 2.- Candidate to have specific FILLFACTOR

select *, n_tup_upd / (n_tup_ins + n_tup_upd + n_tup_del) as upd_ratio
FROM
(
  SELECT c.oid as relid,
  n.nspname as schema,
  c.relname,
  pg_size_pretty(pg_relation_size(n.nspname || '."' || c.relname || '"')) as table_size,
  pg_stat_get_tuples_inserted(c.oid)::float as n_tup_ins,
  pg_stat_get_tuples_updated(c.oid)::float as n_tup_upd,
  pg_stat_get_tuples_deleted(c.oid)::float as n_tup_del,
  pg_stat_get_live_tuples(c.oid) as n_live_tup,
  pg_stat_get_dead_tuples(c.oid) as n_dead_tup,
  c.reloptions
  from pg_class c left join pg_namespace n on (n.oid = c.relnamespace)
  where     
    c.relkind = any(array['r'::char, 't'::char, 'm'::char])
    and c.reltuples > 0
    and pg_relation_size(n.nspname || '."' || c.relname || '"') > 1024000 -- size in bytes
    
) foo
where (n_tup_ins + n_tup_upd + n_tup_del) > 0
order by upd_ratio desc limit 50;