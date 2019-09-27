## Information about columns

Name |	Type|	References|	Description|
-----|------|-----------|------------|
transaction |	xid	|| Numeric transaction identifier of the prepared transaction
gid |	text|	| Global transaction identifier that was assigned to the transaction
prepared |	timestamp with time zone ||	Time at which the transaction was prepared for commit
owner|	name|	pg_authid.rolname|	Name of the user that executed the transaction
database|	name|	pg_database.datname	|Name of the database in which the transaction was executed

## Example
#### Create database and table
```
postgres=# create database prepared_xacts;
CREATE DATABASE
postgres=#\c prepared_xacts
prepared_xacts=# create table test (id  int) ;
CREATE TABLE
```
#### Start the process
```
prepared_xacts=# BEGIN;
BEGIN
prepared_xacts=# insert INTO test values (1); --Insert the amount of data you want
INSERT 0 1
prepared_xacts=# PREPARE transaction 'trx1';
PREPARE TRANSACTION
prepared_xacts=#select * from test;
 id
----
(0 rows)
prepared_xacts=# SELECT * from pg_prepared_xacts ;
 transaction | gid  |           prepared            |  owner   |    database    
-------------+------+-------------------------------+----------+----------------
     2042336 | trx1 | 2019-09-27 16:56:19.818131+02 | postgres | prepared_xacts
(1 fila)

prepared_xacts=# COMMIT PREPARED 'trx1';
COMMIT PREPARED
prepared_xacts=# select * from test;
 id
----
  1
  1
  1
  2
  2
 10
 10
(7 filas)

```

It can be noted that until the commit is made, no change is reflected
