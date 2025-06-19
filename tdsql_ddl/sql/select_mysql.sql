SELECT concat_ws('&^*=','update',a.TABLE_NAME,a.COLUMN_NAME,b.COLUMN_NAME,a.COLUMN_COMMENT) from
        (SELECT * FROM information_schema.COLUMNS
        WHERE TABLE_SCHEMA = 'swan_5b9f2a9244d511f0bb676e8ddda8d6dc' AND TABLE_NAME = 'ai_train_scenarios' and COLUMN_NAME in('enable_rank')) a
        join information_schema.COLUMNS b on b.TABLE_SCHEMA = 'swan_5b9f2a9244d511f0bb676e8ddda8d6dc' AND b.TABLE_NAME = 'ai_train_scenarios' and if(a.ORDINAL_POSITION = 1, 2, a.ORDINAL_POSITION) = b.ORDINAL_POSITION + 1
             UNION ALL
SELECT concat_ws('&^*=','update',a.TABLE_NAME,a.COLUMN_NAME,b.COLUMN_NAME,a.COLUMN_COMMENT) from
        (SELECT * FROM information_schema.COLUMNS
        WHERE TABLE_SCHEMA = 'swan_5b9f2a9244d511f0bb676e8ddda8d6dc' AND TABLE_NAME = 'kb_async_tasks' and COLUMN_NAME in('retry_times')) a
        join information_schema.COLUMNS b on b.TABLE_SCHEMA = 'swan_5b9f2a9244d511f0bb676e8ddda8d6dc' AND b.TABLE_NAME = 'kb_async_tasks' and if(a.ORDINAL_POSITION = 1, 2, a.ORDINAL_POSITION) = b.ORDINAL_POSITION + 1
            ;