{
  pkgs,
  lib,
  config,
  ...
}:
{
  options = {
    firefox.enable = lib.mkEnableOption "enables firefox";
  };

  config = lib.mkIf config.firefox.enable {
    programs.firefox = {
      enable = true;
      package = pkgs.wrapFirefox (pkgs.firefox-unwrapped.override { pipewireSupport = true; }) { };
      policies = {
        DisableTelemetry = true;
        DisableFirefoxStudies = true;
        DontCheckDefaultBrowser = true;
        DisablePocket = true;
        DNSOverHTTPS = {
          Enabled = true;
          Fallback = true;
          Locked = true;
          ProviderURL = "https://cloudflare-dns.com/dns-query";
        };
      };
      profiles = {
        zorbik = {
          bookmarks = [
            {
              toolbar = true;
              bookmarks = [
                {
                  name = "Nix";
                  bookmarks = [
                    {
                      name = "NixOS Wiki";
                      url = "https://wiki.nixos.org/wiki/NixOS_Wiki";
                    }
                    {
                      name = "home-manager options";
                      url = "https://nix-community.github.io/home-manager/options.xhtml";
                    }
                    {
                      name = "Misterio77/nix-config";
                      url = "https://github.com/Misterio77/nix-config";
                    }
                  ];
                }
              ];
            }
          ];
          extensions = with pkgs.inputs.firefox-addons; [ bitwarden ];
          search = {
            default = "DuckDuckGo";
            engines = {
              "Amazon.com".metaData.hidden = true;
              "Bing".metaData.hidden = true;
              "eBay".metaData.hidden = true;
            };
            force = true;
            order = [
              "DuckDuckGo"
              "Google"
            ];
          };
          settings = {
            "browser.contentblocking.category" = "strict";
            "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons" = false;
            "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features" = false;
            "browser.newtabpage.activity-stream.feeds.section.highlights" = true;
            "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
            "browser.newtabpage.activity-stream.improvesearch.topSiteSearchShortcuts.havePinned" =
              "google,amazon";
            "browser.newtabpage.activity-stream.section.highlights.includePocket" = false;
            "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
            "browser.theme.content-theme" = 0;
            "browser.theme.toolbar-theme" = 0;
            "browser.toolbars.bookmarks.visibility" = "always";
            "browser.urlbar.quicksuggest.dataCollection.enabled" = false;
            "browser.urlbar.suggest.quicksuggest.nonsponsored" = false;
            "browser.urlbar.suggest.quicksuggest.sponsored" = false;
            "browser.warnOnQuitSortcut" = false;
            "datareporting.healthreport.uploadEnabled" = false;
            "dom.security.https_only_mode" = true;
            "extensions.formautofill.addresses.enabled" = false;
            "extensions.formautofill.creditCards.enabled" = false;
            "layout.css.prefers-color-scheme.content-override" = 0;
            "privacy.donottrackheader.enabled" = true;
            "privacy.fingerprintingProtection" = true;
            "privacy.globalprivacycontrol.enabled" = true;
            "signon.rememberSignons" = false;

            "browser.uiCustomization.state" = {
              placements = {
                nav-bar = [
                  "back-button"
                  "forward-button"
                  "stop-reload-button"
                  "customizableui-special-spring1"
                  "urlbar-container"
                  "customizableui-special-spring2"
                  "downloads-button"
                  "_446900e4-71c2-419f-a6a7-df9c091e268b_-browser-action"
                ];
                TabsToolbar = [
                  "firefox-view-button"
                  "tabbrowser-tabs"
                  "new-tab-button"
                ];
              };
            };
          };
        };
      };
    };
  };
}
