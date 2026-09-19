{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    jdk21
    maven
    nodejs_24
    python3
  ];
}
