
-- platform_message_logs
CREATE TABLE lx.platform_message_logs_local on cluster default_cluster (`id` UInt64,`news_log_id` String,`push_data` String,`push_platform` String DEFAULT '' COMMENT '推送的平台',`platform_corp_id` String DEFAULT '' COMMENT '企微/飞书corp_id',`sent_user_count` Int32 DEFAULT '0' COMMENT '推送人数',`received_user_count` Int32 DEFAULT '0' COMMENT '推送成功人数',`success_message_id` String DEFAULT '' COMMENT '成功推送消息ID,用于撤回',`recall_status` Int8 DEFAULT '0' COMMENT '撤回状态 0:未撤回 1:已撤回',`created_at` Nullable(String) DEFAULT NULL,`updated_at` Nullable(String) DEFAULT NULL,`SrcCDBID` String,`SrcDatabaseName` String,`_sign` Int8,`_version` UInt64) ENGINE = ReplicatedReplacingMergeTree('/clickhouse/tables/platform_message_logs/{shard}', '{replica}', _version) ORDER BY (SrcCDBID, SrcDatabaseName, id) SETTINGS index_granularity = 8192;

CREATE TABLE lx.platform_message_logs on cluster default_cluster (`id` UInt64,`news_log_id` String,`push_data` String,`push_platform` String DEFAULT '' COMMENT '推送的平台',`platform_corp_id` String DEFAULT '' COMMENT '企微/飞书corp_id',`sent_user_count` Int32 DEFAULT '0' COMMENT '推送人数',`received_user_count` Int32 DEFAULT '0' COMMENT '推送成功人数',`success_message_id` String DEFAULT '' COMMENT '成功推送消息ID,用于撤回',`recall_status` Int8 DEFAULT '0' COMMENT '撤回状态 0:未撤回 1:已撤回',`created_at` Nullable(String) DEFAULT NULL,`updated_at` Nullable(String) DEFAULT NULL,`SrcCDBID` String,`SrcDatabaseName` String,`_sign` Int8,`_version` UInt64) ENGINE = Distributed('default_cluster', 'lx', 'platform_message_logs_local', cityHash64(toString(tuple(id))));


-- honor_awards
ALTER TABLE lx.honor_awards_local on cluster default_cluster ADD COLUMN `is_revoked` Int8 DEFAULT 0 COMMENT '是否撤回' AFTER `scene`;
ALTER TABLE lx.honor_awards on cluster default_cluster ADD COLUMN `is_revoked` Int8 DEFAULT 0 COMMENT '是否撤回' AFTER `scene`;

ALTER TABLE lx.honor_awards_local on cluster default_cluster ADD COLUMN `revoked_by` String DEFAULT '' COMMENT '撤回操作人' AFTER `is_revoked`;
ALTER TABLE lx.honor_awards on cluster default_cluster ADD COLUMN `revoked_by` String DEFAULT '' COMMENT '撤回操作人' AFTER `is_revoked`;


-- ai_faq
ALTER TABLE lx.ai_faq_local on cluster default_cluster ADD COLUMN `disk_node_id` String DEFAULT '' COMMENT '关联文档ID' AFTER `add_type`;
ALTER TABLE lx.ai_faq on cluster default_cluster ADD COLUMN `disk_node_id` String DEFAULT '' COMMENT '关联文档ID' AFTER `add_type`;

ALTER TABLE lx.ai_faq_local on cluster default_cluster ADD COLUMN `is_audited` Int8 DEFAULT 1 COMMENT '是否为待审核问答对' AFTER `disk_node_id`;
ALTER TABLE lx.ai_faq on cluster default_cluster ADD COLUMN `is_audited` Int8 DEFAULT 1 COMMENT '是否为待审核问答对' AFTER `disk_node_id`;

