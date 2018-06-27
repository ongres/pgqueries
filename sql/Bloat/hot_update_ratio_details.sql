-- Which are the candidates to reduce the FILLFACTOR 9.2
-- This query is entirely related to the FILLFACTOR setup. If you see very
-- low hot_ratio numbers, this means that those tables will probably need an increase off 
-- the free space per block,  by reducing FILLFACTOR (default 95 in newer versions).
-- Unfortunately, there is no way to check wether updates were against the id exclusily, which 
-- makes this ratio not necessarily strict regarding failed _hot-updates_. That is, if you run 
-- UPDATEs using a non PK column as filtering, they will count in n_tup_upd and not in the n_tup_hot_upd
-- , making the ratio decrease unfairly. The only way to deal with this is decreasing the FILLFACTOR, and monitor
-- if the number of n_tup_hot_upd per second increases over time. 
-- Remember, FILLFACTOR does not apply to the entire table unless you recreate or run a vacuum full on the table.

WITH details AS
(
  SELECT t.schemaname, t.relname, c.reloptions,
       t.n_tup_upd, t.n_tup_hot_upd,
       case when n_tup_upd > 0
            then (n_tup_hot_upd * 100) / n_tup_upd
            else NULL
        end AS hot_perc
   FROM pg_stat_all_tables t
      JOIN (pg_class c JOIN pg_namespace n ON c.relnamespace = n.oid)
        ON n.nspname = t.schemaname AND c.relname = t.relname
  WHERE n_tup_upd > 0
) 
SELECT *
FROM details 
WHERE hot_perc > 80 -- We get those that have a high amount of hot updates.
ORDER BY  n_tup_upd desc, n_tup_hot_upd desc,hot_perc desc;

   
