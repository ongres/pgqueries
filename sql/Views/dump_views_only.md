## Dump Views Only

```bash
time pg_dump --disable-triggers --no-privileges -c  <PASTE HERE THE QUERY OUTPUT> YOURDB | psql -h thehost  -U <user> <database> 2>&1 | tee restore_views.log
```

or

```bash
pg_dump $(psql -c "select string_agg(...etc...)" db) db
```

[Export only views in Postgres (stackoverflow)](https://stackoverflow.com/questions/8473955/export-only-views-in-postgres)


Restoring in a different schema needs a local dump and rewrite. Although it seems pretty straighforward. 
That is, there are only two lines that have search_path (can be easily regexp) and the mentions to the schema
(if anyother than public) can be matched as "schemaname." (s/schema\./schema_new\.). Can be scripted.