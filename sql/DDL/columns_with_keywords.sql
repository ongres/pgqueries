-- keyword used in attributes names on tables 

select 
column_name key_word, string_agg (table_name,',') tables_with_keyword_in_columns
from information_schema.columns  
where table_schema not in ('information_schema','pg_catalog') and column_name in (select word from pg_get_keywords())
group by 1
