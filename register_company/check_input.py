from pyspark.sql import SparkSession

# from openapi_logs.check_input_output_json import cleaned_df


# 创建SparkSession
spark = (SparkSession.builder.appName("JsonParsingApp").master("local[*]")
         .config("spark.driver.memory", "4g")
         .config("spark.executor.memory", "4g")
         .getOrCreate())

# 读取本地文件
# input_path = "file:///Users/tangqiliang/Documents/files/pvuv_logs/202410/test1001"
input_path = "file:///Users/tangqiliang/Documents/工作/data_repair/register_company/input"
df = spark.read.json(input_path)

df.createOrReplaceTempView("my_json")

# 进行数据清洗和处理
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

# cleaned_df = spark.sql("""
#     select distinct http_request_uri
#     -- request,parse_url(concat('http://', request), 'QUERY', 'company_id') company_id
#     from my_json
# """)

cleaned_df.show()

# 停止SparkSession
spark.stop()
