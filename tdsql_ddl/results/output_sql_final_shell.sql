
-- kb_templates
CREATE TABLE IF NOT EXISTS lx.kb_templates_local on cluster default_cluster (`incr_id` UInt64,`id` String,`space_id` String,`name` String,`cover` String,`type` String,`target_type` String,`target_id` String,`status` Int8,`created_by` String,`updated_by` String,`owned_by` String,`deleted_at` UInt64,`created_at` Nullable(String),`updated_at` Nullable(String),`SrcCDBID` String,`SrcDatabaseName` String,`_sign` Int8,`_version` UInt64) ENGINE = ReplicatedReplacingMergeTree('/clickhouse/tables/kb_templates/{shard}', '{replica}', _version) ORDER BY (SrcCDBID, SrcDatabaseName, incr_id) SETTINGS index_granularity = 8192;

CREATE TABLE IF NOT EXISTS lx.kb_templates on cluster default_cluster (`incr_id` UInt64,`id` String,`space_id` String,`name` String,`cover` String,`type` String,`target_type` String,`target_id` String,`status` Int8,`created_by` String,`updated_by` String,`owned_by` String,`deleted_at` UInt64,`created_at` Nullable(String),`updated_at` Nullable(String),`SrcCDBID` String,`SrcDatabaseName` String,`_sign` Int8,`_version` UInt64) ENGINE = Distributed('default_cluster', 'lx', 'kb_templates_local', cityHash64(toString(tuple(incr_id))));


-- kb_template_usages
CREATE TABLE IF NOT EXISTS lx.kb_template_usages_local on cluster default_cluster (`incr_id` UInt64,`id` String,`space_id` String,`template_id` String,`entry_id` String,`created_by` String,`created_at` Nullable(String),`SrcCDBID` String,`SrcDatabaseName` String,`_sign` Int8,`_version` UInt64) ENGINE = ReplicatedReplacingMergeTree('/clickhouse/tables/kb_template_usages/{shard}', '{replica}', _version) ORDER BY (SrcCDBID, SrcDatabaseName, incr_id) SETTINGS index_granularity = 8192;

CREATE TABLE IF NOT EXISTS lx.kb_template_usages on cluster default_cluster (`incr_id` UInt64,`id` String,`space_id` String,`template_id` String,`entry_id` String,`created_by` String,`created_at` Nullable(String),`SrcCDBID` String,`SrcDatabaseName` String,`_sign` Int8,`_version` UInt64) ENGINE = Distributed('default_cluster', 'lx', 'kb_template_usages_local', cityHash64(toString(tuple(incr_id))));


-- exam_questions
ALTER TABLE lx.exam_questions_local on cluster default_cluster ADD COLUMN IF NOT EXISTS `release_question_lib_id` Nullable(String) COMMENT '考试发布时加入的题库id' AFTER `question_lib_id`;
ALTER TABLE lx.exam_questions on cluster default_cluster ADD COLUMN IF NOT EXISTS `release_question_lib_id` Nullable(String) COMMENT '考试发布时加入的题库id' AFTER `question_lib_id`;


-- exam_papers
ALTER TABLE lx.exam_papers_local on cluster default_cluster ADD COLUMN IF NOT EXISTS `is_hidden` Int8 DEFAULT 0 COMMENT '是否在试卷库显示:0显示，1隐藏' AFTER `extra_content`;
ALTER TABLE lx.exam_papers on cluster default_cluster ADD COLUMN IF NOT EXISTS `is_hidden` Int8 DEFAULT 0 COMMENT '是否在试卷库显示:0显示，1隐藏' AFTER `extra_content`;


-- exam_events
ALTER TABLE lx.exam_events_local on cluster default_cluster ADD COLUMN IF NOT EXISTS `quote_type` String DEFAULT 'quote' COMMENT '考卷引用类型:quote引用，non_quote非引用' AFTER `type`;
ALTER TABLE lx.exam_events on cluster default_cluster ADD COLUMN IF NOT EXISTS `quote_type` String DEFAULT 'quote' COMMENT '考卷引用类型:quote引用，non_quote非引用' AFTER `type`;


-- ai_knowledge_point_tasks
ALTER TABLE lx.ai_knowledge_point_tasks_local on cluster default_cluster ADD COLUMN IF NOT EXISTS `original_snapshot` Nullable(String) COMMENT '原始知识点快照' AFTER `status`;
ALTER TABLE lx.ai_knowledge_point_tasks on cluster default_cluster ADD COLUMN IF NOT EXISTS `original_snapshot` Nullable(String) COMMENT '原始知识点快照' AFTER `status`;


-- kb_entry_contents
ALTER TABLE lx.kb_entry_contents_local on cluster default_cluster ADD COLUMN IF NOT EXISTS `ai_summary` Nullable(String) COMMENT 'AI摘要' AFTER `summary`;
ALTER TABLE lx.kb_entry_contents on cluster default_cluster ADD COLUMN IF NOT EXISTS `ai_summary` Nullable(String) COMMENT 'AI摘要' AFTER `summary`;


-- ai_knowledge
ALTER TABLE lx.ai_knowledge_local on cluster default_cluster ADD COLUMN IF NOT EXISTS `extra` Nullable(String) COMMENT '额外字段信息' AFTER `import_type`;
ALTER TABLE lx.ai_knowledge on cluster default_cluster ADD COLUMN IF NOT EXISTS `extra` Nullable(String) COMMENT '额外字段信息' AFTER `import_type`;


-- news
ALTER TABLE lx.news_local on cluster default_cluster ADD COLUMN IF NOT EXISTS `source` String DEFAULT '' AFTER `created_by`;
ALTER TABLE lx.news on cluster default_cluster ADD COLUMN IF NOT EXISTS `source` String DEFAULT '' AFTER `created_by`;

