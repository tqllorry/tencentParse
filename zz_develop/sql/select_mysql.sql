SELECT concat_ws('&^*=','add','perm_relationships',(SELECT COLUMN_NAME FROM information_schema.COLUMNS WHERE TABLE_SCHEMA='swan_cfb4e750c65911efbd257e2579a8d90c' AND TABLE_NAME='perm_relationships' and COLUMN_KEY='PRI')) UNION ALL
SELECT concat_ws('&^*=','add','perm_attributes',(SELECT COLUMN_NAME FROM information_schema.COLUMNS WHERE TABLE_SCHEMA='swan_cfb4e750c65911efbd257e2579a8d90c' AND TABLE_NAME='perm_attributes' and COLUMN_KEY='PRI')) UNION ALL
SELECT concat_ws('&^*=','update',a.TABLE_NAME,a.COLUMN_NAME,b.COLUMN_NAME,a.COLUMN_COMMENT) from
        (SELECT * FROM information_schema.COLUMNS
        WHERE TABLE_SCHEMA = 'swan_cfb4e750c65911efbd257e2579a8d90c' AND TABLE_NAME = 'learning_roadmaps' and COLUMN_NAME in('enable_member_remind_immediately', 'new_member_remind_times')) a
        join information_schema.COLUMNS b on b.TABLE_SCHEMA = 'swan_cfb4e750c65911efbd257e2579a8d90c' AND b.TABLE_NAME = 'learning_roadmaps' and a.ORDINAL_POSITION = b.ORDINAL_POSITION + 1
            ;