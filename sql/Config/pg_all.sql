select 'select * from ' || table_name || ';' from information_schema.views where table_name like 'pg_%';
\g /tmp/pg_all.sql
\i /tmp/pg_all.sql