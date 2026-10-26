{ config, pkgs, ... }:

{
  # Prompt leggero: utente@host, directory, branch git e stato, niente moduli per i linguaggi
  programs.starship = {
    enable = true;
    enableBashIntegration = true;
    settings = {
      add_newline = false;
      format = "$username$hostname$directory$git_branch$git_status$nix_shell$cmd_duration$character";
      # Starship mostra utente e host solo via ssh: qui sempre, es. davidemark@t480
      username = {
        show_always = true;
        format = "[$user]($style)";
      };
      hostname = {
        ssh_only = false;
        format = "[@$hostname]($style) ";
      };
      directory.truncation_length = 3;
      git_branch.format = "[ $branch]($style) ";
      git_status.format = "([$all_status$ahead_behind]($style) )";
      cmd_duration.min_time = 3000;
    };
  };
}
