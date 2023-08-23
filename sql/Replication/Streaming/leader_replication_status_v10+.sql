-- Only for getting the status of those pids for streaming replication.
-- 
SELECT 	client_addr, 
		client_hostname, 
		client_port, 
		rs.slot_name, 
		rs.slot_type,
		state, 
		pg_wal_lsn_diff(pg_current_wal_flush_lsn(), flush_lsn), --in bytes
		pg_size_pretty(pg_wal_lsn_diff(pg_current_wal_flush_lsn(), flush_lsn)), 
		pg_wal_lsn_diff(pg_current_wal_lsn(), write_lsn) as fromCurrentToWriteLSN, --in bytes
		pg_size_pretty(pg_wal_lsn_diff(pg_current_wal_lsn(), write_lsn)) as fromCurrentToWriteLSN_pretty, 
		write_lsn, sent_lsn, flush_lsn, replay_lsn,
		write_lag, flush_lag, replay_lag,
		rs.restart_lsn, rs.confirmed_flush_lsn,
		sync_state, sync_priority
	FROM pg_stat_replication sr JOIN pg_replication_slots rs
	ON (sr.pid = rs.active_pid)
	WHERE rs.slot_type = 'physical';