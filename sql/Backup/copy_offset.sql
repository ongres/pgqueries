-- copy file offset and at the same time start backup
-- wal-e thingy 
COPY (SELECT file_name,   
	lpad(file_offset::text, 8, '0') AS file_offset 
	FROM pg_xlogfile_name_offset(  
		pg_start_backup('freeze_start_2018-12-08T13:37:02.401092+00:00'))) TO STDOUT WITH CSV HEADER;

