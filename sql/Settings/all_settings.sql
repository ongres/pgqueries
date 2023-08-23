-- Get settings ordered by context
SELECT name, setting, 
    short_desc::text , extra_desc::text, 
        context
FROM pg_settings
ORDER BY context;
