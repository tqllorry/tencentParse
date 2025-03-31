SELECT concat_ws('&^*=','add','kb_permission_applications',(SELECT COLUMN_NAME FROM information_schema.COLUMNS WHERE TABLE_SCHEMA='swan_e1dc97900df611f0becb92cf1d6e1d6b' AND TABLE_NAME='kb_permission_applications' and COLUMN_KEY='PRI')) UNION ALL
SELECT concat_ws('&^*=','add','kb_permission_approvals',(SELECT COLUMN_NAME FROM information_schema.COLUMNS WHERE TABLE_SCHEMA='swan_e1dc97900df611f0becb92cf1d6e1d6b' AND TABLE_NAME='kb_permission_approvals' and COLUMN_KEY='PRI')) UNION ALL
SELECT concat_ws('&^*=','add','ud_field_values',(SELECT COLUMN_NAME FROM information_schema.COLUMNS WHERE TABLE_SCHEMA='swan_e1dc97900df611f0becb92cf1d6e1d6b' AND TABLE_NAME='ud_field_values' and COLUMN_KEY='PRI')) UNION ALL
SELECT concat_ws('&^*=','update',a.TABLE_NAME,a.COLUMN_NAME,b.COLUMN_NAME,a.COLUMN_COMMENT) from
        (SELECT * FROM information_schema.COLUMNS
        WHERE TABLE_SCHEMA = 'swan_e1dc97900df611f0becb92cf1d6e1d6b' AND TABLE_NAME = 'kb_entries' and COLUMN_NAME in('status', '新建索引(parent_id', 'status)')) a
        join information_schema.COLUMNS b on b.TABLE_SCHEMA = 'swan_e1dc97900df611f0becb92cf1d6e1d6b' AND b.TABLE_NAME = 'kb_entries' and a.ORDINAL_POSITION = b.ORDINAL_POSITION + 1
             UNION ALL
SELECT concat_ws('&^*=','update',a.TABLE_NAME,a.COLUMN_NAME,b.COLUMN_NAME,a.COLUMN_COMMENT) from
        (SELECT * FROM information_schema.COLUMNS
        WHERE TABLE_SCHEMA = 'swan_e1dc97900df611f0becb92cf1d6e1d6b' AND TABLE_NAME = 'kb_files' and COLUMN_NAME in('status', '新建索引(entry_id', 'status)')) a
        join information_schema.COLUMNS b on b.TABLE_SCHEMA = 'swan_e1dc97900df611f0becb92cf1d6e1d6b' AND b.TABLE_NAME = 'kb_files' and a.ORDINAL_POSITION = b.ORDINAL_POSITION + 1
             UNION ALL
SELECT concat_ws('&^*=','update',a.TABLE_NAME,a.COLUMN_NAME,b.COLUMN_NAME,a.COLUMN_COMMENT) from
        (SELECT * FROM information_schema.COLUMNS
        WHERE TABLE_SCHEMA = 'swan_e1dc97900df611f0becb92cf1d6e1d6b' AND TABLE_NAME = 'kb_file_revisions' and COLUMN_NAME in('created_from')) a
        join information_schema.COLUMNS b on b.TABLE_SCHEMA = 'swan_e1dc97900df611f0becb92cf1d6e1d6b' AND b.TABLE_NAME = 'kb_file_revisions' and a.ORDINAL_POSITION = b.ORDINAL_POSITION + 1
             UNION ALL
SELECT concat_ws('&^*=','update',a.TABLE_NAME,a.COLUMN_NAME,b.COLUMN_NAME,a.COLUMN_COMMENT) from
        (SELECT * FROM information_schema.COLUMNS
        WHERE TABLE_SCHEMA = 'swan_e1dc97900df611f0becb92cf1d6e1d6b' AND TABLE_NAME = 'learning_roadmaps' and COLUMN_NAME in('enable_board_remind', 'board_remind_start_time', 'board_remind_end_time', 'board_remind_times')) a
        join information_schema.COLUMNS b on b.TABLE_SCHEMA = 'swan_e1dc97900df611f0becb92cf1d6e1d6b' AND b.TABLE_NAME = 'learning_roadmaps' and a.ORDINAL_POSITION = b.ORDINAL_POSITION + 1
            ;