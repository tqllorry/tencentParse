# coding=utf-8
import json
import commands
import sys
import os
import time
import argparse
import subprocess
from datetime import date, timedelta

reload(sys)
sys.setdefaultencoding('utf-8')

parser = argparse.ArgumentParser(description='ck_to_hive')
parser.add_argument('--ck_database', '-cd', help='必要参数', required=True)
parser.add_argument('--ck_table', '-ct', help='必要参数', required=True)
parser.add_argument('--fields', '-f', help='必要参数', required=True)
parser.add_argument('--ck_list_path', '-path', help='必要参数', required=True)
parser.add_argument('--where', '-where', help='条件参数', required=False)
parser.add_argument('--manually_table_path', '-manually_table_path', help='条件参数', required=False)
parser.add_argument('--manually_ck_list', '-manually_ck_list', help='条件参数', required=False)
parser.add_argument('--manually_column', '-manually_column', help='条件参数', required=False)
args = parser.parse_args()

database = args.ck_database
table = args.ck_table
ck_fields = args.fields
ck_list_path = args.ck_list_path
where = args.where
manually_table_path = args.manually_table_path
manually_ck_list = args.manually_ck_list
manually_column = args.manually_column

if not where:
    where = '1=1'

# 如果没指定导出路径，默认为table名
if not manually_table_path:
    manually_table_path = table

# 获取导出字段（manually_ck_list为自定义字段列表，如给某字段添加函数操作）
field_list = []
final_field_list = ''
fields = ck_fields.replace('`', '').split(',')

if not manually_column:
    for field in fields:
        field_list.append("`{}`".format(field.strip()))
    print(field_list)
    final_field_list = ','.join(field_list).replace('`', '\\`')
else:
    final_field_list = manually_column.replace('`', '\\`')
    print("自定义字段：{}".format(final_field_list))

with open(ck_list_path, 'r') as fp:
    ck_config_list = json.load(fp)

# 如果没指定ck的index，默认为全部index
if not manually_ck_list:
    print("未指定ck库index，默认为全部库")
else:
    print("指定ck库index：{}".format(manually_ck_list))
    ck_config_list = [item for item in ck_config_list if str(item['index']) in manually_ck_list.split(',')]

dt = (date.today() + timedelta(days=-1)).strftime("%Y%m%d")

# 导出
print(time.strftime("%H:%M:%S"))

dir_path = "/data/tdbank/{}/{}".format(database, manually_table_path)
tsv_path = "{}/{}.tsv.all".format(dir_path, dt)
temp_tsv_path = "{}/temp_{}.tsv.all".format(dir_path, dt)

if not os.path.exists(dir_path):
    os.makedirs(dir_path)
    os.chmod(dir_path, 0777)
else:
    if os.path.exists(tsv_path):
        os.remove(tsv_path)
    if os.path.exists(temp_tsv_path):
        os.remove(temp_tsv_path)

# 若输入的database等于lx，则导出两个库数据
if database == 'lx':
    loop_list = ['lx', 'lx_yz_others']
else:
    loop_list = [None]

for db in loop_list:
    for ck_config in ck_config_list:
        if db == 'lx':
            if ck_config['index'] == -1:
                continue
            else:
                export_sql = "select {} from lx.{} final where _sign=1 and {}".format(final_field_list, table, where)
        elif db == 'lx_yz_others':
            if ck_config['index'] != -1:
                continue
            else:
                export_sql = "select {} from lx_yz_others.{} final where _sign=1 and {}".format(
                    final_field_list.replace('\\`SrcCDBID\\`', '\'cdb-rlmkue91\'')
                    .replace('SrcCDBID', '\'cdb-rlmkue91\'')
                    .replace('SrcDatabaseName', '_srcDatabaseName'), table, where)
        else:
            export_sql = "select {} from {}.{} final where _sign=1 and {}".format(final_field_list, database, table,
                                                                                  where)
        print(export_sql)

        export_cmd = "clickhouse-client --port {} -h {} --user {} --password {} --query \"{} SETTINGS max_threads=2,max_block_size=1000 \" >>{}".format(
            ck_config['ck_port'], ck_config['ck_host'], ck_config['ck_user'], ck_config['ck_password'], export_sql,
            temp_tsv_path)
        print(export_cmd)
        (status, output) = commands.getstatusoutput(export_cmd)
        print(status)
        print(output)
        if status:
            print("ck导出失败：{}".format(temp_tsv_path))
            sys.exit(1)
        print("ck导出成功: {}.{}".format(temp_tsv_path, ck_config['index']))
        print(time.strftime("%H:%M:%S"))

if os.path.exists(temp_tsv_path):
    if table == 'ai_histories':
        # 删除行数过长的行
        try:
            original_lines = int(subprocess.check_output(['wc', '-l', temp_tsv_path]).split()[0])
        except subprocess.CalledProcessError:
            print("统计原始文件行数失败。")
            exit(1)

        awk_command = "awk \'length($0) <= 467968\' {} > {} && rm -rf {}".format(temp_tsv_path, tsv_path, temp_tsv_path)
        # awk_command = "perl -i -ne \'print if length($_) <= 467968\' {}".format(temp_tsv_path)
        if subprocess.call(awk_command, shell=True) == 0:
            try:
                new_lines = int(subprocess.check_output(['wc', '-l', temp_tsv_path]).split()[0])
                deleted_lines = original_lines - new_lines
                print("已处理文件 {}，删除 {} 行，并将结果写入 {}。".format(temp_tsv_path, deleted_lines, tsv_path))
                # print("已处理文件 {}，删除 {} 行。".format(temp_tsv_path, deleted_lines))
            except subprocess.CalledProcessError:
                print("统计新文件行数失败。")
        else:
            print("执行 awk 命令时出错。")
    else:
        os.rename(temp_tsv_path, tsv_path)
