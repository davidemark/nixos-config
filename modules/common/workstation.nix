# What every NixOS workstation has in common besides the shared modules: the user, the lock screen
# PAM service and the stateVersion. The hosts add their own keys and groups on top.
{ ... }:

{
  users.users.davidemark = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" "input" ];
  };

  security.pam.services.swaylock = {};

  system.stateVersion = "26.05";
}
