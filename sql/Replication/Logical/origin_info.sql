-- Origins are useful for custom made logical decoding plugins. 10
-- https://www.postgresql.org/docs/10/static/replication-origins.html
-- Origins aren't shared, that's why the status uses local_id and 
-- the origin uses r[epl]o[rigin]ident.
SELECT * 
FROM pg_replication_origin pro 
    join pg_replication_origin_status prs  -- pg_show_replication_origin_status
    ON pro.roident = prs.local_id;