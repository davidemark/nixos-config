# VS Code and its extensions, the same on every host that has VS Code (t480, master).
# A new extension goes in this one list. s720 has no VS Code (few resources).
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
