{ pkgs, nx_tzdb, ... }:
let
  version = "unstable-2025-01-21";
  src = pkgs.fetchgit {
    fetchSubmodules = true;
    deepClone = true;
    url = "https://git.citron-emu.org/Citron/Citron";
    rev = "774d8d9eba6225570689fb4d2a2af73e15c66d6d";
    sha256 = "sha256-qNQsgoYGsBr0eBaj/NJGZQcMMOWd/urtTtOeZj/T9jY=";
  };
in
pkgs.qt6.callPackage ./citron.nix ({ inherit nx_tzdb version src; })
