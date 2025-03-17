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
parser.add_argument('--tdsqlhid', '-tdsqlhid', help='必要参数', required=True)
parser.add_argument('--cdbid', '-cdbid', help='必要参数', required=True)
parser.add_argument('--manually_table_path', '-manually_table_path', help='必要参数', required=True)
parser.add_argument('--cdcid', '-cdcid', help='条件参数', required=False)
args = parser.parse_args()

database = args.ck_database
ck_list_path = args.ck_list_path
tdsqlhid = args.tdsqlhid
cdbid = args.cdbid
manually_table_path = args.manually_table_path
cdcid = args.cdcid

with open(ck_list_path, 'r') as fp:
    ck_config_list = json.load(fp)

ck_config = [item for item in ck_config_list if str(item['tdsqlhid']) == tdsqlhid][0]

# dt = time.strftime("%Y%m%d", time.localtime())
dt = (date.today() + timedelta(days=-1)).strftime("%Y%m%d")

# 导出
export_sql1 = "show tables"
print(export_sql1)

tsv_path = "/data/tdbank/{}/{}/{}.tsv.all".format(database, manually_table_path, dt)
if os.path.exists(tsv_path):
    os.remove(tsv_path)

temp_tsv_path = "/data/tdbank/{}/{}/sql_{}.tsv.all".format(database, manually_table_path, dt)
if os.path.exists(temp_tsv_path):
    os.remove(temp_tsv_path)

dir_history_path = "/data/tdbank/{}/{}/*".format(database, manually_table_path)
if os.path.exists(dir_history_path):
    os.remove(dir_history_path)

# 没有目录就新建
dir_path = "/data/tdbank/{}/{}".format(database, manually_table_path)
if not os.path.exists(dir_path):
    os.makedirs(dir_path)
    os.chmod(dir_path, 0777)

export_cmd = "clickhouse-client --port {} -h {} --user {} --password {} -d {} --query \"{}\" >>{}".format(
    ck_config['ck_port'], ck_config['ck_host'], ck_config['ck_user'], ck_config['ck_password'], database, export_sql1,
    temp_tsv_path)
print(export_cmd)
(status, output) = commands.getstatusoutput(export_cmd)
print(status)
print(output)
if status:
    print("ck导出失败：{}".format(temp_tsv_path))
    sys.exit(1)
print("ck导出成功: {}.{}".format(temp_tsv_path, ck_config['tdsqlhid']))
print(time.strftime("%H:%M:%S"))

condition = ''
if database == 'lx':
    condition = 'and SrcCDBID=\'{}\''.format(cdbid)
elif database == 'lx_yz_others':
    condition = '_srcInstanceID=\'{}\''.format(cdcid)
else:
    condition = ''

with open(temp_tsv_path, 'r') as f:
    lines = f.readlines()
    result = []
    for line in lines:
        line = line.strip()
        if not line.endswith('_local'):
            line = 'select concat(\'' + line + ',\',toString(count(1))) from ' + line + ' where _sign=1 {} union all'.format(
                condition)
            result.append(line)

with open(temp_tsv_path, 'w') as f:
    f.write('\n'.join(result))

with open(temp_tsv_path, 'a') as f:
    f.write('\nselect \'null,0\'')

export_cmd = "clickhouse-client --port {} -h {} --user {} --password {} -d {} < {} >>{}".format(
    ck_config['ck_port'], ck_config['ck_host'], ck_config['ck_user'], ck_config['ck_password'], database, temp_tsv_path,
    tsv_path)

print(export_cmd)
(status, output) = commands.getstatusoutput(export_cmd)
print(status)
print(output)
if status:
    print("ck导出失败：{}".format(tsv_path))
    sys.exit(1)
print("ck导出成功: {}.{}".format(tsv_path, ck_config['tdsqlhid']))
print(time.strftime("%H:%M:%S"))

with open(tsv_path, 'r') as f:
    lines = f.readlines()
    result = []
    for line in lines:
        table_name, count = line.strip().split(',')
        if int(count) > 0:
            result.append(line.strip())
with open(tsv_path, 'w') as f:
    f.write('\n'.join(result))
