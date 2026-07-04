{ config, pkgs, ... }:
{
  programs.bash = {
    enable = true;
    shellAliases = {
      ns = "niri-session";
      ff = "fastfetch";
      cc = "clear";
      la = "ls -lh --color=auto";
      lla = "ls -lah --color=auto";
      grep = "grep --color=auto";
      vim = "nvim";
      nixc = "nvim ~/repositories/nixos-config";
      nixt480 = "nvim ~/repositories/nixos-config/hosts/t480";
      nixs720 = "nvim ~/repositories/nixos-config/hosts/s720";
      buildt480 = "sudo nixos-rebuild switch --flake .#t480";
      builds720 = "sudo nixos-rebuild switch --flake .#s720";
    };
  };
}
