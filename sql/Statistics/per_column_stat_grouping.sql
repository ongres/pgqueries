-- This query helps to group columns by amount of distinct values. 
-- Useful for determining the STATISTICS attribute per column for improving query paths and faster 
-- stats collection through ANALYZE 
-- We discard catalog tables, although for a deeper review we should check this. 
-- stats can be crappy, like n_distinct =1  but the most_common_freq not being >0.99.
-- This is probably a sign that you need to run analyze
-- perc_of_top_3_freqs shows the percentage of the top 3 most frequent values. If it is too high,
-- it means that there are too frequent values on the table, so you won't see a huge performance improvement
-- with BTREE indexes, you may want to deal these with GIST, ie. 
-- See: https://www.postgresql.org/docs/9.6/static/view-pg-stats.html


WITH grouped_stats AS (
SELECT schemaname, tablename,attname, n_distinct, C.reltuples,correlation, null_frac,avg_width,st.setting,
  (SELECT sum(s) FROM unnest((most_common_freqs::float[])[0:3]) s ) as frac_of_top_3_freqs
FROM pg_stats ps
LEFT JOIN pg_class C ON (C.relname = ps.tablename)
LEFT JOIN pg_namespace N ON (N.oid = C.relnamespace)
, pg_settings st
WHERE 
    schemaname NOT IN ('information_schema','pg_catalog')
    -- AND tablename IN ('','')
and st.name = 'default_statistics_target'
and N.nspname = ps.schemaname
)
SELECT schemaname || '.' || tablename as tablename, attname, 
  n_distinct,reltuples,
  case when n_distinct > 0 THEN (reltuples - (reltuples*null_frac))/n_distinct ELSE 0 END as tuples_per_value, -- not considering the most frequent fraction yet 
  null_frac,
  reltuples*null_frac as null_vals,
  correlation,avg_width,
    CASE 
  WHEN n_distinct::real < 0::real
  THEN 'Unique'
  WHEN n_distinct::real < setting::real
  THEN 'Targeted'
  WHEN n_distinct::real >= setting::real
  THEN 'Not_all_targeted'
  END as statistic_hint,
  round(frac_of_top_3_freqs::numeric,2) as frac_of_top_3_freqs,
CASE WHEN correlation > -0.2 AND correlation < 0.2 THEN 'physical_order_suboptimal' ELSE 'physical_order_OK' END as corr_threshold,CASE WHEN null_frac > 0.5 THEN 'too_many_nulls' WHEN null_frac BETWEEN 0.2 and 0.5 THEN 'high_amount_nulls' ELSE 'nulls_acceptable' END as null_hint
FROM grouped_stats
-- WHERE reltuples > 10000 -- just discarding very small tables
ORDER BY tablename,n_distinct DESC;

   
