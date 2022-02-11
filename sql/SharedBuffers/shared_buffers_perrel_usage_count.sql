-- This is more odd way to see the landscape of the usagecount per buffer.
-- We seek here how static are buffers on each relation. This can give us the 
-- lead if we run short of shared_buffers.
-- set session statement_timeout='45s'; 
WITH viewbuf AS (
select c.relname as rel, usagecount, count(*) as bufcount,
    --pg_size_pretty(pg_relation_size(c.oid)) as relation_size
    percentile_cont(0.5) WITHIN GROUP (ORDER BY usagecount) as score_median,
    pg_relation_size(c.oid),
    c.oid as reloid, 
    c.relpages
FROM pg_buffercache b INNER JOIN pg_class c
             ON b.relfilenode = pg_relation_filenode(c.oid) AND
                b.reldatabase IN (0, (SELECT oid FROM pg_database
                                      WHERE datname = current_database()))
GROUP BY c.relname, usagecount, c.oid, c.relpages
ORDER BY c.relname
)
-- Maximum 6 values per array. 
-- We array everything cause there could be absent _states_ of the usagecount.
-- Both ixcount and usagecount are correlative in order, order_by_bufcount is the
-- one that gives you the order on the amount of buffers per each usagecount.
-- The highed the 5' scored blocks on a relation the better. Unfortunately there are 
-- many scenarios of when and how the score of blocks can vary, so to give an idea
-- we ideally need to collect all of this information and aggregate.
SELECT rel, 
       array_agg(usagecount order by usagecount desc) as ixcount , 
       score_median,
       array_agg(bufcount order by usagecount desc) as usagecount,
       array_agg(usagecount order by bufcount desc) as order_by_bufcount
FROM viewbuf
group by rel , score_median--, relation_size
order by usagecount desc
limit 20;


