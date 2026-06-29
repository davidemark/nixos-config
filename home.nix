{ config, pkgs, ... }:

{
  home.username = "davidemark";
  home.homeDirectory = "/home/davidemark";
  home.stateVersion = "26.05";

  programs.home-manager.enable = true;

  # Config Niri tramite home.file
  home.file.".config/niri/config.kdl".text = ''
    input {
        keyboard {
            xkb {
                layout "it"
            }
        }
    }

    binds {
        Mod+Return { spawn "foot"; }
        Mod+D { spawn "fuzzel"; }
        Mod+Q { close-window; }
        Mod+Shift+E { quit; }

        Mod+H { focus-column-left; }
        Mod+L { focus-column-right; }
        Mod+J { focus-window-down; }
        Mod+K { focus-window-up; }

        Mod+Shift+H { move-column-left; }
        Mod+Shift+L { move-column-right; }

        Mod+1 { focus-workspace 1; }
        Mod+2 { focus-workspace 2; }
        Mod+3 { focus-workspace 3; }
        Mod+4 { focus-workspace 4; }
        Mod+5 { focus-workspace 5; }

        Mod+Shift+1 { move-window-to-workspace 1; }
        Mod+Shift+2 { move-window-to-workspace 2; }
        Mod+Shift+3 { move-window-to-workspace 3; }
        Mod+Shift+4 { move-window-to-workspace 4; }
        Mod+Shift+5 { move-window-to-workspace 5; }
    }
  '';
}
