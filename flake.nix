{
  # Nix Flake for this package
  description = "rhasselbaum/mqtt-launcher package Flake";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        pname = "mqtt-launcher";
      in
      {
        packages = {
          mqtt-launcher = pkgs.stdenv.mkDerivation {
            inherit pname;
            version = "git";

            src = ./.;
            buildInputs = [
              (pkgs.python3.withPackages (p: with p; [ paho-mqtt_2 ]))
              pkgs.makeWrapper
            ];

            installPhase = ''
              mkdir -p $out/bin
              cp $src/${pname}.py $out/bin
              chmod +x $out/bin/${pname}.py
              makeWrapper $out/bin/${pname}.py $out/bin/${pname}
            '';
          };
        };

        defaultPackage = self.packages.${system}.mqtt-launcher;
      }
    );
  }