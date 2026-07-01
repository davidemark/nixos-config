{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  # Boot — UEFI con systemd-boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Flake
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

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

  # Audio
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
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

  # Pacchetti base
  environment.systemPackages = with pkgs; [
    curl
    fastfetch
    firefox
    foot
    fuzzel
    git
    mako
    neovim
    waybar
    wget
  ];

  system.stateVersion = "26.05";
}
