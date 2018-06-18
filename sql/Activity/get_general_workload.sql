-- This query gives a broad view of the activity 

select st.schemaname, st.relname, 
    pg_size_pretty(pg_relation_size(st.schemaname || '.' || quote_ident(st.relname))) as No_idx_size,
    pg_size_pretty(pg_total_relation_size(st.schemaname || '.' || quote_ident(st.relname))) as With_idx_size,
    seq_scan ,
    seq_tup_read ,  idx_scan  , idx_tup_fetch , n_tup_ins , n_tup_upd , n_tup_del
    ,pg_relation_size(st.schemaname || '.' || quote_ident(st.relname)) as size,
    heap_blks_read , heap_blks_hit , idx_blks_read , idx_blks_hit , toast_blks_read , toast_blks_hit ,
    tidx_blks_read , tidx_blks_hit 
    from pg_stat_user_tables st JOIN pg_statio_user_tables io USING (relid)
    order by size desc LIMIT 20;

