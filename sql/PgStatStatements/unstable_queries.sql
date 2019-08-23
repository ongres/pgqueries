-- Unstable queries, with larges deltas.

SELECT queryid, calls,mean_time, max_time, query, 
  rows, shared_blks_read, 
   
  blk_read_time+blk_write_time,temp_blks_written+temp_blks_read,stddev_time 
from pg_Stat_statements 

ORDER BY 
  mean_time DESC,
  stddev_time DESC 

LIMIT 10;

