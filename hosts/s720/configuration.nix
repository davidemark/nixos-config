{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/common/base.nix
    ../../modules/common/dev.nix
    ../../modules/common/audio.nix
    ../../modules/common/fonts.nix
    ../../modules/common/portal.nix
  ];

  swapDevices = [{ device = "/swapfile"; size = 4096; }];

  boot.loader.grub = {
    enable = true;
    device = "/dev/sda";
  };
  # use amdgpu instead of radeon for better performance on Kabini (GX-222GC)
  boot.kernelParams = [ "amdgpu.cik_support=1" "radeon.cik_support=0" ];

  networking.hostName = "s720";

  # Static IP — unmanage from NetworkManager, configure via NixOS networking stack
  networking.networkmanager.unmanaged = [ "interface-name:enp1s0" ];
  networking.interfaces.enp1s0 = {
    useDHCP = false;
    ipv4.addresses = [{ address = "192.168.1.101"; prefixLength = 24; }];
  };
  networking.defaultGateway = "192.168.1.1";
  networking.nameservers = [ "192.168.1.11" "8.8.8.8" ];

  users.users.davidemark = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" "input" ];
  };

  services.tailscale.enable = true;

  services.tlp.enable = true;
  services.thermald.enable = true;

  security.pam.services.swaylock = {};

  environment.systemPackages = with pkgs; [
    bruno
    distrobox
    mgba
    ollama
    qbittorrent
    vesktop
  ];

  system.stateVersion = "26.05";
}