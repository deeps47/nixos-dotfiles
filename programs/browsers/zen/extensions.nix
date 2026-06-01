{ pkgs, ... }:

{
  programs.zen-browser.policies = {
    ExtensionSettings = {
      "uBlock0@raymondhill.net" = {
        install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
        installation_mode = "force_installed";
      };
      # Dark Reader
      "addon@darkreader.org" = {
        install_url = "https://addons.mozilla.org/firefox/downloads/latest/darkreader/latest.xpi";
        installation_mode = "force_installed";
      };
    };

    # --- uBlock Origin Payload Injection ---
    "3rdparty".Extensions."uBlock0@raymondhill.net" = {
      adminSettings = {
        userSettings = {
          uiTheme = "dark";
          advancedUserEnabled = true; # Unlocks the dynamic filtering matrix
          suspendUntilListsAreLoaded = true;
          cloudStorageEnabled = false; # Keep state entirely local/declarative
        };

        # The exact internal names of the filter lists you want enabled
        selectedFilterLists = [
          "user-filters"
          "ublock-filters"
          "ublock-badware"
          "ublock-privacy"
          "ublock-quick-fixes"
          "ublock-unbreak"
          "easylist"
          "easyprivacy"
          "urlhaus-1" # Malicious URL blocklist 
          "plowe-0"
          "fanboy-cookiemonster" # Annoyances/Cookie banners
        ];

        # Optional: Import third-party or custom remote lists
        importedLists = [
          # "https://example.com/custom-malware-blocklist.txt"
        ];

        # Optional: Define strict dynamic filtering rules globally
        # Example: Block all 3rd-party frames and scripts by default
        # dynamicFilteringString = ''
        #   * * 3p-frame block
        #   * * 3p-script block
        # '';
      };
    };
  };
}
