# Helpful documentation: https://github.com/NixOS/nixpkgs/blob/master/doc/languages-frameworks/go.section.md
{ lib, stdenv, installShellFiles, buildGoModule }:
buildGoModule rec {
  name = "lsleases";

  src = lib.cleanSource ./.;

  vendorHash = "sha256-mqtJX1Qt7UD69HcXr21TIOZxag4F42g1oKaJUR/kicM=";

  subPackages = [
    "cmd/lsleases"
    "cmd/lsleasesd"
  ];

  doCheck = false;

  meta = with lib; {
    description = "lsleases - list dynamic assigned ip addresses in your network";
    homepage = "https://github.com/j-keck/lsleases";
    license = licenses.mit;
  };
}
