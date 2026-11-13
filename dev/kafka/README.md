# Local Kafka for learning

One KRaft broker in Podman, started only when needed (t480 and s720 get the aliases from `modules/home/java-dev.nix`).

```bash
kafka-up                 # broker on localhost:29092
kafka-ui-up              # broker + web UI on http://localhost:8080
kafka-down               # stop and remove everything (topics are lost)
```

Without the aliases: `podman-compose -f dev/kafka/compose.yaml up -d` (add `--profile ui` for the UI).

Try it:

```bash
kcat -b localhost:29092 -L                                   # broker and topics
echo hello | kcat -b localhost:29092 -P -t test              # produce
kcat -b localhost:29092 -C -t test -e                        # consume and exit
podman exec kafka /opt/kafka/bin/kafka-topics.sh --bootstrap-server kafka:9092 --list   # official tools, no install
```

Spring or plain Java clients use `bootstrap.servers=localhost:29092`.
