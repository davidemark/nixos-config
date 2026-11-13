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
    ../../modules/home/ssh.nix
    ../../modules/home/claude.nix
    ../../modules/home/neovim.nix
    ../../modules/home/java-dev.nix
    ./home/niri.nix
    ./home/waybar.nix
  ];

  home.username = "davidemark";
  home.homeDirectory = "/home/davidemark";
  home.stateVersion = "26.05";
  programs.home-manager.enable = true;

  # 4 GB of RAM: leave room for Maven, the app under test and the browser
  my.java.jdtlsXmx = "1g";

}