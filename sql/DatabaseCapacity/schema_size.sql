-- This calculate only tables and its indexes, probably it needs review on newer versions 9.0
SELECT SUM(pg_total_relation_size(quote_ident(schemaname) || '.' || quote_ident(tablename)))::BIGINT 
FROM pg_tables 
WHERE schemaname = 'public'; -- Set your schema name here

