# Queries to analyze Designing of  tables and statistics 

## Objective: Having some queries to analyze Designing of  tables and statistics from Redshit 



## Gathering context information
  * **table_def.sql:** Get details from  table's definition 
  * **analyze_compression_act.sql:** Get analyze compression activities
  * **candidates_sortkey_filter.sql and WITH_candidates_sortkey_filter.sql:** Get candidates to sortkey filters
  * **query_stats.sql:** Get queries stats
  * **statistics_tables_1.sql:** Analyzing the tables
  * **statistics_tables_2.sql:** Analyzing the tables 2
  * **analyze_compression.sql:** Get compression's analysis  
  * **statistics_query_queue.sql:** Get queries waiting on a WLM Query Slot 
  

## Resources
  * Some of the following queries are a variant of  [amazon-redshift-utils](https://github.com/awslabs/amazon-redshift-utils) 
  * The data was gathering from Redshift's catalog views and tables, the PostgreSQL's catalog was also used (`stl_ and pg` )
  