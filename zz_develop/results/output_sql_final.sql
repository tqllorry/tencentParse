
-- learning_roadmap_tag_staff
CREATE TABLE IF NOT EXISTS lx.learning_roadmap_tag_staff_local on cluster default_cluster (
    `id` UInt64,
    `tag_id` String,
    `staff_id` String,
    `created_at` Nullable(String),
    `updated_at` Nullable(String),
    `SrcCDBID` String,
    `SrcDatabaseName` String,
    `_sign` Int8,
    `_version` UInt64
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/tables/learning_roadmap_tag_staff/{shard}', '{replica}', _version)
ORDER BY (SrcCDBID, SrcDatabaseName, id)
SETTINGS index_granularity = 8192;

CREATE TABLE IF NOT EXISTS lx.learning_roadmap_tag_staff on cluster default_cluster (
    `id` UInt64,
    `tag_id` String,
    `staff_id` String,
    `created_at` Nullable(String),
    `updated_at` Nullable(String),
    `SrcCDBID` String,
    `SrcDatabaseName` String,
    `_sign` Int8,
    `_version` UInt64
)
ENGINE = Distributed('default_cluster', 'lx', 'learning_roadmap_tag_staff_local', cityHash64(toString(tuple(id))));


-- content_selections
CREATE TABLE IF NOT EXISTS lx.content_selections_local on cluster default_cluster (
    `incr_id` UInt64,
    `id` String,
    `target_type` String,
    `target_id` String,
    `comment_id` String,
    `selection` String,
    `selection_md5` String,
    `created_at` Nullable(String),
    `updated_at` Nullable(String),
    `SrcCDBID` String,
    `SrcDatabaseName` String,
    `_sign` Int8,
    `_version` UInt64
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/tables/content_selections/{shard}', '{replica}', _version)
ORDER BY (SrcCDBID, SrcDatabaseName, incr_id)
SETTINGS index_granularity = 8192;

CREATE TABLE IF NOT EXISTS lx.content_selections on cluster default_cluster (
    `incr_id` UInt64,
    `id` String,
    `target_type` String,
    `target_id` String,
    `comment_id` String,
    `selection` String,
    `selection_md5` String,
    `created_at` Nullable(String),
    `updated_at` Nullable(String),
    `SrcCDBID` String,
    `SrcDatabaseName` String,
    `_sign` Int8,
    `_version` UInt64
)
ENGINE = Distributed('default_cluster', 'lx', 'content_selections_local', cityHash64(toString(tuple(incr_id))));


-- documents
ALTER TABLE lx.documents_local on cluster default_cluster ADD COLUMN IF NOT EXISTS `enable_select` Int8 COMMENT '是否开启划词' AFTER `enable_copy_limit`;
ALTER TABLE lx.documents on cluster default_cluster ADD COLUMN IF NOT EXISTS `enable_select` Int8 COMMENT '是否开启划词' AFTER `enable_copy_limit`;

