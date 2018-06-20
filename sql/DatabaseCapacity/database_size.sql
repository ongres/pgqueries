-- Database Size pretty format 9.0
-- CREATE OR REPLACE FUNCTION sizedb() RETURNS text AS $$
SELECT pg_size_pretty(pg_database_size(current_database()));
-- $$ LANGUAGE SQL;

