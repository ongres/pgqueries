-- Sizes of tables ordered by its real weight, including indexes
select relname,
	round(reltuples /1000 /1000) as tuples_million,
	round(pg_relation_size(oid) /1024 /1024 /1024.0, 2) as table_size_gb,
	round(pg_total_relation_size(oid) /1024 /1024 /1024.0, 2)as total_table_size_gb,
	case
		when pg_relation_size(oid)::numeric = 0
		then null
		else round((pg_total_relation_size(oid)-pg_relation_size(oid))
			/ pg_relation_size(oid)::numeric, 2)
	end as indexes_vs_table
from pg_class
where relkind = 'r'
order by pg_total_relation_size(oid) desc;

