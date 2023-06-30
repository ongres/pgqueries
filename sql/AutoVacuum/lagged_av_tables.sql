-- This query gets those tables surpassing the threshold 
-- * threshold = vac_base_thresh + vac_scale_factor * reltuples
-- See https://github.com/postgres/postgres/blob/master/src/backend/postmaster/autovacuum.c#L3004
-- FIXME! This query does not take into account that there could be custom AV options
WITH base AS (
			SELECT  schemaname||'.'|| relname as fullrelname,
					current_setting('autovacuum_vacuum_threshold')::real + 
					(current_setting('autovacuum_vacuum_scale_factor')::real*
					n_live_tup) as threshold,
					n_dead_tup as deadtuples
			FROM pg_stat_user_tables
		)
SELECT     
	fullrelname,
	pg_size_pretty(pg_total_relation_size(fullrelname::regclass)) AS relationSize,
	round(threshold) as threshold,
	deadtuples
FROM base
WHERE 
    deadtuples > threshold
ORDER BY deadtuples DESC
;