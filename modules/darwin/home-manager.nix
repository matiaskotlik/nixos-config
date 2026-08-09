{
  config,
  pkgs,
  ...
}:

let
  user = "matiaskotlik";
  sharedFiles = import ../shared/files.nix { inherit config pkgs; };
  additionalFiles = import ./files.nix { inherit user config pkgs; };
in
{
  # It me
  # nix-darwin only touches users listed in knownUsers
  users.knownUsers = [ user ];
  users.users.${user} = {
    name = "${user}";
    uid = 501;
    home = "/Users/${user}";
    isHidden = false;
    shell = pkgs.fish;
  };

  # Fish shell
  programs.fish.enable = true;
  environment.shells = [ pkgs.fish ];

  homebrew = {
    enable = true;
    casks = pkgs.callPackage ./casks.nix { };
    onActivation.cleanup = "uninstall";
    # Mirror nix-homebrew taps so cleanup won't untap them
    taps = builtins.attrNames config.nix-homebrew.taps;

    # These app IDs are from using the mas CLI app
    # mas = mac app store
    # https://github.com/mas-cli/mas
    #
    # $ nix shell nixpkgs#mas
    # $ mas search <app name>
    #
    # If you have previously added these apps to your Mac App Store profile (but not installed them on this system),
    # you may receive an error message "Redownload Unavailable with This Apple ID".
    # This message is safe to ignore. (https://github.com/dustinlyons/nixos-config/issues/83)
    masApps = {
      "bitwarden" = 1352778147;
      "slack" = 803453959;
    };
  };

  # Enable home-manager
  home-manager = {
    useGlobalPkgs = true;
    backupFileExtension = "bak";
    users.${user} =
      {
        pkgs,
        config,
        lib,
        ...
      }:
      {
        home = {
          enableNixpkgsReleaseCheck = false;
          packages = pkgs.callPackage ./packages.nix { };
          file = lib.mkMerge [
            sharedFiles
            additionalFiles
          ];
          stateVersion = "23.11";
        };
        xdg.enable = true;
        programs = import ../shared/home-manager.nix { inherit config pkgs lib; };

        # iTerm2 app prefs, profile lives in files.nix
        targets.darwin.defaults."com.googlecode.iterm2" = {
          # Default to the nix-managed dynamic profile
          "Default Bookmark Guid" = "nix-default-0001";
          PromptOnQuit = false;
          OnlyWhenMoreTabs = false;
          HideTab = true;
          # Homebrew owns updates, not Sparkle
          SUEnableAutomaticChecks = false;
        };

        # Marked broken Oct 20, 2022 check later to remove this
        # https://github.com/nix-community/home-manager/issues/3344
        manual.manpages.enable = false;
      };
  };

}
