{
  pkgs,
  ...
}: {
  imports = [
    ./system.nix
    ./quirks.nix
    ./hardware-configuration.nix
    ./fs.nix
  ];

  modules = {
    hardware.gpu.amd.enable = true;
    networking = {
      firewall.enable = true;
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
      gaming.steam.enable = true;
    };
    services = {
      login.greetd.enable = true;
      openssh.enable = true;
      tlp = {
        enable = true;
        limitCharge = {
          enable = true;
          stopCharge = 80;
          startCharge = 70;
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
    kernelPackages = pkgs.linuxPackages_latest;

    kernelParams = [];

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
      equibop
      mpv
      acpi
      btop-rocm
      moonlight-qt
      ripgrep
      easyeffects
      alsa-utils
      qpwgraph
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
  };

  console.useXkbConfig = true;

  hardware = {
    alsa.enablePersistence = true;

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
