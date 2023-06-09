select s.schemaname,
       s.relname as tablename,
       s.indexrelname as indexname,
       pg_relation_size(s.indexrelid) as index_size,
       pg_size_pretty(pg_relation_size(s.indexrelid)) as index_size_human
from pg_catalog.pg_stat_user_indexes s
   join pg_catalog.pg_index i on s.indexrelid = i.indexrelid
where --s.idx_scan = 0    -- has never been scanned
      s.idx_scan < 50     -- almost never used
  and pg_relation_size(relid) > 5 * 8192 -- skip empty objects
  and 0 <>all (i.indkey)  -- no index column is an expression
  and not i.indisunique   -- is not a unique index
  and not exists          -- does not enforce a constraint
         (select 1 from pg_catalog.pg_constraint c
          where c.conindid = s.indexrelid)
order by pg_relation_size(s.indexrelid) desc;
