-- In certain scenarios, very often used indexes can be addressed as following:
-- Increasing FILLFACTOR to improve block allocation efficiency
-- Index Partitioning (when only the last updated/inserted records are heavily accessed). This require rotation accordingly the table rows .


WITH top_used_indexes AS (
	SELECT
       relid::regclass as related_table,
       indexrelname,
       sum(idx_blks_read) as idx_read,
	   sum(idx_blks_hit)  as idx_hit,
       max(idx_blks_read) OVER () as max_read_blks,
       max(idx_blks_hit) OVER () as max_hit_blks,
	   CASE WHEN  sum(idx_blks_hit) > 0 THEN
	     round((sum(idx_blks_hit) - sum(idx_blks_read)) / sum(idx_blks_hit),2)
	    ELSE sum(idx_blks_hit)
	    END as hit_ratio
	FROM
	    pg_statio_user_indexes
	GROUP BY indexrelname, relid, idx_blks_read, idx_blks_hit
	ORDER BY hit_ratio ASC
)
SELECT *,
CASE 
  WHEN hit_ratio < 0.95 THEN 'Read/Hit Ratio moderately low' 
  WHEN hit_ratio < 0.9 THEN 'Read/Hit Ratio too low'
END as HINT_COLUMN
FROM top_used_indexes 
WHERE 
  idx_read > (max_read_blks * 0.5) OR idx_hit > (max_hit_blks * 0.5);

