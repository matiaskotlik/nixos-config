# nixos-config

nix-darwin, NixOS, and home-manager configuration.

## Bootstrap

```sh
curl -fsSL https://raw.githubusercontent.com/matiaskotlik/nixos-config/main/bootstrap.sh | sh
```

Installs Nix if missing, clones this repo to `~/nixos-config`, and switches the system to it.

On macOS the primary account must be `matias` (uid 501), and the `masApps` in
`modules/darwin/home-manager.nix` need Mac App Store sign-in. On NixOS the host is named
`nixos` and disko owns `/dev/nvme0n1`; edit `hosts/nixos` and `modules/nixos/disk-config.nix`
if that is not your machine.

## Rebuild

```sh
nix run .#build-switch
```
