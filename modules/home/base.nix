# What every workstation's home-manager config has in common: the user and the modules every host uses.
# Host-specific modules (vscode, java, kafka, ssh, niri, waybar) stay in each hosts/<host>/home.nix.
# neovim.nix is imported by each host right after this module, not from here: modules imported through
# another module are merged after the host's own ones, which reorders the nixvim keymaps (java-lsp.nix).
{ ... }:

{
  imports = [
    ./bash.nix
    ./starship.nix
    ./foot.nix
    ./mako.nix
    ./gtk.nix
    ./xdg-dirs.nix
    ./lock.nix
    ./scripts.nix
    ./wallpaper.nix
    ./claude.nix
  ];

  home.username = "davidemark";
  home.homeDirectory = "/home/davidemark";
  home.stateVersion = "26.05";
  programs.home-manager.enable = true;
}
