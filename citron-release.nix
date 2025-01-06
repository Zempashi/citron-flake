{ pkgs, nx_tzdb, ... }:

let
  version = "v0.3-canary-refresh";
  src = pkgs.fetchgit {
    fetchSubmodules = true;
    deepClone = true;
    url = "https://git.citron-emu.org/Citron/Citron";
    tag = "v0.3-canary-refresh";
    sha256 = "03ikkvsays29nkhd5sk088qq20islmn6bv9wjv7l76hc8hd7vx3a";
  };
in
pkgs.qt6.callPackage ./citron.nix ({ inherit nx_tzdb version src; })
