-- use pg_sleep(n) to whatever you need.

DO

$$
DECLARE
rec1 pg_stat_bgwriter;
rec2 pg_stat_bgwriter;

BEGIN
SELECT * from pg_stat_bgwriter into rec1;
perform pg_sleep(60);
SELECT * from pg_stat_bgwriter into rec2;


raise notice 'Checkpoints timed: %', rec2.checkpoints_timed - rec1.checkpoints_timed;
raise notice 'Checkpoint requested: %', rec2.checkpoints_req - rec1.checkpoints_req;
raise notice 'Checkpoint write time: %', rec2.checkpoint_write_time - rec1.checkpoint_write_time;
raise notice 'Checpoint sync time: %', rec2.checkpoint_sync_time - rec1.checkpoint_sync_time;
raise notice 'Buffers checkpoint: %', rec2.buffers_checkpoint - rec1.buffers_checkpoint;
raise notice 'Buffers clean: %', rec2.buffers_clean - rec1.buffers_clean;
raise notice 'Max Written Clean: %', rec2.maxwritten_clean - rec1.maxwritten_clean;
raise notice 'Buffers Backend: %', rec2.buffers_backend - rec1.buffers_backend;
raise notice 'Buffers Backend fsync: %', rec2.buffers_backend_fsync - rec1.buffers_backend_fsync;
raise notice 'Buffers Alloc: %', rec2.buffers_alloc - rec1.buffers_alloc;
END;
$$
language plpgsql;