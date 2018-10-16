-- Gets the growth of the database in a period of time 9.2
-- Increase pg_sleep accordingly

WITH timeset AS (
select pg_database_size(datname) num, 
    pg_size_pretty(pg_database_size(datname)) size 
    from pg_database where datname = 'db'
UNION ALL
select pg_database_size(datname) num, 
    pg_size_pretty(pg_database_size(datname)) size 
    from pg_database, pg_sleep(10) where datname = 'db' 
)
SELECT pg_size_pretty((num - lag(num,1) 
            OVER (ORDER BY num))/10) transfer_per_second, 
        size  
    FROM timeset
; 
