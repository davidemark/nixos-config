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

  # BenQ EX2780Q on HDMI. TODO: check the output name with `niri msg outputs` after the install (HDMI-A-1 is the
  # usual name; a wrong name is ignored by niri, the monitor then uses its preferred mode).
  my.niri.outputs = [
    "output \"HDMI-A-1\" {"
    "    mode \"2560x1440@60.000\""
    "}"
  ];

  # TODO: temperatureHwmon (k10temp path: `ls -d /sys/devices/pci*/*/hwmon`) and ethernetInterface once known.
}
