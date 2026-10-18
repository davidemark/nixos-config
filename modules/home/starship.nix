{ config, pkgs, ... }:

{
  # Prompt leggero: directory, branch git e stato, niente moduli per i linguaggi
  programs.starship = {
    enable = true;
    enableBashIntegration = true;
    settings = {
      add_newline = false;
      format = "$directory$git_branch$git_status$nix_shell$cmd_duration$character";
      directory.truncation_length = 3;
      git_branch.format = "[ $branch]($style) ";
      git_status.format = "([$all_status$ahead_behind]($style) )";
      cmd_duration.min_time = 3000;
    };
  };
}
