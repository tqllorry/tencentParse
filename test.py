# coding=utf-8
import json
import commands
import sys
import os
import time
import argparse
from datetime import date, timedelta

database = 'lx'

manually_column = '`id`, `name`,`age`,SrcCDBID,`SrcDatabaseName`'
manually_column = None

table = 'staffs'

dt = (date.today() + timedelta(days=-1)).strftime("%Y%m%d")

where = '1=1'

ck_fields = 'id, name,age, `SrcCDBID`,SrcDatabaseName'

field_list = []
final_field_list = ''
fields = ck_fields.replace('`', '').split(',')

manually_table_path = None

# 如果没指定导出路径，默认为table名
if not manually_table_path:
    manually_table_path = table

dir_path = "/data/tdbank/{}/{}".format(database, manually_table_path)
tsv_path = "{}/{}.tsv.all".format(dir_path, dt)
temp_tsv_path = "{}/temp_{}.tsv.all".format(dir_path, dt)

awk_command = "awk \'length($0) <= 467968\' {} > {}".format(temp_tsv_path, tsv_path)

print(awk_command)

if not manually_column:
    for field in fields:
        field_list.append("`{}`".format(field.strip()))
    print(field_list)
    final_field_list = ','.join(field_list).replace('`', '\\`')
else:
    final_field_list = manually_column.replace('`', '\\`')
    print("自定义字段：{}".format(final_field_list))

# 若输入的database等于lx，则导出两个库数据
if database == 'lx':
    loop_list = ['lx', 'lx_yz_others']
else:
    loop_list = [None]

for db in loop_list:
    if db == 'lx':
        export_sql = "select {} from lx.{} final where _sign=1 and {}".format(final_field_list, table, where)
    elif db == 'lx_yz_others':
        export_sql = "select {} from lx_yz_others.{} final where _sign=1 and {}".format(
            final_field_list.replace('\\`SrcCDBID\\`', '\'cdb-rlmkue91\'')
            .replace('SrcCDBID', '\'cdb-rlmkue91\'')
            .replace('SrcDatabaseName', '_srcDatabaseName'), table, where)
    else:
        export_sql = "select {} from {}.{} final where _sign=1 and {}".format(
            final_field_list.replace('`', '\\`'), database, table, where)

    print(export_sql)
