{ config, pkgs, ... }:
{
  programs.git = {
    enable = true;
    # Use the git package that has libsecret support
    package = pkgs.git.override { withLibsecret = true; };
    settings = {
      credential.helper = "${pkgs.git.override { withLibsecret = true; }}/bin/git-credential-libsecret";
      user.name = "deeps47";
      user.email = "65827314+deeps47@users.noreply.github.com";

    };
  };
}

