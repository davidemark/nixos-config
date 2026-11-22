{ config, pkgs, ... }:

{
  imports = [
    ../../modules/home/base.nix
    ../../modules/home/neovim.nix
    ../../modules/home/vscode.nix
    ../../modules/home/niri.nix
    ../../modules/home/waybar.nix
    ../../modules/home/waybar-style.nix
  ];

}