{ config, pkgs, ... }:
{
  services.mako = {
    enable = true;
    settings = {
      background-color = "#303446dd";
      text-color = "#c6d0f5";
      border-color = "#8caaeedd";
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
      border-color=#a6d189dd

      [urgency=normal]
      border-color=#8caaeedd

      [urgency=high]
      border-color=#e78284dd
      default-timeout=0
    '';
  };
}