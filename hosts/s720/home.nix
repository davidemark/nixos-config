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
    ../../modules/home/ssh.nix
    ../../modules/home/claude.nix
    ../../modules/home/neovim.nix
    ../../modules/home/kafka-dev.nix
    ./home/niri.nix
    ../../modules/home/waybar.nix
    ../../modules/home/waybar-style.nix
  ];

  home.username = "davidemark";
  home.homeDirectory = "/home/davidemark";
  home.stateVersion = "26.05";
  programs.home-manager.enable = true;

  # Interfaces of the other hosts are not verified yet: they use one generic network module
  my.waybar.ethernetInterface = "enp1s0";
}