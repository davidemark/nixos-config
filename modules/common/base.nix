{ config, pkgs, ... }:
{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  time.timeZone = "Europe/Rome";
  i18n.defaultLocale = "en_US.UTF-8";

  networking.networkmanager.enable = true;

  programs.niri.enable = true;
  programs.dconf.enable = true;

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = true;
  };

  hardware.graphics.enable = true;

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  environment.systemPackages = with pkgs; [
    ani-cli
    asciiquarium
    bluetui
    brightnessctl
    bruno
    btop
    cbonsai
    cava
    catppuccin-gtk
    claude-code
    cmatrix
    curl
    distrobox
    fastfetch
    firefox
    foot
    fuzzel
    git
    heroic
    imv
    lazygit
    lutris
    mako
    mgba
    nchat
    neovim
    nodejs_24
    ollama
    papirus-icon-theme
    playerctl
    podman
    podman-compose
    prismlauncher
    python3
    qbittorrent
    swaybg
    swayidle
    swaylock
    tailscale
    thunar
    tor-browser
    tree
    vesktop
    vscode
    waybar
    wget
    wireplumber
    xwayland-satellite
    yazi
  ];
}