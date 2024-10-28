SELECT concat_ws('&^*=','add','platform_message_logs',(SELECT COLUMN_NAME FROM information_schema.COLUMNS WHERE TABLE_SCHEMA='swan_74b570288f7611ef88e5a2fd79ed158a' AND TABLE_NAME='platform_message_logs' and COLUMN_KEY='PRI')) UNION ALL
SELECT concat_ws('&^*=','update',a.TABLE_NAME,a.COLUMN_NAME,b.COLUMN_NAME,a.COLUMN_COMMENT) from
        (SELECT * FROM information_schema.COLUMNS
        WHERE TABLE_SCHEMA = 'swan_74b570288f7611ef88e5a2fd79ed158a' AND TABLE_NAME = 'honor_awards' and COLUMN_NAME in('is_revoked', 'revoked_by')) a
        join information_schema.COLUMNS b on b.TABLE_SCHEMA = 'swan_74b570288f7611ef88e5a2fd79ed158a' AND b.TABLE_NAME = 'honor_awards' and a.ORDINAL_POSITION = b.ORDINAL_POSITION + 1
             UNION ALL
SELECT concat_ws('&^*=','update',a.TABLE_NAME,a.COLUMN_NAME,b.COLUMN_NAME,a.COLUMN_COMMENT) from
        (SELECT * FROM information_schema.COLUMNS
        WHERE TABLE_SCHEMA = 'swan_74b570288f7611ef88e5a2fd79ed158a' AND TABLE_NAME = 'ai_faq' and COLUMN_NAME in('disk_node_id', 'is_audited')) a
        join information_schema.COLUMNS b on b.TABLE_SCHEMA = 'swan_74b570288f7611ef88e5a2fd79ed158a' AND b.TABLE_NAME = 'ai_faq' and a.ORDINAL_POSITION = b.ORDINAL_POSITION + 1
            ;