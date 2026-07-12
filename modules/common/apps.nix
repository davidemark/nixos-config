{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    bruno
    claude-code
    distrobox
    ollama
    qbittorrent
    tor-browser
    vesktop
    vscode
  ];
}