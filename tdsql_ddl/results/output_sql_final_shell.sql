
-- kb_permission_applications
CREATE TABLE IF NOT EXISTS lx.kb_permission_applications_local on cluster default_cluster (`incr_id` UInt64,`id` String,`target_type` String,`target_id` String,`apply_permission` String,`approved_permission` String,`description` String,`status` Int8,`approval_type` Int8,`created_by` String,`approved_by` String,`approved_at` Nullable(UInt64),`expired_at` Nullable(UInt64),`created_at` Nullable(String),`updated_at` Nullable(String),`SrcCDBID` String,`SrcDatabaseName` String,`_sign` Int8,`_version` UInt64) ENGINE = ReplicatedReplacingMergeTree('/clickhouse/tables/kb_permission_applications/{shard}', '{replica}', _version) ORDER BY (SrcCDBID, SrcDatabaseName, incr_id) SETTINGS index_granularity = 8192;

CREATE TABLE IF NOT EXISTS lx.kb_permission_applications on cluster default_cluster (`incr_id` UInt64,`id` String,`target_type` String,`target_id` String,`apply_permission` String,`approved_permission` String,`description` String,`status` Int8,`approval_type` Int8,`created_by` String,`approved_by` String,`approved_at` Nullable(UInt64),`expired_at` Nullable(UInt64),`created_at` Nullable(String),`updated_at` Nullable(String),`SrcCDBID` String,`SrcDatabaseName` String,`_sign` Int8,`_version` UInt64) ENGINE = Distributed('default_cluster', 'lx', 'kb_permission_applications_local', cityHash64(toString(tuple(incr_id))));


-- ud_field_values
CREATE TABLE IF NOT EXISTS lx.ud_field_values_local on cluster default_cluster (`incr_id` UInt64,`field_id` String,`origin_field_id` String DEFAULT '',`entity_type` String,`entity_id` String,`value` String,`created_by` String,`updated_by` String,`created_at` Nullable(String),`updated_at` Nullable(String),`SrcCDBID` String,`SrcDatabaseName` String,`_sign` Int8,`_version` UInt64) ENGINE = ReplicatedReplacingMergeTree('/clickhouse/tables/ud_field_values/{shard}', '{replica}', _version) ORDER BY (SrcCDBID, SrcDatabaseName, incr_id) SETTINGS index_granularity = 8192;

CREATE TABLE IF NOT EXISTS lx.ud_field_values on cluster default_cluster (`incr_id` UInt64,`field_id` String,`origin_field_id` String DEFAULT '',`entity_type` String,`entity_id` String,`value` String,`created_by` String,`updated_by` String,`created_at` Nullable(String),`updated_at` Nullable(String),`SrcCDBID` String,`SrcDatabaseName` String,`_sign` Int8,`_version` UInt64) ENGINE = Distributed('default_cluster', 'lx', 'ud_field_values_local', cityHash64(toString(tuple(incr_id))));


-- kb_permission_approvals
CREATE TABLE IF NOT EXISTS lx.kb_permission_approvals_local on cluster default_cluster (`incr_id` UInt64,`apply_id` String,`approver` String,`approved_at` Nullable(UInt64),`expired_at` Nullable(UInt64),`created_at` Nullable(String),`updated_at` Nullable(String),`SrcCDBID` String,`SrcDatabaseName` String,`_sign` Int8,`_version` UInt64) ENGINE = ReplicatedReplacingMergeTree('/clickhouse/tables/kb_permission_approvals/{shard}', '{replica}', _version) ORDER BY (SrcCDBID, SrcDatabaseName, incr_id) SETTINGS index_granularity = 8192;

CREATE TABLE IF NOT EXISTS lx.kb_permission_approvals on cluster default_cluster (`incr_id` UInt64,`apply_id` String,`approver` String,`approved_at` Nullable(UInt64),`expired_at` Nullable(UInt64),`created_at` Nullable(String),`updated_at` Nullable(String),`SrcCDBID` String,`SrcDatabaseName` String,`_sign` Int8,`_version` UInt64) ENGINE = Distributed('default_cluster', 'lx', 'kb_permission_approvals_local', cityHash64(toString(tuple(incr_id))));


-- kb_entries
ALTER TABLE lx.kb_entries_local on cluster default_cluster ADD COLUMN IF NOT EXISTS `status` UInt32 DEFAULT 0 COMMENT 'entry解析状态' AFTER `entry_type`;
ALTER TABLE lx.kb_entries on cluster default_cluster ADD COLUMN IF NOT EXISTS `status` UInt32 DEFAULT 0 COMMENT 'entry解析状态' AFTER `entry_type`;


-- kb_files
ALTER TABLE lx.kb_files_local on cluster default_cluster ADD COLUMN IF NOT EXISTS `status` UInt32 DEFAULT 0 COMMENT 'file解析状态' AFTER `revision_id`;
ALTER TABLE lx.kb_files on cluster default_cluster ADD COLUMN IF NOT EXISTS `status` UInt32 DEFAULT 0 COMMENT 'file解析状态' AFTER `revision_id`;


-- kb_file_revisions
ALTER TABLE lx.kb_file_revisions_local on cluster default_cluster ADD COLUMN IF NOT EXISTS `created_from` String DEFAULT '' COMMENT '来源' AFTER `reverted_from`;
ALTER TABLE lx.kb_file_revisions on cluster default_cluster ADD COLUMN IF NOT EXISTS `created_from` String DEFAULT '' COMMENT '来源' AFTER `reverted_from`;


-- learning_roadmaps
ALTER TABLE lx.learning_roadmaps_local on cluster default_cluster ADD COLUMN IF NOT EXISTS `enable_board_remind` UInt8 DEFAULT 0 COMMENT '是否开启学员直属上级看板提醒' AFTER `new_member_remind_times`;
ALTER TABLE lx.learning_roadmaps on cluster default_cluster ADD COLUMN IF NOT EXISTS `enable_board_remind` UInt8 DEFAULT 0 COMMENT '是否开启学员直属上级看板提醒' AFTER `new_member_remind_times`;

ALTER TABLE lx.learning_roadmaps_local on cluster default_cluster ADD COLUMN IF NOT EXISTS `board_remind_start_time` Nullable(String) COMMENT '开始提醒时间' AFTER `enable_board_remind`;
ALTER TABLE lx.learning_roadmaps on cluster default_cluster ADD COLUMN IF NOT EXISTS `board_remind_start_time` Nullable(String) COMMENT '开始提醒时间' AFTER `enable_board_remind`;

ALTER TABLE lx.learning_roadmaps_local on cluster default_cluster ADD COLUMN IF NOT EXISTS `board_remind_end_time` Nullable(String) COMMENT '结束提醒时间' AFTER `board_remind_start_time`;
ALTER TABLE lx.learning_roadmaps on cluster default_cluster ADD COLUMN IF NOT EXISTS `board_remind_end_time` Nullable(String) COMMENT '结束提醒时间' AFTER `board_remind_start_time`;

ALTER TABLE lx.learning_roadmaps_local on cluster default_cluster ADD COLUMN IF NOT EXISTS `board_remind_times` String DEFAULT '' COMMENT '上级看板提醒时间段' AFTER `board_remind_end_time`;
ALTER TABLE lx.learning_roadmaps on cluster default_cluster ADD COLUMN IF NOT EXISTS `board_remind_times` String DEFAULT '' COMMENT '上级看板提醒时间段' AFTER `board_remind_end_time`;

