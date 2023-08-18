WITH cte_fsync_client_backend_io AS
  (SELECT sum(fsyncs) fsync_client_backend_io
   FROM pg_stat_io
   WHERE backend_type = 'client backend'
 ),
     cte_fsync_total_io AS
  (SELECT sum(fsyncs) fsync_total_io
   FROM pg_stat_io)
SELECT round((
          (SELECT fsync_client_backend_io
           FROM cte_fsync_client_backend_io) *100)/
  (SELECT fsync_total_io
   FROM cte_fsync_total_io),2) as io_backend_fsync_activity_pct;
