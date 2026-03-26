{ config, lib, pkgs, ... }:

{
  xdg.desktopEntries = {

    notion-app = {
      name = "Notion";
      genericName = "Note Taking App";
      exec = "brave --app=\"https://notion.so\"";
      terminal = false;
      categories = [ "Utility" ];
      icon = "${config.home.homeDirectory}/nixos-dotfiles/modules/icons/notion.svg";
      settings = {
        # Paste the exact string from hyprctl clients here
        StartupWMClass = "brave-notion.so__-Default";

      };
    };

    obsidian-app = {
      name = "Obsidian";
      genericName = "Note Taking App";
      exec = "brave --app=\"https://obsidian.local\"";
      terminal = false;
      categories = [ "Utility" ];
      icon = "${config.home.homeDirectory}/nixos-dotfiles/modules/icons/obsidian.svg";
      settings = {
        # Paste the exact string from hyprctl clients here
        StartupWMClass = "brave-obsidian.local__-Default";

      };
    };
    # Overrides the default Tribler desktop entry
    tribler-app = {
      name = "Tribler";
      genericName = "P2P Network";
      exec = "tribler"; # Back to perfectly normal!
      terminal = false;
      categories = [ "Network" "P2P" ];
      icon = "tribler";
    };
    # 2. Ghost entry for the launcher window class
    "brave-127.0.0.1__-Default" = {
      name = "Tribler";
      exec = "tribler";
      icon = "tribler"; # Forces the taskbar to use this icon!
      settings = { NoDisplay = "true"; }; # Keeps it hidden from your app menu
    };

    # 3. Ghost entry for the system tray window class
    "brave-127.0.0.1__ui_-Default" = {
      name = "Tribler";
      exec = "tribler";
      icon = "tribler";
      settings = { NoDisplay = "true"; };
    };

    # You can keep adding as many apps as you want here
    # trading-view-app = { ... };
  };
}
