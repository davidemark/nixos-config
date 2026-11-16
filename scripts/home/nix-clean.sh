#!/usr/bin/env bash
# nix-clean        show what goes, ask, then clean
# nix-clean -y     no question
set -u
sys=/nix/var/nix/profiles/system

cur=$(readlink "$sys" | sed -n 's/^system-\([0-9]*\)-link$/\1/p')
[ -n "$cur" ] || { echo "errore: generazione corrente non trovata"; exit 1; }
# Generation numbers from the profile links: `nix-env --list-generations` as a normal user
# tries to take the profile write lock and fails with "Permission denied".
nums=$(for l in "$sys"-*-link; do n=${l##*/system-}; echo "${n%-link}"; done | sort -n)
prev=$(echo "$nums" | awk -v c="$cur" '$1 < c {p = $1} END {print p}')
keep="$cur${prev:+ $prev}"
gone=$(echo "$nums" | awk -v c="$cur" -v p="${prev:-0}" '$1 < c && $1 != p {printf "%s ", $1}')

echo "Generazione in uso: $cur, precedente (rollback): ${prev:-nessuna}. Restano: $keep"
if [ -z "$gone" ]; then echo "Generazioni di sistema da togliere: nessuna"; else echo "Generazioni di sistema da togliere: $gone"; fi
[ "$(readlink -f /run/booted-system)" = "$(readlink -f /run/current-system)" ] || \
  echo "Nota: il sistema avviato non e' quello in uso (switch senza riavvio): la generazione avviata resta protetta dal garbage collector."
echo "Spazio libero ora: $(df -h --output=avail /nix | tail -1 | tr -d ' ')"

if [ "${1:-}" != "-y" ]; then
  read -r -p "Procedo? [s/N] " a
  case "$a" in s|S|y|Y) ;; *) echo "Annullato."; exit 0 ;; esac
fi

# +2 counts back from the generation in use: it keeps that one and the one before it
sudo nix-env --delete-generations +2 -p "$sys" || exit 1
# No separate home-manager generations: it is a NixOS module here (useUserPackages), so its
# state is part of each system generation and goes with it.
sudo nix-collect-garbage
# Rewrite the boot entries from the generations that are left. No rebuild: no new generation
# and no change to what runs.
sudo "$sys/bin/switch-to-configuration" boot

echo "Spazio libero ora: $(df -h --output=avail /nix | tail -1 | tr -d ' ')"
