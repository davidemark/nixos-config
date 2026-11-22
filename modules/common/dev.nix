# Development toolchains: Go, JDK 25 with Maven, Node.js, Python.
{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    go
    jdk25
    # Maven sets JAVA_HOME to the default jdk (21) unless told otherwise
    (maven.override { jdk_headless = jdk25_headless; })
    nodejs_24
    python3
  ];
}
