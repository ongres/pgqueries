-- Most active tables. 8.4
-- Table activity limited to top 10 by size of the table
-- This query will show the size of the table with/out indexes , how many times was accessed seq/index, and metrics of the several  cache hits of the table(rows, index, pg_toast, index.pg_toast)
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
  -- Returns the number of sequential scans, tuples read through sequential scan and the ratio
  -- This varies if you use BRIN
  seq_scan || '/' || seq_tup_read || '/' || CASE WHEN seq_scan > 0 THEN seq_tup_read / seq_scan ELSE 0 END  as heap_seqscan_tupfetch_ratio,
  idx_scan || '/' || idx_tup_fetch || '/' || CASE WHEN idx_scan > 0 THEN idx_tup_fetch / idx_scan ELSE 0 END as idx_scan_tupfetch_ratio,
  -- 1 means all access to the rel are being through idx
  -- The larger, the better
  CASE WHEN seq_scan > 0 THEN idx_scan / seq_scan ELSE 1 END as ratio_idx_seq_scan, 
  n_tup_ins || '/' || n_tup_upd || '/' || n_tup_del as ins_upd_del_ops,
  -- The larger, the better. The lower numbers indicate that the table is not cached or not so frequently access
  CASE WHEN heap_blks_read > 0 THEN  heap_blks_hit / heap_blks_read  END as ratio_read_hit_heap, 
  CASE WHEN idx_blks_read > 0 THEN  idx_blks_hit / idx_blks_read  END as ratio_read_hit_idx, 
  -- For TOAST, we should expect the reverse case, as we would prefer to avoid caching too much TOAST attributes.
  -- Queries should avoid * projection to skip those blocks. 
  CASE WHEN toast_blks_read > 0 THEN  toast_blks_hit / toast_blks_read  END as ratio_read_hit_toast,
  CASE WHEN tidx_blks_read > 0 THEN  tidx_blks_hit / tidx_blks_read  END as ratio_read_hit_tidx

FROM most_active_tables
LIMIT 10;
