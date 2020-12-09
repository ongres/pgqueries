
This query returns these fields:



* tblname: the table name.
* size_in_mb: size of tabls in MB.
* has_dist_key: Indicates whether the table has distribution key. 1 indicates a key exists; 0 indicates there is no key. For example, nation does not have a distribution key.
* has_sort_key: Indicates whether the table has a sort key. 1 indicates a key exists; 0 indicates there is no key. For example, nation does not have a sort key.
* has_column_encoding: Indicates whether the table has any compression encodings defined for any of the columns. 1 indicates at least one column has an encoding. 0 indicates there is no encoding. For example, region has no compression encoding.
* ratio_skew_across_slices: An indication of the data distribution skew. A smaller value is good.
* pct_slices_populated: The percentage of slices populated. A larger value is good.



```
    tablename    | size_in_mb | has_dist_key | has_sort_key | has_col_encoding | ratio_skew_across_slices | pct_slices_populated 
-----------------+------------+--------------+--------------+------------------+--------------------------+----------------------
 public.my_table |         22 |            1 |            1 |                1 |                        0 |                  100

```

