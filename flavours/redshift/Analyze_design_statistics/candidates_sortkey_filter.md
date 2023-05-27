This query return these fields:



* table: the table name.
* filter: filter found
* querytext: the query





```
  table   |            filter             |                               querytext                               
----------+-------------------------------+------------------------------------------------------------------
 my_table | Filter: ((i % 2::bigint) = 0) | select count(*), avg(j),max(j),min(j) from my_table where i%2=0;
 my_table | Filter: (i < 5)               | select count(*), avg(j),max(j),min(j) from my_table where i<5;

```


Consider create a sortkey in filter output:

```
alter table my_table ALTER  SORTKEY ( i);
```
