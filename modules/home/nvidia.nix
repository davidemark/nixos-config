{ config, pkgs, ... }:

{
  boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest;

  # Driver NVIDIA proprietario — necessario per RTX 4070, no nouveau
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    enable = true;
    modesetting.enable = true;          # richiesto per Wayland/Niri
    powerManagement.enable = false;      # non serve, non è un laptop
    open = false;                        # kernel module proprietario, più stabile del driver open per la serie 40
    nvidiaSettings = true;
    # IMPORTANTE: con nix-cachyos-kernel va referenziato così,
    # non con pkgs.linuxPackages.nvidiaPackages — altrimenti
    # nix prova a buildare il modulo contro il kernel sbagliato
    # e i due driver collidono (vedi issue #13 del repo).
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "nvidia";
    NVD_BACKEND = "direct";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
  };
}