-- getting a stat of very frequent values with bad uniqueness (default_statistic_target very large
-- may not be useful sometimes for certain columns)
select tablename, attname, n_distinct,(most_common_vals::text::text[])[1],
              most_common_freqs[1]
       from pg_Stats
       where schemaname not in ('pg_catalog', 'information_schema')
         and n_distinct between 100 and 500 and most_common_freqs[1] < 0.18
      order by n_distinct desc

