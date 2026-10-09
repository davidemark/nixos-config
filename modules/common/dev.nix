{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    go
    jdk21
    maven
    nodejs_24
    python3
  ];
}
