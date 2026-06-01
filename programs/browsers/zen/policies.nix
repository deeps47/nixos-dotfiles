{ pkgs, ... }:

{
  programs.zen-browser.policies = {

    # --- Feature Lockdowns ---
    DisableFirefoxStudies = true;
    DisablePocket = true;
    DisableFirefoxAccounts = true; # Disable Sync (unless you self-host sync)
    DisableProfileImport = true;
    DisableAppUpdate = true; # Let Nix manage updates
    AutofillAddressEnabled = true;
    AutofillCreditCardEnabled = false;
    DisableFeedbackCommands = true;
    DisableTelemetry = true;
    DontCheckDefaultBrowser = true;
    NoDefaultBookmarks = true;
    EnableTrackingProtection = {
      Value = true;
      Locked = true;
      Cryptomining = true;
      Fingerprinting = true;
    };

    # --- Permissions & Security ---
    PromptForDownloadLocation = true;
    OfferToSaveLogins = false;
    OfferToSaveLoginsDefault = false;

    Permissions = {
      Camera = { BlockNewRequests = true; };
      Microphone = { BlockNewRequests = true; };
      Location = { BlockNewRequests = true; };
      Notifications = { BlockNewRequests = true; };
      Autoplay = { Default = "block-audio-video"; };
    };
  };
}
