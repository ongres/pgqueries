# PgQueries

This repository contains a collection of useful PostgreSQL queries for daily
troubleshooting and analysis.

It is intended to have a programatic way to store queries and mark them depending
the version on top of which they work (that is, in the future, we can execute
a query version depending on the server).

## Organization and formats

- use `.sql` for SQLs and Procedural Languages.
- use `.md` within the same file name as the .sql if you want to include 
  documentation of the query and its contents.


When you add a `.sql`, please add a line like the bellow at the top:

```
-- This query does THIS. 9.0
-- Optional comments explaining what this does and what it shouldn't
```

Version isn't mandatory, although we'll make sure that all sqls have a small comment like this.
The more the comments, the better.

The hierarchical tree is compound by:

```
sql/<category>/file.[sql|md]
```



## SQL formatting and practices

Rule 1:

> Try to make backward compatible queries or even better, provide different queries per version.
> eg. Queries using advanced properties of CTE or recursive, LATERAL, FDW, etc can be used, but
> try to provide their version for older versions or at least add them in the TODO.md

Rule 2: 

> First comment line is mandatory. Minimal accepted documentation.

## Testing

TODO

(We do have an easy way to spin up docker images from all available versions and trigger queries
against them). Probably we can reuse postgresqlco.nf infrastructure for this.

Something like [egres QA](https://gitlab.com/ongresinc/devel/egres/egres_qa/tree/compose) could work.


## Resources

[SQL tricks for Postgres/PostGIS](https://abelvm.github.io/sql/sql-tricks/) 



## References and other repositories

- https://github.com/NikolayS/postgres_dba/tree/master/sql
- https://github.com/ioguix/pgsql-bloat-estimation/tree/master/table
- https://wiki.postgresql.org/wiki/Show_database_bloat
- https://github.com/hvf/franchise


