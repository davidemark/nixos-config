# Extras on top of Steam for the machines that game seriously (t480, master): Remote Play ports, gamescope,
# gamemode and game launchers. Needs steam.nix too (it enables the client).
{ pkgs, ... }:

{
  programs.steam = {
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    gamescopeSession.enable = true;
  };

  programs.gamemode.enable = true;

  environment.systemPackages = with pkgs; [
    heroic
    lutris
    mangohud
    mgba
    openmw
  ];
}