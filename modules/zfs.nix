{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.services.zfsBackupReplication;
  zfsBackup = pkgs.writeScriptBin "send_zfs_snapshot" (builtins.readFile ../scripts/send_zfs_snapshot.sh);
in
{
  options.services.zfsBackupReplication = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to enable zfsBackup.";
    };
    datasets = mkOption {
      type = types.listOf types.attrs;
      default = [];
      description = "List of datasets to backup";
    };
  };

  config = mkIf cfg.enable {
    systemd = mkMerge [
      {
        timers = builtins.listToAttrs (map (dataset: {
          name = dataset.serviceName;
          value = {
            wantedBy = [ "timers.target" ];
            description = "Backup ZFS snapshots to backup server";
            timerConfig = {
              OnCalendar = "hourly";
              Persistent = true;
            };
          };
        }) cfg.datasets);
      }
      {
        services = builtins.listToAttrs (map (dataset: {
          name = dataset.serviceName;
          value = {
            path = with pkgs; [ zfs bash openssh zfsBackup ];
            serviceConfig = {
              User = dataset.user;
              Type = "oneshot";
            };
            script = "${zfsBackup}/bin/send_zfs_snapshot -r ${dataset.remoteHost} -s ${dataset.name} -d ${dataset.remote}";
          };
        }) cfg.datasets);
      }
    ];
  };
}
