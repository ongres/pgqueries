-- Current amount of WALs present in the waldir
with oldest_mod_walfile as (
    select (substring(name from 9 for 8) || '/' || substring(name from 17 for 8 ))::pg_lsn as oldest_lsn
        from pg_ls_waldir() 
        where name not ilike '%history%' /* Skip .history files */
        order by modification desc limit 1
)
select pg_size_pretty(pg_wal_lsn_diff( pg_current_wal_lsn(),oldest_lsn))
from oldest_mod_walfile;




