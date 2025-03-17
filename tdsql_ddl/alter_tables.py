#!/usr/bin/env python3
def generate_alter_table_shell_file(mysql_result_path1, output_file_path1, output_shell_file_path1):
    primary_keys = []

    # 读取output_mysql_info.txt文件
    with open(mysql_result_path1, 'r') as f:
        mysql_lines = f.readlines()

    for line in mysql_lines:

        if line.startswith('add'):
            if len(line.strip().split('&^*=')) < 3:
                error_info = "！！！！！{}表没有主键！！！！！".format(line.strip().split('&^*=')[1])
                raise ValueError(error_info)
            else:
                primary_keys.append(line.strip().split('&^*=')[2].strip())

    with open(output_file_path1, 'r') as f:
        lines = f.readlines()

    with open(output_shell_file_path1, 'w') as f:
        for line in lines:
            if line.startswith(')'):
                line = line.replace('\n', ' ')

            if line.startswith('    `'):
                line = line.replace('    `', '`').replace('\n', '')

            line = line.replace('on cluster default_cluster (\n', 'on cluster default_cluster (') \
                .replace('\'{replica}\', _version)\n', '\'{replica}\', _version) ') \
                .replace('DEFAULT \\\'\\\'', 'DEFAULT \'\'')

            for primary_key in primary_keys:
                line = line.replace('ORDER BY (SrcCDBID, SrcDatabaseName, {})\n'.format(primary_key),
                                    'ORDER BY (SrcCDBID, SrcDatabaseName, {}) '.format(primary_key))

            f.write(line)


def generate_select_mysql(file_path1, output_file_path1, db_name1):
    with open(file_path1, 'r') as f:
        lines = [line.strip() for line in f.readlines() if line.strip()]

    sql_list = []
    for line in lines:
        if '[新增字段' in line:
            # 分割表名和新增字段
            table_name, fields_str = line.split('[新增字段')
            table_name = table_name.replace(' ', '').replace('--', '')

            # 拼接字段列表
            fields = fields_str.replace('，', ',').split(',')
            field_list = [f"'{field.strip().rstrip(']')}'" for field in fields]
            field_str = ', '.join(field_list)

            # 拼接SQL语句
            sql = '''SELECT concat_ws('&^*=','update',a.TABLE_NAME,a.COLUMN_NAME,b.COLUMN_NAME,a.COLUMN_COMMENT) from
        (SELECT * FROM information_schema.COLUMNS
        WHERE TABLE_SCHEMA = 'swan_{}' AND TABLE_NAME = '{}' and COLUMN_NAME in({})) a
        join information_schema.COLUMNS b on b.TABLE_SCHEMA = 'swan_{}' AND b.TABLE_NAME = '{}' and a.ORDINAL_POSITION = b.ORDINAL_POSITION + 1
            '''.format(db_name1, table_name, field_str, db_name1, table_name)

            sql_list.append(sql)

        elif '[新建表]' in line:
            # 分割表名
            table_name, fields_str = line.split('[新建表]')
            table_name = table_name.replace(' ', '').replace('--', '')

            # 拼接SQL语句
            sql = "SELECT concat_ws('&^*=','add','{}',(SELECT COLUMN_NAME FROM information_schema.COLUMNS WHERE TABLE_SCHEMA='swan_{}' AND TABLE_NAME='{}' and COLUMN_KEY='PRI'))".format(
                table_name, db_name1, table_name)

            sql_list.append(sql)

        else:
            continue

    # 将多个SQL语句拼接成一个大的SQL语句
    big_sql = ' UNION ALL\n'.join(sql_list) + ';'

    # 输出到文件
    with open(output_file_path1, 'w') as f:
        f.write(big_sql)


