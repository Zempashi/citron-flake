{ pkgs, nx_tzdb, ... }:
let
  version = "unstable-2025-01-20";
  src = pkgs.fetchgit {
    fetchSubmodules = true;
    deepClone = true;
    url = "https://git.citron-emu.org/Citron/Citron";
    rev = "d7dc87bbf3a9c515c96f7734df34b31810540c50";
    sha256 = "jm3AINx+uSq6g5nSpT0kbagPrPFv2BOgRweNIhXU14o=";
  };
in
pkgs.qt6.callPackage ./citron.nix ({ inherit nx_tzdb version src; })
