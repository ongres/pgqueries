# xmin horizon query

> Original source by Nikolai Samokhvalov from [Modern PG Monitoring](https://docs.google.com/presentation/d/1taKST9H59FG7MKtVLUlqQ_WozJfRQ1MFidnN7HxBQ6U/edit#slide=id.g123822391b9_0_11).

The query uses the `age` functions with `xmin` parameter and extracts
from the catalog (activity, replication slots, and prepared transactions)
the oldest transaction currently held.

Useful for detecting long-execution transactions.

