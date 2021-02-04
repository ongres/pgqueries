-- Query for metric the distribution of the deleted tuples across blocks
-- pageinspect is require
-- A function was developed to generalize the query using the table name to analyze  as parameter 
-- To use the function use for example:  SELECT * FROM get_dead_tuples_distribution('pg_class');

create extension pageinspect;

create or replace function get_dead_tuples_distribution (ptab character varying) returns 
table (page_number int, min_position int, max_position int, count_of_row int, count_of_dead int )
as 
$$
declare
begin
	return query execute  
'WITH page_row AS (
    SELECT
        (ctid::text::point)[0] AS page,
        (ctid::text::point)[1] AS ROW
    FROM
        '||$1||'
),
page_count AS (
    SELECT
        count(DISTINCT page) AS pgcnt
FROM
    page_row
)
SELECT
    page::int,
    min(ROW)::int min_pos,
    max(ROW)::int max_pos,
    count(ROW)::int cnt_row,
    (
        SELECT
            count(*)
        FROM
            heap_page_items (get_raw_page ('''||$1||''', page::int))
        WHERE
            lp_flags IN (2, 3)
            AND lp_len = 0)::int cnt_dead
FROM
    page_row
GROUP BY
    page
ORDER BY
    page';
 

end;
$$
language plpgsql; 

