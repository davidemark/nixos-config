# Wallpaper at login (niri startup) and Mod+W / Mod+Shift+W (safe / unsafe), same on every host.
# The folder is ~/repositories/wallpapers/<resolution>/<safe|unsafe>; a host with another screen
# sets my.wallpaper.resolution. Logic and fallbacks: scripts/home/wallpaper.sh.
{ config, lib, pkgs, ... }:

{
  options.my.wallpaper.resolution = lib.mkOption {
    type = lib.types.str;
    default = "1920x1080";
    example = "3440x1440";
    description = "Name of the resolution folder inside the wallpapers repo used by this host.";
  };

  config.home.file = {
    ".local/bin/cycle-wallpaper.sh" = {
      executable = true;
      source = ../../scripts/home/cycle-wallpaper.sh;
    };
    ".local/bin/wallpaper" = {
      executable = true;
      source = pkgs.replaceVars ../../scripts/home/wallpaper.sh {
        resolution = config.my.wallpaper.resolution;
        notify_send = "${pkgs.libnotify}/bin/notify-send";
      };
    };
  };
}
