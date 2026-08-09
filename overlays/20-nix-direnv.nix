_self: super: {
  # pin newer than nixpkgs
  nix-direnv = super.callPackage (super.fetchFromGitHub {
    owner = "nix-community";
    repo = "nix-direnv";
    rev = "3.2.0";
    hash = "sha256-dNJeSRuuqA2avtLpTse7mTTmnYdVnC5BxRsofuLXiqE=";
  }) { };
}
