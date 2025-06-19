from pyspark.sql import SparkSession

# from openapi_logs.check_input_output_json import cleaned_df


# 创建SparkSession
spark = (SparkSession.builder.appName("JsonParsingApp").master("local[*]")
         .config("spark.driver.memory", "4g")
         .config("spark.executor.memory", "4g")
         .getOrCreate())

# 读取本地文件
input_path = "file:///Users/tangqiliang/Documents/工作/data_repair/pvuv_logs_miniprogram/input"
df = spark.read.json(input_path)

df.createOrReplaceTempView("my_json")

# 进行数据清洗和处理
cleaned_df = spark.sql("""
    select parse_url(concat('http://', replace(request, '%0A', '')), 'QUERY', 'company_id') company_id,
        parse_url(concat('http://', replace(request, '%0A', '')), 'QUERY', 'target_type') target_type,
        parse_url(concat('http://', replace(request, '%0A', '')), 'QUERY', 'staff_id') staff_id,
        agent, 
        from_unixtime(unix_timestamp(`timestamp`, 'dd/MMM/yyy:HH:mm:ss Z'), 'yyyyMMdd') as `timestamp`
    from my_json
    where from_unixtime(unix_timestamp(`timestamp`, 'dd/MMM/yyy:HH:mm:ss Z'), 'yyyyMMdd') >= '20250303'
""")

# cleaned_df = spark.sql("""
#     select distinct http_request_uri
#     -- request,parse_url(concat('http://', request), 'QUERY', 'company_id') company_id
#     from my_json
# """)

cleaned_df.show()

# 停止SparkSession
spark.stop()
