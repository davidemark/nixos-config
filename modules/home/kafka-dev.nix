# Local Kafka broker for the machines used for coding (t480, s720): the broker and the demo project
# live in the playground-java repo. Start it only when needed (see playground-java/kafka/README.md).
{ ... }:

let
  kafkaCompose = "~/repositories/playground-java/kafka/compose.yaml";
in
{
  programs.bash.shellAliases = {
    kafka-up = "podman-compose -f ${kafkaCompose} up -d";
    kafka-ui-up = "podman-compose -f ${kafkaCompose} --profile ui up -d";
    kafka-down = "podman-compose -f ${kafkaCompose} --profile ui down";
  };
}
