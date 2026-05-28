{
  description = "Catppuccin Mocha Mauve Plymouth theme for NixOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { nixpkgs, flake-utils, ... }:
    with flake-utils.lib; eachDefaultSystem (system: let
      pkgs = import nixpkgs { inherit system; };
    in {
      packages.default = pkgs.callPackage ./package.nix {};
      packages.nixos-catppuccin-mauve = pkgs.callPackage ./package.nix {};

      devShells.default = pkgs.mkShell {
        packages = with pkgs; [ imagemagick plymouth ];
      };
    }) // {
      overlays.default = final: prev: {
        nixos-catppuccin-mauve = final.callPackage ./package.nix {};
      };
    };
}
