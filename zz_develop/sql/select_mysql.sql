SELECT concat_ws('&^*=','add','learning_roadmap_tag_staff',(SELECT COLUMN_NAME FROM information_schema.COLUMNS WHERE TABLE_SCHEMA='swan_cfb4e750c65911efbd257e2579a8d90c' AND TABLE_NAME='learning_roadmap_tag_staff' and COLUMN_KEY='PRI')) UNION ALL
SELECT concat_ws('&^*=','add','content_selections',(SELECT COLUMN_NAME FROM information_schema.COLUMNS WHERE TABLE_SCHEMA='swan_cfb4e750c65911efbd257e2579a8d90c' AND TABLE_NAME='content_selections' and COLUMN_KEY='PRI')) UNION ALL
SELECT concat_ws('&^*=','update',a.TABLE_NAME,a.COLUMN_NAME,b.COLUMN_NAME,a.COLUMN_COMMENT) from
        (SELECT * FROM information_schema.COLUMNS
        WHERE TABLE_SCHEMA = 'swan_cfb4e750c65911efbd257e2579a8d90c' AND TABLE_NAME = 'documents' and COLUMN_NAME in('enable_select')) a
        join information_schema.COLUMNS b on b.TABLE_SCHEMA = 'swan_cfb4e750c65911efbd257e2579a8d90c' AND b.TABLE_NAME = 'documents' and a.ORDINAL_POSITION = b.ORDINAL_POSITION + 1
            ;