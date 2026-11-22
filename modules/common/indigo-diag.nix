{ pkgs, ... }:
let
  script = pkgs.writeShellScript "indigo-diag" (builtins.readFile ./indigo-diag.sh);
in
{
  # Read-only host diagnostics for the Indigo bot (/diagnostics). Forced command, no shell access.
  # indigo-diag.sh is a copy of host/indigo-diag in the indigo repo: keep the two equal.
  users.groups.indigo-diag = { };
  users.users.indigo-diag = {
    isSystemUser = true;
    group = "indigo-diag";
    shell = pkgs.bash;          # sshd runs the forced command through the user's shell: nologin would refuse it
    hashedPassword = "*";       # no password login, but not "locked" for sshd
    openssh.authorizedKeys.keys = [
      ''from="192.168.1.13",command="${script}",restrict ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHfrXb33wwICbnqmr3Sww6abbuU7qwsYavNwE8mBnOhj davidemark@indigo-diag''
    ];
  };
}
