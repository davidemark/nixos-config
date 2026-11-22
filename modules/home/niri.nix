# niri: the same keyboard layout, look and key bindings on every host. What differs per host is set
# with my.niri.* in hosts/<host>/home.nix.
{ config, lib, ... }:

let
  cfg = config.my.niri;
  indented = lib.concatMapStrings (line: "\n    ${line}");
  outputs = lib.optionalString (cfg.outputs != [ ]) (lib.concatStringsSep "\n" cfg.outputs + "\n\n");
  touchpad = lib.optionalString cfg.touchpad (indented [
    "touchpad {"
    "    tap"
    "    natural-scroll"
    "    click-method \"clickfinger\""
    "}"
  ]);
  audioFallback = indented cfg.audioFallbackKeys;
  extraBinds = indented cfg.extraBinds;
in
{
  options.my.niri = {
    outputs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Lines of the output blocks, at the top of the config (e.g. a fixed mode).";
    };
    touchpad = lib.mkEnableOption "the touchpad settings (laptops)";
    audioFallbackKeys = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Extra audio key bindings, placed after the XF86 mic mute binding.";
    };
    extraBinds = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Extra key bindings at the end of the binds block.";
    };
  };

  config.home.file.".config/niri/config.kdl".text = ''
    ${outputs}input {
        keyboard {
            xkb {
                layout "us"
                options "ctrl:nocaps"
            }
        }${touchpad}
    }

    cursor {
        hide-when-typing
        hide-after-inactive-ms 1000
    }

    layout {
        gaps 8
        default-column-width { proportion 1.0; }
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
    spawn-sh-at-startup "sleep 1 && ~/.local/bin/wallpaper start"

    binds {
        Mod+Return { spawn "foot"; }
        Mod+Space { spawn "fuzzel"; }
        Mod+B { spawn "brave-origin"; }
        Mod+D { spawn "vesktop"; }
        Mod+G { spawn "steam"; }
        Mod+Shift+G { spawn "heroic"; }
        Mod+T { spawn "thunar"; }
        Mod+C { spawn "sh" "-c" "pkill waybar || waybar"; }
        Mod+Q { close-window; }
        Mod+Shift+E { quit; }
        Mod+Escape { spawn "swaylock"; }

        Mod+W { spawn "sh" "-c" "~/.local/bin/wallpaper next safe"; }
        Mod+Shift+W { spawn "sh" "-c" "~/.local/bin/wallpaper next unsafe"; }

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
        Mod+I { spawn "sh" "-c" "~/.local/bin/sysinfo-popup"; }

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
        XF86AudioMicMute allow-when-locked=true { spawn "sh" "-c" "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"; }${audioFallback}
        XF86MonBrightnessUp { spawn "brightnessctl" "set" "+5%"; }
        XF86MonBrightnessDown { spawn "brightnessctl" "set" "5%-"; }
        XF86AudioPlay { spawn "playerctl" "play-pause"; }
        XF86AudioNext { spawn "playerctl" "next"; }
        XF86AudioPrev { spawn "playerctl" "previous"; }

        Print { screenshot; }
        Ctrl+Print { screenshot-screen; }${extraBinds}
    }
  '';
}
