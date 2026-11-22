# XDG desktop portal, gvfs and thumbnails for the file manager and file dialogs.
{ config, pkgs, ... }:

{
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config.common.default = "*";
  };

  services.gvfs.enable = true;
  services.tumbler.enable = true;
}