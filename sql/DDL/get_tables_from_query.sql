-- Get the tables from a query.
create or replace function get_query_tables(p_query text) returns text[] language plpgsql as $$
declare
  x xml;
begin
  execute 'explain (format xml) ' || p_query into x;
  return xpath('//explain:Relation-Name/text()', x, array[array['explain', 'http://www.postgresql.org/2009/explain']])::text[];
end $$;

select get_query_tables('SELECT 1');
