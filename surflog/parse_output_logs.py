from pyspark.sql import SparkSession

# 创建SparkSession
spark = SparkSession.builder.appName("JsonParsingApp").master("local[*]").getOrCreate()

# 读取本地文件
input_path = "file:///Users/tangqiliang/Documents/files/dwv_surflog/download"
df = spark.read.json(input_path)

df.createOrReplaceTempView("my_json")

# 进行数据清洗和处理
cleaned_df = spark.sql("""
    select
        get_json_object(M, '$.staff_id') as f_staff_id,
        get_json_object(M, '$.company_id') as f_company_id,
        get_json_object(M, '$.target_id') as f_target_id,
        get_json_object(M, '$.target_type') as f_target_type,
        get_json_object(M, '$.url') as f_url,
        get_json_object(M, '$.team_code') as f_team_code,
        get_json_object(M, '$.agent') as f_agent,
        get_json_object(M, '$.time') as f_time,
        get_json_object(M, '$.extra') as f_extra
    from my_json
    where type = 'collect'
""")

# cleaned_df.show()

output_path = "file:///Users/tangqiliang/Documents/files/dwv_surflog/result"

# 导出parquet文件
cleaned_df.repartition(1).write.mode("overwrite").format("parquet").save(output_path)

# 导出成csv
# cleaned_df.repartition(3).write.mode("overwrite").format("com.databricks.spark.csv").option("header", "false").save(output_path)

# 停止SparkSession
spark.stop()
