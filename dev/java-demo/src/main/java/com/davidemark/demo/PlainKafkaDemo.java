package com.davidemark.demo;

import java.time.Duration;
import java.util.List;
import java.util.Properties;
import org.apache.kafka.clients.consumer.ConsumerRecord;
import org.apache.kafka.clients.consumer.KafkaConsumer;
import org.apache.kafka.clients.producer.KafkaProducer;
import org.apache.kafka.clients.producer.ProducerRecord;
import org.apache.kafka.common.serialization.StringDeserializer;
import org.apache.kafka.common.serialization.StringSerializer;

/** Plain Java Kafka client, no Spring: run its main with the debugger (needs `kafka-up`). */
public class PlainKafkaDemo {

  private static final String BOOTSTRAP = "localhost:29092";
  private static final String TOPIC = "demo-plain";

  public static void main(String[] args) {
    Properties producerProps = new Properties();
    producerProps.put("bootstrap.servers", BOOTSTRAP);
    producerProps.put("key.serializer", StringSerializer.class.getName());
    producerProps.put("value.serializer", StringSerializer.class.getName());
    try (KafkaProducer<String, String> producer = new KafkaProducer<>(producerProps)) {
      producer.send(new ProducerRecord<>(TOPIC, "key", "hello from plain Java"));
      producer.flush();
    }

    Properties consumerProps = new Properties();
    consumerProps.put("bootstrap.servers", BOOTSTRAP);
    consumerProps.put("group.id", "demo-plain");
    consumerProps.put("auto.offset.reset", "earliest");
    consumerProps.put("key.deserializer", StringDeserializer.class.getName());
    consumerProps.put("value.deserializer", StringDeserializer.class.getName());
    try (KafkaConsumer<String, String> consumer = new KafkaConsumer<>(consumerProps)) {
      consumer.subscribe(List.of(TOPIC));
      for (ConsumerRecord<String, String> record : consumer.poll(Duration.ofSeconds(10))) {
        System.out.println("received: " + record.value());
      }
    }
  }
}
