#!/bin/bash

PROPERTIES_FILE="/etc/kafka/connect-distributed-custom.properties"

S3_SINK_PROPERTIES_FILE="/etc/kafka/s3-sink.json"

# replacing ENV VARS...
sed -i "s|KAFKA_STORAGE_TOPICS_NAME|$KAFKA_STORAGE_TOPICS_NAME|g" $PROPERTIES_FILE
sed -i "s|KAFKA_PRODUCER_GROUP_ID|$KAFKA_PRODUCER_GROUP_ID|g" $PROPERTIES_FILE
sed -i "s|KAFKA_BOOTSTRAP_SERVERS|$KAFKA_BOOTSTRAP_SERVERS|g" $PROPERTIES_FILE
sed -i "s|KAFKA_USERNAME|$KAFKA_USERNAME|g" $PROPERTIES_FILE
sed -i "s|KAFKA_PASSWORD|$KAFKA_PASSWORD|g" $PROPERTIES_FILE

sed -i "s|CONNECT_NAME|$CONNECT_NAME|g" $S3_SINK_PROPERTIES_FILE
sed -i "s|SCHEMA_REGISTRY|$SCHEMA_REGISTRY|g" $S3_SINK_PROPERTIES_FILE
sed -i "s|SCHEMA_AUTH|$SCHEMA_AUTH|g" $S3_SINK_PROPERTIES_FILE
sed -i "s|AWS_KAFKA_BUCKET_NAME|$AWS_KAFKA_BUCKET_NAME|g" $S3_SINK_PROPERTIES_FILE

/usr/bin/connect-distributed $PROPERTIES_FILE &
sleep 60

echo "~> Creating S3SinkConnector Connector..."

curl -X POST -H "Content-Type: application/json" --data @"$S3_SINK_PROPERTIES_FILE" http://localhost:8083/connectors

echo "~> S3SinkConnector Connector Created..."

tail -f /dev/null
