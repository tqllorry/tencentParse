from __future__ import print_function

import re
import sys

from datetime import datetime, date, timedelta
from pyspark.sql import SparkSession

ds = '20250611'
match = re.match(r"(\d{4})(\d{2})(\d{2})", ds)
daySub = match.group(1, 2, 3)
input_day = datetime(int(daySub[0]), int(daySub[1]), int(daySub[2]))

# ======================== 日需求日期 ========================
# 指定的数据日期的年月日
dt_year = daySub[0]
dt_month = daySub[1]
dt_day = daySub[2]
print('dt_year={}, dt_month={}, dt_day={}'.format(dt_year, dt_month, dt_day))

# 指定的数据日期，%Y%m%d格式
dt = input_day.strftime('%Y%m%d')
print('dt=%s' % dt)

# 指定的数据日期，%Y-%m-%d格式
DT_WITH_SEPARTOR = '{y}-{m}-{d}'.format(y=dt_year, m=dt_month, d=dt_day)
print('dt_with_separtor=%s' % DT_WITH_SEPARTOR)

# ======================== 周需求日期 ========================
week_index = input_day.weekday()
monday = (input_day + timedelta(days=-week_index)).strftime("%Y%m%d")
match = re.match(r"(\d{4})(\d{2})(\d{2})", monday)
daySub = match.group(1, 2, 3)

# 指定的数据日期的周一的年月日
monday_year = daySub[0]
monday_month = daySub[1]
monday_day = daySub[2]

# 指定的数据日期的周一的年月日
MONDAY_DT = '{y}{m}{d}'.format(y=monday_year, m=monday_month, d=monday_day)
MONDAY_DT_WITH_SEPARTOR = '{y}-{m}-{d}'.format(y=monday_year, m=monday_month, d=monday_day)

print('monday_year={}, monday_month={}, monday_day={}'.format(monday_year, monday_month, monday_day))
print('monday_dt=%s' % MONDAY_DT)
print('monday_dt_with_separtor=%s' % MONDAY_DT_WITH_SEPARTOR)

# ======================== 其他需求日期 ========================
# 计算当日的昨天日期
yesterday = (date.today() + timedelta(days=-1)).strftime("%Y%m%d")
print('yesterday=%s' % yesterday)

# 指定的数据日期前一天
last_dt = (input_day + timedelta(days=-1)).strftime("%Y%m%d")
last_last_dt = (input_day + timedelta(days=-2)).strftime("%Y%m%d")
prev7d_dt = (input_day + timedelta(days=-7)).strftime("%Y%m%d")
prev8d_dt = (input_day + timedelta(days=-8)).strftime("%Y%m%d")
prev29d_dt = (input_day + timedelta(days=-29)).strftime("%Y%m%d")

print('last_dt=%s' % last_dt)
print('last_last_dt=%s' % last_last_dt)
print('prev7d_dt=%s' % prev7d_dt)
print('prev8d_dt=%s' % prev8d_dt)
print('prev29d_dt=%s' % prev29d_dt)

if input_day.month == 1:
    prev_month_year = input_day.year - 1
    prev_month = 12
else:
    prev_month_year = input_day.year
    prev_month = input_day.month - 1

# 获取前一个月的最后一天
prev_month_last_day = (input_day.replace(day=1) - timedelta(days=1)).strftime('%Y%m%d')
prev_month_date = (input_day.replace(day=1) - timedelta(days=1)).strftime('%Y%m')

print('前一个月的月末日期:', prev_month_last_day)
print('前一个月的月末日期:', prev_month_date)

print(monday)
print(MONDAY_DT)
print(week_index)

# 计算前一天日期
prev_day = (datetime.strptime(MONDAY_DT, "%Y%m%d") + timedelta(days=-1)) .strftime("%Y%m%d")

print('MONDAY_DT的前一天日期:', prev_day)

# 上个月的日期格式（Python 2.7 语法）
prev_month_str = "{0}{1:02d}".format(prev_month_year, prev_month)
print(prev_month_str)

