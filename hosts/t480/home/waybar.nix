{ config, pkgs, ... }:
{
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
}
