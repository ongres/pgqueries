-- Get summarized _all the database_ dirty rows overall

SELECT sum(n_live_tup) as Total_Live_rows, sum(n_dead_tup) as Total_Dead_Rows,
            round(sum(n_dead_tup)*100/nullif(sum(n_live_tup),0),2) as Percentage_of_Dead_Rows,
            pg_size_pretty(sum(pg_relation_size(schemaname || '.' || quote_ident(relname)))::bigint)
            FROM pg_stat_user_tables;

