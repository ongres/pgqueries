--  Getting the most written tables 
SELECT  relname,  
(n_tup_ins + n_tup_upd + n_tup_del + n_tup_hot_upd ) as swrites ,
n_tup_ins, n_tup_upd, n_tup_del,n_tup_hot_upd
FROM pg_stat_user_tables
order by swrites desc limit 10;