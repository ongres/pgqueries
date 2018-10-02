-- Aggregating the info in buffercache to have a pincture of the shared buffers usage shape.
WITH agg AS ( 
    SELECT count(*) as buffer_count, sum(usagecount) as usagecount,  
       count(case when isdirty then 1 end ) as dirty_buffers, 
       -- round(100*(count(case when isdirty then 1 end ))/count(*)) as dirt_perc, 
       sum(pinning_backends) as pinned_backends
    FROM pg_buffercache
)
SELECT *, round(((100*dirty_buffers::double precision)/buffer_count::double precision)::numeric,2)  as dirt_perc 
FROM agg;
