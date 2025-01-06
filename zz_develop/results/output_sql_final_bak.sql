
-- perm_attributes
CREATE TABLE IF NOT EXISTS lx.perm_attributes_local on cluster default_cluster (
    `id` UInt64,
    `entity_type` String,
    `entity_id` String,
    `name` String,
    `type` String,
    `value` String,
    `created_by` String,
    `created_at` Nullable(String),
    `updated_at` Nullable(String),
    `SrcCDBID` String,
    `SrcDatabaseName` String,
    `_sign` Int8,
    `_version` UInt64
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/tables/perm_attributes/{shard}', '{replica}', _version)
ORDER BY (SrcCDBID, SrcDatabaseName, id)
SETTINGS index_granularity = 8192;

CREATE TABLE IF NOT EXISTS lx.perm_attributes on cluster default_cluster (
    `id` UInt64,
    `entity_type` String,
    `entity_id` String,
    `name` String,
    `type` String,
    `value` String,
    `created_by` String,
    `created_at` Nullable(String),
    `updated_at` Nullable(String),
    `SrcCDBID` String,
    `SrcDatabaseName` String,
    `_sign` Int8,
    `_version` UInt64
)
ENGINE = Distributed('default_cluster', 'lx', 'perm_attributes_local', cityHash64(toString(tuple(id))));


-- perm_relationships
CREATE TABLE IF NOT EXISTS lx.perm_relationships_local on cluster default_cluster (
    `id` UInt64,
    `entity_type` String,
    `entity_id` String,
    `relation` String,
    `subject_type` String,
    `subject_id` String,
    `subject_relation` String,
    `created_by` String,
    `created_at` Nullable(String),
    `updated_at` Nullable(String),
    `SrcCDBID` String,
    `SrcDatabaseName` String,
    `_sign` Int8,
    `_version` UInt64
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/tables/perm_relationships/{shard}', '{replica}', _version)
ORDER BY (SrcCDBID, SrcDatabaseName, id)
SETTINGS index_granularity = 8192;

CREATE TABLE IF NOT EXISTS lx.perm_relationships on cluster default_cluster (
    `id` UInt64,
    `entity_type` String,
    `entity_id` String,
    `relation` String,
    `subject_type` String,
    `subject_id` String,
    `subject_relation` String,
    `created_by` String,
    `created_at` Nullable(String),
    `updated_at` Nullable(String),
    `SrcCDBID` String,
    `SrcDatabaseName` String,
    `_sign` Int8,
    `_version` UInt64
)
ENGINE = Distributed('default_cluster', 'lx', 'perm_relationships_local', cityHash64(toString(tuple(id))));


-- learning_roadmaps
ALTER TABLE lx.learning_roadmaps_local on cluster default_cluster ADD COLUMN IF NOT EXISTS `enable_member_remind_immediately` Int8 DEFAULT 0 COMMENT '是否开启新加入项目立即提醒' AFTER `enable_manager_remind`;
ALTER TABLE lx.learning_roadmaps on cluster default_cluster ADD COLUMN IF NOT EXISTS `enable_member_remind_immediately` Int8 DEFAULT 0 COMMENT '是否开启新加入项目立即提醒' AFTER `enable_manager_remind`;

ALTER TABLE lx.learning_roadmaps_local on cluster default_cluster ADD COLUMN IF NOT EXISTS `new_member_remind_times` String DEFAULT '' COMMENT '提醒新成员的时间' AFTER `enable_member_remind_immediately`;
ALTER TABLE lx.learning_roadmaps on cluster default_cluster ADD COLUMN IF NOT EXISTS `new_member_remind_times` String DEFAULT '' COMMENT '提醒新成员的时间' AFTER `enable_member_remind_immediately`;

