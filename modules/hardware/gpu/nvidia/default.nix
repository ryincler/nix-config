{
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkDefault mkForce;
in {
  options = {
    nvidia.enable = mkEnableOption "nvidia module";
  };

  config = mkIf config.nvidia.enable {
    nixpkgs.config = {
      allowUnfree = mkForce true;
      cudaSupport = mkDefault true;
    };

    hardware.nvidia = {
      powerManagement.enable = true;
      open = mkDefault true;
      package = mkDefault config.boot.kernelPackages.nvidiaPackages.beta;
      nvidiaSettings = mkDefault false;
    };

    services.xserver.videoDrivers = ["nvidia"];

    boot = {
      kernelParams = [
        "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
      ];
      kernelModules = [
        "nvidia"
        "nvidia_modeset"
        "nvidia_drm"
        "nvidia_uvm"
      ];
    };
  };

}
