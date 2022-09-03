{
  description = "A collection of utilities for ripping, dumping, analysing, and modifying disk images.";

  inputs = rec {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        packages = rec {
          default = ipflib;

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
      }
    );
}
