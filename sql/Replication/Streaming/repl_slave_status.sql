-- slave status trhough wal receiver status 9.6
SELECT
  pid, status, 
  received_lsn, latest_end_lsn,
  last_msg_receipt_time,
  last_msg_receipt_time - last_msg_send_time as lag_betw_messg,
  clock_timestamp() - pg_last_xact_replay_timestamp() as delay_time,
  pg_last_xact_replay_timestamp()
        
from pg_stat_wal_receiver;
