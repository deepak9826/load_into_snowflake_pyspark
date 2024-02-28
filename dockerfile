# Use an official Python runtime as a parent image
FROM python:3.8-slim
FROM openjdk:11-jdk

# Set the working directory in the container
WORKDIR /app

# Copy the Python script, config file, input data, and log4j.properties into the container
COPY load_data_into_snowflake.py config.py input_data.csv log4j.properties ./

RUN apt-get update && \
    apt-get install -y openjdk-11-jdk && \
    rm -rf /var/lib/apt/lists/*

RUN apt-get update && \
    apt-get install -y python3-dev && \
    apt-get install -y python3-pip && \
    rm -rf /var/lib/apt/lists/*
# Install any needed packages specified in requirements.txt
RUN pip install pyspark==3.3

ENV JAVA_HOME /usr/lib/jvm/java-11-openjdk-amd64
ENV PATH $JAVA_HOME/bin:$PATH

# RUN curl -O https://downloads.apache.org/hadoop/common/hadoop-3.2.3/hadoop-3.2.3.tar && \
#     tar -xzvf hadoop-3.2.3.tar && \
#     mv hadoop-3.2.3 /usr/local/hadoop && \
#     rm hadoop-3.2.3.tar.gz


# Set Hadoop environment variables
# ENV HADOOP_HOME /usr/local/hadoop
# ENV PATH $HADOOP_HOME/bin:$PATH

# Run the Python script when the container launches
CMD ["python3", "load_data_into_snowflake.py"]
