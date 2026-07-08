{ config, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/common/base.nix
    ../../modules/common/audio.nix
    ../../modules/common/fonts.nix
    ../../modules/common/portal.nix
    ../../modules/common/bluetooth.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "t480";

  users.users.davidemark = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" "input" "libvirtd" ];
  };

  hardware.graphics.enable = true;

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
  };

  services.tlp.enable = true;
  services.thermald.enable = true;

  security.pam.services.swaylock = {};

  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;
  programs.virt-manager.enable = true;

  environment.systemPackages = with pkgs; [
    heroic
    lutris
    ollama
    openmw
    prismlauncher
    qbittorrent
    virt-manager
  ];

  system.stateVersion = "26.05";
}