{
  pkgs,
  ...
}: let
  optimizeWithFlags = pkg: flags:
    pkg.overrideAttrs (old: {
      NIX_CMAKE_COMPILE = [old.NIX_CMAKE_COMPILE or ""] ++ flags;
      NIX_ENFORCE_NO_NATIVE = false;
    });

  optimizeNormalFlags = pkg: optimizeWithFlags pkg ["-O2" "-march=skylake" "-flto" "-pipe"];
in {
  imports = [
    ./system.nix
    ./quirks.nix
    ./hardware-configuration.nix
  ];

  fileSystems."/".options = ["compress=zstd"];

  modules = {
    hardware.gpu.intel.enable = true;
    networking = {
      tailscale.enable = true;
      networkmanager.enable = true;
    };
    display.wm.wayland = {
      niri = {
        enable = true;
        xwayland.enable = true;
      };
    };
    programs = {
      editors.neovim.enable = true;
      terminal.foot.enable = true;
    };
    services = {
      login.greetd.enable = true;
      openssh.enable = true;
      tlp = {
        enable = true;
        limitCharge = {
          enable = true;
          stopCharge = 80;
          startCharge = 65;
        };
      };
    };
    gui.themes.fontconfig = {
      enable = true;
      useMonoEverywhere = true;
    };
  };

  documentation = {
    dev.enable = true;
  };

  nix = {
    settings = {
      trusted-users = ["root" "ry"];
    };

    distributedBuilds = true;
    buildMachines = [
      {
        hostName = "100.64.0.3";
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
      optimizeWithFlags pkgs.linuxKernel.kernels.linux_zen ["-O2" "-march=skylake" "-pipe"]
    );
    */
    kernelPackages = pkgs.linuxPackages_latest;

    kernelParams = [ ];

    # Bootloader
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
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
    extraGroups = ["networkmanager" "wheel" "input" "wireshark"];
    packages = with pkgs; [
      firefox
      fuzzel
      vesktop
      mpv
      acpi
      btop
      moonlight-qt
      ripgrep
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM+ChTqbCdjAugSOma7mRYN1fUTUgd4YmCcFcB+4CGoL"
    ];
  };

  # Allow unfree packages
  nixpkgs.config = {
    allowUnfree = true;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    git
    nautilus
  ];

  networking.firewall.enable = false;

  programs = {
    wireshark = {
      enable = true;
      package = pkgs.wireshark;
    };
    nh = {
      enable = true;
      flake = "/home/ry/nix-config/";
    };

    localsend = {
      enable = true;
    };

    nano.enable = false;
  };

  console.useXkbConfig = true;

  hardware = {
    bluetooth = {
      enable = true;
    };
  };

  services = {
    blueman.enable = true;

    pipewire = {
      enable = true;
      wireplumber.enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };

  qt.style = ["adwaita-dark"];
}
