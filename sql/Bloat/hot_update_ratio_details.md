## Hot Update

Reducing the FILLFACTOR for highly updated tables could improve performance by reducing
IO in detriment of bigger relations. That is, cause each block will have more available
free space to store new row versions. Those new versions will contain their transaction 
id number, which its commit being tracked in the commit log. If tx is commited and 
the transaction id is lower or equal than the current tx, so it is the consistent state.
Otherwise either is not commited and it is a _newer and uncommited_ version of the row.

The query provides the tables that are potential candidates for a reduction of the FILLFACTOR and
have more than `hot_perc`%.

FILLFACTOR is by default 95 (%) in newer versions, although heads up for those under 9.3 as the 
FILLFACTOR is way lower, meaning bigger tables.

The problem of the fillfactor is a fixed value for all the blocks, meaning that if updates are
not evenly distributed, this may affect the whole statistics. eg. 1% of your table receives 80%
of the updates will _probably_ use more _new blocks_ if new row versions do not fit in the current
block. If this is the case, you need to consider partitioning or in the worst case, use the
same fillfactor for all the table.

Unfortunately, there is no way to check wether updates were against the id exclusily, which 
makes this ratio not necessarily strict regarding failed _hot-updates_. That is, if you run 
UPDATEs using a non PK column as filtering, they will count in `n_tup_upd` and not in the `n_tup_hot_upd`
, making the ratio decrease unfairly. The only way to deal with this is decreasing the FILLFACTOR, and monitor
if the number of n_tup_hot_upd per second increases over time. 

Although, if table is small within large amount of updates, finding a perfect fit for FILLFACTOR
is easier. Keep in mind, you want to increase the free space on your table enough for holding
the row versions, but you don't want to have too much as it also affects performance (more blocks
to read, memory management, etc).  

Remember, FILLFACTOR does not apply to the entire table unless you recreate or run a vacuum full on the table.

```sql
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
```
   
