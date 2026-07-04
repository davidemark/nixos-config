{ config, pkgs, ... }:
{
  programs.bash = {
    enable = true;
    shellAliases = {
      ns = "niri-session";
      ff = "fastfetch";
      cc = "clear";
      grep = "grep --color=auto";
      vim = "nvim";
      nixc = "nvim ~/repositories/nixos-config";
      nixt480 = "nvim ~/repositories/nixos-config/hosts/t480";
      nixs720 = "nvim ~/repositories/nixos-config/hosts/s720";
    };
  };
}
