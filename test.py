CREATE_SQL = "create table if not exists dashboard_tdw_test.{} like " \
             "dashboard_tdw_test.ads_disk_nodes_categories_d_f" \
    .format(TABLE_NAME)
