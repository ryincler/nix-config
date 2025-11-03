{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkOption mkMerge;
  cfg = config.modules.services.tlp;
in {
  options = {
    modules.services.tlp = {
      enable = mkEnableOption "laptop TLP config";
      limitCharge = {
        enable = mkEnableOption "battery charging limits";
        stopCharge = mkOption {
          type = lib.types.ints.between 1 100;
          default = 80;
          description = "Percent charge threshold to stop charging.";
        };
        startCharge = mkOption {
          type = lib.types.ints.between 0 99;
          default = 65;
          description = "Percent charge threshold to start charging.";
        };
      };
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      services.tlp = {
        enable = true;
        settings = {
          CPU_SCALING_GOVERNOR_ON_AC = "performance";
          CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

          CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
          CPU_ENERGY_PERF_POLICY_ON_BAT = "default";

          CPU_MIN_PERF_ON_AC = 0;
          CPU_MAX_PERF_ON_AC = 100;
          CPU_MIN_PERF_ON_BAT = 0;
          CPU_MAX_PERF_ON_BAT = 60;

          CPU_BOOST_ON_AC = 1;
          CPU_BOOST_ON_BAT = 1;

          CPU_HWP_DYN_BOOST_ON_AC = 1;
          CPU_HWP_DYN_BOOST_ON_BAT = 0;
        };
      };
    }

    (mkIf cfg.limitCharge.enable {
      assertions = [
        {
          assertion = cfg.limitCharge.stopCharge > cfg.limitCharge.startCharge;
          message = "stopCharge should be greater than startCharge";
        }
      ];
      services.tlp.settings = {
        START_CHARGE_THRESH_BAT0 = cfg.limitCharge.startCharge;
        STOP_CHARGE_THRESH_BAT0 = cfg.limitCharge.stopCharge;
      };
    })
  ]);
}

