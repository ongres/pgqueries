# Lock contention analysis

Originilly published by Nikolai Samodkalov from [Modern Postgres Monitoring](https://docs.google.com/presentation/d/1taKST9H59FG7MKtVLUlqQ_WozJfRQ1MFidnN7HxBQ6U/edit#slide=id.g24d913ededf_0_22).

Recommended to execute with `\watch Nsecs` (where Nsecs is the wait seconds).

This query returns the locks affecting PIDS, the state of the lock and the query from 
the PID. It also provides the current xid held by the PID and the longest xmin impacting
on the query.

Use this statement whenever you want to hunt locking transactions.