def generate_select_ck(file_path1, output_file_path1, db_name1):
    with open(file_path1, 'r') as f:
        lines = [line.strip() for line in f.readlines() if line.strip()]

    update_sql_list = []
    add_sql_list = []

    for line in lines:
        if '[新建表]' in line:
            table_name = line.replace('[新建表]', '').replace('-- ', '').strip()
            add_sql = "SELECT concat('add&^*=',name,'&^*=',replace(arrayElement(splitByString('.{} (',arrayElement(splitByString(') ENGINE = ',create_table_query),1)),2),', \`_sign\` Int8, \`_version\` UInt64, \`_dversion\` UInt64','')) FROM system.tables WHERE database='{}' AND name='{}'".format(
                table_name, ck_db_name, table_name)
            add_sql_list.append(add_sql)

        elif '[新增字段' in line:
            # 分割表名和新增字段
            table_name, fields_str = line.split('[新增字段')
            table_name = table_name.replace(' ', '').replace('--', '')

            # 拼接字段列表
            fields = fields_str.replace('，', ',').split(',')
            field_list = [f"'{field.strip().rstrip(']')}'" for field in fields]
            field_str = ', '.join(field_list)

            # 拼接SQL语句
            sql = "(table = '{}' AND name in({}))".format(table_name, field_str)

            update_sql_list.append(sql)

        else:
            continue

    # 将多个SQL语句拼接成一个大的SQL语句
    if update_sql_list:
        update_big_sql = "SELECT concat('update&^*=',table,'&^*=',name,'&^*=',concat(type,' ',default_kind,' ',default_expression)) FROM system.columns WHERE database='{}' and (".format(ck_db_name) + ' or'.join(
            update_sql_list) + ');'
    else:
        update_big_sql = "select ''"

    if add_sql_list:
        add_big_sql = ' UNION ALL '.join(add_sql_list) + ' UNION ALL '
    else:
        add_big_sql = ""

    result = "clickhouse-client --host 10.26.49.20 --port 9000 --user etl --password SmceVqeCuUCQ4el2 -d " + db_name1 + " --query \"select '' union all " + add_big_sql + update_big_sql + "\""

    # 输出到文件
    with open(output_file_path1, 'w') as f:
        f.write(result)


def generate_alter_table_statement(mysql_result_path1, ck_result_path1, output_file_path1):
    # 读取output_ck_info.txt文件
    with open(ck_result_path1, 'r') as f:
        ck_lines = f.readlines()

    ck_dict = {}

    with open(output_file_path1, 'w') as w:

        last_table_name = ''

        for line in ck_lines:
            if line.startswith('add'):
                dml_type, table_name, create_sql = line.strip().split('&^*=')
                if table_name != last_table_name:
                    w.write(f"\n-- {table_name}\n")
                    last_table_name = table_name

                # local语句
                create_sql_local = 'CREATE TABLE IF NOT EXISTS lx.' + table_name + "_local on cluster default_cluster (" + create_sql + ", `SrcCDBID` String, `SrcDatabaseName` String, `_sign` Int8, `_version` UInt64) ENGINE = ReplicatedReplacingMergeTree('/clickhouse/tables/{}".format(
                    table_name)
                create_sql_local += "/{shard}', '{replica}', _version) ORDER BY (SrcCDBID, SrcDatabaseName, id) SETTINGS index_granularity = 8192;\n\n"
                w.write(create_sql_local)

                # 非local语句
                create_sql = 'CREATE TABLE IF NOT EXISTS lx.' + table_name + " on cluster default_cluster (" + create_sql + ", `SrcCDBID` String, `SrcDatabaseName` String, `_sign` Int8, `_version` UInt64) ENGINE = Distributed('default_cluster', 'lx', '" + table_name + "_local', cityHash64(toString(tuple(id))));\n\n"
                w.write(create_sql)

            elif line.startswith('update'):
                dml_type, table_name, column_name, column_type = line.strip().split('&^*=')

                column_type = column_type.replace('\\', '')
                key = f"{table_name}|{column_name}"
                if key not in ck_dict:
                    ck_dict[key] = []
                ck_dict[key].append(column_type)

            else:
                continue

    # 读取output_mysql_info.txt文件
    with open(mysql_result_path1, 'r') as f:
        mysql_lines = f.readlines()

    mysql_dict = {}
    mysql_order = []
    for line in mysql_lines:

        if line.startswith('add'):
            dml_type, table_name, primary_key = line.strip().split('&^*=')

            with open(output_file_path1, 'r') as temp_f:
                temp_lines = temp_f.readlines()

            with open(output_file_path1, 'w') as temp_f:
                for temp_line in temp_lines:
                    temp_fields = temp_line.strip().split(' ')
                    if len(temp_fields) >= 6 and temp_fields[5].replace('lx.', '').removesuffix(
                            "_local") == table_name:
                        sharding_key_1 = "cityHash64(toString(tuple({})))".format(primary_key)
                        sharding_key_2 = "(SrcCDBID, SrcDatabaseName, {})".format(primary_key)
                        temp_line = temp_line.replace('cityHash64(toString(tuple(id)))', sharding_key_1).replace(
                            '(SrcCDBID, SrcDatabaseName, id)', sharding_key_2)
                    temp_f.write(temp_line)

        elif line.startswith('update'):
            dml_type, table_name, column_name, after_column, comment = line.strip().split('&^*=')
            key = f"{table_name}|{column_name}"
            if key not in mysql_dict:
                mysql_dict[key] = []
                mysql_order.append(key)
            mysql_dict[key].append(after_column)
            mysql_dict[key].append(comment)

        else:
            continue

    final_dict = {}
    for key in ck_dict.keys() & mysql_dict.keys():
        final_dict[key] = ck_dict[key] + mysql_dict[key]

    with open(output_file_path1, 'a') as f:
        last_table_name = ''
        for key in mysql_order:
            table_name, column_name = key.split('|')
            if table_name != last_table_name:
                f.write(f"\n-- {table_name}\n")
                last_table_name = table_name
            column_types = ', '.join(final_dict[key][:-2])
            after_column = final_dict[key][-2]
            comment = final_dict[key][-1]
            if comment:
                comment = f"'{comment}'"
                f.write(
                    f"ALTER TABLE lx.{table_name}_local on cluster default_cluster ADD COLUMN IF NOT EXISTS `{column_name}` {column_types} COMMENT {comment} AFTER `{after_column}`;\n")
                f.write(
                    f"ALTER TABLE lx.{table_name} on cluster default_cluster ADD COLUMN IF NOT EXISTS `{column_name}` {column_types} COMMENT {comment} AFTER `{after_column}`;\n\n")
            else:
                f.write(
                    f"ALTER TABLE lx.{table_name}_local on cluster default_cluster ADD COLUMN IF NOT EXISTS `{column_name}` {column_types} AFTER `{after_column}`;\n")
                f.write(
                    f"ALTER TABLE lx.{table_name} on cluster default_cluster ADD COLUMN IF NOT EXISTS `{column_name}` {column_types} AFTER `{after_column}`;\n\n")

    with open(output_file_path1, 'r') as f:
        lines = f.readlines()

    with open(output_file_path1, 'w') as f:
        for line in lines:
            if line.startswith('CREATE TABLE IF NOT EXISTS'):
                line = line.replace(') SETTINGS ', ')\nSETTINGS ') \
                    .replace(') ORDER BY (', ')\nORDER BY (') \
                    .replace(') ENGINE = ', '\n)\nENGINE = ') \
                    .replace('on cluster default_cluster (', 'on cluster default_cluster (\n    ') \
                    .replace(', `', ',\n    `')
            f.write(line)


