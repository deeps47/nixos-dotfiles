{ config, pkgs, ... }:
{
  programs.git = {
    enable = true;
    name = "deeps47";
    email = "65827314+deeps47@users.noreply.github.com";
    # Use the git package that has libsecret support
    package = pkgs.git.override { withLibsecret = true; };
    settings = {
      credential.helper = "${pkgs.git.override { withLibsecret = true; }}/bin/git-credential-libsecret";
    };
  };
}

