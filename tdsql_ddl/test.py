dt = "20241010"

DATABASE = "dashboard_tdw"
TABLE_NAME = "ads_company_exam_events_staff_d_f"
BASE_TABLE_NAME = "ads_company_exam_events_staff_d_i"
DELETE_TABLE_NAME = "ads_company_exam_events_staff_delete_d_i"
APP_NAME = "export_{}_to_mysql".format(TABLE_NAME)
COLUMNS = ("company_id,team_id,staff_id,staff_name,staff_organization,staff_status,"
           "exam_id,exam_title,exam_category,exam_type,exam_from,exam_source,exam_time_range,staff_exam_status,"
           "staff_exam_join_type,staff_exam_count,staff_exam_ended_at,staff_exam_result_score,staff_exam_result,"
           "staff_exam_credits,staff_exam_points,staff_exam_spend,staff_exam_switch_count,staff_exam_avg_spend")

TRUNCATE_SQL_1 = "truncate {}.{}".format(DATABASE, BASE_TABLE_NAME)
TRUNCATE_SQL_2 = "truncate {}.{}".format(DATABASE, DELETE_TABLE_NAME)

SELECT_SQL_1 = '''
    select {},join_type from lx_saas.ads_company_exam_events_staff_d_i
    where concat(`year`, `month`, `day`) = '{}' and join_type in('insert', 'update')
'''.format(COLUMNS, dt)

aaa = 'asdsaf dfs_{}'.format(dt)

print(aaa)