{ pkgs, nx_tzdb, ... }:
let
  version = "unstable-2025-02-09";
  src = pkgs.fetchgit {
    fetchSubmodules = true;
    deepClone = true;
    url = "https://git.citron-emu.org/Citron/Citron";
    rev = "13ada2d705137483f7004374438135d2a918e578";
    sha256 = "sha256-yudrigcwOjWtQcdGUJdRtD5DcwbXMrPyaypsQCp4J9U=";
  };
in
pkgs.qt6.callPackage ./citron.nix ({ inherit nx_tzdb version src; })
