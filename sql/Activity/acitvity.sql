-- Get activity and lock state
SELECT (now() - a.query_start) > '00:01:00'::interval AS long_tx,
   a.pid,
   u.usename AS username,
   a.wait_event_type,
   now() - a.query_start AS "time",
   kl.pid AS b_pid,
   a.state,
   a.query
  FROM pg_stat_activity a
    JOIN pg_user u ON a.usesysid = u.usesysid
    LEFT JOIN pg_locks l ON l.pid = a.pid AND NOT l.granted
    LEFT JOIN pg_locks kl ON l.transactionid = kl.transactionid AND l.pid <> kl.pid
 WHERE 
    a.query <> '<IDLE>'::text 
    -- AND NOT a.query ~~ '%-- ME%'::text 
    AND a.pid <> pg_backend_pid() 
    AND a.state <> 'idle'::text
 ORDER BY a.query_start;
