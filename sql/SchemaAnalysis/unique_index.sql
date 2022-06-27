-- Get unique indexes through filtering and removing partitioned tables
--
SELECT  count(*) OVER(), c2.relname, i.indisprimary, i.indisunique, i.indisclustered, i.indisvalid, 
        pg_catalog.pg_get_indexdef(i.indexrelid, 0, true) ,
        pg_catalog.pg_get_constraintdef(con.oid, true), 
        contype, condeferrable, condeferred, 
        i.indisreplident, c2.reltablespace
FROM    pg_catalog.pg_class c, 
        pg_catalog.pg_class c2, pg_catalog.pg_index i
    LEFT JOIN   pg_catalog.pg_constraint con 
            ON  (conrelid = i.indrelid 
                    AND conindid = i.indexrelid AND contype IN ('p','u','x'))
WHERE c.oid = i.indrelid 
    AND i.indexrelid = c2.oid
    AND indisunique = true
    AND c.relispartition = false
    AND pg_catalog.pg_get_constraintdef(con.oid, true) ilike '%FILTER%' 
    AND c.relnamespace NOT IN ('pg_toast'::regnamespace)
ORDER BY    i.indisprimary DESC, 
            c2.relname;
