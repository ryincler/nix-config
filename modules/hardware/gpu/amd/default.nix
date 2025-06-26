{
  config,
  lib,
  ...
}: let
  inherit (lib) mkOption mkIf;
  cfg = config.modules.hardware.gpu.amd;
in {
  options = {
    modules.hardware.gpu.amd.enable = mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enables support for AMD GPUs.";
    };
  };
  config = mkIf cfg.enable {
    nixpkgs.overlays = [
      (final: prev: {
        linux-firmware = prev.linux-firmware.overrideAttrs {
          version = "20250625-cbbc56e";
          src = final.fetchFromGitLab {
            owner = "kernel-firmware";
            repo = "linux-firmware";
            rev = "cbbce56d6dcc1ec8fb485dfb92c68cb9acd51410";
            hash = "sha256-7XN2g4cnHLnICs/ynt8dCpTJbbBkbOdtRm3by/XrDps=";
          };
        };
      })
    ];
    # To be able to adjust voltage and clock in sysfs
    boot.kernelParams = ["amdgpu.ppfeaturemask=0xffffffff"];

    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };
  };
}
