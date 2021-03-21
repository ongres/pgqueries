
-- This query help us to understand the bgwriter and checkpoint activity
-- and analyze if we need to adjust parameters such us: checkpoint_completion_target, max_wal, bgwriter_delay, bgwriter_lru_maxpages,bgwriter_lru_multiplier

SELECT
    to_char(100 * checkpoints_timed::NUMERIC  / nullif((checkpoints_timed + checkpoints_req),0),'990D9') || ' %' AS "Checkpoints timed",
    to_char(100 * checkpoints_req::NUMERIC    / nullif((checkpoints_timed + checkpoints_req),0),'990D9') || ' %' AS "Checkpoints req",
    '-------' AS "------------------",
    to_char(100 * buffers_checkpoint::NUMERIC / nullif((buffers_checkpoint + buffers_clean + buffers_backend),0),'990D9') || ' %' AS "Written checkpoint",
    to_char(100 * buffers_backend::NUMERIC    / nullif((buffers_checkpoint + buffers_clean + buffers_backend),0),'990D9') || ' %' AS "Written backend",
    to_char(100 * buffers_backend_fsync::NUMERIC    / nullif((buffers_checkpoint + buffers_clean + buffers_backend),0),'990D9') || ' %' AS "Written backend_fsync",
    to_char(100 * buffers_clean::NUMERIC      / nullif((buffers_checkpoint + buffers_clean + buffers_backend),0),'990D9') || ' %' AS "Written clean",
    '-------' AS "------------------",
    pg_size_pretty((buffers_checkpoint + buffers_clean + buffers_backend) * current_setting('block_size')::INTEGER / 
        (EXTRACT (EPOCH FROM current_timestamp - stats_reset))::BIGINT) || ' / s' AS "Size"
FROM pg_stat_bgwriter;

