FROM ubuntu:16.04

# Install OpenJDK 8
RUN apt-get update && apt-get install -y default-jre

# Install Spark 2.1.0
RUN apt-get update && apt-get install -y curl
RUN curl -s http://d3kbcqa49mib13.cloudfront.net/spark-2.1.0-bin-hadoop2.7.tgz | tar -xz -C /usr/local/
RUN cd /usr/local && ln -s spark-2.1.0-bin-hadoop2.7 spark

ENV SPARK_HOME "/usr/local/spark/"
ENV PYTHONPATH "/usr/local/spark/python/lib/pyspark.zip:/usr/local/spark/python/lib/py4j-0.10.4-src.zip"
ENV SPARK_TESTING true

RUN apt-get update && apt-get install -y python python3-pip
RUN pip3 install awscli==1.9.17

COPY spark-defaults.conf /usr/local/spark/conf/spark-defaults.conf
COPY hdfs-site.xml /usr/local/spark/conf/hdfs-site.xml

ENV AWS_ACCESS_KEY_ID FAKE
ENV AWS_SECRET_ACCESS_KEY FAKE
# Spark AWS dependencies
RUN mkdir -p /usr/local/spark/ext/
RUN curl -o /usr/local/spark/ext/hadoop-aws-2.7.1.jar http://central.maven.org/maven2/org/apache/hadoop/hadoop-aws/2.7.1/hadoop-aws-2.7.1.jar
RUN curl -o /usr/local/spark/ext/aws-java-sdk-1.7.4.jar http://central.maven.org/maven2/com/amazonaws/aws-java-sdk/1.7.4/aws-java-sdk-1.7.4.jar

ADD . /opt/local_s3
WORKDIR /opt/local_s3
