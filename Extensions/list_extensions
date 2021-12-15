-- List all the available extensions in the system.
-- This is the same as executing \dx in psql, but not all clients support listing extensions. 
-- It also discards obsoletes.
select * 
  from pg_available_extensions() 
  where comment not like '%(obsolete)%' 
  order by 1;
