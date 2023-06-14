-- xmin horizon
-- Originally written by Nikolai Samokhvalov 
-- Slides can be found at https://docs.google.com/presentation/d/1taKST9H59FG7MKtVLUlqQ_WozJfRQ1MFidnN7HxBQ6U/edit#slide=id.g24d913ededf_0_14
with bits as (
  select
    (
      select age(backend_xmin) as xmin_age_local
      from pg_stat_activity
      order by xmin_age_local desc nulls last
      limit 1),
    (
      select age(xmin) as xmin_age_slots
      from pg_replication_slots
      order by xmin_age_slots desc nulls last
      limit 1
    ),
    (
      select age(transaction) as xmin_age_prepared_xacts
      from pg_prepared_xacts
      order by xmin_age_prepared_xacts desc nulls last
      limit 1
    )
)
select
  *,
  case
    when pg_is_in_recovery() then null
    else greatest(xmin_age_local, xmin_age_slots, xmin_age_prepared_xacts)
  end as xmin_age
from bits;
