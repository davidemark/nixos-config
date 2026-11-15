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
        "cpu",
        "custom/sep",
        "memory",
        "custom/sep",
        "disk",
        "custom/sep",
        "pulseaudio",
        "custom/sep",
        "network"
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

      "cpu": {
        "format": "󰻠 {usage}%",
        "interval": 3,
        "tooltip-format": "{avg_frequency} GHz"
      },

      "memory": {
        "format": "󰍛 {percentage}%",
        "interval": 3,
        "tooltip-format": "{used:0.1f} / {total:0.1f} GiB\nswap: {swapUsed:0.1f} / {swapTotal:0.1f} GiB"
      },

      "disk": {
        "format": "󰋊 {percentage_used}%",
        "interval": 60,
        "path": "/",
        "tooltip-format": "{used} / {total}"
      },

      "battery": {
        "states": {
          "warning": 30,
          "critical": 15
        },
        "format": "{icon} {capacity}%",
        "format-charging": "󰂄 {capacity}%",
        // Plugged in but held by the TLP charge thresholds: the kernel reports "Not charging"
        "format-plugged": "󰚥 {capacity}%",
        "format-full": "󰚥 {capacity}%",
        "format-icons": ["󰁺", "󰁻", "󰁼", "󰁽", "󰁾", "󰁿", "󰂀", "󰂁", "󰂂", "󰁹"]
      },

      "network": {
        "format-wifi": "󰤨 {essid}",
        "format-ethernet": "󰈀 {ipaddr}",
        "format-disconnected": "󰤭",
        "tooltip-format-wifi": "{essid} ({signalStrength}%)\n{ipaddr}",
        "tooltip-format-ethernet": "{ifname}: {ipaddr}"
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
}
