from pyspark.sql import SparkSession

# 创建SparkSession
spark = (SparkSession.builder.appName("JsonParsingApp").master("local[*]")
         .config("spark.driver.memory", "4g")
         .config("spark.executor.memory", "4g")
         .getOrCreate())

# 读取本地文件
# input_path = "file:///Users/tangqiliang/Documents/工作/files/pvuv_logs/202412/input"
input_path = "file:///Users/tangqiliang/Documents/工作/data_repair/pvuv_logs_miniprogram/input"
df = spark.read.json(input_path)

df.createOrReplaceTempView("my_json")


cleaned_df = spark.sql("""
    select if(grouping(company_id) = 1, '-10000', company_id) as company_id, access_date, staff_id,
        count(1) pv,
        sum(if(agent like '%miniprogram%', 1, 0)) miniprogram_pv,
        sum(if(agent in('wxwork_pc', 'weixin_pc', 'web'), 1, 0)) pc_pv,
        sum(if(agent in('wxwork', 'weixin'), 1, 0)) h5_pv
        -- count(DISTINCT if(agent like '%miniprogram%', staff_id, null)) miniprogram_uv, count(if(agent like '%miniprogram%', 1, null)) miniprogram_pv,
        -- count(DISTINCT if(agent in('wxwork_pc', 'weixin_pc'), staff_id, null)) pc_uv, count(if(agent in('wxwork_pc', 'weixin_pc'), 1, null)) pc_pv,
        -- count(DISTINCT if(agent in('wxwork', 'weixin', 'web'), staff_id, null)) h5_uv, count(if(agent in('wxwork', 'weixin', 'web'), 1, null)) h5_pv
    from(
        select parse_url(concat('http://', replace(request, '%0A', '')), 'QUERY', 'company_id') company_id,
            parse_url(concat('http://', replace(request, '%0A', '')), 'QUERY', 'target_type') target_type,
            parse_url(concat('http://', replace(request, '%0A', '')), 'QUERY', 'staff_id') staff_id,
            case -- when lower(agent) like '%miniprogram%' then 'miniprogram'
                when lower(agent) like '%wxwork%' and lower(agent) like '%mobile%' and lower(agent) like '%miniprogram%' then 'wxwork_miniprogram'
                when lower(agent) like '%wxwork%' and lower(agent) like '%miniprogram%' then 'wxwork_pc_miniprogram'
                when lower(agent) like '%micromessenger%' and lower(agent) like '%mobile%' and lower(agent) like '%miniprogram%' then 'weixin_miniprogram'
                when lower(agent) like '%micromessenger%' and lower(agent) like '%miniprogram%' then 'weixin_pc_miniprogram'
                when lower(agent) like '%wxwork%' and lower(agent) like '%mobile%' then 'wxwork'
                when lower(agent) like '%wxwork%' then 'wxwork_pc'
                when lower(agent) like '%micromessenger%' and lower(agent) like '%mobile%' then 'weixin'
                when lower(agent) like '%micromessenger%' then 'weixin_pc'
            else 'web' end as agent,
            from_unixtime(unix_timestamp(`timestamp`, 'dd/MMM/yyy:HH:mm:ss Z'), 'yyyyMMdd') as access_date
        from my_json
    ) a
    where access_date between '20250303' and '20250513' and target_type = 'kb_space'
    group by company_id, access_date, staff_id grouping sets (
        (access_date, staff_id), (company_id, access_date, staff_id)
    )
""")

# cleaned_df.show()

# output_path = "file:///Users/tangqiliang/Documents/工作/files/pvuv_logs/202412/output"
output_path = "file:///Users/tangqiliang/Documents/工作/data_repair/pvuv_logs_miniprogram/output3"

# 导出parquet文件
# cleaned_df.repartition(3).write.mode("overwrite").format("parquet").save(output_path)
# cleaned_df.write.mode("overwrite").format("parquet").save(output_path)

# 导出成csv
cleaned_df.write.mode("overwrite").format("com.databricks.spark.csv").save(output_path)

# 停止SparkSession
spark.stop()
