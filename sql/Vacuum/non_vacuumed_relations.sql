-- Get tables never vacuumed by size
select relid, schemaname || '.' || relname, last_vacuum, last_analyze 
from pg_stat_user_tables 
where last_vacuum is null or last_analyze is null order by pg_relation_size(relid) desc;