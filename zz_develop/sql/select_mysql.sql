SELECT concat_ws('&^*=','update',a.TABLE_NAME,a.COLUMN_NAME,b.COLUMN_NAME,a.COLUMN_COMMENT) from
        (SELECT * FROM information_schema.COLUMNS
        WHERE TABLE_SCHEMA = 'swan_1168e4c6e75711efaea61ea75098e1da' AND TABLE_NAME = 'learning_roadmaps' and COLUMN_NAME in('manager_remind_config')) a
        join information_schema.COLUMNS b on b.TABLE_SCHEMA = 'swan_1168e4c6e75711efaea61ea75098e1da' AND b.TABLE_NAME = 'learning_roadmaps' and a.ORDINAL_POSITION = b.ORDINAL_POSITION + 1
            ;