{ config, pkgs, lib, ... }:

{
  # --- Display Manager ---
  # Disable SDDM completely
  services.displayManager.sddm.enable = false;
  services.displayManager.sddm.wayland.enable = false;

  # Enable Greetd with tuigreet
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        # Launch tuigreet, show the time, and tell it to run Hyprland after you log in
        command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd start-hyprland";
        user = "greeter";
      };
    };
  };

  # --- Polkit & Portals ---
  security.polkit.enable = true;

  xdg.portal.enable = true;

  # Install extra portal helpers for GTK/X11 compatibility/fallbacks
  xdg.portal.extraPortals = with pkgs; [
    xdg-desktop-portal-hyprland
    xdg-desktop-portal-gtk
  ];

  # --- Keyring & Security ---
  # GNOME Keyring / libsecret available system-wide
  environment.systemPackages = with pkgs; [
    gnome-keyring
    libsecret
  ];

  # Enable the GNOME Keyring daemon
  services.gnome.gnome-keyring.enable = true;

  # CRITICAL: Tell PAM to let greetd automatically unlock your GNOME Keyring when you type your password
  security.pam.services.greetd.enableGnomeKeyring = true;
}
