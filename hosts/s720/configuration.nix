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
    ../../modules/common/gaming.nix
  ];

  boot.loader.grub = {
    enable = true;
    device = "/dev/sda";
  };
  # use amdgpu instead of radeon for better performance on Kabini (GX-222GC)
  boot.kernelParams = [ "amdgpu.cik_support=1" "radeon.cik_support=0" ];

  networking.hostName = "s720";

  users.users.davidemark = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" "input" ];
  };

  services.tlp.enable = true;
  services.thermald.enable = true;

  security.pam.services.swaylock = {};

  environment.systemPackages = with pkgs; [
  ];

  system.stateVersion = "26.05";
}