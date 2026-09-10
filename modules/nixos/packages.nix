{ pkgs }:

with pkgs;
let
  shared-packages = import ../shared/packages.nix { inherit pkgs; };
in
shared-packages
++ [

  # Containers
  docker
  docker-compose

  # Security
  yubikey-agent

  # Build and packaging
  appimage-run
  gnumake
  cmake
  home-manager

  # Fonts
  fontconfig

  # Audio
  pavucontrol

  # Launcher
  rofi
  rofi-calc

  # Screenshots
  flameshot

  # Terminal utilities
  tree
  unixtools.ifconfig
  unixtools.netstat
  xclip
  xwininfo
  xrandr

  # System utilities
  inotify-tools
  libnotify
  pcmanfm
  sqlite
  xdg-utils

  # PDF viewer
  zathura

  # Browser
  firefox

  # Robotics
  foxglove-studio
]
