-- Version:  PostgreSQL 8.0.2 on i686-pc-linux-gnu, compiled by GCC gcc (GCC) 3.4.2 20041017 (Red Hat 3.4.2-6.fc3), Redshift 1.0.19884
--candidate to sortkey filter
with sub as (
select 
trim(s.perm_Table_name) as table , substring(trim(info),1,580) as filter, 
sum(datediff(seconds,starttime,case when starttime > endtime then starttime else endtime end)) as secs,
count(distinct i.query) as num, 
max(i.query) as query
from stl_explain p
join stl_plan_info i on ( i.userid=p.userid and i.query=p.query and i.nodeid=p.nodeid  )
join stl_scan s on (s.userid=i.userid and s.query=i.query and s.segment=i.segment and s.step=i.step)
where s.starttime > dateadd(day, -7, current_Date)
and s.perm_table_name not like 'Internal Worktable%'
and (( p.info like 'Filter:%'  and p.nodeid > 0 ) or p.info like 'Join Filter:%')
AND trim(s.perm_Table_name)   NOT LIKE 'S3 %'
group by 1,2 order by 1, 3 desc , 4 desc)
select  sub.table,sub.filter,(select text as query from pg_catalog.stl_querytext sq where query = sub.query) as querytext  from sub ;