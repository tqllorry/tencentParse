
-- token_package_logs
CREATE TABLE IF NOT EXISTS lx.token_package_logs_local on cluster default_cluster (
    `id` UInt32,
    `package_id` Int32,
    `consume` UInt64,
    `date` String,
    `created_at` Nullable(String),
    `updated_at` Nullable(String),
    `SrcCDBID` String,
    `SrcDatabaseName` String,
    `_sign` Int8,
    `_version` UInt64,
    `SrcCDBID` String,
    `SrcDatabaseName` String,
    `_sign` Int8,
    `_version` UInt64
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/tables/token_package_logs/{shard}', '{replica}', _version)
ORDER BY (SrcCDBID, SrcDatabaseName, id)
SETTINGS index_granularity = 8192;

CREATE TABLE IF NOT EXISTS lx.token_package_logs on cluster default_cluster (
    `id` UInt32,
    `package_id` Int32,
    `consume` UInt64,
    `date` String,
    `created_at` Nullable(String),
    `updated_at` Nullable(String),
    `SrcCDBID` String,
    `SrcDatabaseName` String,
    `_sign` Int8,
    `_version` UInt64,
    `SrcCDBID` String,
    `SrcDatabaseName` String,
    `_sign` Int8,
    `_version` UInt64
)
ENGINE = Distributed('default_cluster', 'lx', 'token_package_logs_local', cityHash64(toString(tuple(id))));


-- event_sessions
CREATE TABLE IF NOT EXISTS lx.event_sessions_local on cluster default_cluster (
    `id` String,
    `event_id` String,
    `sequence` Int16,
    `location` String,
    `team_id` Nullable(String),
    `privilege_type` Int16,
    `closed_at` Nullable(String),
    `started_at` Nullable(String),
    `ended_at` Nullable(String),
    `duration` UInt32,
    `participant_count` UInt32,
    `attendee_count` UInt32,
    `participant_count_limit` Nullable(UInt32),
    `enable_random_extract` Int8,
    `created_by` String,
    `updated_by` Nullable(String),
    `created_at` Nullable(String),
    `updated_at` Nullable(String),
    `deleted_at` Nullable(String),
    `attend_method` String,
    `attend_location` String,
    `latitude` Float64,
    `longitude` Float64,
    `radius` Float64,
    `deleted_by` Nullable(String),
    `attend_start_at` Nullable(String),
    `attend_end_at` Nullable(String),
    `SrcCDBID` String,
    `SrcDatabaseName` String,
    `_sign` Int8,
    `_version` UInt64,
    `SrcCDBID` String,
    `SrcDatabaseName` String,
    `_sign` Int8,
    `_version` UInt64
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/tables/event_sessions/{shard}', '{replica}', _version)
ORDER BY (SrcCDBID, SrcDatabaseName, id)
SETTINGS index_granularity = 8192;

CREATE TABLE IF NOT EXISTS lx.event_sessions on cluster default_cluster (
    `id` String,
    `event_id` String,
    `sequence` Int16,
    `location` String,
    `team_id` Nullable(String),
    `privilege_type` Int16,
    `closed_at` Nullable(String),
    `started_at` Nullable(String),
    `ended_at` Nullable(String),
    `duration` UInt32,
    `participant_count` UInt32,
    `attendee_count` UInt32,
    `participant_count_limit` Nullable(UInt32),
    `enable_random_extract` Int8,
    `created_by` String,
    `updated_by` Nullable(String),
    `created_at` Nullable(String),
    `updated_at` Nullable(String),
    `deleted_at` Nullable(String),
    `attend_method` String,
    `attend_location` String,
    `latitude` Float64,
    `longitude` Float64,
    `radius` Float64,
    `deleted_by` Nullable(String),
    `attend_start_at` Nullable(String),
    `attend_end_at` Nullable(String),
    `SrcCDBID` String,
    `SrcDatabaseName` String,
    `_sign` Int8,
    `_version` UInt64,
    `SrcCDBID` String,
    `SrcDatabaseName` String,
    `_sign` Int8,
    `_version` UInt64
)
ENGINE = Distributed('default_cluster', 'lx', 'event_sessions_local', cityHash64(toString(tuple(id))));


-- parse_package_logs
CREATE TABLE IF NOT EXISTS lx.parse_package_logs_local on cluster default_cluster (
    `id` UInt32,
    `package_id` Int32,
    `consume` UInt64,
    `date` String,
    `created_at` Nullable(String),
    `updated_at` Nullable(String),
    `SrcCDBID` String,
    `SrcDatabaseName` String,
    `_sign` Int8,
    `_version` UInt64,
    `SrcCDBID` String,
    `SrcDatabaseName` String,
    `_sign` Int8,
    `_version` UInt64
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/tables/parse_package_logs/{shard}', '{replica}', _version)
ORDER BY (SrcCDBID, SrcDatabaseName, id)
SETTINGS index_granularity = 8192;

CREATE TABLE IF NOT EXISTS lx.parse_package_logs on cluster default_cluster (
    `id` UInt32,
    `package_id` Int32,
    `consume` UInt64,
    `date` String,
    `created_at` Nullable(String),
    `updated_at` Nullable(String),
    `SrcCDBID` String,
    `SrcDatabaseName` String,
    `_sign` Int8,
    `_version` UInt64,
    `SrcCDBID` String,
    `SrcDatabaseName` String,
    `_sign` Int8,
    `_version` UInt64
)
ENGINE = Distributed('default_cluster', 'lx', 'parse_package_logs_local', cityHash64(toString(tuple(id))));


-- token_packages
CREATE TABLE IF NOT EXISTS lx.token_packages_local on cluster default_cluster (
    `id` UInt32,
    `type` UInt8,
    `sub_server_type` String,
    `started_at` String,
    `ended_at` String,
    `status` UInt8,
    `total` UInt64,
    `used` UInt64,
    `created_by` String,
    `order_uuid` String,
    `source` String,
    `created_at` Nullable(String),
    `updated_at` Nullable(String),
    `SrcCDBID` String,
    `SrcDatabaseName` String,
    `_sign` Int8,
    `_version` UInt64,
    `SrcCDBID` String,
    `SrcDatabaseName` String,
    `_sign` Int8,
    `_version` UInt64
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/tables/token_packages/{shard}', '{replica}', _version)
ORDER BY (SrcCDBID, SrcDatabaseName, id)
SETTINGS index_granularity = 8192;

CREATE TABLE IF NOT EXISTS lx.token_packages on cluster default_cluster (
    `id` UInt32,
    `type` UInt8,
    `sub_server_type` String,
    `started_at` String,
    `ended_at` String,
    `status` UInt8,
    `total` UInt64,
    `used` UInt64,
    `created_by` String,
    `order_uuid` String,
    `source` String,
    `created_at` Nullable(String),
    `updated_at` Nullable(String),
    `SrcCDBID` String,
    `SrcDatabaseName` String,
    `_sign` Int8,
    `_version` UInt64,
    `SrcCDBID` String,
    `SrcDatabaseName` String,
    `_sign` Int8,
    `_version` UInt64
)
ENGINE = Distributed('default_cluster', 'lx', 'token_packages_local', cityHash64(toString(tuple(id))));


-- parse_packages
CREATE TABLE IF NOT EXISTS lx.parse_packages_local on cluster default_cluster (
    `id` UInt32,
    `type` UInt8,
    `sub_server_type` String,
    `started_at` String,
    `ended_at` String,
    `status` UInt8,
    `total` UInt64,
    `used` UInt64,
    `created_by` String,
    `order_uuid` String,
    `source` String,
    `created_at` Nullable(String),
    `updated_at` Nullable(String),
    `SrcCDBID` String,
    `SrcDatabaseName` String,
    `_sign` Int8,
    `_version` UInt64,
    `SrcCDBID` String,
    `SrcDatabaseName` String,
    `_sign` Int8,
    `_version` UInt64
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/tables/parse_packages/{shard}', '{replica}', _version)
ORDER BY (SrcCDBID, SrcDatabaseName, id)
SETTINGS index_granularity = 8192;

CREATE TABLE IF NOT EXISTS lx.parse_packages on cluster default_cluster (
    `id` UInt32,
    `type` UInt8,
    `sub_server_type` String,
    `started_at` String,
    `ended_at` String,
    `status` UInt8,
    `total` UInt64,
    `used` UInt64,
    `created_by` String,
    `order_uuid` String,
    `source` String,
    `created_at` Nullable(String),
    `updated_at` Nullable(String),
    `SrcCDBID` String,
    `SrcDatabaseName` String,
    `_sign` Int8,
    `_version` UInt64,
    `SrcCDBID` String,
    `SrcDatabaseName` String,
    `_sign` Int8,
    `_version` UInt64
)
ENGINE = Distributed('default_cluster', 'lx', 'parse_packages_local', cityHash64(toString(tuple(id))));

