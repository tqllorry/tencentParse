from pyspark.sql import SparkSession

# 创建SparkSession
spark = SparkSession.builder.appName("JsonParsingApp").master("local[*]").getOrCreate()

# 读取本地文件
input_path = "file:///Users/tangqiliang/Documents/files/pvuv_logs/202410/input"
df = spark.read.json(input_path)

df.createOrReplaceTempView("my_json")

# 进行数据清洗和处理
cleaned_df = spark.sql("""
    select request,timestamp,
        case
            when lower(agent) like '%wxwork%' and lower(agent) like '%mobile%' then 'wxwork'
            when lower(agent) like '%wxwork%' then 'wxwork_pc'
            when lower(agent) like '%micromessenger%' and lower(agent) like '%mobile%' then 'weixin'
            when lower(agent) like '%micromessenger%' then 'weixin_pc'
            else 'web' end as agent
     from my_json
""")

cleaned_df.show()

# 停止SparkSession
spark.stop()
