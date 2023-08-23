-- Gets the cardinality of the tables 
WITH card AS (
SELECT
	nspname AS schemaname,relname,reltuples::double precision,
	reltuples::double precision - avg(reltuples::double precision) OVER () as rows_over_average
FROM pg_class C
LEFT JOIN pg_namespace N ON (N.oid = C.relnamespace)
WHERE relkind='r'
ORDER BY reltuples DESC
)
SELECT schemaname || '.' || relname as table_name, reltuples, round(rows_over_average) as rows_over_average
FROM card;

