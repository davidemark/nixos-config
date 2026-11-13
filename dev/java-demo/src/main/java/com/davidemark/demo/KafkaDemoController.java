package com.davidemark.demo;

import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

/** Spring Kafka: producer and consumer in one place. Off by default, see demo.kafka.enabled. */
@RestController
@ConditionalOnProperty(name = "demo.kafka.enabled", havingValue = "true")
public class KafkaDemoController {

  static final String TOPIC = "demo";

  private final KafkaTemplate<String, String> template;

  public KafkaDemoController(KafkaTemplate<String, String> template) {
    this.template = template;
  }

  @PostMapping("/kafka")
  public String send(@RequestParam String message) {
    template.send(TOPIC, message);
    return "sent: " + message;
  }

  @KafkaListener(topics = TOPIC, groupId = "demo-spring")
  void listen(String message) {
    System.out.println("received: " + message);
  }
}
