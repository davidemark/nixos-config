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
    ../../modules/home/claude.nix
    ../../modules/home/neovim.nix
    ./home/niri.nix
    ../../modules/home/waybar.nix
    ../../modules/home/waybar-style.nix
  ];

  home.username = "davidemark";
  home.homeDirectory = "/home/davidemark";
  home.stateVersion = "26.05";
  programs.home-manager.enable = true;

  # Interfaces not verified yet: one generic network module; temperature left off until checked
  my.waybar = {
    backlight = true;
    microphone = true;
    bluetooth = true;
    battery = true;
  };
}