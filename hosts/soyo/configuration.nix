# SOYO M5 mini PC (Ryzen 3 4300U, Radeon Vega, 16 GB): small desktop for coding, games and experiments.
{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/common/workstation.nix
    ../../modules/common/base.nix
    ../../modules/common/dev.nix
    ../../modules/common/telegram.nix
    ../../modules/common/audio.nix
    ../../modules/common/fonts.nix
    ../../modules/common/portal.nix
    ../../modules/common/indigo-diag.nix
    ../../modules/common/bluetooth.nix
    ../../modules/common/steam.nix
    ../../modules/common/gaming.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Integrated Radeon Vega: amdgpu loaded in the initrd for early KMS (Mesa/RADV come with niri and Steam).
  boot.initrd.kernelModules = [ "amdgpu" ];

  networking.hostName = "soyo";

  # TODO after the install: read the Ethernet interface name (`ip link show`), then replace this comment with the
  # same static block the other hosts use (192.168.1.103/24, interface unmanaged by NetworkManager). Until then the
  # host uses DHCP through NetworkManager, which is safe with any interface name: the router reserves .103 for the
  # MAC of the Ethernet card, so the address is the same either way.
  #
  #   networking.networkmanager.unmanaged = [ "interface-name:<name>" ];
  #   networking.interfaces.<name> = {
  #     useDHCP = false;
  #     ipv4.addresses = [{ address = "192.168.1.103"; prefixLength = 24; }];
  #   };
  #   networking.defaultGateway = "192.168.1.1";
  networking.nameservers = [ "192.168.1.11" "8.8.8.8" ];

  users.users.davidemark = {
    # claude-rc (its Claude sessions) can log in as this user, without port, agent or X11 forwarding. No root and
    # no passwordless sudo: it works on the repos and reads state. No `from=` on purpose: a Tailscale 100.x address
    # does not go in this public repo.
    # TODO: add the public key davidemark@soyo here once the key exists (ssh-keygen -t ed25519 -C davidemark@soyo).
    openssh.authorizedKeys.keys = [
      "no-port-forwarding,no-agent-forwarding,no-X11-forwarding ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILXgpPCH+zxH7F0uu5YS2CVxdZAydY4+gUffvFIWFhOY davidemark@claude-rc"
    ];
  };

  services.tailscale.enable = true;

  # Electron apps (vesktop, vscode, obsidian) use the Wayland backend, as on the t480.
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  environment.systemPackages = with pkgs; [
    distrobox
    obsidian
    vesktop
  ];
}
