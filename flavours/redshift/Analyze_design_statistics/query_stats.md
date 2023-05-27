
This query returns these fields:



* db: database name  .
* n_qry: num times of query executed.
* qrytext: the query.
* min : min time used by the query
* max: max time used by the query
* avg: avg time used by the query
* total: total time used by the query
* last_run: timestamp for last run of query





```
 db  | n_qry |                             qrytext                              | min  | max  | avg  | total |          last_run          | aborted 
-----+-------+------------------------------------------------------------------+------+------+------+-------+----------------------------+---------
 dev |     2 | select count(*), avg(j),max(j),min(j) from my_table where i%2=0; | 0.00 | 1.00 | 0.50 |  1.00 | 2020-10-14 15:21:41.689595 |       0
 dev |     2 | select count(*), avg(j),max(j),min(j) from my_table where i<5;   | 0.00 | 0.00 | 0.00 |  0.00 | 2020-10-14 15:21:42.850863 |       0

```