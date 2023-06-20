-- Amount of generated WALS so far
SELECT pg_size_pretty(pg_current_wal_lsn() - '0/00000000'::pg_lsn);