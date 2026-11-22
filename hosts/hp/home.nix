{ config, pkgs, ... }:

{
  imports = [
    ../../modules/home/base.nix
    ../../modules/home/neovim.nix
    ./home/niri.nix
    ../../modules/home/waybar.nix
    ../../modules/home/waybar-style.nix
  ];

  # Interfaces not verified yet: one generic network module; temperature left off until checked
  my.waybar = {
    backlight = true;
    microphone = true;
    bluetooth = true;
    battery = true;
  };
}