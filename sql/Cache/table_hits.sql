-- This query gives the Cache-Hit ratio that the whole schema-tables have achived . 9.2+

SELECT
	sum(heap_blks_read) as heap_read,
	sum(heap_blks_hit)  as heap_hit,
	sum(heap_blks_hit) / (sum(heap_blks_hit) + sum(heap_blks_read)) as ratio
FROM
	pg_statio_user_tables;
