# java-demo

Small Maven project (Java 21, Spring Boot, Lombok, Kafka clients) to try the editor set up in `modules/home/java-dev.nix` on t480 and s720. Maven only, no Gradle.

```bash
cd dev/java-demo && nvim src/main/java/com/davidemark/demo/GreetingController.java
```

| Try | How |
|---|---|
| Lombok | `Greeting` has no getters in the source; `greeting.getText()` in the test must have no error (jdtls loads the Lombok agent) |
| Test | in `GreetingTest`: `Space t n` (method), `Space t c` (class); or `mvn test` |
| Debugger | breakpoint `Space d b` in `GreetingController.hello`, `F5`, pick `DemoApplication`, then `curl localhost:8080/hello/Davide` |
| Format | `Space c f` (google-java-format) |
| Kafka, plain Java | `kafka-up`, then `F5` on `PlainKafkaDemo` |
| Kafka, Spring | `kafka-up`, run `DemoApplication` with `--demo.kafka.enabled=true`, `curl -X POST 'localhost:8080/kafka?message=hi'` |

First start downloads the Maven dependencies, and jdtls needs a minute to index the project.
