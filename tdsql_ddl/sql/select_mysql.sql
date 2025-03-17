SELECT concat_ws('&^*=','update',a.TABLE_NAME,a.COLUMN_NAME,b.COLUMN_NAME,a.COLUMN_COMMENT) from
        (SELECT * FROM information_schema.COLUMNS
        WHERE TABLE_SCHEMA = 'swan_e51dd52002fe11f08e23ba62037e8f31' AND TABLE_NAME = 'exam_questions' and COLUMN_NAME in('release_question_lib_id')) a
        join information_schema.COLUMNS b on b.TABLE_SCHEMA = 'swan_e51dd52002fe11f08e23ba62037e8f31' AND b.TABLE_NAME = 'exam_questions' and a.ORDINAL_POSITION = b.ORDINAL_POSITION + 1
             UNION ALL
SELECT concat_ws('&^*=','update',a.TABLE_NAME,a.COLUMN_NAME,b.COLUMN_NAME,a.COLUMN_COMMENT) from
        (SELECT * FROM information_schema.COLUMNS
        WHERE TABLE_SCHEMA = 'swan_e51dd52002fe11f08e23ba62037e8f31' AND TABLE_NAME = 'exam_papers' and COLUMN_NAME in('is_hidden')) a
        join information_schema.COLUMNS b on b.TABLE_SCHEMA = 'swan_e51dd52002fe11f08e23ba62037e8f31' AND b.TABLE_NAME = 'exam_papers' and a.ORDINAL_POSITION = b.ORDINAL_POSITION + 1
             UNION ALL
SELECT concat_ws('&^*=','update',a.TABLE_NAME,a.COLUMN_NAME,b.COLUMN_NAME,a.COLUMN_COMMENT) from
        (SELECT * FROM information_schema.COLUMNS
        WHERE TABLE_SCHEMA = 'swan_e51dd52002fe11f08e23ba62037e8f31' AND TABLE_NAME = 'exam_events' and COLUMN_NAME in('quote_type')) a
        join information_schema.COLUMNS b on b.TABLE_SCHEMA = 'swan_e51dd52002fe11f08e23ba62037e8f31' AND b.TABLE_NAME = 'exam_events' and a.ORDINAL_POSITION = b.ORDINAL_POSITION + 1
             UNION ALL
SELECT concat_ws('&^*=','add','kb_templates',(SELECT COLUMN_NAME FROM information_schema.COLUMNS WHERE TABLE_SCHEMA='swan_e51dd52002fe11f08e23ba62037e8f31' AND TABLE_NAME='kb_templates' and COLUMN_KEY='PRI')) UNION ALL
SELECT concat_ws('&^*=','add','kb_template_usages',(SELECT COLUMN_NAME FROM information_schema.COLUMNS WHERE TABLE_SCHEMA='swan_e51dd52002fe11f08e23ba62037e8f31' AND TABLE_NAME='kb_template_usages' and COLUMN_KEY='PRI')) UNION ALL
SELECT concat_ws('&^*=','update',a.TABLE_NAME,a.COLUMN_NAME,b.COLUMN_NAME,a.COLUMN_COMMENT) from
        (SELECT * FROM information_schema.COLUMNS
        WHERE TABLE_SCHEMA = 'swan_e51dd52002fe11f08e23ba62037e8f31' AND TABLE_NAME = 'ai_knowledge_point_tasks' and COLUMN_NAME in('original_snapshot')) a
        join information_schema.COLUMNS b on b.TABLE_SCHEMA = 'swan_e51dd52002fe11f08e23ba62037e8f31' AND b.TABLE_NAME = 'ai_knowledge_point_tasks' and a.ORDINAL_POSITION = b.ORDINAL_POSITION + 1
             UNION ALL
SELECT concat_ws('&^*=','update',a.TABLE_NAME,a.COLUMN_NAME,b.COLUMN_NAME,a.COLUMN_COMMENT) from
        (SELECT * FROM information_schema.COLUMNS
        WHERE TABLE_SCHEMA = 'swan_e51dd52002fe11f08e23ba62037e8f31' AND TABLE_NAME = 'kb_entry_contents' and COLUMN_NAME in('ai_summary')) a
        join information_schema.COLUMNS b on b.TABLE_SCHEMA = 'swan_e51dd52002fe11f08e23ba62037e8f31' AND b.TABLE_NAME = 'kb_entry_contents' and a.ORDINAL_POSITION = b.ORDINAL_POSITION + 1
             UNION ALL
SELECT concat_ws('&^*=','update',a.TABLE_NAME,a.COLUMN_NAME,b.COLUMN_NAME,a.COLUMN_COMMENT) from
        (SELECT * FROM information_schema.COLUMNS
        WHERE TABLE_SCHEMA = 'swan_e51dd52002fe11f08e23ba62037e8f31' AND TABLE_NAME = 'ai_knowledge' and COLUMN_NAME in('extra')) a
        join information_schema.COLUMNS b on b.TABLE_SCHEMA = 'swan_e51dd52002fe11f08e23ba62037e8f31' AND b.TABLE_NAME = 'ai_knowledge' and a.ORDINAL_POSITION = b.ORDINAL_POSITION + 1
             UNION ALL
SELECT concat_ws('&^*=','update',a.TABLE_NAME,a.COLUMN_NAME,b.COLUMN_NAME,a.COLUMN_COMMENT) from
        (SELECT * FROM information_schema.COLUMNS
        WHERE TABLE_SCHEMA = 'swan_e51dd52002fe11f08e23ba62037e8f31' AND TABLE_NAME = 'news' and COLUMN_NAME in('source')) a
        join information_schema.COLUMNS b on b.TABLE_SCHEMA = 'swan_e51dd52002fe11f08e23ba62037e8f31' AND b.TABLE_NAME = 'news' and a.ORDINAL_POSITION = b.ORDINAL_POSITION + 1
            ;