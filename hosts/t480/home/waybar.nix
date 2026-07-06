{ config, pkgs, ... }:
{
  home.file.".config/waybar/config.jsonc".text = ''
    {
      "layer": "top",
      "position": "top",
      "height": 32,
      "spacing": 4,
      "modules-left": ["niri/workspaces"],
      "modules-center": ["clock"],
      "modules-right": [
        "pulseaudio",
        "custom/sep",
        "backlight",
        "custom/sep",
        "network",
        "custom/sep",
        "battery"
      ],

      "custom/sep": {
        "format": "|",
        "tooltip": false
      },

      "niri/workspaces": {
        "format": "{index}"
      },

      "clock": {
        "format": "{:%H:%M}",
        "format-alt": "{:%a %d %b %Y}",
        "tooltip-format": "<big>{:%B %Y}</big>\n<tt><small>{calendar}</small></tt>",
        "calendar": {
          "mode": "month",
          "weeks-pos": "left",
          "on-scroll": 1,
          "format": {
            "months": "<span color='#cdd6f4'><b>{}</b></span>",
            "days": "<span color='#cdd6f4'>{}</span>",
            "weeks": "<span color='#585b70'><b>W{}</b></span>",
            "weekdays": "<span color='#89b4fa'><b>{}</b></span>",
            "today": "<span color='#f38ba8'><b><u>{}</u></b></span>"
          }
        },
        "actions": {
          "on-click-right": "mode",
          "on-scroll-up": "shift_up",
          "on-scroll-down": "shift_down"
        }
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
        "tooltip-format-wifi": "{essid} ({signalStrength}%)\n{ipaddr}",
        "tooltip-format-ethernet": "{ifname}: {ipaddr}",
      },

      "pulseaudio": {
        "format": "{icon} {volume}%",
        "format-muted": "󰝟 muted",
        "format-icons": {
          "default": ["󰕿", "󰖀", "󰕾"]
        },
        "on-click": "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle",
        "scroll-step": 5
      },

      "backlight": {
        "format": "{icon} {percent}%",
        "format-icons": ["󰃞", "󰃟", "󰃠"],
        "scroll-step": 5
      }
    }
  '';

  home.file.".config/waybar/style.css".text = ''
    * {
      font-family: "JetBrainsMono Nerd Font";
      font-size: 13px;
      border: none;
      border-radius: 0;
      min-height: 0;
    }

    window#waybar {
      background-color: rgba(30, 30, 46, 0.90);
      color: #cdd6f4;
    }

    .modules-left {
      padding: 0 8px;
    }

    .modules-center {
      padding: 0 8px;
    }

    .modules-right {
      padding: 0 8px;
    }

    #workspaces button {
      padding: 0 4px;
      color: #585b70;
      background: transparent;
      transition: all 0.2s ease;
    }

    #workspaces button.active {
      color: #cdd6f4;
      border-bottom: 2px solid #89b4fa;
    }

    #workspaces button:hover {
      color: #89b4fa;
      background: rgba(137, 180, 250, 0.1);
    }

    #clock {
      color: #cdd6f4;
      font-weight: bold;
      padding: 0 8px;
    }

    #battery {
      color: #a6e3a1;
      padding: 0 6px;
    }

    #battery.warning {
      color: #f9e2af;
    }

    #battery.critical {
      color: #f38ba8;
      animation: blink 1s linear infinite;
    }

    @keyframes blink {
      to { color: #1e1e2e; background-color: #f38ba8; }
    }

    #network {
      color: #89b4fa;
      padding: 0 6px;
    }

    #network.disconnected {
      color: #585b70;
    }

    #pulseaudio {
      color: #f5c2e7;
      padding: 0 6px;
    }

    #pulseaudio.muted {
      color: #585b70;
    }

    #backlight {
      color: #f9e2af;
      padding: 0 6px;
    }

    #custom-sep {
      color: #313244;
      padding: 0 2px;
    }
  '';

}
