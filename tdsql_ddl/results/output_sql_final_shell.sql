
-- staff_applies
ALTER TABLE lx.staff_applies_local on cluster default_cluster ADD COLUMN IF NOT EXISTS `invited_from` String DEFAULT '' AFTER `invited_by`;
ALTER TABLE lx.staff_applies on cluster default_cluster ADD COLUMN IF NOT EXISTS `invited_from` String DEFAULT '' AFTER `invited_by`;


-- exam_question_libs
ALTER TABLE lx.exam_question_libs_local on cluster default_cluster ADD COLUMN IF NOT EXISTS `category_id` Nullable(String) COMMENT '分类ID' AFTER `sync_status`;
ALTER TABLE lx.exam_question_libs on cluster default_cluster ADD COLUMN IF NOT EXISTS `category_id` Nullable(String) COMMENT '分类ID' AFTER `sync_status`;


-- ai_knowledge
ALTER TABLE lx.ai_knowledge_local on cluster default_cluster ADD COLUMN IF NOT EXISTS `failed_detail` String COMMENT '失败的错误信息' AFTER `revision`;
ALTER TABLE lx.ai_knowledge on cluster default_cluster ADD COLUMN IF NOT EXISTS `failed_detail` String COMMENT '失败的错误信息' AFTER `revision`;


-- ai_ocr_tasks
ALTER TABLE lx.ai_ocr_tasks_local on cluster default_cluster ADD COLUMN IF NOT EXISTS `failed_detail` String COMMENT '失败的错误信息' AFTER `revision`;
ALTER TABLE lx.ai_ocr_tasks on cluster default_cluster ADD COLUMN IF NOT EXISTS `failed_detail` String COMMENT '失败的错误信息' AFTER `revision`;

