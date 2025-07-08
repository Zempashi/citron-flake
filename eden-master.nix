{ pkgs, nx_tzdb, ... }:
let
  version = "unstable-2025-06-12";
  src = pkgs.fetchgit {
    fetchSubmodules = true;
    deepClone = true;
    url = "https://git.eden-emu.dev/eden-emu/eden.git/";
    rev = "5d4c6e085d";
    sha256 = "sha256-yk0jQ4JL/L88aNUKjTXbyPFU4aNOtWf4p0prRKHp7qM=";
  };
in
pkgs.qt6.callPackage ./eden.nix ({ inherit nx_tzdb version src; })
