{ config, pkgs, ... }:
{
  programs.swaylock = {
    enable = true;
    settings = {
      color = "1e1e2e";
      font = "JetBrainsMono Nerd Font";
      indicator-radius = 100;
      indicator-thickness = 7;
      ring-color = "89b4fa";
      ring-ver-color = "a6e3a1";
      ring-wrong-color = "f38ba8";
      inside-color = "1e1e2e";
      inside-ver-color = "1e1e2e";
      inside-wrong-color = "1e1e2e";
      key-hl-color = "cdd6f4";
      text-color = "cdd6f4";
      text-ver-color = "a6e3a1";
      text-wrong-color = "f38ba8";
      show-failed-attempts = true;
    };
  };

  services.swayidle = {
    enable = true;
    timeouts = [
      {
        timeout = 300;
        command = "${pkgs.swaylock}/bin/swaylock -f";
      }
      {
        timeout = 600;
        command = "niri msg action power-off-monitors";
      }
    ];
    events = [
      {
        event = "before-sleep";
        command = "${pkgs.swaylock}/bin/swaylock -f";
      }
    ];
  };
}
