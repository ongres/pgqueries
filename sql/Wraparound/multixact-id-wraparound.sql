-- Multixact Ids are generated on "SELECT ... FOR UPDATE" and variants
-- for row locking. 
-- Source: https://pgpedia.info/m/multixact-id.html
-- Documentation: https://www.postgresql.org/docs/current/routine-vacuuming.html#VACUUM-FOR-MULTIXACT-WRAPAROUND
-- mxid_age can be only used on pg_class.relminmxid. See https://www.postgresql.org/docs/15/routine-vacuuming.html

SELECT relname, relminmxid, mxid_age(relminmxid)
    FROM pg_class
   WHERE relminmxid::text::bigint <> 0
ORDER BY relminmxid::text::bigint ASC
   LIMIT 10;
