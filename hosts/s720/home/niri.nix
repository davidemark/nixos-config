{ config, pkgs, ... }:
{
  home.file.".config/niri/config.kdl".text = ''
    input {
        keyboard {
            xkb {
                layout "us"
                options "ctrl:nocaps"
            }
        }
    }

    cursor {
        hide-when-typing
        hide-after-inactive-ms 1000
    }

    layout {
        gaps 8
        default-column-width { proportion 0.5; }
        preset-column-widths {
            proportion 0.5
            proportion 1.0
        }
        focus-ring {
            width 2
            active-color "#8caaee"
            inactive-color "#414559"
        }
    }

    prefer-no-csd

    window-rule {
        geometry-corner-radius 8
        clip-to-geometry true
    }

    screenshot-path "~/pictures/screenshots/screenshot_%Y-%m-%d_%H-%M-%S.png"

    spawn-at-startup "waybar"
    spawn-at-startup "mako"
    spawn-sh-at-startup "sleep 1 && swaybg -i $(find ~/repositories/wallpapers/1920x1080/safe -type f | sort | head -1) -m fill"

    binds {
        Mod+Return { spawn "foot"; }
        Mod+Space { spawn "fuzzel"; }
        Mod+B { spawn "firefox"; }
        Mod+D { spawn "vesktop"; }
        Mod+G { spawn "steam"; }
        Mod+Shift+G { spawn "heroic"; }
        Mod+T { spawn "thunar"; }
        Mod+C { spawn "sh" "-c" "pkill waybar || waybar"; }
        Mod+Q { close-window; }
        Mod+Shift+E { quit; }
        Mod+Escape { spawn "swaylock"; }

        Mod+W { spawn "sh" "-c" "~/.local/bin/cycle-wallpaper.sh ~/repositories/wallpapers/1920x1080/safe"; }
        Mod+Shift+W { spawn "sh" "-c" "~/.local/bin/cycle-wallpaper.sh ~/repositories/wallpapers/1920x1080/unsafe"; }

        Mod+H { focus-column-left; }
        Mod+L { focus-column-right; }
        Mod+J { focus-window-down; }
        Mod+K { focus-window-up; }

        Mod+Shift+H { move-column-left; }
        Mod+Shift+L { move-column-right; }
        Mod+Shift+J { move-window-down; }
        Mod+Shift+K { move-window-up; }

        Mod+F { maximize-column; }
        Mod+Shift+F { fullscreen-window; }

        Mod+R { switch-preset-column-width; }
        Mod+Shift+R { switch-preset-column-width-back; }

        Mod+Minus { set-column-width "-10%"; }
        Mod+Equal { set-column-width "+10%"; }

        Mod+V { toggle-window-floating; }
        Mod+Shift+V { switch-focus-between-floating-and-tiling; }

        Mod+O { toggle-overview; }

        Mod+BracketLeft  { consume-or-expel-window-left; }
        Mod+BracketRight { consume-or-expel-window-right; }

        Mod+Page_Down { focus-workspace-down; }
        Mod+Page_Up   { focus-workspace-up; }
        Mod+Ctrl+Page_Down { move-column-to-workspace-down; }
        Mod+Ctrl+Page_Up   { move-column-to-workspace-up; }

        Mod+1 { focus-workspace 1; }
        Mod+2 { focus-workspace 2; }
        Mod+3 { focus-workspace 3; }
        Mod+4 { focus-workspace 4; }
        Mod+5 { focus-workspace 5; }

        Mod+Shift+1 { move-column-to-workspace 1; }
        Mod+Shift+2 { move-column-to-workspace 2; }
        Mod+Shift+3 { move-column-to-workspace 3; }
        Mod+Shift+4 { move-column-to-workspace 4; }
        Mod+Shift+5 { move-column-to-workspace 5; }

        Mod+Shift+Slash { show-hotkey-overlay; }

        XF86AudioRaiseVolume allow-when-locked=true { spawn "sh" "-c" "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+ -l 1.0"; }
        XF86AudioLowerVolume allow-when-locked=true { spawn "sh" "-c" "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"; }
        XF86AudioMute allow-when-locked=true { spawn "sh" "-c" "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"; }
        XF86AudioMicMute allow-when-locked=true { spawn "sh" "-c" "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"; }
        XF86MonBrightnessUp { spawn "brightnessctl" "set" "+5%"; }
        XF86MonBrightnessDown { spawn "brightnessctl" "set" "5%-"; }
        XF86AudioPlay { spawn "playerctl" "play-pause"; }
        XF86AudioNext { spawn "playerctl" "next"; }
        XF86AudioPrev { spawn "playerctl" "previous"; }

        Print { screenshot; }
        Ctrl+Print { screenshot-screen; }
    }
  '';
}