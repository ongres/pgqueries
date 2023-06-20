-- Current amount of WALs present in the waldir
WITH oldest_mod_walfile AS (
    SELECT (substring(name from 9 for 8) || '/' || substring(name from 17 for 8 ))::pg_lsn as oldest_lsn
        FROM pg_ls_waldir() 
        ORDER BY modification DESC LIMIT 1
)
SELECT pg_size_pretty(pg_wal_lsn_diff( pg_current_wal_lsn(),oldest_lsn))
FROM oldest_mod_walfile;




