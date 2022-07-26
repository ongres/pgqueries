
## [WIP] Candidate relations for freeze vacuuming

This is an eg result set of the query:


|                   relation         | oldest_current_xid | autovacuum_freeze_max_age | percent_towards_emergency_autovacuum |    size    
|------------------------------------|--------------------|---------------------------|--------------------------------------|------------
| table1                             |          185106698 |                 200000000 |                                   99 | 32 MB
| table2                             |          185106698 |                 200000000 |                                   99 | 56 kB
| table3                             |          185106698 |                 200000000 |                                   93 | 184 kB
| table4l                            |          185106698 |                 200000000 |                                   93 | 64 kB
| tablex                             |          185106698 |                 200000000 |                                   93 | 64 kB
| tablep                             |          185106698 |                 200000000 |                                   93 | 48 kB


On `percent_towards_emergency_autovacuum` in 100%, autovacuum will run in aggressive mode. That is, it will freeze rows on each run
but also, will force a block read to disk.

The sizes are useful for estimate how long the execution will take, but this is also relative to the concurrency, indexes and other factors.
