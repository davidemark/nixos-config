{ config, pkgs, ... }:

{
  imports = [
    ../../modules/home/base.nix
    ../../modules/home/neovim.nix
    ../../modules/home/ssh.nix
    ../../modules/home/vscode.nix
    ../../modules/home/kafka-dev.nix
    ../../modules/home/java-lsp.nix
    ../../modules/home/niri.nix
    ../../modules/home/waybar.nix
    ../../modules/home/waybar-style.nix
  ];

  my.niri = {
    outputs = [
      "output \"DP-1\" {"
      "    mode \"1920x1080@60.000\""
      "}"
    ];
    audioFallbackKeys = [
      "// Fallback senza tasti multimediali: Mod+F1..F6 (volume F1-F3, microfono F4-F6)"
      "Mod+F1 allow-when-locked=true { spawn \"sh\" \"-c\" \"wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle\"; }"
      "Mod+F2 allow-when-locked=true { spawn \"sh\" \"-c\" \"wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-\"; }"
      "Mod+F3 allow-when-locked=true { spawn \"sh\" \"-c\" \"wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+ -l 1.0\"; }"
      "Mod+F4 allow-when-locked=true { spawn \"sh\" \"-c\" \"wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle\"; }"
      "Mod+F5 allow-when-locked=true { spawn \"sh\" \"-c\" \"wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 5%-\"; }"
      "Mod+F6 allow-when-locked=true { spawn \"sh\" \"-c\" \"wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 5%+ -l 1.0\"; }"
    ];
    extraBinds = [ "Alt+Print { screenshot-window; }" ];
  };

  # 4 GB of RAM (3.5 usable): VS Code is here too, used without other heavy programs; leave room for Maven and the app under test
  my.java.jdtlsXmx = "1g";

  # Interfaces of the other hosts are not verified yet: they use one generic network module
  my.waybar.ethernetInterface = "enp1s0";
  # CPU sensor k10temp, chosen by device path (hwmonN numbers change at boot)
  my.waybar.temperatureHwmon = "/sys/devices/pci0000:00/0000:00:18.3/hwmon";
}