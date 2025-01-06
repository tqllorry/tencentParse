
-- kb_files
CREATE TABLE IF NOT EXISTS lx.kb_files_local on cluster default_cluster (
    `incr_id` UInt64,
    `id` String,
    `entry_id` String,
    `revision_id` String,
    `downloadable` Int8,
    `created_by` String,
    `updated_by` String,
    `deleted_at` UInt64,
    `created_at` Nullable(String),
    `updated_at` Nullable(String),
    `SrcCDBID` String,
    `SrcDatabaseName` String,
    `_sign` Int8,
    `_version` UInt64
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/tables/kb_files/{shard}', '{replica}', _version)
ORDER BY (SrcCDBID, SrcDatabaseName, incr_id)
SETTINGS index_granularity = 8192;

CREATE TABLE IF NOT EXISTS lx.kb_files on cluster default_cluster (
    `incr_id` UInt64,
    `id` String,
    `entry_id` String,
    `revision_id` String,
    `downloadable` Int8,
    `created_by` String,
    `updated_by` String,
    `deleted_at` UInt64,
    `created_at` Nullable(String),
    `updated_at` Nullable(String),
    `SrcCDBID` String,
    `SrcDatabaseName` String,
    `_sign` Int8,
    `_version` UInt64
)
ENGINE = Distributed('default_cluster', 'lx', 'kb_files_local', cityHash64(toString(tuple(incr_id))));


-- kb_spaces
CREATE TABLE IF NOT EXISTS lx.kb_spaces_local on cluster default_cluster (
    `incr_id` UInt64,
    `id` String,
    `name` String,
    `description` String,
    `logo` String,
    `team_id` String,
    `privilege_type` Int8,
    `colab_space_id` String,
    `root_entry_id` String,
    `version` UInt64,
    `created_by` String,
    `updated_by` String,
    `owned_by` String,
    `deleted_at` UInt64,
    `created_at` Nullable(String),
    `updated_at` Nullable(String),
    `SrcCDBID` String,
    `SrcDatabaseName` String,
    `_sign` Int8,
    `_version` UInt64
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/tables/kb_spaces/{shard}', '{replica}', _version)
ORDER BY (SrcCDBID, SrcDatabaseName, incr_id)
SETTINGS index_granularity = 8192;

CREATE TABLE IF NOT EXISTS lx.kb_spaces on cluster default_cluster (
    `incr_id` UInt64,
    `id` String,
    `name` String,
    `description` String,
    `logo` String,
    `team_id` String,
    `privilege_type` Int8,
    `colab_space_id` String,
    `root_entry_id` String,
    `version` UInt64,
    `created_by` String,
    `updated_by` String,
    `owned_by` String,
    `deleted_at` UInt64,
    `created_at` Nullable(String),
    `updated_at` Nullable(String),
    `SrcCDBID` String,
    `SrcDatabaseName` String,
    `_sign` Int8,
    `_version` UInt64
)
ENGINE = Distributed('default_cluster', 'lx', 'kb_spaces_local', cityHash64(toString(tuple(incr_id))));


-- kb_file_revisions
CREATE TABLE IF NOT EXISTS lx.kb_file_revisions_local on cluster default_cluster (
    `incr_id` UInt64,
    `id` String,
    `file_id` String,
    `reverted_from` String,
    `name` String,
    `path` String,
    `size` UInt32,
    `ext` String,
    `seq` UInt32,
    `created_by` String,
    `created_at` Nullable(String),
    `deleted_at` UInt64,
    `SrcCDBID` String,
    `SrcDatabaseName` String,
    `_sign` Int8,
    `_version` UInt64
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/tables/kb_file_revisions/{shard}', '{replica}', _version)
ORDER BY (SrcCDBID, SrcDatabaseName, incr_id)
SETTINGS index_granularity = 8192;

CREATE TABLE IF NOT EXISTS lx.kb_file_revisions on cluster default_cluster (
    `incr_id` UInt64,
    `id` String,
    `file_id` String,
    `reverted_from` String,
    `name` String,
    `path` String,
    `size` UInt32,
    `ext` String,
    `seq` UInt32,
    `created_by` String,
    `created_at` Nullable(String),
    `deleted_at` UInt64,
    `SrcCDBID` String,
    `SrcDatabaseName` String,
    `_sign` Int8,
    `_version` UInt64
)
ENGINE = Distributed('default_cluster', 'lx', 'kb_file_revisions_local', cityHash64(toString(tuple(incr_id))));


-- kb_entries
CREATE TABLE IF NOT EXISTS lx.kb_entries_local on cluster default_cluster (
    `incr_id` UInt64,
    `id` String,
    `space_id` String,
    `parent_id` String,
    `name` String,
    `entry_type` String,
    `target_type` String,
    `target_id` String,
    `sort_id` UInt64,
    `version` UInt64,
    `children_count` UInt32,
    `privilege_type` Int8,
    `extension` String,
    `extra` String,
    `created_by` String,
    `updated_by` String,
    `edited_by` String,
    `owned_by` String,
    `edited_at` Nullable(String),
    `deleted_at` UInt64,
    `deleted_by` String DEFAULT \'\',
    `deleted_from_entry_id` String DEFAULT \'\',
    `created_at` Nullable(String),
    `updated_at` Nullable(String),
    `SrcCDBID` String,
    `SrcDatabaseName` String,
    `_sign` Int8,
    `_version` UInt64
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/tables/kb_entries/{shard}', '{replica}', _version)
ORDER BY (SrcCDBID, SrcDatabaseName, incr_id)
SETTINGS index_granularity = 8192;

CREATE TABLE IF NOT EXISTS lx.kb_entries on cluster default_cluster (
    `incr_id` UInt64,
    `id` String,
    `space_id` String,
    `parent_id` String,
    `name` String,
    `entry_type` String,
    `target_type` String,
    `target_id` String,
    `sort_id` UInt64,
    `version` UInt64,
    `children_count` UInt32,
    `privilege_type` Int8,
    `extension` String,
    `extra` String,
    `created_by` String,
    `updated_by` String,
    `edited_by` String,
    `owned_by` String,
    `edited_at` Nullable(String),
    `deleted_at` UInt64,
    `deleted_by` String DEFAULT \'\',
    `deleted_from_entry_id` String DEFAULT \'\',
    `created_at` Nullable(String),
    `updated_at` Nullable(String),
    `SrcCDBID` String,
    `SrcDatabaseName` String,
    `_sign` Int8,
    `_version` UInt64
)
ENGINE = Distributed('default_cluster', 'lx', 'kb_entries_local', cityHash64(toString(tuple(incr_id))));

