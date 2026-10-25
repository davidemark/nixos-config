{ config, pkgs, ... }:

{
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;
    max-jobs = 2;
    stalled-download-timeout = 90;
  };

  nixpkgs.config.allowUnfree = true;

  time.timeZone = "Europe/Rome";
  i18n.defaultLocale = "en_US.UTF-8";

  networking.networkmanager.enable = true;

  zramSwap.enable = true;

  # Keep kernel errors (e.g. the Bluetooth "Reading supported features failed") off the tty login
  # screen; they still go to the journal.
  boot.consoleLogLevel = 3;

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
    brave-origin
    btop
    catppuccin-gtk
    claude-code
    fastfetch
    foot
    fuzzel
    git
    imv
    lazygit
    mako
    nchat
    neovim
    papirus-icon-theme
    playerctl
    podman
    podman-compose
    rclone
    swaybg
    swayidle
    swaylock
    tailscale
    thunar
    tmux
    tree
    unzip
    waybar
    wireplumber
    wl-clipboard
    xwayland-satellite
  ];
  
}