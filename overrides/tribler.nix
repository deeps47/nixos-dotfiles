{ pkgs, ... }:

let
  tribler-latest = pkgs.stdenv.mkDerivation rec {
    pname = "tribler";
    version = "8.4.1";

    src = pkgs.fetchurl {
      url = "https://github.com/Tribler/tribler/releases/download/v${version}/tribler_${version}_x64.deb";
      sha256 = "sha256-8+0absrf5Sp9ixKsqC/HIXTWYWrlb1JNXTBNu976Rh0=";
    };

    nativeBuildInputs = with pkgs; [
      autoPatchelfHook
      dpkg
      makeWrapper
      # The magic NixOS hook that fixes the Namespace Gtk crash
      wrapGAppsHook3
      gobject-introspection
    ];

    buildInputs = with pkgs; [
      stdenv.cc.cc.lib
      zlib
      glib
      dbus
      nss
      nspr
      atk
      at-spi2-atk
      cups
      libdrm
      mesa
      pango
      cairo
      gobject-introspection
      libsodium
      xmessage
      xdg-utils

      # System Tray dependencies
      gtk3
      libappindicator-gtk3
      gdk-pixbuf

      xcb-util-cursor
      fontconfig
      freetype

      libX11
      libXcomposite
      libXdamage
      libXext
      libXfixes
      libXrandr
      libxcb
      libxshmfence
      libglvnd
      libxkbcommon
      alsa-lib
    ];

    unpackPhase = "dpkg-deb -x $src .";

    installPhase = ''
            mkdir -p $out
            cp -r usr/* $out/

            # REMOVE the original desktop files so they don't conflict
            rm -rf $out/share/applications

            cat > $out/bin/tribler <<EOF
      #!/bin/sh
      cd $out/share/tribler
      exec ./tribler "\$@"
      EOF
            chmod +x $out/bin/tribler
    '';

    # Tell wrapGAppsHook3 NOT to auto-wrap so we can combine it with our LD_LIBRARY_PATH wrapper
    dontWrapGApps = true;

    postFixup = ''
            # 1. Create a smart browser script directly inside the Nix package
            cat > $out/bin/smart-browser <<'EOF'
      #!/bin/sh
      if [[ "$1" == http* ]]; then
        exec brave --app="$1"
      else
        exec xdg-open "$1"
      fi
      EOF
            chmod +x $out/bin/smart-browser

            # 2. Force Python to use our script via the BROWSER variable
            wrapProgram $out/bin/tribler \
              "''${gappsWrapperArgs[@]}" \
              --set BROWSER "$out/bin/smart-browser" \
              --prefix PATH : ${pkgs.lib.makeBinPath [ pkgs.xdg-utils ]} \
              --prefix LD_LIBRARY_PATH : ${pkgs.lib.makeLibraryPath buildInputs}
    '';
  };
in
{
  home.packages = [ tribler-latest ];
}
