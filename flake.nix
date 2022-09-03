{
  inputs = rec {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.05";
    flake-utils.url = "github:numtide/flake-utils";

    ipflib-src.url = "http://www.softpres.org/_media/files:ipflib42_linux-x86_64.tar.gz?id=download&cache=cache";
    ipflib-src.flake = false;
  };

  outputs = { self, nixpkgs, flake-utils, ipflib-src }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        packages = rec {
          default = ipflib;

          ipflib = pkgs.stdenv.mkDerivation rec {
            pname = "ipflib";
            version = "4.2";

            src = ipflib-src;

            installPhase = ''
              mkdir -p $out $out/lib
              cp -vr include $out
              cp -v libcapsimage.so.4.2 $out/lib
              ln -s libcapsimage.so.4.2 $out/lib/libcapsimage.so.4
            '';

            postFixup = ''
              patchelf --set-rpath ${pkgs.stdenv.cc.cc.lib}/lib $out/lib/libcapsimage.so.4.2
            '';
          };
        };
      }
    );
}
