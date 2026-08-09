{ pkgs }:

with pkgs; [
  # General packages for development and system management
  btop
  coreutils
  killall
  openssh
  sqlite
  wget
  zip

  # Encryption and security tools
  age
  gnupg

  # Media-related packages
  dejavu_fonts
  fd
  font-awesome
  hack-font
  noto-fonts
  noto-fonts-color-emoji
  meslo-lgs-nf

  # Node.js development tools
  nodejs_26
  pnpm_11

  # Text and terminal utilities
  htop
  jq
  ripgrep
  tree
  tmux
  unzip
  
  # Development tools
  curl
  gh
  fzf
  direnv
  fh
  
  # Programming languages and runtimes
  go
  rustc
  cargo
  openjdk

  # Python packages
  python3
  virtualenv
]
