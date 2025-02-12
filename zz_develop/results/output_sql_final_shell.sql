
-- scorm_scoes
CREATE TABLE IF NOT EXISTS lx.scorm_scoes_local on cluster default_cluster (`incr_id` UInt64,`id` String,`title` String,`scorm_id` String,`manifest` String,`organization` String,`parent` String,`identifier` String,`launch` String,`type` String,`order` Int32,`created_at` Nullable(String),`updated_at` Nullable(String),`SrcCDBID` String,`SrcDatabaseName` String,`_sign` Int8,`_version` UInt64) ENGINE = ReplicatedReplacingMergeTree('/clickhouse/tables/scorm_scoes/{shard}', '{replica}', _version) ORDER BY (SrcCDBID, SrcDatabaseName, incr_id)
SETTINGS index_granularity = 8192;

CREATE TABLE IF NOT EXISTS lx.scorm_scoes on cluster default_cluster (`incr_id` UInt64,`id` String,`title` String,`scorm_id` String,`manifest` String,`organization` String,`parent` String,`identifier` String,`launch` String,`type` String,`order` Int32,`created_at` Nullable(String),`updated_at` Nullable(String),`SrcCDBID` String,`SrcDatabaseName` String,`_sign` Int8,`_version` UInt64) ENGINE = Distributed('default_cluster', 'lx', 'scorm_scoes_local', cityHash64(toString(tuple(incr_id))));


-- scorms
CREATE TABLE IF NOT EXISTS lx.scorms_local on cluster default_cluster (`incr_id` UInt64,`id` String,`course_id` String,`name` String,`type` String,`nav` Int8 DEFAULT 1,`hidetoc` Int8 DEFAULT 0,`reference` String,`intro` String,`introformat` Int16,`version` String,`maxattempt` Int32,`md5hash` String,`completionstatusrequired` Int8,`completionscorerequired` Int32,`completionstatusallscos` Int8,`created_by` String,`created_at` Nullable(String),`updated_at` Nullable(String),`SrcCDBID` String,`SrcDatabaseName` String,`_sign` Int8,`_version` UInt64) ENGINE = ReplicatedReplacingMergeTree('/clickhouse/tables/scorms/{shard}', '{replica}', _version) ORDER BY (SrcCDBID, SrcDatabaseName, incr_id)
SETTINGS index_granularity = 8192;

CREATE TABLE IF NOT EXISTS lx.scorms on cluster default_cluster (`incr_id` UInt64,`id` String,`course_id` String,`name` String,`type` String,`nav` Int8 DEFAULT 1,`hidetoc` Int8 DEFAULT 0,`reference` String,`intro` String,`introformat` Int16,`version` String,`maxattempt` Int32,`md5hash` String,`completionstatusrequired` Int8,`completionscorerequired` Int32,`completionstatusallscos` Int8,`created_by` String,`created_at` Nullable(String),`updated_at` Nullable(String),`SrcCDBID` String,`SrcDatabaseName` String,`_sign` Int8,`_version` UInt64) ENGINE = Distributed('default_cluster', 'lx', 'scorms_local', cityHash64(toString(tuple(incr_id))));


-- scorm_data
CREATE TABLE IF NOT EXISTS lx.scorm_data_local on cluster default_cluster (`id` UInt32,`sco_id` String,`name` String,`value` Nullable(String),`created_at` Nullable(String),`updated_at` Nullable(String),`SrcCDBID` String,`SrcDatabaseName` String,`_sign` Int8,`_version` UInt64) ENGINE = ReplicatedReplacingMergeTree('/clickhouse/tables/scorm_data/{shard}', '{replica}', _version) ORDER BY (SrcCDBID, SrcDatabaseName, id)
SETTINGS index_granularity = 8192;

CREATE TABLE IF NOT EXISTS lx.scorm_data on cluster default_cluster (`id` UInt32,`sco_id` String,`name` String,`value` Nullable(String),`created_at` Nullable(String),`updated_at` Nullable(String),`SrcCDBID` String,`SrcDatabaseName` String,`_sign` Int8,`_version` UInt64) ENGINE = Distributed('default_cluster', 'lx', 'scorm_data_local', cityHash64(toString(tuple(id))));


-- scorm_elements
CREATE TABLE IF NOT EXISTS lx.scorm_elements_local on cluster default_cluster (`id` UInt32,`element` String,`SrcCDBID` String,`SrcDatabaseName` String,`_sign` Int8,`_version` UInt64) ENGINE = ReplicatedReplacingMergeTree('/clickhouse/tables/scorm_elements/{shard}', '{replica}', _version) ORDER BY (SrcCDBID, SrcDatabaseName, id)
SETTINGS index_granularity = 8192;

