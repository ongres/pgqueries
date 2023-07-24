-- Get status of slots and replication senders 9.6
-- Execute this on master
SELECT 
  pid, application_name, client_addr, backend_start,
  sent_location,write_location,flush_location,replay_location,
  slot_name, xmin, active_pid,
  pg_xlog_location_diff(pg_current_xlog_location(),sent_location) as local_queue_diff,
  pg_xlog_location_diff(pg_current_xlog_location(),replay_location) as remote_delta
FROM pg_stat_replication        sr
    JOIN pg_replication_slots   rs
    ON (sr.pid = rs.active_pid);
