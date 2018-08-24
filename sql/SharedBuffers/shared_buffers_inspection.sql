-- Required pg_buffercache contrib. Inspects the usage of the shared_buffers
WITH bufs AS (
SELECT  c.relname as rel, count(*) AS buffers, 
        sum(usagecount) as score, 
        count(Case when isdirty then 1 end )   as dirtpages,
        sum(pinning_backends) as pinbackend,
        sum(c.relpages) as relpages
             FROM pg_buffercache b INNER JOIN pg_class c
             ON b.relfilenode = pg_relation_filenode(c.oid) AND
                b.reldatabase IN (0, (SELECT oid FROM pg_database
                                      WHERE datname = current_database()))
             GROUP BY c.relname
             ORDER BY 2 DESC
             LIMIT 20
) -- returns the most populated relations in SB in that order
SELECT rel, buffers, (buffers * 8) /1024 as size_MB, 
        score,  dirtpages, pinbackend,
        round(((100*dirtpages::double precision)/buffers::double precision)::numeric,2) as dirt_perc,
        round(((100*buffers::double precision)/relpages::double precision)::numeric,8) as perc_of_rel_in_SB
from bufs
;

