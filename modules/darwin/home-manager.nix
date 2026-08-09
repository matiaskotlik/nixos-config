{ config, pkgs, lib, home-manager, ... }:

let
  user = "matiaskotlik";
  # Define the content of your file as a derivation
  myEmacsLauncher = pkgs.writeScript "emacs-launcher.command" ''
    #!/bin/sh
    emacsclient -c -n &
  '';
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
    casks = pkgs.callPackage ./casks.nix {};
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
    users.${user} = { pkgs, config, lib, ... }:{
      home = {
        enableNixpkgsReleaseCheck = false;
        packages = pkgs.callPackage ./packages.nix {};
        file = lib.mkMerge [
          sharedFiles
          additionalFiles
          { "emacs-launcher.command".source = myEmacsLauncher; }
        ];
        stateVersion = "23.11";
      };
      programs = {} // import ../shared/home-manager.nix { inherit config pkgs lib; };

      # Marked broken Oct 20, 2022 check later to remove this
      # https://github.com/nix-community/home-manager/issues/3344
      manual.manpages.enable = false;
    };
  };

}
