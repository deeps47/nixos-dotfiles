{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    adwaita-icon-theme
    gnome-themes-extra
    bibata-cursors
  ];

  # 1. The "Master" Cursor Configuration
  # This handles X11, Wayland, and creates the necessary ~/.icons/default/index.theme
  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic"; # Change to "Bibata-Modern-Ice" for white
    size = 24;
  };

  # 2. GTK Settings
  gtk = {
    enable = true;
    theme.name = "Adwaita-dark";
    iconTheme.name = "Adwaita";
    # cursorTheme is automatically handled by home.pointerCursor above
  };

  # 3. GNOME/Desktop Interface Settings
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      cursor-theme = "Bibata-Modern-Classic";
      cursor-size = 24;
    };
  };

  # 4. Qt Settings
  qt = {
    enable = true;
    platformTheme.name = "adwaita";
    style.name = "adwaita-dark";
  };

  # 5. Manual GTK overrides (Simplified)
  # home-manager handles the cursor lines now, so we only need the theme preference
  xdg.configFile."gtk-3.0/settings.ini".text = ''
    [Settings]
    gtk-theme-name=Adwaita-dark
    gtk-application-prefer-dark-theme=1
  '';

  xdg.configFile."gtk-4.0/settings.ini".text = ''
    [Settings]
    gtk-theme-name=Adwaita-dark
    gtk-application-prefer-dark-theme=1
  '';

  # 6. Session Variables
  home.sessionVariables = {
    XCURSOR_THEME = "Bibata-Modern-Classic";
    XCURSOR_SIZE = "24";
  };
}
