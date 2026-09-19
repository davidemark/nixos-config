{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    brave
    bruno
    claude-code
    distrobox
    obsidian
    ollama
    qbittorrent
    tor-browser
    vesktop
    vscode
  ];
}
