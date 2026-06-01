{ inputs, ... }:
{
  programs.zen-browser.profiles.default.extraConfig = ''
        ${builtins.readFile "${inputs.betterfox}/Fastfox.js"}
        ${builtins.readFile "${inputs.betterfox}/Securefox.js"}
        ${builtins.readFile "${inputs.betterfox}/Peskyfox.js"}

        /*** OVERRIDES ***/
        user_pref("browser.startup.page", 3);
        user_pref("widget.wayland.opaque-region.enabled", true);
        user_pref("media.ffmpeg.vaapi.enabled", true);
        user_pref("identity.fxaccounts.enabled", false);
        user_pref("signon.rememberSignons", false);
        user_pref("extensions.formautofill.addresses.enabled", false);
        user_pref("extensions.formautofill.creditCards.enabled", false);
    //  user_pref("browser.download.useDownloadDir", false);
        user_pref("browser.ml.linkPreview.enabled", false);
        user_pref("security.cert_pinning.enforcement_level", 1);
        user_pref("browser.firefox-view.feature-tour", "{\"screen\":\"\",\"complete\":true}");
        user_pref("apz.overscroll.enabled", true);
        user_pref("general.smoothScroll", true);
        user_pref("mousewheel.default.delta_multiplier_y", 275);

        user_pref("privacy.query_stripping.enabled", true);
        user_pref("privacy.query_stripping.enabled_in_pbm", true);
        user_pref("privacy.query_stripping.strip_list", "__hsfp __hssc __hstc __s _hsenc _openstat dclid fbclid gbraid gclid gclsrc igshid mc_eid mkt_tok ml_subscriber ml_subscriber_hash msclkid oft_c oft_ck oft_d oft_id oft_ids oft_k oft_lk oft_sk oly_anon_id oly_enc_id rb_clickid s_cid twclid vero_conv vero_id wbraid wickedid yclid tag psc th linkCode");
  '';
}
