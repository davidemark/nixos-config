# Telegram Desktop on every NixOS host except hp (t480, master, d3d3, s720).
{ pkgs, ... }:

{
  environment.systemPackages = [ pkgs.telegram-desktop ];
}
