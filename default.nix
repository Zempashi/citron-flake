{pkgs ? import <nixpkgs> {}}:
let
  nx_tzdb = pkgs.callPackage ./nx_tzdb.nix {};
in
{
  default = pkgs.qt6.callPackage ./eden-master.nix { inherit nx_tzdb; };
  citron = pkgs.qt6.callPackage ./citron-release.nix { inherit nx_tzdb; };
  citron-master = pkgs.qt6.callPackage ./citron-master.nix { inherit nx_tzdb; };
  eden-master = pkgs.qt6.callPackage ./eden-master.nix { inherit nx_tzdb; };
}
