-- This is more odd way to see the landscape of the usagecount per buffer.
-- We seek here how static are buffers on each relation. This can give us the 
-- lead if we run short of shared_buffers.
WITH viewbuf AS (
select c.relname as rel, usagecount, count(*) as bufcount
FROM pg_buffercache b INNER JOIN pg_class c
             ON b.relfilenode = pg_relation_filenode(c.oid) AND
                b.reldatabase IN (0, (SELECT oid FROM pg_database
                                      WHERE datname = current_database()))
GROUP BY c.relname, usagecount
ORDER BY c.relname
)
-- Maximum 6 values per array. 
-- We array everything cause there could be absent _states_ of the usagecount.
SELECT rel, array_agg(usagecount order by usagecount desc) as ixcount , array_agg(bufcount order by usagecount desc) as usagecount
FROM viewbuf
group by rel
order by usagecount desc;


