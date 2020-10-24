
This query returns these fields:



* table: the table name.
* distkey: distribution key.
* skew: A low skew value indicates that table data is properly distributed. If a table has a skew value of 4.00 or higher, consider modifying its data distribution style.
* sortkey: sort key.
* rows: rows stimated
* enc: compresion eanble
* pct_stats_off: A high  value indicates that the table required `ANALYZE` command.
* pct_unsorted: If a table has a pct_unsorted value greater than 20 percent, consider running the `VACUUM` command



```
      table       | distkey |  skew  | sortkey | rows  | enc | pct_stats_off | pct_unsorted 
------------------+---------+--------+---------+-------+-----+---------------+--------------
 public.my_table2 | i       | 1.0000 | i       | 10000 | Y   |          0.00 |         0.00
 public.my_table  | i       | 1.0000 | i       | 10000 | Y   |          0.00 |         0.00
 public.my_table3 |         | 1.0000 |         |  5000 | Y   |         99.99 |         1.00    


```

