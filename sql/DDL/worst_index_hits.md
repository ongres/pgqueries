## Worst indexes in hit performance

The hit vs read ratio. The closest to 1, the better.

Sometimes can be negative when an index has been read in memory once 
and only a few hits received. 

This is the worst case, but we need to track as it can be a new index.

This is ordered from the worst to the best cases, as we don't care about does indexes
with an optimal hit ratio (harcoded to > 0.95). Also we discard indexes that have a 
high amount of hits or usage, as we want to track the worst performing indexes.  


```sql
WITH worst_index_hit_ratio AS (
	SELECT
    relid::regclass as realted_table,
		indexrelname,
    sum(idx_blks_read) as idx_read,
    sum(idx_blks_hit)  as idx_hit,
    CASE WHEN  sum(idx_blks_hit) > 0 THEN
				round((sum(idx_blks_hit) - sum(idx_blks_read)) / sum(idx_blks_hit),1)
    	ELSE sum(idx_blks_hit)
    END as hit_ratio
  FROM
    	pg_statio_user_indexes
  GROUP BY indexrelname, relid
  ORDER BY hit_ratio ASC
)
-- 2)
```

NOTE

> The above query does scan the _user indexes_. If you want to also verify how system tables
are behaving we suggest to use `pg_statio_all_tables`. 

```sql
-- 2)
SELECT * 
    FROM worst_index_hit_ratio 
    WHERE idx_read = 0 
        and idx_hit = 0; --  < 0.9;
```

If you don't see any, you may want to increase filters to a few reads and hits and use LIMIT.