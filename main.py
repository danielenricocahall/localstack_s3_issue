import os
from pyspark.sql import SparkSession

spark = SparkSession.builder.master("local").getOrCreate()

local_df = spark.read.json('/opt/local_s3/data/data.json')
local_df.show()

S3 = 'http://aws-docker:4572'
os.system('aws --endpoint-url={} s3 mb s3://my-tests'.format(S3))
os.system('aws --endpoint-url={} s3 sync data s3://my-tests/data'.format(S3))

remote_df = spark.read.json('s3://my-tests/data')
remote_df.show()
