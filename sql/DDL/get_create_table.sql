
-- Get CREATE TABLE
SELECT
  'CREATE TABLE ' || relname || E'\n(\n' ||
  array_to_string(
    array_agg(
      '    ' || column_name || ' ' ||  type || ' '|| not_null
    )
    , E',\n'
  ) || E'\n);\n'
from
(
  SELECT
    c.relname, a.attname AS column_name,
    pg_catalog.format_type(a.atttypid, a.atttypmod) as type,
    case
      when a.attnotnull
    then 'NOT NULL'
    else 'NULL'
    END as not_null
  FROM pg_class c,
   pg_attribute a,
   pg_type t
   WHERE 
     c.relname like '<table>'
     AND a.attnum > 0
     AND a.attrelid = c.oid
     AND a.atttypid = t.oid
 ORDER BY a.attnum
) as tabledefinition
group by relname;
