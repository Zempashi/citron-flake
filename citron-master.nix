{ pkgs, nx_tzdb, ... }:
let
  version = "unstable-2025-01-26";
  src = pkgs.fetchgit {
    fetchSubmodules = true;
    deepClone = true;
    url = "https://git.citron-emu.org/Citron/Citron";
    rev = "be191f740a477290f6dae570fa615aaf0d24bdd4";
    sha256 = "sha256-D/sPgn030kl3G96IHHYzG/KGjBhJdheyzLZKjSuxUcs=";
  };
in
pkgs.qt6.callPackage ./citron.nix ({ inherit nx_tzdb version src; })
