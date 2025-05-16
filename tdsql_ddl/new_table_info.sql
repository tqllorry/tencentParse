-- 【DB变更审核】

-- 时间：20250425

-- 公司库：
-- event_attendees[新增字段 incr_id, session_id, 新增唯一索引(event_id, session_id, staff_id), 移除主键(event_id, staff_id), 新增主键(incr_id)]
-- event_attend_applications[新增字段 session_id, 新增唯一索引(event_id, session_id, staff_id), 移除索引(event_id, staff_id)]
-- event_staff[新增字段 session_id, quit_at, 新增唯一索引(event_id, session_id, staff_id), 移除索引(event_id, staff_id)]
-- event_sessions[新建表]
-- token_package_logs[新建表]
-- parse_package_logs[新建表]
-- token_packages[新建表]
-- parse_packages[新建表]
-- flux_packages[新增字段 sub_server_type]
-- storage_packages[新增字段 sub_server_type]

