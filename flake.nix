{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
  };
  outputs =
    { self
    , nixpkgs
    , flake-utils
    , ...
    }:
    flake-utils.lib.eachDefaultSystem
      (system:
      let
        pkgs = import nixpkgs { inherit system; };
        lsleases = pkgs.callPackage ./lsleases.nix { };
      in
      {
        packages.default = lsleases;
        packages.lsleases = lsleases;

        devShells.default =
          # self.packages.${system}.default.overrideAttrs (super: {
          pkgs.mkShell
            {
              name = "test";
              nativeBuildInputs = with pkgs;
                [
                  golangci-lint
                  go_1_21
                  gotools
                  go-junit-report
                  go-task
                  delve
                ];
              # });
            };
      })
    // {
      overlays.default = final: prev: {
        inherit (self.packages.${final.system}) lsleases;
      };
    };
}
