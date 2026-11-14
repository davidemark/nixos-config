# VS Code and its extensions, the same on every NixOS host except s720 and hp (t480, master, d3d3).
# A new extension goes in this one list. Every host imports this module; only s720 (few resources) and hp must not.
{ pkgs, ... }:

{
  # The extensions folder stays writable: home-manager only adds one symlink per extension
  # below, so extensions installed from the editor keep working.
  programs.vscode = {
    enable = true;
    mutableExtensionsDir = true;
    profiles.default.extensions = with pkgs.vscode-extensions; [
      jnoortheen.nix-ide
      ritwickdey.liveserver
      vscodevim.vim
    ];
    # Installed by hand from the editor, not in nixpkgs, so not declarable (list them here when
    # reinstalling or setting up another host; add Java/Spring/Kafka ones that stay manual):
    #   vintharas.learn-vim 0.0.28
  };
}
