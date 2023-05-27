
This query returns these fields:



* schemaname: schema of the table.
* tblname: the table name.
* column: name of column.
* type : data type of column
* encoding: type of compression of this column.
* distkey: True if this column is the distribution key for the table.
* sortkey: Order of the column in the sort key
* notnull: null constraint.




```
 schemaname | tablename | column |     type      | encoding | distkey | sortkey | notnull 
------------+-----------+--------+---------------+----------+---------+---------+---------
 public     | my_table  | i      | bigint        | az64     | f       |       0 | f
 public     | my_table  | j      | numeric(18,0) | az64     | f       |       0 | f
 public     | my_table  | k      | date          | az64     | f       |       0 | f

```

