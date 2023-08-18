# IO analysis

Taking advantage from the new view [pg_stat_io](https://www.postgresql.org/docs/devel/monitoring-stats.html#MONITORING-PG-STAT-IO-VIEW) released in PG16 , it is possible to see statitics about backend type and IO operations

The queries for this porpose can be used to check the information about:


* Analyze the impact of vacuum in IO activity (high is bad,maybe >10% ?)
* Analyze the impact of client backend in fsync activity (high is bad,maybe >10% ?)

TODO: analyze , top IO consumer, top evictions