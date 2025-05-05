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
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };
  };
}
