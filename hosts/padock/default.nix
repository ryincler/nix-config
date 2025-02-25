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
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  nixpkgs.overlays = [
    (final: prev: {
      moonlight-qt = optimizeNormalFlags prev.moonlight-qt;
    })
  ];

  nixpkgs.hostPlatform = {
    #gcc.arch = "skylake";
    #gcc.tune = "skylake";
    system = "x86_64-linux";
  };

  documentation = {
    dev.enable = true;
  };

  nix = {
    settings = {
      experimental-features = "nix-command flakes";
      system-features = [
        "nixos-test"
        "benchmark"
        "big-parallel"
        "kvm"
        "gccarch-skylake"
      ];
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
    /*
    kernelPackages = pkgs.linuxPackagesFor (
      optimizeWithFlags pkgs.linuxKernel.kernels.linux_zen ["-O2" "-march=skylake" "-flto" "-pipe"]
    );
    */

    kernelPackages = pkgs.linuxPackages_zen;
    #kernelPackages = pkgs.linuxPackages_latest;

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

  networking.hostName = "padock"; # Define your hostname.

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
      brightnessctl
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
    pkgs.slurp
    pkgs.grim
    pkgs.wl-clipboard
    pkgs.xdg-utils
    pkgs.catppuccin-cursors.mochaSky

    inputs.swww.packages.${pkgs.system}.swww
  ];

  networking.firewall.enable = false; 

  system.stateVersion = "24.05";

  programs = {
    nh = {
      enable = true;
      flake = "/home/ry/nix-config/";
    };

    localsend = {
      enable = true;
    };

    nano.enable = false;

    hyprland = {
      enable = true;
      xwayland.enable = false;
      package = optimizeNormalFlags inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    };

    tmux.enable = true;

    steam = {
      enable = true;
    };

    nvf = {
      enable = true;
      settings.vim = {
        lsp.enable = true;
        syntaxHighlighting = true;

        options = {
          expandtab = true;
          tabstop = 2;
          softtabstop = 2;
          shiftwidth = 2;
          backup = false;
          writebackup = true;
          swapfile = true;
        };

        languages = {
          enableLSP = true;
          enableFormat = true;
          enableTreesitter = true;
          enableExtraDiagnostics = true;
          markdown.enable = true;
          bash.enable = true;
          java.enable = true;
          ts = {
            enable = true;
            format.enable = true;
          };
          nix = {
            enable = true;
          };
        };
      };
    };
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

    throttled = {
      enable = true;

      extraConfig = ''
        [GENERAL]
        Enabled: True
        Sysfs_Power_Path: /sys/class/power_supply/AC*/online
        Autoreload: True

        [BATTERY]
        Update_Rate_s: 30
        PL1_Tdp_W: 29
        PL1_Duration_s: 28
        PL2_Tdp_W: 44
        PL2_Duration_S: 0.002
        Trip_Temp_C: 85
        cTDP: 0
        Disable_BDPROCHOT: False

        [AC]
        Update_Rate_s: 5
        PL1_Tdp_W: 44
        PL1_Duration_s: 28
        PL2_Tdp_W: 44
        PL2_Duration_S: 0.002
        Trip_Temp_C: 95
        # Set HWP energy performance hints to 'performance' on high load (EXPERIMENTAL)
        # Uncomment only if you really want to use it
        # HWP_Mode: False
        # Set cTDP to normal=0, down=1 or up=2 (EXPERIMENTAL)
        cTDP: 0
        # Disable BDPROCHOT (EXPERIMENTAL)
        Disable_BDPROCHOT: False

        [UNDERVOLT]
        CORE: -105
        CACHE: -105
        GPU: -95
        UNCORE: -90
        ANALOGIO: 0
      '';
    };

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

    zerotierone = {
      enable = true;
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

  xdg = {
    portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
        #xdg-desktop-portal-hyprland
      ];
    };
  };
}
