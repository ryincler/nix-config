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
    # To be able to adjust voltage and clock in sysfs
    boot.kernelParams = ["amdgpu.ppfeaturemask=0xffffffff"];

    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };
  };
}
