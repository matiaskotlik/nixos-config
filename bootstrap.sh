#!/bin/sh
set -e

export NIX_CONFIG='extra-experimental-features = nix-command flakes'
DIR=$HOME/nixos-config

if ! command -v nix >/dev/null; then
  curl -fsSL https://install.determinate.systems/nix | sh -s -- install --no-confirm
  . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
fi

[ -e "$DIR/.git" ] || nix run nixpkgs#git -- clone https://github.com/matiaskotlik/nixos-config "$DIR"
cd "$DIR"
exec nix run .#build-switch
