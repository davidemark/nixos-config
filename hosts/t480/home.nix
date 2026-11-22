{ config, pkgs, ... }:

{
  imports = [
    ../../modules/home/base.nix
    ../../modules/home/neovim.nix
    ../../modules/home/kafka-dev.nix
    ../../modules/home/java-lsp.nix
    ../../modules/home/vscode.nix
    ../../modules/home/ssh.nix
    ../../modules/home/niri.nix
    ../../modules/home/waybar.nix
    ../../modules/home/waybar-style.nix
  ];

  my.niri = {
    touchpad = true;
    columnWidth = "1.0";
  };

  my.java.jdtlsXmx = "2g";

  my.waybar = {
    backlight = true;
    microphone = true;
    bluetooth = true;
    battery = true;
    # coretemp, temp1 = "Package id 0" (thermal_zone0 is the virtual INT3400, 20 C: wrong)
    temperatureHwmon = "/sys/devices/platform/coretemp.0/hwmon";
    wifiInterface = "wlp3s0";
    ethernetInterface = "enp0s31f6";
  };
}