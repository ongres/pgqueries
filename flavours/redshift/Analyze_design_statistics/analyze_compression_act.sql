-- Version:  PostgreSQL 8.0.2 on i686-pc-linux-gnu, compiled by GCC gcc (GCC) 3.4.2 20041017 (Red Hat 3.4.2-6.fc3), Redshift 1.0.19884
--get analyze compression activities
select start_time last_analyze_compression, tablename, col,attname,old_encoding,new_encoding 
from stl_analyze_compression ac
JOIN pg_attribute a ON ac.tbl = a.attrelid AND a.attnum-1 = ac.col 
where start_time = (select max(start_time) from stl_analyze_compression where tbl=ac.tbl )
order by tablename,col  