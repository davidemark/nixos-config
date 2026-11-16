{ config, pkgs, ... }:

{
  imports = [
    ../../modules/home/bash.nix
    ../../modules/home/starship.nix
    ../../modules/home/foot.nix
    ../../modules/home/mako.nix
    ../../modules/home/gtk.nix
    ../../modules/home/xdg-dirs.nix
    ../../modules/home/lock.nix
    ../../modules/home/scripts.nix
    ../../modules/home/wallpaper.nix
    ../../modules/home/claude.nix
    ../../modules/home/neovim.nix
    ../../modules/home/kafka-dev.nix
    ../../modules/home/java-lsp.nix
    ../../modules/home/vscode.nix
    ../../modules/home/ssh.nix
    ./home/niri.nix
    ../../modules/home/waybar.nix
    ../../modules/home/waybar-style.nix
  ];

  home.username = "davidemark";
  home.homeDirectory = "/home/davidemark";
  home.stateVersion = "26.05";
  programs.home-manager.enable = true;

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