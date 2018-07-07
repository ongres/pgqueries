-- slowest query
SELECT queryid,
    query,
    calls,
    total_time/1000 as time_secs,
    (total_time/1000)/calls as per_call,
    CASE
      WHEN (shared_blks_hit > 0 AND shared_blks_read > 0) THEN round(shared_blks_hit / (shared_blks_hit + shared_blks_read)) 
      ELSE 0 END as hit_ratio,
    CASE
      WHEN (shared_blks_dirtied > 0) THEN round(shared_blks_dirtied / calls )
      ELSE 0 END  as blk_dirt_per_call,
    CASE
      WHEN (shared_blks_written > 0) THEN round(shared_blks_written / calls )
      ELSE 0 END as blk_wrtn_per_call
FROM pg_stat_statements
ORDER BY calls DESC
LIMIT 10;
