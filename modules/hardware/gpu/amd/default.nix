{
  config,
  lib,
  pkgs,
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
    # Revert amdgpu regression freeze nonsense on linux-firmware version 20251125.
    # See https://gitlab.freedesktop.org/drm/amd/-/issues/4737
    nixpkgs.overlays = [
      (final: prev: {
        linux-firmware = prev.linux-firmware.overrideAttrs {
          version = "a0f0e52-git-revert";
          src = pkgs.fetchFromGitLab {
            owner = "kernel-firmware";
            repo = "linux-firmware";
            rev = "a0f0e52138e5f77fb0f358ff952447623ae0a7c4";
            hash = "sha256-ukXZjh5OWnFoppD1TVBwHvcXvH4IOoebnQI+pDm/nOk=";
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
