-- Gets max /avg duration per usenrname or query pattern
 select usename, count(*), avg(clock_timestamp()-query_start), 
   max(clock_timestamp()-query_start)
   from pg_stat_activity 
   where
     1 = 1  
     --
     -- and query ~ 'unicorn'
    and state <> 'idle'
    group by usename
;