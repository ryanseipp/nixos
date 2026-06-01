{ inputs, ... }:
{
  flake.homeModules.zen-browser =
    { lib, config, ... }:
    let
      cfg = config.zen-browser;
      # 1Password X — Password Manager (AMO add-on id)
      onePasswordExtId = "{d634138d-c276-4fc8-924b-40a0ea21d284}";
    in
    {
      imports = [ inputs.zen-browser.homeModules.beta ];

      options.zen-browser.enable = lib.mkEnableOption "enables the Zen browser";

      config = lib.mkIf cfg.enable {
        programs.zen-browser = {
          enable = true;
          setAsDefaultBrowser = true;

          # Enforced policies (cannot be overridden in-app)
          policies = {
            DisableTelemetry = true;
            DisableFirefoxStudies = true;
            DisablePocket = true;
            DisableFeedbackCommands = true;
            DontCheckDefaultBrowser = true;
            NoDefaultBookmarks = true;
            # 1Password handles all credentials/autofill — disable Zen's built-ins
            OfferToSaveLogins = false;
            PasswordManagerEnabled = false;
            AutofillAddressEnabled = false;
            AutofillCreditCardEnabled = false;
            EnableTrackingProtection = {
              Value = true;
              Locked = true;
              Cryptomining = true;
              Fingerprinting = true;
            };
            # System DNS: hard-disable DNS-over-HTTPS so the OS resolver is used
            DNSOverHTTPS = {
              Enabled = false;
              Locked = true;
            };
            # HTTPS-Only mode (per-site "continue to HTTP" exceptions still allowed)
            HttpsOnlyMode = "enabled";
            # Force-install the 1Password extension
            ExtensionSettings."${onePasswordExtId}" = {
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/1password-x-password-manager/latest.xpi";
              installation_mode = "force_installed";
            };
          };

          profiles.default.settings = {
            # Dark mode: dark browser chrome; sites follow system (we deliberately
            # leave layout.css.prefers-color-scheme.content-override at default).
            "ui.systemUsesDarkTheme" = 1;
            "browser.theme.toolbar-theme" = 0; # 0 = dark
            "browser.theme.content-theme" = 0; # 0 = dark (browser-internal pages)

            # System DNS (belt-and-suspenders with the DNSOverHTTPS policy)
            "network.trr.mode" = 5; # 5 = explicitly off -> OS resolver

            # Disable all built-in autofill / saved logins (1Password handles it)
            "signon.rememberSignons" = false; # password manager off
            "signon.autofillForms" = false; # don't prefill login fields
            "signon.generation.enabled" = false; # no suggested passwords
            "extensions.formautofill.addresses.enabled" = false;
            "extensions.formautofill.creditCards.enabled" = false;
            "browser.formfill.enable" = false; # no form/search history autocomplete

            # HTTPS-Only mode for all windows (incl. private browsing)
            "dom.security.https_only_mode" = true;
            "dom.security.https_only_mode_pbm" = true;

            # Balanced privacy
            "privacy.trackingprotection.enabled" = true;
            "privacy.trackingprotection.socialtracking.enabled" = true;
            "privacy.donottrackheader.enabled" = true;
            "privacy.fingerprintingProtection" = true;
            "network.cookie.cookieBehavior" = 5; # reject + partition trackers
            "datareporting.healthreport.uploadEnabled" = false;
            "datareporting.policy.dataSubmissionEnabled" = false;
            "toolkit.telemetry.enabled" = false;
            "browser.send_pings" = false;
          };
        };
      };
    };
}
