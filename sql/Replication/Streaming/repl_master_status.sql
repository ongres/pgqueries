-- Get status of slots and replication senders 9.6
-- Execute this on master
SELECT * 
FROM pg_stat_replication        sr
    JOIN pg_replication_slots   rs
    ON (sr.pid = rs.active_pid);