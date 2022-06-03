

## Multixact ID

An identifier used to support row locking by multiple transactions.

A multixact ID is an internal identifier used  support row locking by multiple transactions.

Multixact IDs are created when transactions use "SELECT … FOR UPDATE" (or one of these lock modes: SHARE, KEY SHARE, NO KEY UPDATE) to lock and update tuples.

Multixact IDs live in the pg_multixact directory.

[See Pgpedia](https://pgpedia.info/m/multixact-id.html#:~:text=A%20multixact%20ID%20is%20an,live%20in%20the%20pg_multixact%20directory.)

## Related errors

```
ERROR:  multixact "members" limit exceeded
```

Related HINT:

```
HINT:  Execute a database-wide VACUUM in database with OID 16398 with reduced vacuum_multixact_freeze_min_age and vacuum_multixact_freeze_table_age settings.
```

## Temporal tables and Multixact

Temporal tables can also exhaust the multixact capacity. For those, a VACUUM won't make much if it is not forced to do an aggressive scan (that is, 
not relying only on dead tuples but in xid).

- Check that no open backends, sessions or active are sticking temporal tables.
- Restart the instance, so temporal tables get removed from the pg_temp*.

