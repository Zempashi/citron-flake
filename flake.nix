{
  description = "A flake of an experimental Ciron Nintendo Switch emulator";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    #systems.url = "github:nix-systems/default-linux";
  };

  outputs = { self, nixpkgs, systems, ... }:
  let
    eachSystem = nixpkgs.lib.genAttrs (import systems);
  in
  {
    packages = eachSystem (system:
    let
      pkgs = import nixpkgs {
        inherit system;
        #config = {allowUnfree = true;}; # cuda
      };
    in {
        nx_tzdb = pkgs.callPackage ./nx_tzdb.nix {};
        compat-list = pkgs.callPackage ./compat-list.nix {};
        default = self.packages.${system}.citron;
        citron = pkgs.libsForQt5.callPackage ./citron.nix { nx_tzdb=self.packages.${system}.nx_tzdb; compat-list=self.packages.${system}.compat-list; };
      }
    );
  };
}

