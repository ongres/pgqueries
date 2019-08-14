-- Hunting idle in transaction queries

SELECT (now() - pg_stat_activity.xact_start) AS age, 
     pg_stat_activity.datname, pg_stat_activity.pid, pg_stat_activity.usename, pg_stat_activity.state, pg_stat_activity.query_start, pg_stat_activity.client_addr, pg_stat_activity.query 
FROM pg_stat_activity 
WHERE  (pg_stat_activity.xact_start IS NOT NULL)  
    and state ~ 'idle in transaction'
ORDER BY pg_stat_activity.xact_start;
