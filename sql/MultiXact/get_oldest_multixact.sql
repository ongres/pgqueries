-- This query returns a list of tables holding multixact slots and their ages
-- The age here is not tied to a time constraint, but rather to the transaction
-- amount distance from the relminmxid.
SELECT relnamespace::regnamespace, relname, relkind, relminmxid,
      (select next_multixact_id::text::bigint FROM pg_control_checkpoint()) - relminmxid::TEXT::BIGINT AS age
FROM pg_class
WHERE relminmxid::TEXT::BIGINT <> 0
ORDER BY relminmxid::TEXT::BIGINT ASC;    
