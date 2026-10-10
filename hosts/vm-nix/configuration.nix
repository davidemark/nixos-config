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
  ];

  swapDevices = [{ device = "/swapfile"; size = 4096; }];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "vm-nix";

  # Proxmox VirtIO NIC — typically ens18, verify with: ip link show
  networking.networkmanager.unmanaged = [ "interface-name:ens18" ];
  networking.interfaces.ens18 = {
    useDHCP = false;
    ipv4.addresses = [{ address = "192.168.1.13"; prefixLength = 24; }];
  };
  networking.defaultGateway = "192.168.1.1";
  networking.nameservers = [ "192.168.1.11" "8.8.8.8" ];

  users.users.davidemark = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" "input" ];
  };

  services.tailscale.enable = true;
  services.qemuGuest.enable = true;

  security.pam.services.swaylock = {};

  environment.systemPackages = with pkgs; [
    rustdesk
  ];

  system.stateVersion = "26.05";
}
