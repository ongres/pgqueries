/*
Per database stats (check what database is in a bad situation to run a vacuum freeze in all relations)
*/

WITH per_database_stats AS (
  SELECT 
    datname,
    age(datfrozenxid) AS oldest_current_xid,
    current_setting('autovacuum_freeze_max_age')::float AS autovacuum_freeze_max_age
  FROM
    pg_database 
  ORDER BY
    oldest_current_xid DESC
)
SELECT
  datname,
  oldest_current_xid,
  autovacuum_freeze_max_age,
  round(100*(oldest_current_xid/autovacuum_freeze_max_age::float)) AS percent_towards_emergency_autovacuum
FROM
  per_database_stats  ;

/*

        datname        | oldest_current_xid | autovacuum_freeze_max_age | percent_towards_emergency_autovacuum 
-----------------------+--------------------+---------------------------+--------------------------------------
 template1             |          195155334 |                 200000000 |                                   98
 database1             |          189165308 |                 200000000 |                                   95
 database2             |          185105958 |                 200000000 |                                   93



*/