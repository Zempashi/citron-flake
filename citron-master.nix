{ pkgs, nx_tzdb, ... }:
let
  version = "unstable-2025-01-18";
  src = pkgs.fetchgit {
    fetchSubmodules = true;
    deepClone = true;
    url = "https://git.citron-emu.org/Citron/Citron";
    rev = "d4d3061eb78fdba50201613271688a1dcd231ef4";
    sha256 = "lQ5fHqbO/aT4VGmxTo4/YTm1JLGmQlihts6QUHUbJXo=";
  };
in
pkgs.qt6.callPackage ./citron.nix ({ inherit nx_tzdb version src; })
