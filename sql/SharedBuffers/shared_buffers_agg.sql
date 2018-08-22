-- Aggregating the info in buffercache to have a pincture of the shared buffers usage shape.
WITH bufs AS (
SELECT  c.relname as rel, count(*) AS buffers, 
        sum(usagecount) as score, 
        count(Case when isdirty then 1 end )   as dirtpages
             FROM pg_buffercache b INNER JOIN pg_class c
             ON b.relfilenode = pg_relation_filenode(c.oid) AND
                b.reldatabase IN (0, (SELECT oid FROM pg_database
                                      WHERE datname = current_database()))
             GROUP BY c.relname
             ORDER BY 2 DESC
             LIMIT 20
)
SELECT rel, buffers, (buffers * 8) /1024 as size_MB, score,  dirtpages
from bufs
;


SELECT count(*), sum(usagecount) ,  count(case when isdirty then 1 end )
FROM pg_buffercache;

