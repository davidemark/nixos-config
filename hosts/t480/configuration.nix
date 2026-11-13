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
    # claude-rc (its Claude sessions) can log in as this user, without port, agent or X11 forwarding. No root and
    # no passwordless sudo: it works on the repos and reads state. No `from=` on purpose: a Tailscale 100.x address
    # does not go in this public repo.
    openssh.authorizedKeys.keys = [
      "no-port-forwarding,no-agent-forwarding,no-X11-forwarding ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILXgpPCH+zxH7F0uu5YS2CVxdZAydY4+gUffvFIWFhOY davidemark@claude-rc"
    ];
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

  # Electron apps (vesktop, vscode, obsidian) use the Wayland backend instead of X11 through
  # xwayland-satellite, where vesktop showed a black window. Needs a new login to take effect.
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  environment.systemPackages = with pkgs; [
    brightnessctl
    bruno
    distrobox
    dwarf-fortress
    obsidian
    ollama  # on demand for pinolo: run `ollama serve`, models stay in ~/.ollama
    telegram-desktop
    vesktop
    vscode
  ];

  system.stateVersion = "26.05";
}