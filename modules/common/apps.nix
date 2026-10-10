{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    brave
    bruno
    claude-code
    distrobox
    ollama
    qbittorrent
    tor-browser
    vesktop
  ];
}
