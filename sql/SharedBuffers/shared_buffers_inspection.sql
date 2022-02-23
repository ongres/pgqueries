-- Required pg_buffercache contrib. Inspects the usage of the shared_buffers
WITH bufs AS (
SELECT  c.relname as rel, 
        count(*) AS buffers, 
        sum(usagecount) as score, 
        count(Case when isdirty then 1 end )   as dirtypages,
        percentile_cont(0.5) WITHIN GROUP (ORDER BY usagecount) as score_median,
        sum(pinning_backends) as pinbackend,
        sum(c.relpages) as relpages
             FROM pg_buffercache b INNER JOIN pg_class c
             ON b.relfilenode = pg_relation_filenode(c.oid) AND
                b.reldatabase IN (0, (SELECT oid FROM pg_database
                                      WHERE datname = current_database()))
             GROUP BY c.relname
             ORDER BY 2 DESC
             -- In the case of Productive environments, you can limit the number of relations to reduce the LWLock issuing.
             -- LIMIT 20
)
,
_settings AS (
     -- TODO: We want also to consider wal_buffers, max_connection allocations
     SELECT setting::int 
        FROM pg_settings WHERE name = 'shared_buffers'   
)

SELECT rel, buffers, 
        (buffers * 8) /1024 as size_MB,
        -- The score weight returns the score in relation to the amount of buffers 
        score/buffers as score_weight, 
        score_median,  
        dirtypages,
        -- Commented this column as it is not useful in statistically terms in this query.  
        -- pinbackend,
        round(((100*dirtypages::double precision)/buffers::double precision)::numeric,2) as dirt_perc,
        -- The reason of so large rounding threshold is because large tables might
        -- bias the result. This returns the percentage of the relation allocated in the shared buffers
        -- FIXME: Probably a logaritmic could help to identify hot page chunks.
        CASE 
        WHEN relpages<>0 THEN
        round(((100*buffers::double precision)/relpages::double precision)::numeric,8) 
        ELSE 0
        END as alloc_rel_perc,
        -- The percentage of shared buffers allocated by the table
        round(((100*buffers::double precision)/s.setting::double precision)::numeric,8) as perc_alloc_in_sb,
        -- The total amount of allocated buffers in megabytes
        sum(((buffers*8)/1024)) OVER () as MB_alloc,
        -- The percentage of dirty shared buffers
        sum(  round(((100*dirtypages::double precision)/s.setting::double precision)::numeric,2) ) OVER () as dirty_perc_of_sb

from bufs b, _settings s
;
