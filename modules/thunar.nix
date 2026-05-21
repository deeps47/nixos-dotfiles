# ./modules/thunar.nix
{ pkgs, ... }:

{
  # 1. Enable Thunar and its volume management plugins
  programs.thunar = {
    enable = true;
    plugins = with pkgs; [
      thunar-archive-plugin
      thunar-volman
    ];
  };

  # 2. Thumbnail support for images and media files inside Thunar
  services.tumbler.enable = true;

  # 3. Mount, trash, and filesystem virtualization layers
  services.gvfs.enable = true;
  services.udisks2.enable = true;

  # 4. Optional: Support for mobile media devices (MTP)
  services.udev.packages = [ pkgs.libmtp ];
}
