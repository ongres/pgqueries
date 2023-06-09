-- This query returns a list of active session holding multixact slots and their ages
-- The age here is not tied to a time constraint, but rather to the transaction
-- amount distance from the relminmxid and now.
SELECT pid, datname, usename, state, txid_current(), backend_xmin, 
txid_current()::text::int - backend_xmin::text::int difference
, statement_timestamp() - query_start elapsed , pg_blocking_pids(pid) as blocked_by,  query::varchar(150) query FROM pg_stat_activity WHERE backend_xmin IS NOT NULL ORDER BY age(backend_xmin) ; 