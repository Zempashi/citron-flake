let
  nixpkgs = fetchTarball "https://github.com/NixOS/nixpkgs/tarball/nixos-24.11";
  pkgs = import nixpkgs { config = {}; overlays = []; };
  nx_tzdb = pkgs.callPackage ./nx_tzdb.nix {};
  compat-list = pkgs.callPackage ./compat-list.nix {};
in
{
  citron = pkgs.libsForQt5.callPackage ./citron.nix { nx_tzdb=nx_tzdb; compat-list=compat-list; };
}
