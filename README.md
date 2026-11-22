# nixos-config

My personal NixOS configuration, managed as a single [Nix flake](https://nixos.wiki/wiki/Flakes) across every machine I run: 5 hosts, one source of truth, fully declarative and reproducible.

## Hosts

| Host | Notes |
|---|---|
| `master` | primary daily driver |
| `d3d3` | |
| `hp` | laptop |
| `s720` | |
| `t480` | ThinkPad, TLP/thermald power management |

Each host has its own `configuration.nix` (+ `hardware-configuration.nix`, generated) and `home.nix`. Everything shared lives in `modules/`; a host adds only what is specific to it (`t480`'s power management and Kafka tooling, `hp`'s laptop bits, `master`'s NVIDIA setup, `s720`'s static network and Wake-on-LAN).

## Structure

```
flake.nix                 # entry point: mkHost builds one nixosConfiguration per host
hosts/<name>/
  configuration.nix       # system config for this host
  hardware-configuration.nix
  home.nix                # home-manager entry point: imports modules/home/base.nix and sets the my.* options
modules/
  common/                 # shared system-level modules
    workstation.nix       # user, swaylock PAM, stateVersion (every host)
    base.nix, dev.nix, audio.nix, fonts.nix, portal.nix   # every host
    telegram.nix          # every host except hp
    bluetooth.nix, gaming.nix, nvidia.nix, indigo-diag.nix  # only where needed
  home/                   # shared home-manager modules
    base.nix              # user + the modules every host uses (bash, starship, foot, mako, gtk, ...)
    niri.nix, waybar.nix, waybar-style.nix, wallpaper.nix, neovim.nix, ...
scripts/home/             # shell scripts installed by modules/home/scripts.nix and wallpaper.nix
```

Per-host differences are options, not copies: `my.niri.*` (touchpad, column width, outputs, extra keys), `my.waybar.*` (modules and network interfaces), `my.wallpaper.resolution`, `my.java.jdtlsXmx`.

## What's in it

- **Window manager**: [niri](https://github.com/YaLTeR/niri) (scrollable-tiling Wayland compositor), with `waybar`, `mako` (notifications), `fuzzel`, `swaylock`/`swayidle`.
- **Shell/editor**: `bash` + `neovim`, configured via home-manager.
- **Containers**: `podman` with Docker compatibility (`virtualisation.podman.dockerCompat`), so `docker` commands work against the Podman backend.
- **Networking**: NetworkManager, Tailscale.
- **Housekeeping**: automatic weekly garbage collection (`nix.gc`, 30-day retention), `auto-optimise-store`.

## Usage

```bash
# rebuild the current host
sudo nixos-rebuild switch --flake .#<hostname>

# e.g. on t480
sudo nixos-rebuild switch --flake .#t480
```

## Why

Started as a way to stop hand-configuring Linux boxes one at a time and actually trust that every machine matches its own committed config. Rebuilding a machine from scratch (or adding a new one) is now `nixos-rebuild switch --flake .#<host>`.

## Public repo checks

This repo is public, so every clone installs a pre-commit hook that blocks private keys, tokens, plain-text passwords, Tailscale `100.x` addresses, MAC addresses, Wi-Fi names and personal email addresses in the staged diff, and refuses commits that are not authored with the GitHub noreply email.

```bash
scripts/install-hooks.sh <id>+<user>@users.noreply.github.com   # once per clone
scripts/check-secrets.sh --all                                   # audit every tracked file
```

A line that is safe on purpose can carry `secrets-ok` in a comment.
