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
        "bluetooth",
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
            "months": "<span color='#c6d0f5'><b>{}</b></span>",
            "days": "<span color='#c6d0f5'>{}</span>",
            "weeks": "<span color='#626880'><b>W{}</b></span>",
            "weekdays": "<span color='#8caaee'><b>{}</b></span>",
            "today": "<span color='#e78284'><b><u>{}</u></b></span>"
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
        "tooltip-format-ethernet": "{ifname}: {ipaddr}"
      },

      "bluetooth": {
        "format": "󰂯 {status}",
        "format-connected": "󰂱 {device_alias}",
        "format-off": "󰂲",
        "tooltip-format": "{controller_alias}\t{controller_address}\n\n{num_connections} connected",
        "tooltip-format-connected": "{controller_alias}\t{controller_address}\n\n{num_connections} connected\n\n{device_enumerate}",
        "tooltip-format-enumerate-connected": "{device_alias}\t{device_address}",
        "on-click": "blueman-manager"
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
      background-color: rgba(48, 52, 70, 0.90);
      color: #c6d0f5;
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
      color: #626880;
      background: transparent;
      transition: all 0.2s ease;
    }

    #workspaces button.active {
      color: #c6d0f5;
      border-bottom: 2px solid #8caaee;
    }

    #workspaces button:hover {
      color: #8caaee;
      background: rgba(140, 170, 238, 0.1);
    }

    #clock {
      color: #c6d0f5;
      font-weight: bold;
      padding: 0 8px;
    }

    #battery {
      color: #a6d189;
      padding: 0 6px;
    }

    #battery.warning {
      color: #e5c890;
    }

    #battery.critical {
      color: #e78284;
      animation: blink 1s linear infinite;
    }

    @keyframes blink {
      to { color: #303446; background-color: #e78284; }
    }

    #network {
      color: #8caaee;
      padding: 0 6px;
    }

    #network.disconnected {
      color: #626880;
    }

    #pulseaudio {
      color: #f4b8e4;
      padding: 0 6px;
    }

    #pulseaudio.muted {
      color: #626880;
    }

    #backlight {
      color: #e5c890;
      padding: 0 6px;
    }

    #bluetooth {
      color: #8caaee;
      padding: 0 6px;
    }

    #bluetooth.off {
      color: #626880;
    }

    #custom-sep {
      color: #414559;
      padding: 0 2px;
    }
  '';
}