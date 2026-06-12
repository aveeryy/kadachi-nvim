{
  description = "Neovim configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    gift-wrap = {
      url = "github:tgirlcloud/gift-wrap";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ self, nixpkgs, ... }:
    let
      inherit (nixpkgs) lib;

      forAllSystems =
        f:
        lib.genAttrs lib.systems.flakeExposed (
          system:
          f (
            import nixpkgs {
              inherit system;
              config.allowUnfree = true;
            }
          )
        );

      mkPackages =
        default: pkgs:
        let
          generatedPackages = import ./default.nix {
            inherit pkgs;
            gift-wrap = inputs.gift-wrap.packages.${pkgs.stdenv.hostPlatform.system};
            versionSuffix = self.shortRev or self.dirtyShortRev or "unknown";
          };
          defaultPackage = lib.optionalAttrs default { default = generatedPackages.kadachi-nvim; };
        in
        generatedPackages // defaultPackage;
    in
    {
      legacyPackages = forAllSystems (mkPackages true);
      packages = forAllSystems (mkPackages true);
    };
}
