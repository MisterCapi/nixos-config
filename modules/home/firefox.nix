# modules/home/firefox.nix
{ inputs, ... }:
{
  flake.homeModules.firefox = { config, stylix, ... }:
  let
    profileDir = "${config.home.homeDirectory}/.mozilla/firefox/${
      config.programs.firefox.profiles.default.path
    }";
  in
  {
    programs.firefox = {
      enable = true;
      profiles.default = {
        settings = {
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
          "browser.theme.content-theme" = 0;   # 0 = dark, 1 = light, 2 = system
          "browser.newtabpage.activity-stream.newtabWallpapers.enabled" = false;
        };
      };
    };
    # TODO: Quick fix for noe, will need do add custom homepage

    stylix.targets.firefox.enable = false;

    home.file = let
      rp = inputs.rosepine-firefox;
      chrome = "${profileDir}/chrome";
    in {
      "${chrome}/userChrome.css".source  = "${rp}/dist/userChrome.css";
      "${chrome}/userColors.css".source  = "${rp}/dist/userColors.css";
      "${chrome}/userContent.css".source = "${rp}/dist/userContent.css";
      "${chrome}/add.svg".source         = "${rp}/dist/add.svg";
      "${chrome}/left-arrow.svg".source  = "${rp}/dist/left-arrow.svg";
      "${chrome}/right-arrow.svg".source = "${rp}/dist/right-arrow.svg";
    };
  };
}
