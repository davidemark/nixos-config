{ config, pkgs, ... }:

{
  home.username = "davidemark";
  home.homeDirectory = "/home/davidemark";
  home.stateVersion = "26.05";

  programs.home-manager.enable = true;

  # Alias
  programs.bash = {
    enable = true;
    shellAliases = {
      ns = "niri-session";
    };
  };

  # Foot
  home.file.".config/foot/foot.ini".text = ''
    [main]
    font=monospace:size=14

    [colors-dark]
    alpha=0.9
    background=1e1e2e
    foreground=cdd6f4
    regular0=45475a
    regular1=f38ba8
    regular2=a6e3a1
    regular3=f9e2af
    regular4=89b4fa
    regular5=f5c2e7
    regular6=94e2d5
    regular7=bac2de
    bright0=585b70
    bright1=f38ba8
    bright2=a6e3a1
    bright3=f9e2af
    bright4=89b4fa
    bright5=f5c2e7
    bright6=94e2d5
    bright7=a6e3a1
  '';

  # Waybar config
  home.file.".config/waybar/config.jsonc".text = ''
    {
      "layer": "top",
      "position": "top",
      "height": 32,
      "spacing": 8,
      "modules-left": ["niri/workspaces"],
      "modules-center": ["clock"],
      "modules-right": ["pulseaudio", "backlight", "battery", "network", "cpu", "memory"],

      "niri/workspaces": {
        "format": "{index}"
      },

      "clock": {
        "format": "{:%H:%M}",
        "format-alt": "{:%a %d %b %Y}",
        "tooltip-format": "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>"
      },

      "battery": {
        "states": {
          "warning": 30,
          "critical": 15
        },
        "format": "{icon} {capacity}%",
        "format-charging": "󰂄 {capacity}%",
        "format-icons": ["󰁺", "󰁻", "󰁼", "󰁽", "󰁾", "󰁿", "󰂀", "󰂁", "󰂂", "󰁹"]
      },

      "network": {
        "format-wifi": "󰤨 {essid}",
        "format-ethernet": "󰈀 {ipaddr}",
        "format-disconnected": "󰤭",
        "tooltip-format": "{ifname}: {ipaddr}"
      },

      "pulseaudio": {
        "format": "{icon} {volume}%",
        "format-muted": "󰝟",
        "format-icons": {
          "default": ["󰕿", "󰖀", "󰕾"]
        },
        "on-click": "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
      },

      "backlight": {
        "format": "{icon} {percent}%",
        "format-icons": ["󰃞", "󰃟", "󰃠"]
      },

      "cpu": {
        "format": "󰻠 {usage}%",
        "interval": 5
      },

      "memory": {
        "format": "󰍛 {percentage}%",
        "interval": 5
      }
    }
  '';

  # Waybar style
  home.file.".config/waybar/style.css".text = ''
    * {
      font-family: monospace;
      font-size: 13px;
      border: none;
      border-radius: 0;
      min-height: 0;
    }

    window#waybar {
      background-color: rgba(30, 30, 46, 0.85);
      color: #cdd6f4;
    }

    .modules-left,
    .modules-center,
    .modules-right {
      padding: 0 8px;
    }

    #workspaces button {
      padding: 0 6px;
      color: #585b70;
      background: transparent;
    }

    #workspaces button.active {
      color: #cdd6f4;
    }

    #workspaces button.focused {
      color: #89b4fa;
    }

    #clock {
      color: #cdd6f4;
      font-weight: bold;
    }

    #battery {
      color: #a6e3a1;
    }

    #battery.warning {
      color: #f9e2af;
    }

    #battery.critical {
      color: #f38ba8;
    }

    #network {
      color: #89b4fa;
    }

    #pulseaudio {
      color: #f5c2e7;
    }

    #pulseaudio.muted {
      color: #585b70;
    }

    #backlight {
      color: #f9e2af;
    }

    #cpu {
      color: #94e2d5;
    }

    #memory {
      color: #cdd6f4;
    }
  '';

  # Niri
  home.file.".config/niri/config.kdl".text = ''
    input {
        keyboard {
            xkb {
                layout "us"
            }
        }
        touchpad {
            tap
            natural-scroll
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
            active-color "#7fc8ff"
            inactive-color "#505050"
        }
    }

    prefer-no-csd

    window-rule {
        geometry-corner-radius 8
        clip-to-geometry true
    }

    spawn-at-startup "waybar"
    spawn-at-startup "swww-daemon"
    spawn-at-startup "sh" "-c" "sleep 1 && swww img /home/davidemark/repositories/wallpapers/Anime-Girl2.png --transition-type none"

    binds {
        Mod+Return { spawn "foot"; }
        Mod+Space { spawn "fuzzel"; }
        Mod+B { spawn "firefox"; }
	Mod+S { spawn "steam"; }
        Mod+D { spawn "discord"; }
        Mod+C { spawn "nchat"; }
        Mod+W { spawn "sh" "-c" "pkill waybar || waybar"; }
        Mod+Q { close-window; }
        Mod+Shift+E { quit; }

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

        // Tasti Fn
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
