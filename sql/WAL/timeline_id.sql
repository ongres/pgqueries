-- get timeline id < 9.6
select substr(pg_xlogfile_name(pg_current_xlog_location()),0,9);