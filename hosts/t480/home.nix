{ config, pkgs, ... }:
{
  imports = [
    ./home/bash.nix
    ./home/foot.nix
    ./home/waybar.nix
    ./home/niri.nix
    ./home/neovim.nix
    ./home/scripts.nix
  ];

  home.username = "davidemark";
  home.homeDirectory = "/home/davidemark";
  home.stateVersion = "26.05";
  programs.home-manager.enable = true;
}
