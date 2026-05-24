{ pkgs, ... }:

{
  home.packages = with pkgs; [
    mpv
    btop
    eza
    bat
    proton-vpn
    yt-dlp
    lutris
    steam-run
    zstd
    obsidian
    wine
    vulkan-tools
    widevine-cdm
    vlc
    veracrypt
    # screen-toolkit plugin
    grim
    slurp
    tesseract
    imagemagick
    zbar
    wl-screenrec
    # Clipper plugin
    wl-clipboard
    cliphist
    wtype
  ];
}
