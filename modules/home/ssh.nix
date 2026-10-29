{ config, pkgs, ... }:

# SSH client config for the homelab. Each host has two names:
#   <name>     LAN address, works at home
#   <name>-ts  through Tailscale (MagicDNS short names, so no Tailscale IP is written in this public
#              repo), works anywhere. zimablade and indigo are not in the tailnet, so they are
#              reached by jumping through the homelab VM.
# Using the subnet route (accept-routes) instead would clash with other networks that also
# use 192.168.1.0/24.
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings = {
      "*" = {
        IdentityFile = "~/.ssh/id_ed25519";
        AddKeysToAgent = "yes";
        ServerAliveInterval = 30;
        # Do not learn extra host keys (RSA, ECDSA) after login: known_hosts keeps only the
        # ed25519 key accepted the first time.
        UpdateHostKeys = "no";
      };

      homelab = { HostName = "192.168.1.11"; User = "root"; };
      "homelab-ts" = { HostName = "homelab"; User = "root"; };

      # From the LAN claude-rc may not answer (its Tailscale RouteAll issue, see the vault):
      # use claude-rc-ts until it is fixed.
      "claude-rc" = { HostName = "192.168.1.12"; User = "root"; };
      "claude-rc-ts" = { HostName = "claude-rc"; User = "root"; };

      zimablade = { HostName = "192.168.1.10"; User = "root"; };
      "zimablade-ts" = { HostName = "192.168.1.10"; User = "root"; ProxyJump = "homelab-ts"; };

      indigo = { HostName = "192.168.1.13"; User = "root"; };
      "indigo-ts" = { HostName = "192.168.1.13"; User = "root"; ProxyJump = "homelab-ts"; };

      futro = { HostName = "192.168.1.101"; User = "davidemark"; };
      "futro-ts" = { HostName = "s720"; User = "davidemark"; };
    };
  };
}
