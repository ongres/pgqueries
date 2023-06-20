-- Given the current xlog location, it calculates the size of the current active WAL
-- Source: https://www.cybertec-postgresql.com/en/checkpoint-distance-and-amount-of-wal/
SELECT pg_size_pretty(pg_current_xlog_location() - '0/00000000'::pg_lsn);
