#!/usr/bin/env bash
# wallpaper start          set the first wallpaper of the "safe" folder (niri startup)
# wallpaper next safe      next wallpaper of the safe folder (Mod+W)
# wallpaper next unsafe    next wallpaper of the unsafe folder (Mod+Shift+W)
# The folder depends on my.wallpaper.resolution of the host (set in wallpaper.nix):
#   ~/repositories/wallpapers/<resolution>/<safe|unsafe>
# If that folder is missing, a resolution folder with the images directly inside is used for
# "safe"; otherwise the 1920x1080 folder, with a notification, never a silent empty background.
root="$HOME/repositories/wallpapers"
resolution="@resolution@"
fallback="1920x1080"
notify="@notify_send@"

kind="${2:-safe}"
[ "$1" = start ] && kind=safe

has_images() { [ -d "$1" ] && [ -n "$(find "$1" -maxdepth 1 -type f \( -name "*.png" -o -name "*.jpg" -o -name "*.jpeg" \) | head -1)" ]; }

dir="$root/$resolution/$kind"
if ! has_images "$dir"; then
  if [ "$kind" = safe ] && has_images "$root/$resolution"; then
    dir="$root/$resolution"
  else
    dir="$root/$fallback/$kind"
    if ! has_images "$dir"; then
      "$notify" -u critical -a wallpaper "Wallpaper" "No images in $root/$resolution/$kind nor in the fallback $root/$fallback/$kind"
      exit 1
    fi
    [ "$resolution" = "$fallback" ] || "$notify" -a wallpaper "Wallpaper" "Folder $resolution/$kind missing or empty: using $fallback/$kind"
  fi
fi

case "$1" in
  start) exec swaybg -i "$(find "$dir" -type f | sort | head -1)" -m fill ;;
  next) exec "$HOME/.local/bin/cycle-wallpaper.sh" "$dir" ;;
  *) echo "usage: wallpaper start | wallpaper next safe|unsafe" >&2; exit 2 ;;
esac
