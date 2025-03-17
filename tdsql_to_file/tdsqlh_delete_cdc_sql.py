# coding=utf-8
import json
import commands
import sys
import os
import time
import argparse
from datetime import datetime, date, timedelta

reload(sys)
sys.setdefaultencoding('utf-8')

parser = argparse.ArgumentParser(description='ck_to_hive')
parser.add_argument('--ck_database', '-cd', help='必要参数', required=True)
parser.add_argument('--ck_list_path', '-path', help='必要参数', required=True)
parser.add_argument('--tdsqlhid', '-tdid', help='必要参数', required=True)
parser.add_argument('--ck_cdbid', '-cc', help='必要参数', required=True)
parser.add_argument('--cdcid', '-cdcid', help='条件参数', required=False)

# 是否只处理特定后缀的行，如果处理全部行，请删掉此参数
parser.add_argument('--is_suffix', '-is', help='条件参数', required=False)
args = parser.parse_args()

database = args.ck_database
ck_list_path = args.ck_list_path
tdsqlhid = args.tdsqlhid
cdbid = args.ck_cdbid
cdcid = args.cdcid
is_suffix = args.is_suffix

with open(ck_list_path, 'r') as fp:
    ck_config_list = json.load(fp)
    ck_config = ck_config_list[0]

# 导出
print(time.strftime("%H:%M:%S"))
export_sql = "show tables from {}".format(database)
print(export_sql)

for ck_config in ck_config_list:
    if ck_config['tdsqlhid'] == tdsqlhid:
        dir_path = "/data/tdbank/{}/show_tables".format(database)
        if not os.path.exists(dir_path):
            os.makedirs(dir_path)
            os.chmod(dir_path, 0777)
        tsv_path = "/data/tdbank/{}/show_tables/{}.sql".format(database, tdsqlhid)
        if os.path.exists(tsv_path):
            os.remove(tsv_path)
        export_cmd = "clickhouse-client --port {} -h {} --user {} --password {} --query \'{} SETTINGS max_threads=2,max_block_size=1000 \' >{}".format(
            ck_config['ck_port'], ck_config['ck_host'], ck_config['ck_user'], ck_config['ck_password'], export_sql,
            tsv_path)
        print(export_cmd)
        (status, output) = commands.getstatusoutput(export_cmd)
        print(status)
        print(output)
        if status:
            print("ck导出失败：{}".format(tsv_path))
            sys.exit(1)
        print("ck导出成功: {}".format(tsv_path))
        print(time.strftime("%H:%M:%S"))

# 指定要处理的文件夹路径
folder_path = "/data/tdbank/{}/show_tables".format(database)

# 指定要添加的字符串
start_string = "ALTER TABLE {}.".format(database)
if database == 'lx':
    end_string = " on cluster default_cluster DELETE WHERE SrcCDBID=\'{}\';".format(cdbid)
else:
    end_string = " on cluster default_cluster DELETE WHERE _srcInstanceID=\'{}\';".format(cdcid)

# 指定要处理的行结尾字符串
if is_suffix is None:
    print("不处理指定后缀，处理全部行")
    ending_string = ""
else:
    ending_string = is_suffix

# 遍历文件夹中的所有文件
for file_name in os.listdir(folder_path):
    if file_name.startswith(tdsqlhid) and file_name.endswith('.sql'):
        file_path = os.path.join(folder_path, file_name)

        # 检查是否为文件
        if os.path.isfile(file_path):
            # 读取文件内容
            with open(file_path, "r") as file:
                lines = file.readlines()

            # 修改文件内容
            modified_lines = []
            for line in lines:
                # 判断行是否以指定字符串结尾
                if line.strip().endswith(ending_string):
                    modified_line = "{}{}{}\n".format(start_string, line.strip(), end_string)
                    modified_lines.append(modified_line)

            # 去掉最后一行换行
            if modified_lines:
                modified_lines[-1] = modified_lines[-1].rstrip("\n")

            # 将修改后的内容写回文件
            with open(file_path, "w") as file:
                file.writelines(modified_lines)

for ck_config in ck_config_list:
    if ck_config['tdsqlhid'] == tdsqlhid:
        delete_sql_file = '{}/{}.sql'.format(folder_path, tdsqlhid)

        delete_cmd = "clickhouse-client --port {} -h {} --user {} --password {} --queries-file {}".format(
            ck_config['ck_port'], ck_config['ck_host'], ck_config['ck_user'], ck_config['ck_password'], delete_sql_file)
        print(delete_cmd)

        (status, output) = commands.getstatusoutput(delete_cmd)
        print(status)
        print(output)
        if status:
            print("ck删除失败")
            sys.exit(1)
        print("ck删除成功")
        print(time.strftime("%H:%M:%S"))
