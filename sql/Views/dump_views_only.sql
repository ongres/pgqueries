-- Dump views only 9.0
-- Inspired on https://stackoverflow.com/questions/8473955/export-only-views-in-postgres
select string_agg( '-t ' || quote_ident(nspname) || '.' || quote_ident(relname), ' ' )
  from pg_class join pg_namespace on pg_namespace.oid = pg_class.relnamespace
  where relkind = 'v' 
  -- and nspname = 'your_schema'
  and not (nspname ~ '^pg_' or nspname = 'information_schema');
