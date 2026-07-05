{ config, pkgs, ... }:
{
  services.mako = {
    enable = true;
    settings = {
      background-color = "#1e1e2edd";
      text-color = "#cdd6f4";
      border-color = "#89b4fadd";
      border-radius = 8;
      border-size = 2;
      font = "JetBrainsMono Nerd Font 12";
      width = 300;
      height = 100;
      margin = "10";
      padding = "12";
      default-timeout = 5000;
    };
    extraConfig = ''
      [urgency=low]
      border-color=#a6e3a1dd

      [urgency=normal]
      border-color=#89b4fadd

      [urgency=high]
      border-color=#f38ba8dd
      default-timeout=0
    '';
  };
}
