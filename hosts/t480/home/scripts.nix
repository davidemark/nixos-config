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
}
