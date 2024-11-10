{
  config,
  lib,
  pkgs,
  ...
}: let
  # Shorter name to access final settings a
  # user of hello.nix module HAS ACTUALLY SET.
  # cfg is a typical convention.
  cfg = config.services.lsleases;
in {
  imports = [
    # Paths to other modules.
    # Compose this module out of smaller ones.
  ];

  options.services.lsleases = {
    # Option declarations.
    # Declare what settings a user of this module can set.
    # Usually this includes a global "enable" option which defaults to false.
    enable = lib.mkEnableOption "lsleases service";
  };

  config = lib.mkIf cfg.enable {
    # Option definitions.
    # Define what other settings, services and resources should be active.
    # Usually these depend on whether a user of this module chose to "enable" it
    # using the "option" above.
    # Options for modules imported in "imports" can be set here.
    systemd.services.lsleasesd = {
      enable = true;
      description = "lsleases";
      serviceConfig = {
        ExecStart = "${pkgs.lsleases}/bin/lsleasesd -webui -t 20m -m 2";
      };
      wantedBy = ["multi-user.target"];
    };
    environment.systemPackages = with pkgs; [
      lsleases
    ];
  };
}
