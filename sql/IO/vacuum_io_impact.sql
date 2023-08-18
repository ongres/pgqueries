WITH cte_vacuum_io AS
  (SELECT sum(READS)+sum(writes)+sum(extends) vacuum_io
   FROM pg_stat_io
   WHERE backend_type = 'autovacuum worker'
     OR (context = 'vacuum'
         AND (READS <> 0
              OR writes <> 0
              OR extends <> 0)) ),
     cte_total_io AS
  (SELECT sum(READS)+sum(writes)+sum(extends) total_io
   FROM pg_stat_io)
SELECT round((
          (SELECT vacuum_io
           FROM cte_vacuum_io) *100)/
  (SELECT total_io
   FROM cte_total_io),2) as io_vacuum_activity_pct;
