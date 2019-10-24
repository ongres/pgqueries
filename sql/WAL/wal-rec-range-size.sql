-- Size of wals
select pg_size_pretty('16C60/0000002D'::pg_lsn - '16C2B/00000051'::pg_lsn);