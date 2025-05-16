from pyspark.sql import SparkSession

# 创建SparkSession
spark = (SparkSession.builder.appName("JsonParsingApp").master("local[*]")
         .config("spark.driver.memory", "4g")
         .config("spark.executor.memory", "4g")
         .getOrCreate())

# 读取本地文件
# input_path = "file:///Users/tangqiliang/Documents/工作/files/pvuv_logs/202412/input"
input_path = "file:///Users/tangqiliang/Documents/工作/data_repair/register_company/input"
df = spark.read.json(input_path)

df.createOrReplaceTempView("my_json")

# 进行数据清洗和处理
# cleaned_df = spark.sql("""
#     select request,timestamp,
#         case
#             when lower(agent) like '%wxwork%' and lower(agent) like '%mobile%' then 'wxwork'
#             when lower(agent) like '%wxwork%' then 'wxwork_pc'
#             when lower(agent) like '%micromessenger%' and lower(agent) like '%mobile%' then 'weixin'
#             when lower(agent) like '%micromessenger%' then 'weixin_pc'
#             else 'web' end as agent,
#         referrer
#      from my_json
# """)

cleaned_df = spark.sql("""
    select substr(`@timestamp`, 0, 10) d,
        count(if((
        (referer = "https://lexiangla.com/register?version=2" AND tag = "RegistrationController@registerCompany")
            OR (tag = "LoginV2Controller@createCompany")
        )
        and `user-agent` not like '%Mobile%', 1, null)) pc_cnt,
        count(if((
        (referer = "https://lexiangla.com/register?version=2" AND tag = "RegistrationController@registerCompany")
            OR (tag = "LoginV2Controller@createCompany")
        )
        and `user-agent` like '%Mobile%', 1, null)) mobile_cnt
    from my_json
    group by substr(`@timestamp`, 0, 10)
    order by d desc
""")

# cleaned_df.show()

# output_path = "file:///Users/tangqiliang/Documents/工作/files/pvuv_logs/202412/output"
output_path = "file:///Users/tangqiliang/Documents/工作/data_repair/register_company/output"

# 导出parquet文件
# cleaned_df.repartition(3).write.mode("overwrite").format("parquet").save(output_path)
# cleaned_df.write.mode("overwrite").format("parquet").save(output_path)

# 导出成csv
cleaned_df.write.mode("overwrite").format("com.databricks.spark.csv").save(output_path)

# 停止SparkSession
spark.stop()
