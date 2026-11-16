# Waybar config, one module for every host (style: waybar-style.nix). Same layout everywhere:
#   workspaces | clock | [brightness] volume [microphone] [bluetooth] [network] [temperature] [battery]
# Modules that depend on the hardware are switched on per host with my.waybar.*. CPU, memory and
# disk are not in the bar: the Mod+I popup (sysinfo-popup, scripts.nix) shows them for a few seconds.
{ config, lib, ... }:

let
  cfg = config.my.waybar;

  sep = "custom/sep";

  # Enabled modules, in layout order.
  right = lib.concatLists [
    (lib.optional cfg.backlight "backlight")
    [ "pulseaudio" ]
    (lib.optional cfg.microphone "pulseaudio#mic")
    (lib.optional cfg.bluetooth "bluetooth")
    (
      if cfg.wifiInterface == null && cfg.ethernetInterface == null then [ "network" ]
      else
        lib.optional (cfg.ethernetInterface != null) "network#ethernet"
        ++ lib.optional (cfg.wifiInterface != null) "network#wifi"
    )
    (lib.optional cfg.temperature "temperature")
    (lib.optional cfg.battery "battery")
  ];

  # A separator between modules, but none between the ethernet and the wifi icon.
  isNet = m: lib.hasPrefix "network" m;
  withSeps = lib.foldl'
    (acc: m:
      if acc == [ ] then [ m ]
      else if isNet m && isNet (lib.last acc) then acc ++ [ m ]
      else acc ++ [ sep m ])
    [ ]
    right;

  netCommon = {
    format-wifi = "󰤨";
    format-ethernet = "󰈀";
    format-disconnected = "󰤭";
    tooltip-format-wifi = "{essid} ({signalStrength}%)\n{ifname}: {ipaddr}";
    tooltip-format-ethernet = "{ifname}: {ipaddr}";
    tooltip-format-disconnected = "{ifname}: disconnected";
  };

  settings = {
    layer = "top";
    position = "top";
    height = 32;
    spacing = 4;
    modules-left = [ "niri/workspaces" ];
    modules-center = [ "clock" ];
    modules-right = withSeps;

    ${sep} = {
      format = "|";
      tooltip = false;
    };

    "niri/workspaces".format = "{index}";

    clock = {
      format = "{:%H:%M}";
      format-alt = "{:%a %d %b %Y}";
      tooltip-format = "<big>{:%B %Y}</big>\n<tt><small>{calendar}</small></tt>";
      calendar = {
        mode = "month";
        weeks-pos = "left";
        on-scroll = 1;
        format = {
          months = "<span color='#c6d0f5'><b>{}</b></span>";
          days = "<span color='#c6d0f5'>{}</span>";
          weeks = "<span color='#626880'><b>W{}</b></span>";
          weekdays = "<span color='#8caaee'><b>{}</b></span>";
          today = "<span color='#e78284'><b><u>{}</u></b></span>";
        };
      };
      actions = {
        on-click-right = "mode";
        on-scroll-up = "shift_up";
        on-scroll-down = "shift_down";
      };
    };

    pulseaudio = {
      format = "{icon} {volume}%";
      format-muted = "󰝟 muted";
      format-icons.default = [ "󰕿" "󰖀" "󰕾" ];
      on-click = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
      scroll-step = 5;
    };

    # "{format_source}" prints only the input device part.
    "pulseaudio#mic" = {
      format = "{format_source}";
      format-source = "󰍬 {volume}%";
      format-source-muted = "󰍭 muted";
      on-click = "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
      scroll-step = 5;
    };

    backlight = {
      format = "{icon} {percent}%";
      format-icons = [ "󰃞" "󰃟" "󰃠" ];
      scroll-step = 5;
    };

    bluetooth = {
      format = "󰂯";
      format-connected = "󰂱";
      format-off = "󰂲";
      format-disabled = "󰂲";
      tooltip-format = "{controller_alias}\t{controller_address}\n\n{num_connections} connected";
      tooltip-format-connected = "{controller_alias}\t{controller_address}\n\n{num_connections} connected\n\n{device_enumerate}";
      tooltip-format-enumerate-connected = "{device_alias}\t{device_address}";
      on-click = "blueman-manager";
    };

    battery = {
      states = {
        warning = 30;
        critical = 15;
      };
      format = "{icon} {capacity}%";
      format-charging = "󰂄 {capacity}%";
      # Plugged in but held by the TLP charge thresholds: the kernel reports "Not charging"
      format-plugged = "󰚥 {capacity}%";
      format-full = "󰚥 {capacity}%";
      format-icons = [ "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹" ];
    };

    temperature = {
      format = "{icon} {temperatureC}°C";
      format-icons = [ "󱃃" "󰔏" "󱃂" ];
      critical-threshold = 85;
      interval = 5;
    };

    # Without "interface" waybar follows the default route, which is the static ethernet one even
    # when the cable is unplugged: hosts that know their interfaces get one module each.
    network = netCommon;
    "network#wifi" = netCommon // lib.optionalAttrs (cfg.wifiInterface != null) {
      interface = cfg.wifiInterface;
    };
    "network#ethernet" = netCommon // {
      format-disconnected = "";
    } // lib.optionalAttrs (cfg.ethernetInterface != null) {
      interface = cfg.ethernetInterface;
    };
  };
in
{
  options.my.waybar = {
    backlight = lib.mkEnableOption "brightness module (laptop panel)";
    microphone = lib.mkEnableOption "microphone module";
    bluetooth = lib.mkEnableOption "bluetooth module";
    battery = lib.mkEnableOption "battery module";
    temperature = lib.mkEnableOption "temperature module (thermal_zone0)";
    wifiInterface = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "Wi-Fi interface name; with ethernetInterface unset too, one generic network module is used.";
    };
    ethernetInterface = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "Ethernet interface name.";
    };
  };

  config.home.file.".config/waybar/config.jsonc".text = builtins.toJSON settings;
}
