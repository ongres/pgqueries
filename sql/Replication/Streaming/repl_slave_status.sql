-- slave status trhough wal receiver status 9.6
SELECT 
        clock_timestamp() - pg_last_xact_replay_timestamp() as delay_time,
        pg_last_xact_replay_timestamp(),
        *
from pg_stat_wal_receiver;
