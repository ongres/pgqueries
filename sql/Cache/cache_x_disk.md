## Cache x disk

From [Monitoring Stats documentation](https://www.postgresql.org/docs/current/static/monitoring-stats.html):

Missed blocks is (TODO implement this in query):

```
cache_miss = "result_of" pg_stat_get_db_blocks_fetched(oid) - "result_of" pg_stat_get_db_blocks_hit(oid)
```