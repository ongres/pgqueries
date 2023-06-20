/*
Per database stats (check what database is in a bad situation to run a vacuum freeze in all relations)
*/

WITH per_database_stats AS (
  SELECT 
    datname,
    age(datfrozenxid) AS oldest_xid_age,
    current_setting('autovacuum_freeze_max_age')::float AS autovacuum_freeze_max_age
  FROM
    pg_database 
  ORDER BY
    oldest_xid_age DESC
)
SELECT
  datname || ' / ' || autovacuum_freeze_max_age AS "DB / AV_FREEZE_MAX_AGE",
  oldest_xid_age,
  round(100*(oldest_xid_age/autovacuum_freeze_max_age::float)) AS "%_towards_emergency_autovacuum"
FROM
  per_database_stats  ;
