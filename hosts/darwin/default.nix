{ pkgs, ... }:

let
  user = "matiaskotlik";
in

{
  imports = [
    ../../modules/darwin/home-manager.nix
    ../../modules/shared
  ];

  # Determinate Nix
  determinateNix = {
    enable = true;

    customSettings = {
      trusted-users = [
        "@admin"
        "${user}"
      ];
      extra-substituters = [ "https://nix-community.cachix.org" ];
      extra-trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };

    # Garbage collection
    determinateNixd.garbageCollector.strategy = "automatic";
  };

  # Touch ID for sudo
  security.pam.services.sudo_local.touchIdAuth = true;

  environment.systemPackages = with pkgs; import ../../modules/shared/packages.nix { inherit pkgs; };

  # Tailscale
  services.tailscale.enable = true;

  system = {
    checks.verifyNixPath = false;
    primaryUser = user;
    stateVersion = 5;

    defaults = {
      NSGlobalDomain = {
        AppleShowAllExtensions = true;
        ApplePressAndHoldEnabled = false;

        KeyRepeat = 2; # Values: 120, 90, 60, 30, 12, 6, 2
        InitialKeyRepeat = 15; # Values: 120, 94, 68, 35, 25, 15

        "com.apple.mouse.tapBehavior" = 1;
        "com.apple.sound.beep.volume" = 0.0;
        "com.apple.sound.beep.feedback" = 0;
      };

      dock = {
        autohide = true;
        show-recents = false;
        launchanim = true;
        orientation = "bottom";
        tilesize = 48;

        persistent-apps = [
          { app = "/Applications/Firefox.app"; }
          { app = "/Users/${user}/Applications/Home Manager Apps/iTerm2.app"; }
          { app = "/Applications/PyCharm.app"; }
          { app = "/Applications/IntelliJ IDEA.app"; }
          { app = "/Applications/CLion.app"; }
          { app = "/Applications/Slack.app"; }
          { app = "/Applications/Discord.app"; }
          { app = "/Applications/Signal.app"; }
          { app = "/System/Applications/Messages.app"; }
          { app = "/System/Applications/Mail.app"; }
          { app = "/Applications/Notion.app"; }
          { app = "/Applications/Spotify.app"; }
        ];

        persistent-others = [
          {
            folder = {
              path = "/Users/${user}/Downloads";
              arrangement = "name";
              displayas = "stack";
              showas = "fan";
            };
          }
        ];
      };

      finder = {
        _FXShowPosixPathInTitle = false;
      };

      trackpad = {
        Clicking = true;
        TrackpadThreeFingerDrag = true;
      };
    };
  };
}
