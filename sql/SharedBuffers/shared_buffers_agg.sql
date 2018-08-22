-- Aggregating the info in buffercache to have a pincture of the shared buffers usage shape.
SELECT count(*), sum(usagecount) ,  count(case when isdirty then 1 end ), sum(pinning_backends)
FROM pg_buffercache;

