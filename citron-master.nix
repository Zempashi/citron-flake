{ pkgs, nx_tzdb, ... }:
let
  version = "unstable-2025-07-08";
  src = pkgs.fetchgit {
    fetchSubmodules = true;
    deepClone = true;
    url = "https://git.citron-emu.org/citron/emu.git/";
    rev = "046538bb473c99fe3d02f9b0e76f7a056e6cecc8";
    sha256 = "sha256-63eoHiskOZ0NbQKZ2Lp8BDThJR7Pdi/u9fBe9FHT9HE=";
  };
in
pkgs.qt6.callPackage ./citron.nix ({ inherit nx_tzdb version src; })
