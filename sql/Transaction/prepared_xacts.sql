-- PostgreSQL > 8.2
-- displays information about transactions that are currently prepared for two-phase commit
-- Note that in order to use this view it is necessary to have this value max_prepared_transactions set to 1 in the postgresql.conf file

select * from pg_prepared_xacts;
