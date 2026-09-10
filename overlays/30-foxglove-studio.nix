_self: super: {
  # pin newer than nixpkgs
  foxglove-studio = super.foxglove-studio.overrideAttrs (
    finalAttrs: _: {
      version = "3.1.1";
      src = super.fetchurl {
        url = "https://get.foxglove.dev/desktop/v${finalAttrs.version}/foxglove-studio-${finalAttrs.version}-linux-amd64.deb";
        hash = "sha256-wKTcS5sE03f9F3c+Zt3P1shpGX8Z7BIDb9Vppm8kE6o=";
      };
    }
  );
}
