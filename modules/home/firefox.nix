{ ... }:
{
  flake.homeModules.firefox = {
    programs.firefox = {
      enable = true;

      # Enterprise Policies work globally on all profiles
      policies = {
        # --- 1. Disable Telemetry --- 
        DisableTelemetry = true;
        DisableFirefoxStudies = true;
	DisablePocket = true; # Annoying recommended articles
        EnableTrackingProtection = {
          Value = true;
          Locked = true;
          Cryptomining = true;
          Fingerprinting = true;
        };

        # --- 2. uBlock Origin in every profile ---
        ExtensionSettings = {
          # Official download link
          "uBlock0@raymondhill.net" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
            installation_mode = "force_installed";

	    adminSettings = builtins.toJSON {
              userSettings = {
                uiTheme = "dark";
                webrtcIPAddressHidden = true;
              };
              selectedFilterLists = [
                "user-filters"
                "ublock-filters"
                "ublock-badware"
                "ublock-privacy"
                "ublock-unbreak"
		"ublock-annoyances" # Anti adblock and popup
                "easylist" # Anti Ads
                "easyprivacy" # Anti tracker
                "urlhaus-1" # Anti malware
		"adguard-annoyance" # Cookies popup killer
                "easylist-annoyances" # Cookies and popups
                "plowe-0" # Polish filter
                "POL-0" # Polish filter
              ];
	    };
          };
        };
      };
      # Needs more settings here like personal and work profiles etc
    };
  };
}
