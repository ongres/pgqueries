-- getting publication info more verbose 10
select  pubname, pu.usename, puballtables , 
        pr.prrelid::regclass as source_class, 
        ltrim(case pubinsert when true then ' ins' end || case pubdelete when true then ' del' end || case pubupdate when true then ' upd' end)  as events 
from pg_publication pp 
 join pg_publication_rel pr 
   on pp.oid = prpubid 
 join pg_user pu 
   on (pu.usesysid = pp.pubowner);