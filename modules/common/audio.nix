{ config, pkgs, ... }:

{
  # PipeWire asks RTKit for realtime priority; without it the journal logs
  # "RTKit error: ServiceUnknown" and audio can crackle under load.
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };
}