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
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "t480";

  # Static IP — ThinkPad T480 ethernet is typically enp0s31f6, verify with: ip link show
  networking.networkmanager.unmanaged = [ "interface-name:enp0s31f6" ];
  networking.interfaces.enp0s31f6 = {
    useDHCP = false;
    ipv4.addresses = [{ address = "192.168.1.102"; prefixLength = 24; }];
  };
  networking.defaultGateway = "192.168.1.1";
  networking.nameservers = [ "192.168.1.11" "8.8.8.8" ];

  users.users.davidemark = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" "input" "libvirtd" ];
  };

  services.tlp.enable = true;
  services.thermald.enable = true;

  security.pam.services.swaylock = {};

  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;
  programs.virt-manager.enable = true;

  environment.systemPackages = with pkgs; [
    brightnessctl
    virt-manager
  ];

  system.stateVersion = "26.05";
}