CREATE TABLE IF NOT EXISTS lx.scorm_elements on cluster default_cluster (`id` UInt32,`element` String,`SrcCDBID` String,`SrcDatabaseName` String,`_sign` Int8,`_version` UInt64) ENGINE = Distributed('default_cluster', 'lx', 'scorm_elements_local', cityHash64(toString(tuple(id))));


-- liveroom_visit_rules
CREATE TABLE IF NOT EXISTS lx.liveroom_visit_rules_local on cluster default_cluster (`incr_id` UInt64,`id` String,`name` String,`liveroom_id` String,`default_definition` String,`disable_definition_switch` Int8,`privilege_type` Int8,`created_by` String,`updated_by` String,`created_at` Nullable(String),`updated_at` Nullable(String),`deleted_at` Nullable(String),`SrcCDBID` String,`SrcDatabaseName` String,`_sign` Int8,`_version` UInt64) ENGINE = ReplicatedReplacingMergeTree('/clickhouse/tables/liveroom_visit_rules/{shard}', '{replica}', _version) ORDER BY (SrcCDBID, SrcDatabaseName, incr_id)
SETTINGS index_granularity = 8192;

CREATE TABLE IF NOT EXISTS lx.liveroom_visit_rules on cluster default_cluster (`incr_id` UInt64,`id` String,`name` String,`liveroom_id` String,`default_definition` String,`disable_definition_switch` Int8,`privilege_type` Int8,`created_by` String,`updated_by` String,`created_at` Nullable(String),`updated_at` Nullable(String),`deleted_at` Nullable(String),`SrcCDBID` String,`SrcDatabaseName` String,`_sign` Int8,`_version` UInt64) ENGINE = Distributed('default_cluster', 'lx', 'liveroom_visit_rules_local', cityHash64(toString(tuple(incr_id))));


-- scorm_values
CREATE TABLE IF NOT EXISTS lx.scorm_values_local on cluster default_cluster (`id` UInt32,`sco_id` String,`staff_id` String,`element_id` Int32,`value` Nullable(String),`created_at` Nullable(String),`updated_at` Nullable(String),`SrcCDBID` String,`SrcDatabaseName` String,`_sign` Int8,`_version` UInt64) ENGINE = ReplicatedReplacingMergeTree('/clickhouse/tables/scorm_values/{shard}', '{replica}', _version) ORDER BY (SrcCDBID, SrcDatabaseName, id)
SETTINGS index_granularity = 8192;

CREATE TABLE IF NOT EXISTS lx.scorm_values on cluster default_cluster (`id` UInt32,`sco_id` String,`staff_id` String,`element_id` Int32,`value` Nullable(String),`created_at` Nullable(String),`updated_at` Nullable(String),`SrcCDBID` String,`SrcDatabaseName` String,`_sign` Int8,`_version` UInt64) ENGINE = Distributed('default_cluster', 'lx', 'scorm_values_local', cityHash64(toString(tuple(id))));


-- liverooms
ALTER TABLE lx.liverooms_local on cluster default_cluster ADD COLUMN IF NOT EXISTS `enable_visit_rule` Int8 DEFAULT 0 COMMENT '是否启用观看规则' AFTER `enable_playback`;
ALTER TABLE lx.liverooms on cluster default_cluster ADD COLUMN IF NOT EXISTS `enable_visit_rule` Int8 DEFAULT 0 COMMENT '是否启用观看规则' AFTER `enable_playback`;


-- ai_knowledge
ALTER TABLE lx.ai_knowledge_local on cluster default_cluster ADD COLUMN IF NOT EXISTS `space_id` String DEFAULT '' AFTER `team_id`;
ALTER TABLE lx.ai_knowledge on cluster default_cluster ADD COLUMN IF NOT EXISTS `space_id` String DEFAULT '' AFTER `team_id`;


-- ai_train_scenarios
ALTER TABLE lx.ai_train_scenarios_local on cluster default_cluster ADD COLUMN IF NOT EXISTS `evaluation_rule` String COMMENT '场景评价规则' AFTER `evaluation`;
ALTER TABLE lx.ai_train_scenarios on cluster default_cluster ADD COLUMN IF NOT EXISTS `evaluation_rule` String COMMENT '场景评价规则' AFTER `evaluation`;


-- ai_train_evaluation_rules
ALTER TABLE lx.ai_train_evaluation_rules_local on cluster default_cluster ADD COLUMN IF NOT EXISTS `related_scenario_count` Int32 DEFAULT 0 COMMENT '关联场景数' AFTER `evaluation`;
ALTER TABLE lx.ai_train_evaluation_rules on cluster default_cluster ADD COLUMN IF NOT EXISTS `related_scenario_count` Int32 DEFAULT 0 COMMENT '关联场景数' AFTER `evaluation`;

