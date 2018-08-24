-- logical replication slot info 10
select * 
from pg_replication_slots prs join 
    pg_subscription pgs on prs.slot_name = pgs.subslotname
where slot_type = 'logical';