{ config, pkgs, ... }:

{
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = false;  # off at boot, turn it on from blueman or bluetui
  services.blueman.enable = true;

  environment.systemPackages = with pkgs; [
    bluetui
  ];
}