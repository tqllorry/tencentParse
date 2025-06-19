
-- ai_train_scenarios
ALTER TABLE lx.ai_train_scenarios_local on cluster default_cluster ADD COLUMN IF NOT EXISTS `enable_rank` Int8 DEFAULT 0 COMMENT '是否开启排行榜' AFTER `limited_practice_times`;
ALTER TABLE lx.ai_train_scenarios on cluster default_cluster ADD COLUMN IF NOT EXISTS `enable_rank` Int8 DEFAULT 0 COMMENT '是否开启排行榜' AFTER `limited_practice_times`;


-- kb_async_tasks
ALTER TABLE lx.kb_async_tasks_local on cluster default_cluster ADD COLUMN IF NOT EXISTS `retry_times` Int8 DEFAULT 0 COMMENT '失败重试次数' AFTER `input_data`;
ALTER TABLE lx.kb_async_tasks on cluster default_cluster ADD COLUMN IF NOT EXISTS `retry_times` Int8 DEFAULT 0 COMMENT '失败重试次数' AFTER `input_data`;

