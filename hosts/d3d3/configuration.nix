{ config, pkgs, ... }:

{
  imports = [
    # Generate on the machine itself: sudo nixos-generate-config --show-hardware-config > hosts/d3d3/hardware-configuration.nix
    ./hardware-configuration.nix
    ../../modules/common/base.nix
    ../../modules/common/dev.nix
    ../../modules/common/audio.nix
    ../../modules/common/fonts.nix
    ../../modules/common/portal.nix
  ];

  # Dell OptiPlex 790 USFF (i5 2nd gen, 2011): to check on the machine. Its BIOS boots both
  # UEFI and Legacy; if it is installed in Legacy mode, use GRUB on the disk like s720.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "d3d3";

  users.users.davidemark = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" "input" ];
  };

  services.tailscale.enable = true;

  services.thermald.enable = true;

  security.pam.services.swaylock = {};

  system.stateVersion = "26.05";
}
