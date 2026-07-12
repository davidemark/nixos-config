{ config, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/common/base.nix
    ../../modules/common/apps.nix
    ../../modules/common/audio.nix
    ../../modules/common/fonts.nix
    ../../modules/common/portal.nix
    ../../modules/common/bluetooth.nix
    ../../modules/common/gaming.nix
    ../../modules/common/nvidia.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "master";

  users.users.davidemark = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" "input" ];
  };

  security.pam.services.swaylock = {};

  system.stateVersion = "26.05";
}
