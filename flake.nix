{
  description = "A flake of an experimental Ciron Nintendo Switch emulator";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
        {
          packages = (import ./. {inherit pkgs;});
          devShells.default = pkgs.mkShell {
            buildInputs = [ pkgs.git pkgs.nixpkgs-fmt pkgs.update-nix-fetchgit ];
          };
        }
    );
}
