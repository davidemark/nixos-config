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
    ../../modules/home/java-dev.nix
    ../../modules/home/ssh.nix
    ./home/niri.nix
    ./home/waybar.nix
  ];

  home.username = "davidemark";
  home.homeDirectory = "/home/davidemark";
  home.stateVersion = "26.05";
  programs.home-manager.enable = true;

  my.java.jdtlsXmx = "2g";

  # VS Code with the extensions already installed by hand. The extensions folder stays writable:
  # home-manager only adds one symlink per extension below, so extensions installed from the
  # editor (for example learn-vim, which is not in nixpkgs) keep working.
  programs.vscode = {
    enable = true;
    mutableExtensionsDir = true;
    profiles.default.extensions = with pkgs.vscode-extensions; [
      jnoortheen.nix-ide
      ritwickdey.liveserver
      vscodevim.vim
    ];
  };
}