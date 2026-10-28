{ config, pkgs, ... }:
{
  home.file.".local/bin/cycle-wallpaper.sh" = {
    executable = true;
    text = ''
      #!/bin/sh
      WALLPAPER_DIR="$1"
      CURRENT_FILE="$HOME/.cache/current-wallpaper-$(basename $WALLPAPER_DIR)"

      mapfile -t WALLPAPERS < <(find "$WALLPAPER_DIR" -type f \( -name "*.png" -o -name "*.jpg" -o -name "*.jpeg" \) | sort)

      if [ ''${#WALLPAPERS[@]} -eq 0 ]; then
        exit 1
      fi

      if [ -f "$CURRENT_FILE" ]; then
        CURRENT=$(cat "$CURRENT_FILE")
      else
        CURRENT=0
      fi

      NEXT=$(( (CURRENT + 1) % ''${#WALLPAPERS[@]} ))

      pkill swaybg
      sleep 0.1
      swaybg -i "''${WALLPAPERS[$NEXT]}" -m fill &

      echo "$NEXT" > "$CURRENT_FILE"
    '';
  };

  # Opens the Claude sessions running on claude-rc. Naming convention for every Claude session:
  # <host>-<session-name>, so on claude-rc: claude-rc-misc, claude-rc-indigo, claude-rc-maintenance.
  home.file.".local/bin/crc" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      # crc            menu with the Claude sessions on claude-rc, then attach
      # crc <name>     attach to a session (crc misc = claude-rc-misc)
      # crc -l         list the sessions
      # crc --start    recreate the missing sessions (systemctl restart claude-sessions)
      # Detach with Ctrl+b d. Needs the ssh alias claude-rc-ts (modules/home/ssh.nix) and a key
      # authorized on claude-rc. Another host: CLAUDE_RC_HOST=<ssh alias> crc
      set -u
      host="''${CLAUDE_RC_HOST:-claude-rc-ts}"
      prefix="claude-rc-"

      list_sessions() {
        ssh "$host" "tmux list-sessions -F '#S' 2>/dev/null" | grep "^$prefix"
      }

      attach() {
        exec ssh -t "$host" "tmux attach -t '=$1'"
      }

      case "''${1:-}" in
        -l|--list)
          list_sessions
          ;;
        --start)
          ssh "$host" "systemctl restart claude-sessions" && list_sessions
          ;;
        "")
          mapfile -t sessions < <(list_sessions)
          if [ "''${#sessions[@]}" -eq 0 ]; then
            echo "No Claude sessions found on $host (try: crc --start)" >&2
            exit 1
          fi
          select name in "''${sessions[@]}"; do
            [ -n "$name" ] && attach "$name"
          done
          ;;
        *)
          name="$1"
          case "$name" in "$prefix"*) ;; *) name="$prefix$name" ;; esac
          if ! list_sessions | grep -qx "$name"; then
            echo "Session $name not found. Available:" >&2
            list_sessions >&2
            exit 1
          fi
          attach "$name"
          ;;
      esac
    '';
  };
}
