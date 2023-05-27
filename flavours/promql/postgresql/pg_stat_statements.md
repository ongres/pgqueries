-- Top 10 most frequent queries (leader)
```
topk(10, sum by(queryid) (rate(pg_stat_statements_calls[1h]) and on (instance) (pg_replication_is_replica == 0)))
```

-- Top 10 