# PLACEHOLDER so that `nix flake check` works before the install. Replace this whole file with the output of
# `nixos-generate-config --show-hardware-config` run on the soyo during the install (see the second-brain note
# "Installazione soyo"), then commit it. The labels below are not real: the generated file uses UUIDs.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "sd_mod" ];
  boot.kernelModules = [ "kvm-amd" ];

  fileSystems."/" = { device = "/dev/disk/by-label/nixos"; fsType = "ext4"; };
  fileSystems."/boot" = { device = "/dev/disk/by-label/BOOT"; fsType = "vfat"; };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
