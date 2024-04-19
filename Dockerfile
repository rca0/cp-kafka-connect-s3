FROM confluentinc/cp-kafka-connect-base:7.5.3
RUN confluent-hub install --no-prompt confluentinc/kafka-connect-s3:latest

WORKDIR /etc/kafka

COPY entrypoint.sh . 
COPY connect-distributed-custom.properties .
COPY s3-sink.json .

EXPOSE 8083:8083
EXPOSE 9092:9092

CMD /etc/kafka/entrypoint.sh
