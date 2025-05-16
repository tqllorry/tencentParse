SELECT concat_ws('&^*=','update',a.TABLE_NAME,a.COLUMN_NAME,b.COLUMN_NAME,a.COLUMN_COMMENT) from
        (SELECT * FROM information_schema.COLUMNS
        WHERE TABLE_SCHEMA = 'swan_1caf5b76218111f09b7c9ec801154f04' AND TABLE_NAME = 'event_attendees' and COLUMN_NAME in('incr_id', 'session_id', '新增唯一索引(event_id', 'session_id', 'staff_id)', '移除主键(event_id', 'staff_id)', '新增主键(incr_id)')) a
        join information_schema.COLUMNS b on b.TABLE_SCHEMA = 'swan_1caf5b76218111f09b7c9ec801154f04' AND b.TABLE_NAME = 'event_attendees' and if(a.ORDINAL_POSITION = 1, 2, a.ORDINAL_POSITION) = b.ORDINAL_POSITION + 1
             UNION ALL
SELECT concat_ws('&^*=','update',a.TABLE_NAME,a.COLUMN_NAME,b.COLUMN_NAME,a.COLUMN_COMMENT) from
        (SELECT * FROM information_schema.COLUMNS
        WHERE TABLE_SCHEMA = 'swan_1caf5b76218111f09b7c9ec801154f04' AND TABLE_NAME = 'event_attend_applications' and COLUMN_NAME in('session_id', '新增唯一索引(event_id', 'session_id', 'staff_id)', '移除索引(event_id', 'staff_id)')) a
        join information_schema.COLUMNS b on b.TABLE_SCHEMA = 'swan_1caf5b76218111f09b7c9ec801154f04' AND b.TABLE_NAME = 'event_attend_applications' and if(a.ORDINAL_POSITION = 1, 2, a.ORDINAL_POSITION) = b.ORDINAL_POSITION + 1
             UNION ALL
SELECT concat_ws('&^*=','update',a.TABLE_NAME,a.COLUMN_NAME,b.COLUMN_NAME,a.COLUMN_COMMENT) from
        (SELECT * FROM information_schema.COLUMNS
        WHERE TABLE_SCHEMA = 'swan_1caf5b76218111f09b7c9ec801154f04' AND TABLE_NAME = 'event_staff' and COLUMN_NAME in('session_id', 'quit_at', '新增唯一索引(event_id', 'session_id', 'staff_id)', '移除索引(event_id', 'staff_id)')) a
        join information_schema.COLUMNS b on b.TABLE_SCHEMA = 'swan_1caf5b76218111f09b7c9ec801154f04' AND b.TABLE_NAME = 'event_staff' and if(a.ORDINAL_POSITION = 1, 2, a.ORDINAL_POSITION) = b.ORDINAL_POSITION + 1
             UNION ALL
SELECT concat_ws('&^*=','add','event_sessions',(SELECT COLUMN_NAME FROM information_schema.COLUMNS WHERE TABLE_SCHEMA='swan_1caf5b76218111f09b7c9ec801154f04' AND TABLE_NAME='event_sessions' and COLUMN_KEY='PRI')) UNION ALL
SELECT concat_ws('&^*=','add','token_package_logs',(SELECT COLUMN_NAME FROM information_schema.COLUMNS WHERE TABLE_SCHEMA='swan_1caf5b76218111f09b7c9ec801154f04' AND TABLE_NAME='token_package_logs' and COLUMN_KEY='PRI')) UNION ALL
SELECT concat_ws('&^*=','add','parse_package_logs',(SELECT COLUMN_NAME FROM information_schema.COLUMNS WHERE TABLE_SCHEMA='swan_1caf5b76218111f09b7c9ec801154f04' AND TABLE_NAME='parse_package_logs' and COLUMN_KEY='PRI')) UNION ALL
SELECT concat_ws('&^*=','add','token_packages',(SELECT COLUMN_NAME FROM information_schema.COLUMNS WHERE TABLE_SCHEMA='swan_1caf5b76218111f09b7c9ec801154f04' AND TABLE_NAME='token_packages' and COLUMN_KEY='PRI')) UNION ALL
SELECT concat_ws('&^*=','add','parse_packages',(SELECT COLUMN_NAME FROM information_schema.COLUMNS WHERE TABLE_SCHEMA='swan_1caf5b76218111f09b7c9ec801154f04' AND TABLE_NAME='parse_packages' and COLUMN_KEY='PRI')) UNION ALL
SELECT concat_ws('&^*=','update',a.TABLE_NAME,a.COLUMN_NAME,b.COLUMN_NAME,a.COLUMN_COMMENT) from
        (SELECT * FROM information_schema.COLUMNS
        WHERE TABLE_SCHEMA = 'swan_1caf5b76218111f09b7c9ec801154f04' AND TABLE_NAME = 'flux_packages' and COLUMN_NAME in('sub_server_type')) a
        join information_schema.COLUMNS b on b.TABLE_SCHEMA = 'swan_1caf5b76218111f09b7c9ec801154f04' AND b.TABLE_NAME = 'flux_packages' and if(a.ORDINAL_POSITION = 1, 2, a.ORDINAL_POSITION) = b.ORDINAL_POSITION + 1
             UNION ALL
SELECT concat_ws('&^*=','update',a.TABLE_NAME,a.COLUMN_NAME,b.COLUMN_NAME,a.COLUMN_COMMENT) from
        (SELECT * FROM information_schema.COLUMNS
        WHERE TABLE_SCHEMA = 'swan_1caf5b76218111f09b7c9ec801154f04' AND TABLE_NAME = 'storage_packages' and COLUMN_NAME in('sub_server_type')) a
        join information_schema.COLUMNS b on b.TABLE_SCHEMA = 'swan_1caf5b76218111f09b7c9ec801154f04' AND b.TABLE_NAME = 'storage_packages' and if(a.ORDINAL_POSITION = 1, 2, a.ORDINAL_POSITION) = b.ORDINAL_POSITION + 1
            ;