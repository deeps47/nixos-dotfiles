{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    tokyonight-gtk-theme
    papirus-icon-theme
    bibata-cursors
    adwaita-qt
  ];

  gtk = {
    enable = true;

    theme = {
      name = "Tokyonight-Dark";
      package = pkgs.tokyonight-gtk-theme;
    };

    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };

    cursorTheme = {
      name = "Bibata-Modern-Classic";
      package = pkgs.bibata-cursors;
      size = 24;
    };

    gtk3.extraConfig.gtk-application-prefer-dark-theme = 1;
    gtk4.extraConfig.gtk-application-prefer-dark-theme = 1;
  };

  qt = {
    enable = true;
    platformTheme.name = "gtk";
    style = {
      name = "adwaita-dark";
      package = pkgs.adwaita-qt;
    };
  };

  dconf.settings."org/gnome/desktop/interface" = {
    color-scheme = "prefer-dark";
    gtk-theme = "Tokyonight-Dark";
    icon-theme = "Papirus-Dark";
    cursor-theme = "Bibata-Modern-Classic";
    cursor-size = 24;
  };

  home.sessionVariables = {
  # Session
  #XDG_CURRENT_DESKTOP = "Hyprland"; # only downside — need to change this when switching to niri
  XDG_SESSION_TYPE    = "wayland";
  GDK_BACKEND         = "wayland,x11";

  # Theme
  GTK_THEME           = "Tokyonight-Dark";
  GTK_ICON_THEME      = "Papirus-Dark";
  XCURSOR_THEME       = "Bibata-Modern-Classic";
  XCURSOR_SIZE        = "24";
  };

  home.file.".icons/default/index.theme".text = ''
    [Icon Theme]
    Name=Default
    Inherits=Bibata-Modern-Classic
  '';
}