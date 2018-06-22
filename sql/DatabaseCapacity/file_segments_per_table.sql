-- Estimation of the number of segments for tables and sizes 9.4
-- This is estimated, there could be more files in filesystem
-- Here we use WITH to declare a context, not very useful in this case particularly
-- but interesting approach for versions that do not support custom varaibles in session contexts

WITH context AS (
  SELECT ('{table1,table2,table3}')::regclass[]::oid[] table_list,
         (select (setting::bigint*8) /1024 from pg_settings where name = 'segment_size') file_segment_size_MBs
)
select relname, oid, relfilenode, 
       ((relpages * 8) /1024) / context.file_segment_size_MBs file_segments ,
       pg_size_pretty(pg_total_relation_size(oid)) full_size
FROM context,pg_class 
WHERE oid = ANY (context.table_list);

