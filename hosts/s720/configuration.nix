{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/common/workstation.nix
    ../../modules/common/base.nix
    ../../modules/common/dev.nix
    ../../modules/common/audio.nix
    ../../modules/common/fonts.nix
    ../../modules/common/portal.nix
    ../../modules/common/indigo-diag.nix
    ../../modules/common/telegram.nix
    ../../modules/common/steam.nix
  ];

  swapDevices = [{ device = "/swapfile"; size = 4096; }];

  boot.loader.grub = {
    enable = true;
    device = "/dev/sda";
  };
  # use amdgpu instead of radeon for better performance on Kabini (GX-222GC)
  boot.kernelParams = [ "amdgpu.cik_support=1" "radeon.cik_support=0" ];

  # Steam (Morrowind, base game through Proton) on a Radeon HD 8280E (Kabini, GCN 1.1) with 3.5 GB of RAM.
  # - Vulkan: RADV (Mesa) supports GCN 1.1 only through the amdgpu driver, which the cik_support kernel
  #   parameters above already select; the 32-bit Mesa that Steam and Proton need comes from
  #   hardware.graphics.enable32Bit in base.nix. Nothing else to add for the driver.
  # - No Steam autostart: nothing in niri or systemd starts it, the client (a browser engine, ~500 MB) runs only
  #   when launched (Mod+G).
  # - Left out on purpose, they only use RAM or CPU here: gamescope session, gamemode, Remote Play ports (gaming.nix).
  # - If Proton's default (DXVK, Vulkan) glitches in a game, set the game's launch option in Steam to
  #   PROTON_USE_WINED3D=1 %command% (OpenGL through radeonsi, steadier on old GPUs). See the vault, 06-Infrastructure.
  # vulkan-tools (below): vulkaninfo --summary shows whether RADV sees the GPU.

  networking.hostName = "s720";

  # Static IP — unmanage from NetworkManager, configure via NixOS networking stack
  networking.networkmanager.unmanaged = [ "interface-name:enp1s0" ];
  networking.interfaces.enp1s0 = {
    useDHCP = false;
    ipv4.addresses = [{ address = "192.168.1.101"; prefixLength = 24; }];
    wakeOnLan.enable = true;
  };
  networking.defaultGateway = "192.168.1.1";
  networking.nameservers = [ "192.168.1.11" "8.8.8.8" ];

  # Il .link di systemd (wakeOnLan.enable) non basta: a runtime la scheda Realtek restava su "Wake-on: d".
  # Reimposta il WoL a ogni avvio. TLP lo azzerava poco dopo (WOL_DISABLE=Y di default, vedi sotto).
  systemd.services.wol-enp1s0 = {
    description = "Enable Wake-on-LAN on enp1s0";
    after = [ "sys-subsystem-net-devices-enp1s0.device" "network-addresses-enp1s0.service" ];
    bindsTo = [ "sys-subsystem-net-devices-enp1s0.device" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.ethtool}/bin/ethtool -s enp1s0 wol g";
    };
  };

  users.users.davidemark = {
    # claude-rc (its Claude sessions) can also log in as this user, without port, agent or X11 forwarding. No
    # root and no passwordless sudo. No `from=` on purpose: a Tailscale 100.x address does not go in this public repo.
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDLsQmYJl3w+J571izFfLOLTDTi3Bx1QfeXgQkG+eij9 davidemark@t480"
      "no-port-forwarding,no-agent-forwarding,no-X11-forwarding ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILXgpPCH+zxH7F0uu5YS2CVxdZAydY4+gUffvFIWFhOY davidemark@claude-rc"
    ];
  };

  # claude-rc (its Claude sessions) can log in as root with its ed25519 key, to power the s720 off
  # and to work on it without a password.
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILXgpPCH+zxH7F0uu5YS2CVxdZAydY4+gUffvFIWFhOY davidemark@claude-rc"
  ];

  services.tailscale.enable = true;

  services.tlp.enable = true;
  # TLP di default spegne il Wake-on-LAN delle schede di rete: qui serve per il risveglio da spento.
  services.tlp.settings.WOL_DISABLE = "N";
  services.thermald.enable = true;

  environment.systemPackages = with pkgs; [
    distrobox
    dwarf-fortress
    mgba
    qbittorrent
    vesktop
    vulkan-tools
  ];
}