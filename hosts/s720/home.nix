{ config, pkgs, ... }:

{
  imports = [
    ../../modules/home/base.nix
    ../../modules/home/neovim.nix
    ../../modules/home/ssh.nix
    ../../modules/home/vscode.nix
    ../../modules/home/kafka-dev.nix
    ../../modules/home/java-lsp.nix
    ./home/niri.nix
    ../../modules/home/waybar.nix
    ../../modules/home/waybar-style.nix
  ];

  # 4 GB of RAM (3.5 usable): VS Code is here too, used without other heavy programs; leave room for Maven and the app under test
  my.java.jdtlsXmx = "1g";

  # Interfaces of the other hosts are not verified yet: they use one generic network module
  my.waybar.ethernetInterface = "enp1s0";
  # CPU sensor k10temp, chosen by device path (hwmonN numbers change at boot)
  my.waybar.temperatureHwmon = "/sys/devices/pci0000:00/0000:00:18.3/hwmon";
}