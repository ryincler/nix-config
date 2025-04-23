{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkDefault mkForce mkMerge;
in {
  options = {
    nvidia.enable = mkEnableOption "nvidia module";
  };

  config = mkIf config.nvidia.enable {
    nixpkgs.config = {
      allowUnfree = mkForce true;
      cudaSupport = mkDefault true;
    };

    hardware = {
      nvidia = {
        powerManagement.enable = mkDefault true;
        open = mkDefault true;
        package = mkDefault config.boot.kernelPackages.nvidiaPackages.beta;
        nvidiaSettings = mkDefault false;
        videoAcceleration = mkForce false; # overriding the package
      };

      graphics = {
        enable = true;
        enable32Bit = true;
        extraPackages = with pkgs; [
          # TODO: remove once commit for 575 driver fix lands in nixpkgs
          (nvidia-vaapi-driver.overrideAttrs {
            version = "master";
            src = fetchFromGitHub {
              owner = "elFarto";
              repo = "nvidia-vaapi-driver";
              rev = "master";
              sha256 = "sha256-6s0HB4o7Y0j6A8uADhsgC4zmvVVMtH0MSHX97jbqarA=";
            };
          })
          #nvidia-vaapi-driver
        ];
      };
    };

    services.xserver.videoDrivers = ["nvidia"];

    boot = {
      kernelParams = [
        "nvidia.NVreg_UsePageAttributeTable=1"
        "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
      ];
      /*
      kernelModules = [
        "nvidia"
        "nvidia_modeset"
        "nvidia_drm"
        "nvidia_uvm"
      ];
      */
    };

    nix.settings = {
      substituters = ["https://nix-community.cachix.org"];
      trusted-public-keys = ["nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="];
    };
  };
}
