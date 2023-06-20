-- This query returns the next multixact. For caltulating the age of relminmxid 
-- in pg_class, use mxid_age() instead.

SELECT next_multixact_id::text::bigint AS nextmxid FROM pg_control_checkpoint();
