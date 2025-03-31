from pyspark.sql import SparkSession

# from openapi_logs.check_input_output_json import cleaned_df


# 创建SparkSession
spark = (SparkSession.builder.appName("JsonParsingApp").master("local[*]")
         .config("spark.driver.memory", "4g")
         .config("spark.executor.memory", "4g")
         .getOrCreate())

# 读取本地文件
# input_path = "file:///Users/tangqiliang/Documents/files/pvuv_logs/202410/test1001"
input_path = "file:///Users/tangqiliang/Documents/工作/files/pvuv_logs/20250317"
df = spark.read.json(input_path)

df.createOrReplaceTempView("my_json")

# 进行数据清洗和处理
cleaned_df = spark.sql("""
    select *
    from my_json
    where parse_url(concat('http://', request), 'QUERY', 'url') = 'https://lexiangla.com/teams/k100106/classes/60802064f4f511ef951052a00c17eca9/courses/34260846f5c011ef973e26da5d58a353?company_from=02a2bba4746e11ee9ee7e2246f9a8371'
""")

# cleaned_df = spark.sql("""
#     select distinct http_request_uri
#     -- request,parse_url(concat('http://', request), 'QUERY', 'company_id') company_id
#     from my_json
# """)

cleaned_df.show()

# 停止SparkSession
spark.stop()
