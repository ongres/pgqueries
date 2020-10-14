-- Version:  PostgreSQL 8.0.2 on i686-pc-linux-gnu, compiled by GCC gcc (GCC) 3.4.2 20041017 (Red Hat 3.4.2-6.fc3), Redshift 1.0.19884
--query stats
select trim(database) as DB, count(query) as n_qry, max(substring (qrytext,1,80)) as qrytext, min(run_seconds) as "min" , max(run_seconds) as "max", avg(run_seconds) as "avg", sum(run_seconds) as total, 
max(starttime)::timestamp as last_run, aborted
from (
select userid, label, stl_query.query, trim(database) as database, trim(querytxt) as qrytext, md5(trim(querytxt)) as qry_md5, starttime, endtime, datediff(seconds, starttime,endtime)::numeric(12,2) as run_seconds, 
       aborted, decode(alrt.event,'Very selective query filter','Filter','Scanned a large number of deleted rows','Deleted','Nested Loop Join in the query plan','Nested Loop','Distributed a large number of rows across the network','Distributed','Broadcasted a large number of rows across the network','Broadcast','Missing query planner statistics','Stats',alrt.event) as event
from stl_query 
left outer join ( select query, trim(split_part(event,':',1)) as event from STL_ALERT_EVENT_LOG   group by query, trim(split_part(event,':',1)) ) as alrt on alrt.query = stl_query.query
where userid <> 1 
 and (querytxt like 'SELECT%' or querytxt like 'select%' ) 
 and (querytxt not ilike '%PG_%' )
 ) 
group by database, label, qry_md5, aborted
order by 2 desc,6 desc,8 desc limit 50;