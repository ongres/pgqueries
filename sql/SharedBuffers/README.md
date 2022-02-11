# Shared Buffer Inspection

## pgbuffercache

> Beware using this extension during concurrency peaks, as a LWLock is issued to have a consistent view of the shared space.


## The usage count internals

Each block has a "Clock-sweep access count" score from 0 to 5. What this means is that
the usage count is the current _score_ of backends pinning that buffer going from 0 (
dirtied or non used atm) to 5 (meaning 5 or more backends are accessing now, with
no strategy set). The clock-seep algorithm is explained in detail at `src/backend/storage/buffer/README`.

```
// bufmgr.c
 * PinBuffer -- make buffer unavailable for replacement.
 *
 * For the default access strategy, the buffer's usage_count is incremented
 * when we first pin it; for other strategies we just make sure the usage_count
 * isn't zero.  (The idea of the latter is that we don't want synchronized
 * heap scans to inflate the count, but we need it to not be zero to discourage
 * other backends from stealing buffers from our ring.  As long as we cycle
 * through the ring faster than the global clock-sweep cycles, buffers in
 * our ring won't be chosen as victims for replacement by other backends.)
```


It can give the perspective of the block's _heat-state_.
Each time a backend _pins_ a buffer, it increases by `buf_state += BUF_USAGECOUNT_ONE;`
(bufmgr.c, BUF_USAGECOUNT_ONE is constant 1 ) and decreases through `UnpinBuffer` (bufmgr.c) function
within the same constant step.

This value only rises until it gets writen to its top, `BM_MAX_USAGE_COUNT` to avoid 
favoritism.

If a page is used, its minimum is 1 (ring securing), leaving it at 0 when unpinning. A usagecount buffer
0 means it is dirty or it is not being used.


```
//buf_internals.h
/*
 * The maximum allowed value of usage_count represents a tradeoff between
 * accuracy and speed of the clock-sweep buffer management algorithm.  A
 * large value (comparable to NBuffers) would approximate LRU semantics.
 * But it can take as many as BM_MAX_USAGE_COUNT+1 complete cycles of
 * clock sweeps to find a free buffer, so in practice we don't want the
 * value to be very large.
 */
#define BM_MAX_USAGE_COUNT	5
```

The Clock-sweep is a 256k buffer ring designed to fit in L3 cache in a single instruction. To be processed by the CPU, blocks have to be pinned.

