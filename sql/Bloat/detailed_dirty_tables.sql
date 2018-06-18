-- Get dirty rows per table 
select schemaname, relname, n_live_tup, n_dead_tup,
       pg_size_pretty(pg_relation_size(schemaname || '.' || quote_ident(relname))) as size
       from pg_stat_user_tables
       WHERE n_dead_tup > 0 order by n_dead_tup desc;
