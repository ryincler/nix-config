{pkgs, ...}: let
  optimizeWithFlags = pkg: flags:
    pkg.overrideAttrs (old: {
      NIX_CFLAGS_COMPILE = [(old.NIX_CFLAGS_COMPILE or "")] ++ flags;
    });
in {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./system.nix
  ];

  modules = {
    networking = {
      tailscale.enable = true;
    };

    services = {
      openssh.enable = true;
      sunshine.enable = true;
    };

    hardware.gpu.amd.enable = true;
    display.wm.wayland = {
      hyprland.enable = true;
      niri = {
        enable = true;
        xwayland.enable = true;
      };
    };

    programs = {
      terminal.foot.enable = true;
      gaming = {
        steam.enable = true;
        aagl.enable = true;
      };
      editors.neovim.enable = true;
    };

    gui.themes.fontconfig = {
      enable = true;
      useMonoEverywhere = true;
    };
  };

  nixpkgs.overlays = [
  ];

  nix = {
    settings = {
      system-features = ["benchmark" "big-parallel" "kvm" "nixos-test" "gccarch-znver4"];

      trusted-users = ["root" "ry"];
    };
  };

  zramSwap = {
    enable = true;
  };

  boot = {
    # Linux kernel version

    /*
    kernelPackages = pkgs.linuxPackagesFor (
      optimizeWithFlags pkgs.linuxKernel.kernels.linux_zen [ "-O2" "-march=znver4" "-pipe" ]
    );
    */
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [];

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
  i18n.defaultLocale = "en_CA.UTF-8";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.ry = {
    isNormalUser = true;
    description = "ry";
    extraGroups = ["video" "networkmanager" "wheel" "input" "libvirtd" "corectrl"];
    packages = with pkgs; [
      ani-cli
      vesktop
      mpv
      lutris
      prismlauncher
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
  environment.systemPackages = with pkgs; [
    lf
    git
    ripgrep
    ffmpeg
  ];

  networking.firewall.enable = false;

  virtualisation.libvirtd.enable = true;

  programs = {
    niri.enable = true;

    corectrl.enable = true;

    nh = {
      enable = true;
      flake = "/home/ry/nix-config/";
    };

    firefox = {
      enable = true;
    };

    virt-manager.enable = true;

    nano.enable = false;

    tmux.enable = true;
  };

  console.useXkbConfig = true;

  services = {
    # Printing
    printing.enable = true;
    # Network setup for autodiscovery of network printers
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };

    greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.greetd}/bin/agreety --cmd hyprland";
        };
        initial_session = {
          command = "hyprland";
          user = "ry";
        };
      };
    };

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
