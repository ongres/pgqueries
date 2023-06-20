-- Gets the growth of the database in a period of time 9.2
-- Increase pg_sleep accordingly

WITH timeset AS (
select pg_database_size(datname) num, 
    pg_size_pretty(pg_database_size(datname)) size 
    from pg_database where datname = current_database()
UNION ALL
select pg_database_size(datname) num, 
    pg_size_pretty(pg_database_size(datname)) size 
    from pg_database, pg_sleep(60) where datname = current_database()
)
SELECT pg_size_pretty((num - lag(num,1) 
            OVER (ORDER BY num))/60) transfer_per_minute, 
        size  
    FROM timeset
; 
