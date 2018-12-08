-- Get a better output of pg_settings
SELECT name, category,
        setting,
        short_desc::text , extra_desc::text, 
        context,
        sourcefile || '#L' || sourceline as varloc
FROM pg_settings
WHERE 
    category ~ '^Replication'
    -- category ~ 'eplication'
ORDER BY context;
