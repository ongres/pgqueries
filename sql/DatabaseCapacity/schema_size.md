You can add this query as a function in SQL language ([wiki](https://wiki.postgresql.org/wiki/Schema_Size) ).

```sql
CREATE OR REPLACE FUNCTION pg_schema_size(text) RETURNS BIGINT AS $$
SELECT SUM(pg_total_relation_size(quote_ident(schemaname) || '.' || quote_ident(tablename)))::BIGINT 
FROM pg_tables WHERE schemaname = $1
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION pg_schema_size_filter(text, text) RETURNS BIGINT AS $$
SELECT SUM(pg_total_relation_size(quote_ident(schemaname) || '.' || quote_ident(tablename)))::BIGINT FROM pg_tables WHERE schemaname = $1 AND tablename ~ $2
$$ LANGUAGE SQL;
```

This returns the size in bytes (we try to keep consistency within the existing size functions)


```sql
select pg_size_pretty(pg_schema_size('my_schema'));
```


