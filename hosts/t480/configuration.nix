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

  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    defaultNetwork.settings.dns_enabled = true;
  };

  virtualisation.containers.registries.search = [
    "docker.io"
    "ghcr.io"
    "quay.io"
  ];

  environment.systemPackages = with pkgs; [
    openmw
    virt-manager
  ];

  system.stateVersion = "26.05";
}