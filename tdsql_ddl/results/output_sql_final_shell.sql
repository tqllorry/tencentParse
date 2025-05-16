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


-- event_attendees
ALTER TABLE lx.event_attendees_local on cluster default_cluster ADD COLUMN IF NOT EXISTS `incr_id` UInt64 COMMENT '自增字段，优化翻页';
ALTER TABLE lx.event_attendees on cluster default_cluster ADD COLUMN IF NOT EXISTS `incr_id` UInt64 COMMENT '自增字段，优化翻页';

ALTER TABLE lx.event_attendees_local on cluster default_cluster ADD COLUMN IF NOT EXISTS `session_id` String DEFAULT '' COMMENT '活动场次id' AFTER `event_id`;
ALTER TABLE lx.event_attendees on cluster default_cluster ADD COLUMN IF NOT EXISTS `session_id` String DEFAULT '' COMMENT '活动场次id' AFTER `event_id`;


-- event_attend_applications
ALTER TABLE lx.event_attend_applications_local on cluster default_cluster ADD COLUMN IF NOT EXISTS `session_id` String DEFAULT '' COMMENT '活动场次id' AFTER `event_id`;
ALTER TABLE lx.event_attend_applications on cluster default_cluster ADD COLUMN IF NOT EXISTS `session_id` String DEFAULT '' COMMENT '活动场次id' AFTER `event_id`;


-- event_staff
ALTER TABLE lx.event_staff_local on cluster default_cluster ADD COLUMN IF NOT EXISTS `session_id` String DEFAULT '' COMMENT '活动场次id' AFTER `event_id`;
ALTER TABLE lx.event_staff on cluster default_cluster ADD COLUMN IF NOT EXISTS `session_id` String DEFAULT '' COMMENT '活动场次id' AFTER `event_id`;

ALTER TABLE lx.event_staff_local on cluster default_cluster ADD COLUMN IF NOT EXISTS `quit_at` Nullable(String) DEFAULT NULL COMMENT '取消报名时间' AFTER `updated_at`;
ALTER TABLE lx.event_staff on cluster default_cluster ADD COLUMN IF NOT EXISTS `quit_at` Nullable(String) DEFAULT NULL COMMENT '取消报名时间' AFTER `updated_at`;


-- flux_packages
ALTER TABLE lx.flux_packages_local on cluster default_cluster ADD COLUMN IF NOT EXISTS `sub_server_type` String DEFAULT '' COMMENT '区分乐享1.0还是2.0' AFTER `type`;
ALTER TABLE lx.flux_packages on cluster default_cluster ADD COLUMN IF NOT EXISTS `sub_server_type` String DEFAULT '' COMMENT '区分乐享1.0还是2.0' AFTER `type`;


-- storage_packages
ALTER TABLE lx.storage_packages_local on cluster default_cluster ADD COLUMN IF NOT EXISTS `sub_server_type` String DEFAULT '' COMMENT '乐享版本, 空-1.0, v2-2.0' AFTER `type`;
ALTER TABLE lx.storage_packages on cluster default_cluster ADD COLUMN IF NOT EXISTS `sub_server_type` String DEFAULT '' COMMENT '乐享版本, 空-1.0, v2-2.0' AFTER `type`;


-- token_package_logs
CREATE TABLE IF NOT EXISTS lx.token_package_logs_local on cluster default_cluster (`id` UInt32,`package_id` Int32 COMMENT 'token id',`consume` UInt64 COMMENT 'token消耗量',`date` String COMMENT 'token消耗日期',`created_at` Nullable(String) DEFAULT NULL,`updated_at` Nullable(String) DEFAULT NULL,`SrcCDBID` String,`SrcDatabaseName` String,`_sign` Int8,`_version` UInt64) ENGINE = ReplicatedReplacingMergeTree('/clickhouse/tables/token_package_logs/{shard}', '{replica}', _version) ORDER BY (SrcCDBID, SrcDatabaseName, id) SETTINGS index_granularity = 8192;

CREATE TABLE IF NOT EXISTS lx.token_package_logs on cluster default_cluster (`id` UInt32,`package_id` Int32 COMMENT 'token id',`consume` UInt64 COMMENT 'token消耗量',`date` String COMMENT 'token消耗日期',`created_at` Nullable(String) DEFAULT NULL,`updated_at` Nullable(String) DEFAULT NULL,`SrcCDBID` String,`SrcDatabaseName` String,`_sign` Int8,`_version` UInt64) ENGINE = Distributed('default_cluster', 'lx', 'token_package_logs_local', cityHash64(toString(tuple(id))));


