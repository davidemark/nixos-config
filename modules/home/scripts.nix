# The scripts are plain files in scripts/home/ (shellcheck works on them); this module installs them
# in ~/.local/bin.
{ config, pkgs, ... }:
{
  # Opens the Claude sessions running on claude-rc. Naming convention for every Claude session:
  # <host>-<session-name>, so on claude-rc: claude-rc-orchestrator, claude-rc-indigo, claude-rc-maintenance.
  home.file.".local/bin/crc" = {
    executable = true;
    source = ../../scripts/home/crc.sh;
  };

  # Sends a PDF or an image (PNG, JPEG) to DavideMark through the Indigo Telegram bot. Copy of indigo/client/indigo-send
  # (private repo): keep the two in sync. See the second-brain note 08-Homelab/01-Indigo.
  home.file.".local/bin/indigo-send" = {
    executable = true;
    source = ../../scripts/home/indigo-send.sh;
  };

  # Mod+I: CPU, memory, disk (and battery/temperature where the PC has them) as a mako popup for a
  # few seconds. They are not in the waybar any more. The fixed id makes a second press replace it.
  home.file.".local/bin/sysinfo-popup" = {
    executable = true;
    source = pkgs.replaceVars ../../scripts/home/sysinfo-popup.sh {
      notify_send = "${pkgs.libnotify}/bin/notify-send";
    };
  };

  # nix-clean: delete old system generations, keeping the one in use and the previous one (rollback),
  # then collect the garbage and refresh the bootloader entries. Alias in bash.nix, same on every host.
  home.file.".local/bin/nix-clean" = {
    executable = true;
    source = ../../scripts/home/nix-clean.sh;
  };
}
