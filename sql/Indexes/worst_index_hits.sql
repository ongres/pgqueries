-- The hit vs read ratio. The closest to 1, the better.


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
SELECT * FROM worst_index_hit_ratio WHERE idx_read = 0 and idx_hit = 0; --  < 0.9;

