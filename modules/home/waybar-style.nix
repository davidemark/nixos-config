# Waybar style, one copy for every host. The modules (config.jsonc) come from waybar.nix.
{ ... }:

{
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
      padding: 0;
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

    #cpu {
      color: #85c1dc;
      padding: 0 6px;
    }

    #memory {
      color: #81c8be;
      padding: 0 6px;
    }

    #disk {
      color: #ef9f76;
      padding: 0 6px;
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
    /* Waybar 0.16 builds each niri workspace button as button > box > label (plus an empty
       taskbar box). Keep the look of 0.15: nothing but the number and the line under the active one. */
    #workspaces button box {
      padding: 0;
      margin: 0;
    }

    /* The space around the number is on the label, not on the button: the button is exactly as wide
       as its label, so the line under the active workspace is centred on the number. (Padding on the
       button plus min-width left the label packed at the start of a wider box.) */
    #workspaces button label {
      min-width: 16px;
      padding: 0 8px;
      margin: 0;
      background: transparent;
    }

    #workspaces button {
      min-width: 0;
      margin: 0;
      box-shadow: none;
      text-shadow: none;
      background-image: none;
    }
  '';
}
