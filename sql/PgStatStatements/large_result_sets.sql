-- which queries are returning large result sets, per query
SELECT 
    substring(query,0,100),
    calls,
    rows/calls as rowspercall,
    mean_time,
    shared_blks_hit,
    shared_blks_read
FROM pg_stat_statements
WHERE 
    rows/calls > 1
ORDER BY rowspercall desc