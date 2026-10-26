{ config, pkgs, ... }:

# SSH client config for the homelab. Each host has two names:
#   <name>     LAN address, works at home
#   <name>-ts  through Tailscale, works anywhere. zimablade, indigo and s720 are not in the tailnet,
#              so they are reached by jumping through the homelab VM.
# Using the subnet route (accept-routes) instead would clash with other networks that also
# use 192.168.1.0/24.
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks = {
      "*" = {
        identityFile = "~/.ssh/id_ed25519";
        addKeysToAgent = "yes";
        serverAliveInterval = 30;
        # Do not learn extra host keys (RSA, ECDSA) after login: known_hosts keeps only the
        # ed25519 key accepted the first time.
        extraOptions.UpdateHostKeys = "no";
      };

      homelab = { hostname = "192.168.1.11"; user = "root"; };
      "homelab-ts" = { hostname = "100.122.210.109"; user = "root"; };

      # From the LAN claude-rc may not answer (its Tailscale RouteAll issue, see the vault):
      # use claude-rc-ts until it is fixed.
      "claude-rc" = { hostname = "192.168.1.12"; user = "root"; };
      "claude-rc-ts" = { hostname = "100.86.232.108"; user = "root"; };

      zimablade = { hostname = "192.168.1.10"; user = "root"; };
      "zimablade-ts" = { hostname = "192.168.1.10"; user = "root"; proxyJump = "homelab-ts"; };

      indigo = { hostname = "192.168.1.13"; user = "root"; };
      "indigo-ts" = { hostname = "192.168.1.13"; user = "root"; proxyJump = "homelab-ts"; };

      futro = { hostname = "192.168.1.101"; user = "davidemark"; };
      "futro-ts" = { hostname = "192.168.1.101"; user = "davidemark"; proxyJump = "homelab-ts"; };
    };
  };
}
