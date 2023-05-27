-- Version:  PostgreSQL 8.0.2 on i686-pc-linux-gnu, compiled by GCC gcc (GCC) 3.4.2 20041017 (Red Hat 3.4.2-6.fc3), Redshift 1.0.19884
-- Performs compression analysis and produces a report with the suggested compression encoding for the tables analyzed. The report includes an estimate of the potential reduction in disk space compared to the current encoding.
-- This command acquires an exclusive table lock, be careful
-- This suggested saves disk space and improves query performance for I/O-bound workloads.
ANALYZE COMPRESSION name_of_table;