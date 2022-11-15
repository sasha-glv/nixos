{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.custom.services.seafile;
in {
  options.custom.services.seafile = {
    enable = mkEnableOption "enable custom.services.seafile";
    hostname = mkOption {
      type = with types; string;
      description = ''
        hostname of the seafile server
      '';
    };
    port = mkOption {
      type = with types; int;
      description = ''
        port on where ther server runs on
      '';
    };
    home = mkOption {
      type = with types; path;
      description = ''
        folder in where the seafile stuff gets stored
      '';
    };
    serviceName = mkOption {
      type = with types; string;
      default = "seafile-docker";
      description = ''
        name of the systemd service
      '';
    };
  };
  config = mkIf cfg.enable {
    virtualisation.docker.enable = true;
    systemd.services."${cfg.serviceName}" = {
      enable = true;
      description = "seafile service running as docker";
      after = [ "network.target" "docker.service" ];
      requires = [ "docker.service" ];
      wantedBy = [ "multi-user.target" ];
      script = # sh
        ''
          # delete old instance to ensure update
          ${pkgs.docker}/bin/docker stop seafile || true && ${pkgs.docker}/bin/docker rm -f seafile || true
          # start instance
          ${pkgs.docker}/bin/docker run \
            --name seafile \
            --env SEAFILE_SERVER_HOSTNAME=${cfg.hostname} \
            --env SEAFILE_ADMIN_EMAIL="root@${cfg.hostname}"  \
            --env SEAFILE_ADMIN_PASSWORD="${
              lib.fileContents <secrets/seafile/root>
            }" \
            --volume ${cfg.home}:/shared \
            --publish ${toString cfg.port}:80 \
            seafileltd/seafile:latest
        '';
    };
  };
}
