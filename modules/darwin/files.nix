{ user, config, pkgs, ... }:

let
  home = config.users.users.${user}.home;
  xdg_configHome = "${home}/.config";
  xdg_dataHome   = "${home}/.local/share";
  xdg_stateHome  = "${home}/.local/state"; in
{
  # iTerm2 dynamic profile, picked up live
  "Library/Application Support/iTerm2/DynamicProfiles/nix-profile.json".source =
    ./config/iterm2/nix-profile.json;
}
