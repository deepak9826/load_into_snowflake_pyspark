from pyspark.sql import SparkSession
from config import *


# Create a SparkSession
spark = SparkSession.builder \
    .appName("SnowflakeExample") \
    .config("spark.jars.packages", "net.snowflake:snowflake-jdbc:3.15.0,net.snowflake:spark-snowflake_2.12:2.11.0-spark_3.3") \
    .config("spark.driver.extraJavaOptions", "-Dlog4j.configuration=file:log4j.properties") \
    .getOrCreate()



# Read data from source into a DataFrame
source_df = spark.read.format("csv").option("header", "true").load(file_path)
source_df=source_df.repartition(num_partitions)

# Write DataFrame to Snowflake
source_df.write \
    .format("net.snowflake.spark.snowflake") \
    .options(**sfOptions) \
    .option("dbtable", table_name) \
    .mode("overwrite") \
    .save()

# Stop SparkSession
spark.stop()