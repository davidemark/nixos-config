{ config, pkgs, ... }:
{
  # Global Claude Code instructions, identical on every host.
  home.file.".claude/CLAUDE.md".source = ./claude/CLAUDE.md;
}
