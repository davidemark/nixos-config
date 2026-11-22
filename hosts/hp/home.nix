{ config, pkgs, ... }:

{
  imports = [
    ../../modules/home/base.nix
    ../../modules/home/neovim.nix
    ../../modules/home/niri.nix
    ../../modules/home/waybar.nix
    ../../modules/home/waybar-style.nix
  ];

  my.niri.touchpad = true;

  # Interfaces not verified yet: one generic network module; temperature left off until checked
  my.waybar = {
    backlight = true;
    microphone = true;
    bluetooth = true;
    battery = true;
  };
}