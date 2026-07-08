{ config, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/common/base.nix
    ../../modules/common/audio.nix
    ../../modules/common/fonts.nix
    ../../modules/common/portal.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "s720";

  users.users.davidemark = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" "input" ];
  };

  hardware.graphics.enable = true;

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
  };

  services.tlp.enable = true;
  services.thermald.enable = true;

  security.pam.services.swaylock = {};

  environment.systemPackages = with pkgs; [
    heroic
    lutris
    ollama
    openmw
    prismlauncher
    qbittorrent
  ];

  system.stateVersion = "26.05";
}