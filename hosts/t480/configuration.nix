{ config, pkgs, ... }:
{
  imports = [ ./hardware-configuration.nix ];

  # Boot — UEFI con systemd-boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Flake
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Pacchetti non liberi
  nixpkgs.config.allowUnfree = true;

  # Rete
  networking.hostName = "t480";
  networking.networkmanager.enable = true;

  # Timezone e locale
  time.timeZone = "Europe/Rome";
  i18n.defaultLocale = "en_US.UTF-8";

  # Utente
  users.users.davidemark = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" "input" ];
  };

  # SSH
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = true;
  };

  # Grafica Intel
  hardware.graphics.enable = true;

  # Niri
  programs.niri.enable = true;

  # Steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
  };

  # Audio
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  # Thunar
  services.gvfs.enable = true;
  services.tumbler.enable = true;

  # Portale XDG
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config.common.default = "*";
  };

  # ThinkPad — risparmio energetico e batteria
  services.tlp.enable = true;
  services.thermald.enable = true;

  # Garbage collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  # Pacchetti
  environment.systemPackages = with pkgs; [
    asciiquarium
    bluetui
    btop
    cbonsai
    cava
    claude-code
    cmatrix
    curl
    discord
    distrobox
    fastfetch
    firefox
    foot
    fuzzel
    git
    mako
    nchat
    neovim
    openmw
    podman
    prismlauncher
    thunar
    tree
    waybar
    wget
    xwayland-satellite
  ];

  system.stateVersion = "26.05";
}