-- event_sessions
CREATE TABLE IF NOT EXISTS lx.event_sessions_local on cluster default_cluster (`id` String,`event_id` String,`sequence` Int16 COMMENT '场次在活动中的顺序，从1开始',`location` String,`team_id` Nullable(String) DEFAULT NULL,`privilege_type` Int16 DEFAULT '0',`closed_at` Nullable(String) DEFAULT NULL COMMENT '报名截止时间',`started_at` Nullable(String) DEFAULT NULL,`ended_at` Nullable(String) DEFAULT NULL,`duration` UInt32 DEFAULT '0' COMMENT '活动耗时,单位分钟',`participant_count` UInt32 DEFAULT '0',`attendee_count` UInt32 DEFAULT '0' COMMENT '签到人数',`participant_count_limit` Nullable(UInt32) DEFAULT NULL,`enable_random_extract` Int8 DEFAULT '0' COMMENT '是否随机抽取名额',`created_by` String,`updated_by` Nullable(String) DEFAULT NULL,`created_at` Nullable(String) DEFAULT NULL,`updated_at` Nullable(String) DEFAULT NULL,`deleted_at` Nullable(String) DEFAULT NULL,`attend_method` String DEFAULT 'qrcode' COMMENT '签到方式',`attend_location` String COMMENT '签到位置',`latitude` Float64 COMMENT '签到纬度',`longitude` Float64 COMMENT '签到经度',`radius` Float64 DEFAULT '100.00' COMMENT '签到半径，米',`deleted_by` Nullable(String) DEFAULT NULL COMMENT '删除人',`attend_start_at` Nullable(String) DEFAULT NULL COMMENT '签到开始时间',`attend_end_at` Nullable(String) DEFAULT NULL COMMENT '签到结束时间',`SrcCDBID` String,`SrcDatabaseName` String,`_sign` Int8,`_version` UInt64) ENGINE = ReplicatedReplacingMergeTree('/clickhouse/tables/event_sessions/{shard}', '{replica}', _version) ORDER BY (SrcCDBID, SrcDatabaseName, id) SETTINGS index_granularity = 8192;

CREATE TABLE IF NOT EXISTS lx.event_sessions on cluster default_cluster (`id` String,`event_id` String,`sequence` Int16 COMMENT '场次在活动中的顺序，从1开始',`location` String,`team_id` Nullable(String) DEFAULT NULL,`privilege_type` Int16 DEFAULT '0',`closed_at` Nullable(String) DEFAULT NULL COMMENT '报名截止时间',`started_at` Nullable(String) DEFAULT NULL,`ended_at` Nullable(String) DEFAULT NULL,`duration` UInt32 DEFAULT '0' COMMENT '活动耗时,单位分钟',`participant_count` UInt32 DEFAULT '0',`attendee_count` UInt32 DEFAULT '0' COMMENT '签到人数',`participant_count_limit` Nullable(UInt32) DEFAULT NULL,`enable_random_extract` Int8 DEFAULT '0' COMMENT '是否随机抽取名额',`created_by` String,`updated_by` Nullable(String) DEFAULT NULL,`created_at` Nullable(String) DEFAULT NULL,`updated_at` Nullable(String) DEFAULT NULL,`deleted_at` Nullable(String) DEFAULT NULL,`attend_method` String DEFAULT 'qrcode' COMMENT '签到方式',`attend_location` String COMMENT '签到位置',`latitude` Float64 COMMENT '签到纬度',`longitude` Float64 COMMENT '签到经度',`radius` Float64 DEFAULT '100.00' COMMENT '签到半径，米',`deleted_by` Nullable(String) DEFAULT NULL COMMENT '删除人',`attend_start_at` Nullable(String) DEFAULT NULL COMMENT '签到开始时间',`attend_end_at` Nullable(String) DEFAULT NULL COMMENT '签到结束时间',`SrcCDBID` String,`SrcDatabaseName` String,`_sign` Int8,`_version` UInt64) ENGINE = Distributed('default_cluster', 'lx', 'event_sessions_local', cityHash64(toString(tuple(id))));


-- parse_package_logs
CREATE TABLE IF NOT EXISTS lx.parse_package_logs_local on cluster default_cluster (`id` UInt32,`package_id` Int32 COMMENT '内容解析id',`consume` UInt64 COMMENT '内容解析消耗量',`date` String COMMENT '内容解析消耗日期',`created_at` Nullable(String) DEFAULT NULL,`updated_at` Nullable(String) DEFAULT NULL,`SrcCDBID` String,`SrcDatabaseName` String,`_sign` Int8,`_version` UInt64) ENGINE = ReplicatedReplacingMergeTree('/clickhouse/tables/parse_package_logs/{shard}', '{replica}', _version) ORDER BY (SrcCDBID, SrcDatabaseName, id) SETTINGS index_granularity = 8192;

CREATE TABLE IF NOT EXISTS lx.parse_package_logs on cluster default_cluster (`id` UInt32,`package_id` Int32 COMMENT '内容解析id',`consume` UInt64 COMMENT '内容解析消耗量',`date` String COMMENT '内容解析消耗日期',`created_at` Nullable(String) DEFAULT NULL,`updated_at` Nullable(String) DEFAULT NULL,`SrcCDBID` String,`SrcDatabaseName` String,`_sign` Int8,`_version` UInt64) ENGINE = Distributed('default_cluster', 'lx', 'parse_package_logs_local', cityHash64(toString(tuple(id))));


