from pyspark.sql import SparkSession

# 创建SparkSession
spark = SparkSession.builder.appName("JsonParsingApp").master("local[*]").getOrCreate()

# 读取本地文件
input_path = "file:///Users/tangqiliang/Documents/files/openapi_logs/jsons/1102/1"
df = spark.read.json(input_path)
df.createOrReplaceTempView("my_json")

# 进行数据清洗和处理
cleaned_df = spark.sql("""
    select 
    data.company_id,
    data.suite_id, 
    data.app_type,
    cast((`@filebeat_time` / 1000) as bigint) as t,
    data.response_code,
    replace(to_date(`@timestamp`),'-','') as access_date,
    from_unixtime(unix_timestamp(`@timestamp`, 'yyyy-MM-dd HH:mm:ss.SSS'), 'HH') as `hour`
     from my_json
""")

# cleaned_df.show()

# 将数据写回本地文件
output_path = "file:///Users/tangqiliang/Documents/files/openapi_logs/results/1102"
cleaned_df.repartition(3).write. \
    mode("overwrite"). \
    format("parquet"). \
    save(output_path)

# 停止SparkSession
spark.stop()
