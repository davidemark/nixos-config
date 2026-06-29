{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  # Boot — Legacy BIOS con GRUB
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";

  # Flake
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Rete
  networking.hostName = "s720";
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

  # Grafica AMD
  hardware.graphics.enable = true;

  # Niri
  programs.niri.enable = true;

  # Audio
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  # Garbage collection automatico
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
