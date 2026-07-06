{ config, pkgs, ... }:
{
  gtk = {
    enable = true;
    theme = {
      name = "catppuccin-frappe-blue-standard+default";
      package = pkgs.catppuccin-gtk;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    font = {
      name = "JetBrainsMono Nerd Font";
      size = 11;
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
  };

  home.pointerCursor = {
    gtk.enable = true;
    name = "default";
    size = 24;
  };
}