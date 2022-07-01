-- Index definition 
SELECT pg_get_indexdef(indexrelid) AS index_query FROM pg_index WHERE  indrelid = '<index_name>'::regclass;

