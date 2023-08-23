-- Execute this on replica to know which is the 
-- files need to be copied. This returns the current WAL LSN in the replica,
-- you should copy all the WAL files newer than this point.
select pg_walfile_name(pg_current_wal_lsn());