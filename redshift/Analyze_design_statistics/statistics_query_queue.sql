-- Version:  PostgreSQL 8.0.2 on i686-pc-linux-gnu, compiled by GCC gcc (GCC) 3.4.2 20041017 (Red Hat 3.4.2-6.fc3), Redshift 1.0.19884
--queries waiting on a WLM Query Slot queue
--https://docs.aws.amazon.com/redshift/latest/dg/r_STL_WLM_QUERY.html

SELECT 
        q.querytxt AS querytxt
       ,service_class AS class
       ,slot_count AS slots
       ,total_queue_time/1000  AS queue_milseconds
       ,total_exec_time/1000 as exec_milseconds
FROM stl_wlm_query wlm
  LEFT JOIN stl_query q
         ON q.query = wlm.query
        AND q.userid = wlm.userid
WHERE  wlm.total_queue_Time > 0
and ( querytxt ilike '%select%'  ) 
ORDER BY wlm.total_queue_time DESC
        