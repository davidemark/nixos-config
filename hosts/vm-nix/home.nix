{ config, pkgs, ... }:

{
  imports = [
    ../../modules/home/bash.nix
    ../../modules/home/scripts.nix
    ../../modules/home/claude.nix
    ../../modules/home/neovim.nix
  ];

  home.username = "davidemark";
  home.homeDirectory = "/home/davidemark";
  home.stateVersion = "26.05";
  programs.home-manager.enable = true;
}
