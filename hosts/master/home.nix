{ config, pkgs, ... }:

{
  imports = [
    ../../modules/home/base.nix
    ../../modules/home/neovim.nix
    ../../modules/home/vscode.nix
    ./home/niri.nix
    ../../modules/home/waybar.nix
    ../../modules/home/waybar-style.nix
  ];

  # Ultrawide 21:9 screen (stated by DavideMark, not checked with niri msg outputs)
  my.wallpaper.resolution = "3440x1440";
}