
This query returns these fields:



* last_analyze_compression: timestamp for the last compression analysis  .
* tblname: the table name.
* col: num of column.
* attname : name of column
* old_encoding: type of old compression of this column.
* new_encoding: the suggestion of new compression.





```
last_analyze_compression    |tablename   | col | attname  |old_encoding     | new_encoding
----------------------------+------------+-----+----------+-----------------+----------------
 2020-10-14 15:07:05.909295 | my_table   |   0 | i        | az64            | zstd           
 2020-10-14 15:07:05.909295 | my_table   |   1 | j        | az64            | zstd           
 2020-10-14 15:07:05.909295 | my_table   |   2 | k        | az64            | raw            

```

Consider change the type of  compression using `new_encoding` output:

