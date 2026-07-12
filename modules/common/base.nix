{ config, pkgs, ... }:

{
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;
  };

  nixpkgs.config.allowUnfree = true;

  time.timeZone = "Europe/Rome";
  i18n.defaultLocale = "en_US.UTF-8";

  networking.networkmanager.enable = true;

  zramSwap.enable = true;

  programs.niri.enable = true;
  programs.dconf.enable = true;

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = true;
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

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
    btop
    catppuccin-gtk
    fastfetch
    firefox
    foot
    fuzzel
    git
    imv
    lazygit
    mako
    nchat
    neovim
    nodejs_24
    papirus-icon-theme
    playerctl
    podman
    podman-compose
    python3
    rclone
    swaybg
    swayidle
    swaylock
    tailscale
    thunar
    tree
    unzip
    waybar
    wireplumber
    xwayland-satellite
  ];
  
}