# Used pool

```sql
          clamp_max(
            max(
              max_over_time(pgbouncer_pools_server_active_connections{type="pgbouncer", user="gitlab"}[1m]) /
              (
                (
                  pgbouncer_pools_server_idle_connections{type="pgbouncer", user="gitlab"} +
                  pgbouncer_pools_server_active_connections{type="pgbouncer", user="gitlab"} +
                  pgbouncer_pools_server_testing_connections{type="pgbouncer", user="gitlab"} +
                  pgbouncer_pools_server_used_connections{type="pgbouncer", user="gitlab"} +
                  pgbouncer_pools_server_login_connections{type="pgbouncer", user="gitlab"}
                )
                > 0
              )
) by (database, type, tier, stage, environment), 1)
```

Meaning 1 as the pull fullfil, 0 non used.