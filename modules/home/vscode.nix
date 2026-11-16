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
      # Extension Pack for Java: in nixpkgs it is only the pack itself (VS Code installs a pack's
      # members from the marketplace, a declared extension does not), so the members are listed
      # one by one. Needs a JDK on PATH: jdk25 comes from modules/common/dev.nix on every host.
      vscjava.vscode-java-pack
      redhat.java
      vscjava.vscode-java-debug
      vscjava.vscode-java-test
      vscjava.vscode-java-dependency
      vscjava.vscode-maven
      vscjava.vscode-gradle
      vscjava.vscode-spring-initializr
    ];
    # Installed by hand from the editor, not in nixpkgs, so not declarable (list them here when
    # reinstalling or setting up another host; add Java/Spring ones that stay manual):
    #   vintharas.learn-vim 0.0.28
    #   vscjava.vscode-spring-boot-dashboard (not in nixpkgs, checked 2026-11-16; install by hand if wanted)
    # No Kafka extension on purpose: only verified, official extensions.
    #
    # The Mac m2 (not NixOS) also has VS Code, with extensions installed by hand
    # (`code --install-extension <id>`). Reference list for it, declared + manual:
    #   jnoortheen.nix-ide, ritwickdey.liveserver, vscodevim.vim, vintharas.learn-vim,
    #   vscjava.vscode-java-pack, redhat.java, vscjava.vscode-java-debug, vscjava.vscode-java-test,
    #   vscjava.vscode-java-dependency, vscjava.vscode-maven, vscjava.vscode-gradle,
    #   vscjava.vscode-spring-initializr, vscjava.vscode-spring-boot-dashboard (manual on NixOS too)
    # (a JDK is needed on the Mac too for the Java extensions)
    # Keep this list equal to the one above when an extension is added.
  };
}
