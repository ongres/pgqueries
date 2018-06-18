-- Most active tables. 8.4
-- Table activity limited to 10
WITH most_active_tables AS (
select st.schemaname, st.relname,
      pg_size_pretty(pg_relation_size(st.schemaname || '.' || quote_ident(st.relname))) as No_idx_size,
      pg_size_pretty(pg_total_relation_size(st.schemaname || '.' || quote_ident(st.relname))) as With_idx_size,
      seq_scan ,
      seq_tup_read ,  idx_scan  , idx_tup_fetch , n_tup_ins , n_tup_upd , n_tup_del
      ,pg_relation_size(st.schemaname || '.' || quote_ident(st.relname)) as size,
      heap_blks_read , heap_blks_hit , idx_blks_read , idx_blks_hit , toast_blks_read , toast_blks_hit ,
      tidx_blks_read , tidx_blks_hit
      from pg_stat_user_tables st JOIN pg_statio_user_tables io USING (relid)
      order by size desc
)
SELECT
  schemaname || '.' || relname as table_name,
  No_idx_size || '/' || With_idx_size as noidx_withidx_size,
  seq_scan || '/' || seq_tup_read  as scan_tups_seq,
  CASE WHEN seq_scan > 0 THEN seq_tup_read / seq_scan ELSE 0 END as tup_per_scan, -- this varies if you use BRIN
  idx_scan || '/' || idx_tup_fetch as scan_fetch_idx,
  CASE WHEN seq_scan > 0 THEN idx_scan / seq_scan ELSE 1 END as ratio_idx_seq_scan, -- 1 means all access to the rel are being through idx
  n_tup_ins || '/' || n_tup_upd || '/' || n_tup_del as ins_upd_del_ops,
  (heap_blks_hit*100)/(heap_blks_read + heap_blks_hit+1) as perc_of_rel_cached,
  (idx_blks_hit*100)/(idx_blks_read + idx_blks_hit+1) as perc_of_rel_ix_cached,
  (toast_blks_hit*100)/(toast_blks_read + toast_blks_hit+1) as perc_toast_cached,
  (tidx_blks_hit*100)/(tidx_blks_read + tidx_blks_hit+1) as perc_toast_ix_cached
FROM most_active_tables
LIMIT 10;
