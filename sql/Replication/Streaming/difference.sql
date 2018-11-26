-- Return the difference between de sent lsn and current lsn (the delay
-- in the master basically) +10, not compatible with <10
select pid,
    application_name,
    state,
    pg_wal_lsn_diff(pg_current_wal_insert_lsn(),sent_lsn) 
from pg_stat_replication;
-- https://www.postgresql.org/docs/11/monitoring-stats.html#PG-STAT-REPLICATION-VIEW
