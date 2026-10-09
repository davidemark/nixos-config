{ config, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/common/base.nix
    ../../modules/common/apps.nix
    ../../modules/common/dev.nix
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

  # Static IP — verify interface name with: ip link show (desktop NICs vary)
  # TODO: replace enp3s0 with actual interface name if different
  networking.networkmanager.unmanaged = [ "interface-name:enp3s0" ];
  networking.interfaces.enp3s0 = {
    useDHCP = false;
    ipv4.addresses = [{ address = "192.168.1.100"; prefixLength = 24; }];
  };
  networking.defaultGateway = "192.168.1.1";
  networking.nameservers = [ "192.168.1.11" "8.8.8.8" ];

  users.users.davidemark = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" "input" ];
  };

  services.tailscale.enable = true;

  security.pam.services.swaylock = {};

  system.stateVersion = "26.05";
}
