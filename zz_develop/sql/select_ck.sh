clickhouse-client --host 10.26.49.20 --port 9000 --user etl --password SmceVqeCuUCQ4el2 -d swan_85535ed0c66311e5a2f8bf5011933e87 --query "select '' union all SELECT concat('add&^*=',name,'&^*=',replace(arrayElement(splitByString('.learning_roadmap_tag_staff (',arrayElement(splitByString(') ENGINE = ',create_table_query),1)),2),', \`_sign\` Int8, \`_version\` UInt64, \`_dversion\` UInt64','')) FROM system.tables WHERE database='swan_85535ed0c66311e5a2f8bf5011933e87' AND name='learning_roadmap_tag_staff' UNION ALL SELECT concat('add&^*=',name,'&^*=',replace(arrayElement(splitByString('.content_selections (',arrayElement(splitByString(') ENGINE = ',create_table_query),1)),2),', \`_sign\` Int8, \`_version\` UInt64, \`_dversion\` UInt64','')) FROM system.tables WHERE database='swan_85535ed0c66311e5a2f8bf5011933e87' AND name='content_selections' UNION ALL SELECT concat('update&^*=',table,'&^*=',name,'&^*=',concat(type,' ',default_kind,' ',default_expression)) FROM system.columns WHERE (table = 'documents' AND name in('enable_select'));"