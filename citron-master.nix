{ pkgs, nx_tzdb, ... }:
let
  version = "unstable-2025-02-22";
  src = pkgs.fetchgit {
    fetchSubmodules = true;
    deepClone = true;
    url = "https://git.citron-emu.org/Citron/Citron";
    rev = "d9619b7eed13adc4bac329bf4b46ee254fe7a5a6";
    sha256 = "sha256-brZjPnhR5bxkLEf8LPXTKR7UoNSBfEWVWpLxI7TY4LA=";
  };
in
pkgs.qt6.callPackage ./citron.nix ({ inherit nx_tzdb version src; })
