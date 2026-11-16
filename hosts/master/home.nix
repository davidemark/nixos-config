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
    ../../modules/home/claude.nix
    ../../modules/home/neovim.nix
    ../../modules/home/vscode.nix
    ./home/niri.nix
    ../../modules/home/waybar.nix
    ../../modules/home/waybar-style.nix
  ];

  home.username = "davidemark";
  home.homeDirectory = "/home/davidemark";
  home.stateVersion = "26.05";
  programs.home-manager.enable = true;

  # Ultrawide 21:9 screen (stated by DavideMark, not checked with niri msg outputs)
  my.wallpaper.resolution = "3440x1440";
}