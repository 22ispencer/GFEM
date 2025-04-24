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
        buildInputs = [
          pkgs.gtk4
          pkgs.gtkmm4
        ];
        nativeBuildInputs = [
          pkgs.meson
          pkgs.ninja
          pkgs.pkg-config
          pkgs.clang-tools
        ];
      in
      {
        packages.default = stdenv.mkDerivation {
          inherit nativeBuildInputs buildInputs;
          pname = "gfem";
          version = "0.1.0";
          src = self;
        };
        devShell = pkgs.mkShell {
          inherit nativeBuildInputs buildInputs;
          shellHook = ''
            # Create a build directory if it doesn't exist and configure Meson
            if [ ! -d "build" ]; then
              echo "Configuring Meson build directory..."
              meson setup \
                --prefix=$PWD/install \
                ''${mesonFlags[@]} \
                . build
            fi

            # Generate compile_commands.json using ninja's compdb tool
            echo "Generating compile_commands.json..."
            ninja -C build -t compdb > compile_commands.json

            echo "Entering development shell. compile_commands.json is in the current directory."
          '';
          packages = [
            pkgs.cambalache
          ];
        };
      }
    );
}
