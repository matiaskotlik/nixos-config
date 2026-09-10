{
  config,
  pkgs,
  ...
}:

let
  user = "matias";
  sharedFiles = import ../shared/files.nix { inherit config pkgs; };
  additionalFiles = import ./files.nix { inherit user config pkgs; };
in
{
  # nix-darwin needs knownUsers
  users.knownUsers = [ user ];
  users.users.${user} = {
    name = "${user}";
    uid = 501;
    home = "/Users/${user}";
    isHidden = false;
    shell = pkgs.fish;
  };

  programs.fish.enable = true;
  environment.shells = [ pkgs.fish ];

  homebrew = {
    enable = true;
    casks = pkgs.callPackage ./casks.nix { };
    onActivation.cleanup = "uninstall";
    onActivation.upgrade = true;
    # So cleanup won't untap them
    taps = builtins.attrNames config.nix-homebrew.taps;

    # IDs from the mas CLI
    masApps = {
      "bitwarden" = 1352778147;
      "slack" = 803453959;
    };
  };

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

        # Profile lives in files.nix
        targets.darwin.defaults."com.googlecode.iterm2" = {
          "Default Bookmark Guid" = "nix-default-0001";
          PromptOnQuit = false;
          OnlyWhenMoreTabs = false;
          HideTab = true;
          # Homebrew owns updates, not Sparkle
          SUEnableAutomaticChecks = false;
          # tmux windows as native tabs
          OpenTmuxWindowsIn = 2;
          AutoHideTmuxClientSession = true;
        };

        # https://github.com/nix-community/home-manager/issues/3344
        manual.manpages.enable = false;
      };
  };

}
