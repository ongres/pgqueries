/* 
Shows the percentage towards Wraparound and Emergency Autovacuum (it can be added to monitoring system for alerting)
for the entire cluster
*/


WITH max_age AS ( 
  SELECT
    2000000000 AS max_old_xid, -- two billions
    setting AS autovacuum_freeze_max_age 
  FROM
    pg_catalog.pg_settings 
  WHERE
    name = 'autovacuum_freeze_max_age'
),
per_database_stats AS ( 
  SELECT
    datname,
    m.max_old_xid::int,
    m.autovacuum_freeze_max_age::int,
    age(d.datfrozenxid) AS oldest_current_xid 
  FROM
    pg_catalog.pg_database d 
    JOIN max_age m ON (true) 
  WHERE
    d.datallowconn
) 
SELECT
  max(oldest_current_xid) AS oldest_current_xid,
  max(ROUND(100*(oldest_current_xid/max_old_xid::float))) AS percent_towards_wraparound,
  max(ROUND(100*(oldest_current_xid/autovacuum_freeze_max_age::float))) AS percent_towards_emergency_autovacuum
FROM
  per_database_stats;