{
  inputs,
  lib,
  pkgs,
  ...
}: let
  optimizeWithFlags = pkg: flags:
    pkg.overrideAttrs (old: {
      NIX_CMAKE_COMPILE = [old.NIX_CMAKE_COMPILE or ""] ++ flags;
    });

  optimizeNormalFlags = pkg: optimizeWithFlags pkg ["-O2" "-march=skylake" "-flto" "-pipe"];
in {
  imports = [
    ./system.nix
    ./quirks.nix
    ../../modules # TODO: remove usages of ../ imports
    ./hardware-configuration.nix
  ];

  zerotierone.enable = true;
  steam.enable = false;
  hyprland.enable = true;
  programs.hyprland.xwayland.enable = lib.mkForce false;

  nvf.enable = true;

  nixpkgs.overlays = [
    (final: prev: {
      moonlight-qt = optimizeNormalFlags prev.moonlight-qt;
    })
  ];

  documentation = {
    dev.enable = true;
  };

  nix = {
    settings = {
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;

      # Cachix for Hyprland setup
      substituters = ["https://hyprland.cachix.org"];
      trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];

      trusted-users = ["root" "ry"];
    };

    distributedBuilds = true;
    buildMachines = [
      {
        hostName = "192.168.193.24";
        protocol = "ssh-ng";
        sshUser = "ry";
        system = "x86_64-linux";
        maxJobs = 10;
        speedFactor = 2;
        supportedFeatures = ["nixos-test" "benchmark" "big-parallel" "kvm" "gccarch-znver4"];
      }
    ];

    extraOptions = ''
      builders-use-substitutes = true
    '';
  };

  zramSwap = {
    enable = true;
  };

  boot = {
    # Linux kernel version
    kernelPackages = pkgs.linuxPackagesFor (
      optimizeWithFlags pkgs.linuxKernel.kernels.linux_zen [ "-O2" "-march=skylake" "-pipe" ]
    );
    #kernelPackages = pkgs.linuxPackages_zen;

    kernelParams = [
      "quiet"
      #"sysrq_always_enabled=1"
    ];

    # Bootloader
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  networking = {
    networkmanager.enable = true;
  };

  # Set your time zone.
  time.timeZone = "America/Toronto";

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_CA.UTF-8";
    extraLocaleSettings = {
      LC_TIME = "C.UTF-8";
    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.ry = {
    isNormalUser = true;
    description = "ry";
    extraGroups = ["networkmanager" "wheel" "input"];
    packages = with pkgs; [
      alacritty
      firefox
      fuzzel
      vesktop
      mpv
      acpi
      btop
      libreoffice
      moonlight-qt
    ];

    openssh.authorizedKeys.keys = [
    ];
  };

  # Allow unfree packages
  nixpkgs.config = {
    allowUnfree = true;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = [
    pkgs.lf
    pkgs.git
    pkgs.ripgrep
  ];

  networking.firewall.enable = false; 

  programs = {
    nh = {
      enable = true;
      flake = "/home/ry/nix-config/";
    };

    localsend = {
      enable = true;
    };

    nano.enable = false;

    tmux.enable = true;

  };

  console.useXkbConfig = true;

  hardware = {
    bluetooth = {
      enable = true;
    };

    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        vaapiVdpau
        vpl-gpu-rt
        intel-media-driver

        intel-compute-runtime
      ];
    };
  };

  services = {
    blueman.enable = true;

    openssh = {
      enable = true;

      settings = {
        PermitRootLogin = "no";
        # TODO disable pwd auth
        PasswordAuthentication = true;
      };
    };

    displayManager = {
      ly.enable = true;
    };

    pipewire = {
      enable = true;
      wireplumber.enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };

  # Make Electron and Chromium apps to use Wayland
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

  qt.style = ["adwaita-dark"];

}
