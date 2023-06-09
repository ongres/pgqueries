-- Unstable queries, with larges deltas.

SELECT queryid, calls,mean_exec_time, max_exec_time, query, 
  rows, shared_blks_read, 
   
  blk_read_time+blk_write_time,temp_blks_written+temp_blks_read,stddev_exec_time 
from pg_Stat_statements 

ORDER BY 
  mean_exec_time DESC,
  stddev_exec_time DESC 

LIMIT 10;

