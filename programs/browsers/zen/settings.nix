{ config, ... }:

{
  programs.zen-browser.profiles.default = {
    isDefault = true;

    settings = {
      # --- Performance & Hardware ---
      "gfx.webrender.all" = true;
      "media.ffmpeg.vaapi.enabled" = true;
      "widget.wayland.opaque-region.enabled" = true;

      # --- Privacy & Security ---
      "dom.security.https_only_mode" = true;
      "dom.security.https_only_mode_ever_enabled" = true;
      #"privacy.trackingprotection.enabled" = true;
      "privacy.donottrackheader.enabled" = false;
      "privacy.globalprivacycontrol.enabled" = true;
      "browser.send_pings" = false; # Prevent HTML5 ping tracking
      #"beacon.enabled" = false;

      # --- Network & DNS Noise Reduction ---
      # Disables speculative connections to prevent DNS leaks and unnecessary traffic
      #"network.prefetch-next" = false;
      #"network.dns.disablePrefetch" = true;
      #"network.predictor.enabled" = false;
      #"network.http.speculative-parallel-limit" = 0;
      #"browser.urlbar.speculativeConnect.enabled" = false;
      "network.captive-portal-service.enabled" = false;
      "network.connectivity-service.enabled" = false;

      # --- Disable Telemetry & Data Collection ---
      "toolkit.telemetry.enabled" = false;
      "toolkit.telemetry.unified" = false;
      "toolkit.telemetry.server" = "data:,";
      "toolkit.telemetry.archive.enabled" = false;
      "toolkit.telemetry.newProfilePing.enabled" = false;
      "toolkit.telemetry.shutdownPingSender.enabled" = false;
      "toolkit.telemetry.updatePing.enabled" = false;
      "toolkit.telemetry.bhrPing.enabled" = false;
      "toolkit.telemetry.firstShutdownPing.enabled" = false;
      "app.shield.optoutstudies.enabled" = false;
      "app.normandy.enabled" = false;
      "app.normandy.api_url" = "";
      "browser.discovery.enabled" = false;

      # --- UI/UX & Quality of Life ---
      "browser.startup.page" = 3; # Restore previous session
      "browser.aboutConfig.showWarning" = false; # I know what I'm doing
      "browser.compactmode.show" = true;
      "browser.uidensity" = 1; # Compact density
      "zen.view.use-single-toolbar" = false;
      "zen.view.compact" = false;
      "browser.tabs.inTitlebar" = 1;

      # --- Disable Native Password/Form Autofill ---
      "signon.rememberSignons" = false;
      "browser.formfill.enable" = false;
      "extensions.formautofill.addresses.enabled" = false;
      "extensions.formautofill.creditCards.enabled" = false;

      #
      #"pdfjs.enableScripting" = false;
      #"network.IDN_show_punycode" = true;
      "browser.urlbar.trimURLs" = false;
      "extensions.pocket.enabled" = false;

      # --- Disable Firefox Suggest ---
      "browser.search.suggest.enabled" = false;
      "browser.urlbar.suggest.searches" = false;
      "browser.urlbar.quicksuggest.enabled" = false;
      "browser.urlbar.groupLabels.enabled" = false;
      "browser.newtabpage.activity-stream.showSponsored" = false;
      "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;

      #
      "datareporting.healthreport.uploadEnabled" = false;
      "datareporting.policy.dataSubmissionEnabled" = false;
      "browser.crashReports.unsubmittedCheck.autoSubmit2" = false;
      "browser.crashReports.unsubmittedCheck.enabled" = false;
      "breakpad.reportURL" = "";

    };
  };
}
