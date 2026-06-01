{ pkgs, ... }:

{
  programs.zen-browser.profiles.default = {
    search = {
      default = "ddg";
      privateDefault = "ddg";
      force = true; # Overrides existing search configurations

      engines = {
        "Nix Packages" = {
          urls = [{
            template = "https://search.nixos.org/packages";
            params = [
              { name = "type"; value = "packages"; }
              { name = "query"; value = "{searchTerms}"; }
            ];
          }];
          icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          definedAliases = [ "@np" ];
        };

        # Remove unwanted default engines
        "google".metaData.hidden = true;
        "bing".metaData.hidden = true;
        "ebay".metaData.hidden = true;
      };
    };
  };
}
