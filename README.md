# nixos-config

My personal NixOS configuration, managed as a single [Nix flake](https://nixos.wiki/wiki/Flakes) across every machine I run: 5 hosts, one source of truth, fully declarative and reproducible.

## Hosts

| Host | Notes |
|---|---|
| `master` | primary daily driver |
| `d3d3` | |
| `hp` | laptop |
| `s720` | |
| `t480` | ThinkPad — TLP/thermald power management, libvirtd/virt-manager |

Each host has its own `configuration.nix` (+ `hardware-configuration.nix`, generated) and `home.nix`, importing shared modules and adding only what's host-specific (e.g. `t480`'s power management and virtualisation, `hp`'s laptop-specific bits).

## Structure

```
flake.nix                 # entry point — one nixosConfiguration per host
hosts/<name>/
  configuration.nix       # system config for this host
  hardware-configuration.nix
  home.nix                # home-manager entry point for this host
  home/                   # host-specific home-manager modules (niri, waybar, ...)
modules/
  common/                 # shared system-level modules
    apps.nix, audio.nix, base.nix, bluetooth.nix,
    fonts.nix, gaming.nix, nvidia.nix, portal.nix
  home/                   # shared home-manager modules
    bash.nix, foot.nix, gtk.nix, lock.nix,
    mako.nix, neovim.nix, scripts.nix
```

`modules/common/` and `modules/home/` hold everything shared across hosts; each host only overrides or adds what actually differs (hardware, per-machine services, per-machine home config like `niri.nix`/`waybar.nix`).

## What's in it

- **Window manager**: [niri](https://github.com/YaLTeR/niri) (scrollable-tiling Wayland compositor), with `waybar`, `mako` (notifications), `fuzzel`, `swaylock`/`swayidle`.
- **Shell/editor**: `bash` + `neovim`, configured via home-manager.
- **Containers**: `podman` with Docker compatibility (`virtualisation.podman.dockerCompat`), so `docker` commands work against the Podman backend.
- **Virtualisation**: `libvirtd` + `virt-manager` (on hosts that need VMs).
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
