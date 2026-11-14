# Telegram Desktop on every NixOS host except s720 and hp (t480, master, d3d3).
{ pkgs, ... }:

{
  environment.systemPackages = [ pkgs.telegram-desktop ];
}
