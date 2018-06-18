
-- This needs to be executed in a loop during N minutes.
-- We can do this in a SQL query tho, with a recursive CTE.
-- See DatabaseCapacity/size_growth_interval.sql ^

SELECT 
   checkpoints_timed || '/' || checkpoints_req as checkpts_timed_req,
   checkpoint_write_time / 1000 as chkpt_write_seconds,
   checkpoint_sync_time / 1000 as chkpt_sync_seconds,
   CASE WHEN checkpoints_timed+checkpoints_req>0 THEN round((checkpoint_write_time/checkpoints_timed+checkpoints_req)/1000) ELSE 0 END  as per_chkpt_seconds,
   buffers_alloc,
   stats_reset::timestamp(0),
   CASE WHEN date_part('day',(now() - stats_reset)::interval) > 0  THEN round(checkpoints_req + checkpoints_timed / (date_part('day',(now() - stats_reset)::interval))) ELSE 0 END  as chks_per_day,
   CASE WHEN date_part('day',(now() - stats_reset)::interval) > 0  THEN round(checkpoints_req / (date_part('day',(now() - stats_reset)::interval))) ELSE 0 END  as chk_req_per_day
FROM
  pg_stat_bgwriter;

