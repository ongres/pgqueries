-- Query to gather queries with annoying temporal block written
-- This query is intended to be compatible with RDS, for buidling a query for 
-- measuring temporal files, please write another query.

select query,sum(temp_blks_written) as temp_block_written
  from pg_stat_statements 
  group by query order by temp_block_written desc 
  limit 10;