-- token_packages
CREATE TABLE IF NOT EXISTS lx.token_packages_local on cluster default_cluster (`id` UInt32,`type` UInt8 COMMENT 'token类型; 0：版本套餐包 1：增购包 2：赠送包',`sub_server_type` String DEFAULT '' COMMENT '区分乐享1.0还是2.0',`started_at` String COMMENT 'token生效时间',`ended_at` String COMMENT 'token到期时间',`status` UInt8 DEFAULT '0' COMMENT 'token状态；0: 可用状态，1：已用完, 2:已过期',`total` UInt64 DEFAULT '0' COMMENT 'token总量',`used` UInt64 DEFAULT '0' COMMENT 'token已使用量',`created_by` String COMMENT 'token，赠送人',`order_uuid` String DEFAULT '' COMMENT '关联的自有订单号',`source` String DEFAULT '' COMMENT '来源',`created_at` Nullable(String) DEFAULT NULL,`updated_at` Nullable(String) DEFAULT NULL,`SrcCDBID` String,`SrcDatabaseName` String,`_sign` Int8,`_version` UInt64) ENGINE = ReplicatedReplacingMergeTree('/clickhouse/tables/token_packages/{shard}', '{replica}', _version) ORDER BY (SrcCDBID, SrcDatabaseName, id) SETTINGS index_granularity = 8192;

CREATE TABLE IF NOT EXISTS lx.token_packages on cluster default_cluster (`id` UInt32,`type` UInt8 COMMENT 'token类型; 0：版本套餐包 1：增购包 2：赠送包',`sub_server_type` String DEFAULT '' COMMENT '区分乐享1.0还是2.0',`started_at` String COMMENT 'token生效时间',`ended_at` String COMMENT 'token到期时间',`status` UInt8 DEFAULT '0' COMMENT 'token状态；0: 可用状态，1：已用完, 2:已过期',`total` UInt64 DEFAULT '0' COMMENT 'token总量',`used` UInt64 DEFAULT '0' COMMENT 'token已使用量',`created_by` String COMMENT 'token，赠送人',`order_uuid` String DEFAULT '' COMMENT '关联的自有订单号',`source` String DEFAULT '' COMMENT '来源',`created_at` Nullable(String) DEFAULT NULL,`updated_at` Nullable(String) DEFAULT NULL,`SrcCDBID` String,`SrcDatabaseName` String,`_sign` Int8,`_version` UInt64) ENGINE = Distributed('default_cluster', 'lx', 'token_packages_local', cityHash64(toString(tuple(id))));


-- parse_packages
CREATE TABLE IF NOT EXISTS lx.parse_packages_local on cluster default_cluster (`id` UInt32,`type` UInt8 COMMENT '内容解析类型; 0：版本套餐包 1：增购包 2：赠送包',`sub_server_type` String DEFAULT '' COMMENT '区分乐享1.0还是2.0',`started_at` String COMMENT '内容解析生效时间',`ended_at` String COMMENT '内容解析到期时间',`status` UInt8 DEFAULT '0' COMMENT '内容解析状态；0: 可用状态，1：已用完, 2:已过期',`total` UInt64 DEFAULT '0' COMMENT '内容解析总量',`used` UInt64 DEFAULT '0' COMMENT '内容解析已使用量',`created_by` String COMMENT '内容解析，赠送人',`order_uuid` String DEFAULT '' COMMENT '关联的自有订单号',`source` String DEFAULT '' COMMENT '来源',`created_at` Nullable(String) DEFAULT NULL,`updated_at` Nullable(String) DEFAULT NULL,`SrcCDBID` String,`SrcDatabaseName` String,`_sign` Int8,`_version` UInt64) ENGINE = ReplicatedReplacingMergeTree('/clickhouse/tables/parse_packages/{shard}', '{replica}', _version) ORDER BY (SrcCDBID, SrcDatabaseName, id) SETTINGS index_granularity = 8192;

CREATE TABLE IF NOT EXISTS lx.parse_packages on cluster default_cluster (`id` UInt32,`type` UInt8 COMMENT '内容解析类型; 0：版本套餐包 1：增购包 2：赠送包',`sub_server_type` String DEFAULT '' COMMENT '区分乐享1.0还是2.0',`started_at` String COMMENT '内容解析生效时间',`ended_at` String COMMENT '内容解析到期时间',`status` UInt8 DEFAULT '0' COMMENT '内容解析状态；0: 可用状态，1：已用完, 2:已过期',`total` UInt64 DEFAULT '0' COMMENT '内容解析总量',`used` UInt64 DEFAULT '0' COMMENT '内容解析已使用量',`created_by` String COMMENT '内容解析，赠送人',`order_uuid` String DEFAULT '' COMMENT '关联的自有订单号',`source` String DEFAULT '' COMMENT '来源',`created_at` Nullable(String) DEFAULT NULL,`updated_at` Nullable(String) DEFAULT NULL,`SrcCDBID` String,`SrcDatabaseName` String,`_sign` Int8,`_version` UInt64) ENGINE = Distributed('default_cluster', 'lx', 'parse_packages_local', cityHash64(toString(tuple(id))));

