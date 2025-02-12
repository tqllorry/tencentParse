
-- learning_roadmaps
ALTER TABLE lx.learning_roadmaps_local on cluster default_cluster ADD COLUMN IF NOT EXISTS `manager_remind_config` Nullable(String) COMMENT '项目负责人通知规则' AFTER `enable_manager_remind`;
ALTER TABLE lx.learning_roadmaps on cluster default_cluster ADD COLUMN IF NOT EXISTS `manager_remind_config` Nullable(String) COMMENT '项目负责人通知规则' AFTER `enable_manager_remind`;

