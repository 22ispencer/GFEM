{
  inputs = {
    utils.url = "github:numtide/flake-utils";
  };
  outputs =
    {
      self,
      nixpkgs,
      utils,
    }:
    utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        inherit (pkgs) stdenv;
      in
      {
        packages.default = stdenv.mkDerivation {
          pname = "gfem";
          version = "0.1.0";
          src = self;
          nativeBuildInputs = [
            pkgs.meson
            pkgs.ninja
          ];
        };
        devShell = pkgs.mkShell {
          packages = with pkgs; [
            clang-tools
            guile
          ];
        };
      }
    );
}
