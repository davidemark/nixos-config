{ config, pkgs, ... }:
{
  imports = [
    ../../modules/home/bash.nix
    ../../modules/home/foot.nix
    ../../modules/home/mako.nix
    ../../modules/home/gtk.nix
    ../../modules/home/lock.nix
    ../../modules/home/scripts.nix
    ../../modules/home/neovim.nix
    ./home/niri.nix
    ./home/waybar.nix
  ];

  home.username = "davidemark";
  home.homeDirectory = "/home/davidemark";
  home.stateVersion = "26.05";
  programs.home-manager.enable = true;
}