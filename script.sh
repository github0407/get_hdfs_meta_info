!/usr/bin/env bash
# spark-submit \
#   --class org.apache.spark.examples.SparkPi \
#   --master yarn \
#   --deploy-mode cluster \
#   --executor-memory 2G \
#   --num-executors 5 \
#   $SPARK_HOME/examples/jars/spark-examples_2.11-2.0.2.jar \
#   10000

sh sample_fetch.sh
