{ config, pkgs, ... }:
{
  programs.bash = {
    enable = true;
    shellAliases = {
      ns = "niri-session";
      ff = "fastfetch";
      vim = "nvim";
      nixc = "nvim ~/repositories/nixos-config";
      nixt480 = "nvim ~/repositories/nixos-config/hosts/t480";
    };
  };
}
