-- Worst mean plan time
-- > 13
select queryid, mean_plan_time from pg_stat_statements order by mean_plan_time desc;