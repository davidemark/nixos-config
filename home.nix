{ config, pkgs, ... }:

{
  home.username = "davidemark";
  home.homeDirectory = "/home/davidemark";
  home.stateVersion = "26.05";

  programs.home-manager.enable = true;
}
