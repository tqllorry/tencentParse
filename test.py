# coding:utf-8
"""
PythonSQL Demo
Python Version 2.7
Python Doc https://docs.python.org/2.7/contents.html
"""

import re
from datetime import datetime, date, timedelta


def TDW_PL(tdw, argv):
    tdw.WriteLog('PythonSQL start')

    query = 'select database_name, table_name, safe_partition_days from lx_saas.dim_lx_table_save_partition_info'
    tdw.WriteLog('sql=%s' % query)
    res = tdw.execute(query)
    tdw.WriteLog(res)

    for row in res:
        fields = row.split('\t')
        if len(fields) != 3:
            tdw.WriteLog('Error: Expected 3 columns, got %d: %s' % (len(fields), str(row)))
            continue

        database_name, table_name, safe_partition_days = fields

        safe_partition_days = int(safe_partition_days)

        delete_date = datetime.now() - timedelta(days=safe_partition_days)
        # 获取年、月、日
        dt_year = delete_date.strftime('%Y')
        dt_month = delete_date.strftime('%m')
        dt_day = delete_date.strftime('%d')
        # 构造删除分区的SQL语句
        drop_partition_query = (
                "ALTER TABLE %s.%s DROP IF EXISTS PARTITION (year='%s', month='%s', day='%s')"
                % (database_name, table_name, dt_year, dt_month, dt_day)
        )

        # 写入日志
        tdw.WriteLog('sql=%s' % drop_partition_query)

        # 执行删除分区操作
        # try:
        #     res = tdw.execute(drop_partition_query)
        #     tdw.WriteLog(res)
        #     tdw.WriteLog("Deleted partition from %s.%s for date %s" % (database_name, table_name, delete_date_str))
        # except Exception as e:
        #     tdw.WriteLog("Error deleting partition from %s.%s: %s" % (database_name, table_name, str(e)))

    tdw.WriteLog('PythonSQL end')
