-- 【DB变更审核】

-- 时间：20250331

-- 公司库：
-- kb_permission_applications[新建表]
-- kb_permission_approvals[新建表]
-- ud_field_values[新建表]
-- kb_entries[新增字段 status, 新建索引(parent_id, status)]
-- kb_files[新增字段 status, 新建索引(entry_id, status)]
-- kb_file_revisions[新增字段 created_from]
-- learning_roadmaps[新增字段 enable_board_remind, board_remind_start_time, board_remind_end_time, board_remind_times]


