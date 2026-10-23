{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/common/base.nix
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
  # With the cable unplugged, the static routes above stay in the table with metric 0 and win
  # over Wi-Fi (metric 600), killing IPv4. Tell the kernel to skip routes on a link that is down.
  boot.kernel.sysctl = {
    "net.ipv4.conf.all.ignore_routes_with_linkdown" = 1;
    "net.ipv4.conf.default.ignore_routes_with_linkdown" = 1;
    "net.ipv4.conf.enp0s31f6.ignore_routes_with_linkdown" = 1;
  };
  networking.nameservers = [ "192.168.1.11" "8.8.8.8" ];

  users.users.davidemark = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" "input" ];  # add "libvirtd" with the VMs below
  };

  services.tailscale.enable = true;

  services.tlp.enable = true;
  services.thermald.enable = true;

  security.pam.services.swaylock = {};

  # VMs (virt-manager + libvirt), disabled 2026-10-23: only a win98 VM, unused since July.
  # Uncomment these three lines and add "libvirtd" to extraGroups to bring them back.
  # virtualisation.libvirtd.enable = true;
  # virtualisation.spiceUSBRedirection.enable = true;
  # programs.virt-manager.enable = true;

  environment.systemPackages = with pkgs; [
    brightnessctl
    bruno
    distrobox
    dwarf-fortress
    obsidian
    vesktop
    vscode
  ];

  system.stateVersion = "26.05";
}