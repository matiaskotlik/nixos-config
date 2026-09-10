{ pkgs }:

with pkgs;
[
  # General
  btop
  coreutils
  killall
  openssh
  sqlite
  wget
  zip

  # Security
  age
  gnupg

  # Fonts and media
  dejavu_fonts
  fd
  font-awesome
  nerd-fonts.hack
  noto-fonts
  noto-fonts-color-emoji
  meslo-lgs-nf

  # Node
  nodejs_26
  pnpm_11

  # Terminal utilities
  htop
  jq
  ripgrep
  tree
  tmux
  unzip

  # Development
  curl
  fzf
  fh

  # Languages
  go
  rustc
  cargo
  openjdk

  # Python
  python3
  virtualenv
]
