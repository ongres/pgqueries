# Some insights on buffercache 

There is a misterious usagecount column in the pg_buffercache does have the 
not so explicit description of "Clock-sweep access count". What this means is that
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



We can think on this value as an score, and can give us the idea of its _heat-state_.
Each time a backend _pins_ a buffer, it increases by `buf_state += BUF_USAGECOUNT_ONE;`
(bufmgr.c, BUF_USAGECOUNT_ONE is constant 1 ) and decreases through `UnpinBuffer` (bufmgr.c) function
within the same constant step.

This value only rises until it gets writen to its top, `BM_MAX_USAGE_COUNT` to avoid 
favoritism.

If a page is used, its minimum is 1 (ring securing), leaving it at 0 when unpinning. A usagecount buffer
0 means it is dirty or it is not being used.

A LWLock is issued to have a consistent view so beware on executing this during high peaks of concurrency.

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

