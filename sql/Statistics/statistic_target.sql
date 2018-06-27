-- getting a stat of very frequent values with bad uniqueness (default_statistic_target very large
-- may not be useful sometimes for certain columns)
WITH context AS (
  SELECT --('{workout,userfollowingride}')::regclass[]::oid[] table_list,
         (select setting::integer FROM pg_settings where name = 'default_statistics_target') defstats
)
select tablename, ps.attname, 
        n_distinct,
        --substring((most_common_vals::text::text[])[1], 20) most_common_val, -- Add this column in the group by!
        most_common_freqs[1:3],
        pc.reltuples::bigint /1000000 M_tuples,
        round(ps.null_frac::numeric,2)
from pg_stats ps JOIN pg_class pc ON (pc.oid::regclass = (ps.schemaname || '.' || ps.tablename)::regclass AND ps.schemaname NOT IN ('pg_toast') ) 
     JOIN pg_attribute pa ON (pa.attname = ps.attname),
     context
where schemaname not in ('pg_catalog', 'information_schema')
  --AND n_distinct between 100 and 500 
  AND most_common_freqs[1] > 0.15 -- 15% is "a warning" as postgres will seq scan after 20% 
  AND n_distinct > (CASE WHEN pa.attstattarget < 0 THEN context.defstats END) -- We get the custom value , if null we use context. 
  --AND pc.oid = ANY (context.table_list)
group by tablename, ps.attname, n_distinct, most_common_freqs, M_tuples, null_frac
order by n_distinct desc, M_tuples desc;
   