def run(mysql_db_name1, ck_db_name1):
    file_path = "new_table_info.sql"

    select_mysql_file_path = "sql/select_mysql.sql"
    select_ck_file_path = "sql/select_ck.sh"

    mysql_result_path = "sql/output_mysql_info.txt"
    ck_result_path = "sql/output_ck_info.txt"

    output_file_path = "results/output_sql_final.sql"
    output_shell_file_path = "results/output_sql_final_shell.sql"

    generate_alter_table_shell_file(mysql_result_path, output_file_path, output_shell_file_path)
    generate_select_mysql(file_path, select_mysql_file_path, mysql_db_name1)
    generate_select_ck(file_path, select_ck_file_path, ck_db_name1)
    generate_alter_table_statement(mysql_result_path, ck_result_path, 'results/output_sql_final_bak.sql')
    generate_alter_table_statement(mysql_result_path, ck_result_path, output_file_path)


if __name__ == "__main__":
    # 将新生成的库名替换到db_name，登录至今日新生成的测试库
    # 将tony老师整理的sql变更中的alter部分复制到new_table_info.sql，检查格式
    # 执行本脚本
    # 将select_mysql.sql中的语句复制到新生成的库中执行，将结果覆盖output_mysql_info.txt
    # 将select_ck.sh中的语句复制到CK服务器中执行，将结果覆盖output_ck_info.txt
    # 再次执行此脚本，生成output_sql_final.sql
    # 检查MySQL测试库中 新建表 的字段，补充默认值和备注
    # 再次执行此脚本，生成output_sql_final_shell.sql
    mysql_db_name = 'e51dd52002fe11f08e23ba62037e8f31'
    ck_db_name = 'swan_85535ed0c66311e5a2f8bf5011933e87'

    run(mysql_db_name, ck_db_name)
