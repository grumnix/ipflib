{
  description = "A collection of utilities for ripping, dumping, analysing, and modifying disk images.";

  inputs = rec {
    nixpkgs.url = "github:nixos/nixpkgs";
    nix.inputs.nixpkgs.follows = "nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nix, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in rec {
        packages = flake-utils.lib.flattenTree rec {
          ipflib = pkgs.stdenv.mkDerivation rec {
            pname = "ipflib";
            version = "0.0.0";
            src = fetchTarball {
              url = "http://www.softpres.org/_media/files:ipfdevlib_linux.tgz?id=download&cache=cache";
              sha256 = "sha256:13w3q3rcycfksnsad9yislqhy1b0fakv7rimjlss0r84cgi0jjds";
            };
            installPhase = ''
              mkdir -p $out
              cp -vr include lib $out
            '';
          };
        };
        defaultPackage = packages.ipflib;
      }
    );
}
