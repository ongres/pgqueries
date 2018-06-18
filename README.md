## What is this repository about?

This repository only contains SQLs and Procedural Language hacks. Is not intended to use for executing to a server from the repository itself, instead is a way for finding useful queries for getting information from the database.

## Organization and formats

- use .sql for SQLs and Procedural Languages.
- use .md within the same file name as the .sql if you want to include documentation

when you add a .sql, please add a line like the bellow:

```
-- This query does THIS. 9.0
```

Version isn't mandatory, although we'll make sure that all sqls have a small comment like this.
The more the comments, the better.


## Searching

Config file attached for using with https://github.com/etsy/hound

```bash
docker run -d -p 6080:6080 --name hound -v $(pwd):/data etsy/hound
```

Also we recommend to use https://swtch.com/~rsc/regexp/regexp4.html (Google's codesearch)
[codesearch](https://github.com/google/codesearch)

```
export CSEARCHINDEX=$HOME/ongres/pgQueriesCollection/index
./cindex <this_repo>/sql
./csearch <expression>
```


## References and other repositories

https://github.com/NikolayS/postgres_dba/tree/master/sql
https://github.com/ioguix/pgsql-bloat-estimation/tree/master/table
https://wiki.postgresql.org/wiki/Show_database_bloat



