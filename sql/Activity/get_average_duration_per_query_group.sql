-- Gets max /avg duration per usenrname or query pattern
 select count(*), avg(now()-query_start), max(now()-query_start) 
   from pg_stat_activity 
   where
     1 = 1  
     --
     -- and query ~ 'unicorn'
    group by usename
;