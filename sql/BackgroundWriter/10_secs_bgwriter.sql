-- 10 second iteration for calculate bgwriter activity
WITH tara AS (
  SELECT 
    checkpoints_timed     ,
    checkpoints_req       ,
    checkpoint_write_time ,
    checkpoint_sync_time  ,
    buffers_checkpoint    ,
    buffers_clean         ,
    maxwritten_clean      ,
    buffers_backend       ,
    buffers_backend_fsync ,
    buffers_alloc         
    from pg_stat_bgwriter, pg_sleep(10)
)
SELECT 
    pgb.checkpoints_timed     - tara.checkpoints_timed,
    pgb.checkpoints_req       - tara.checkpoints_req,
    pgb.checkpoint_write_time - tara.checkpoint_write_time,
    pgb.checkpoint_sync_time  - tara.checkpoint_sync_time,
    pgb.buffers_checkpoint    - tara.buffers_checkpoint,
    pgb.buffers_clean         - tara.buffers_clean,
    pgb.maxwritten_clean      - tara.maxwritten_clean,
    pgb.buffers_backend       - tara.buffers_backend,
    pgb.buffers_backend_fsync - tara.buffers_backend_fsync,
    pgb.buffers_alloc      - tara.buffers_alloc
    FROM pg_stat_bgwriter pgb,tara
; 
