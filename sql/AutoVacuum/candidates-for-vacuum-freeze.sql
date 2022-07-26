-- If we cant' run VACUUM FREEZE in the whole database so we can check the TOP100 individual relations candidates to run it

WITH per_table_stats AS (
  SELECT
    c.oid::regclass AS relation,
    age(c.relfrozenxid) AS oldest_current_xid,
    current_setting('autovacuum_freeze_max_age')::float AS autovacuum_freeze_max_age,
    pg_size_pretty(pg_total_relation_size(c.oid)) AS size
  FROM
    pg_class c
    JOIN pg_namespace n on c.relnamespace = n.oid
  WHERE
    relkind IN ('r', 't', 'm') 
    AND n.nspname NOT IN ('pg_toast')
  ORDER BY 
    oldest_current_xid DESC
)
SELECT
  relation,
  oldest_current_xid,
  autovacuum_freeze_max_age,
  round(100*(oldest_current_xid/autovacuum_freeze_max_age::float)) AS percent_towards_emergency_autovacuum,
  size
FROM
  per_table_stats
LIMIT
  100;

