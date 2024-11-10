{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };
  outputs = inputs:
    inputs.flake-parts.lib.mkFlake {
      inherit inputs;
    } {
      imports = [
        inputs.flake-parts.flakeModules.easyOverlay
      ];
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      perSystem = {
        config,
        pkgs,
        system,
        ...
      }: {
        packages.lsleases = pkgs.callPackage ./nix/lsleases.nix {};
        overlayAttrs = {
          inherit (config.packages) lsleases;
        };

        devShells.default =
          pkgs.mkShell
          {
            name = "lsleases dev shell";
            nativeBuildInputs = with pkgs; [
              golangci-lint
              go_1_21
              gotools
              go-junit-report
              go-task
              delve
            ];
          };
        checks = {
          inherit
            (config.packages)
            lsleases
            ;
        };
        # Formatter for your nix files, available through 'nix fmt'
        # Other options beside 'alejandra' include 'nixpkgs-fmt'
        formatter = pkgs.alejandra;

        # overlays.default = final: prev: {
        #   # inherit (packages.${system}) lsleases;
        # };
      };
      flake = {
        nixosModules.default = ./nix/modules;
      };
    };
  # // {
  # };
}
