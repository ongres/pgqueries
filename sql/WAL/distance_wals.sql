-- Execute this on replica to know which is the 
-- files need to be copied
select pg_walfile_name(pg_current_wal_lsn());