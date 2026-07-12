{ config, pkgs, ... }:
{
  programs.bash = {
    enable = true;
    
    sessionVariables = {
      GTK_THEME = "catppuccin-frappe-blue-standard";
    };

    shellAliases = {
      ns = "niri-session";
      ff = "fastfetch";
      cc = "clear";
      la = "ls -lh --color=auto";
      lla = "ls -lah --color=auto";
      grep = "grep --color=auto";
      vim = "nvim";
      nmcli-scan = "nmcli device wifi rescan";
      nmcli-list = "nmcli device wifi list";
      nixc = "nvim ~/repositories/nixos-config";
      nixt480 = "nvim ~/repositories/nixos-config/hosts/t480";
      nixs720 = "nvim ~/repositories/nixos-config/hosts/s720";
      buildt480 = "sudo nixos-rebuild switch --flake .#t480";
      builds720 = "sudo nixos-rebuild switch --flake .#s720";
      buildhp = "sudo nixos-rebuild switch --flake .#hp";
      buildmaster = "sudo nixos-rebuild switch --flake .#master";
      buildd3d3 = "sudo nixos-rebuild switch --flake .#d3d3";
    };
  };
}
