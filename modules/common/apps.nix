{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    brightnessctl
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