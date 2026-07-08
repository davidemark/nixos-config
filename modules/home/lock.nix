{ config, pkgs, ... }:
{
  programs.swaylock = {
    enable = true;
    settings = {
      color = "303446";
      font = "JetBrainsMono Nerd Font";
      indicator-radius = 100;
      indicator-thickness = 7;
      ring-color = "8caaee";
      ring-ver-color = "a6d189";
      ring-wrong-color = "e78284";
      inside-color = "303446";
      inside-ver-color = "303446";
      inside-wrong-color = "303446";
      key-hl-color = "c6d0f5";
      text-color = "c6d0f5";
      text-ver-color = "a6d189";
      text-wrong-color = "e78284";
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
    events = {
      before-sleep = "${pkgs.swaylock}/bin/swaylock -f";
    };
  };
}