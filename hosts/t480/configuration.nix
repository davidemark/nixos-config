{ config, pkgs, ... }:
{
  imports = [ ./hardware-configuration.nix ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nixpkgs.config.allowUnfree = true;

  networking.hostName = "t480";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Rome";
  i18n.defaultLocale = "en_US.UTF-8";

  users.users.davidemark = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" "input" "libvirtd" ];
  };

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = true;
  };

  hardware.graphics.enable = true;

  programs.niri.enable = true;

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
  };

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  services.gvfs.enable = true;
  services.tumbler.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config.common.default = "*";
  };

  services.tlp.enable = true;
  services.thermald.enable = true;

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  security.pam.services.swaylock = {};

  # Virtualizzazione
  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;
  programs.virt-manager.enable = true;

  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    defaultNetwork.settings.dns_enabled = true;
  };

  virtualisation.containers.registries.search = [
    "docker.io"
    "ghcr.io"
    "quay.io"
  ];

  environment.systemPackages = with pkgs; [
    ani-cli
    asciiquarium
    bluetui
    brightnessctl
    bruno
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
    qbittorrent
    git
    heroic
    lazygit
    lutris
    mako
    mgba
    nchat
    neovim
    nodejs_24
    ollama
    openmw
    python3
    playerctl
    podman
    podman-compose
    prismlauncher
    swaybg
    swaylock
    swayidle
    tailscale
    thunar
    tor-browser
    tree
    virt-manager
    vscode
    waybar
    wget
    wireplumber
    xwayland-satellite
    yazi
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  system.stateVersion = "26.05";
}
