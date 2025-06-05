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
      zerotierone.enable = true;
      sunshine.enable = true;
    };

    hardware.gpu.amd.enable = true;
    display.wm.wayland.hyprland.enable = true;

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
    kernelParams = [
      "quiet"
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
  i18n.defaultLocale = "en_CA.UTF-8";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.ry = {
    isNormalUser = true;
    description = "ry";
    extraGroups = ["video" "networkmanager" "wheel" "input" "libvirtd"];
    packages = with pkgs; [
      ani-cli
      alacritty
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

    openssh = {
      enable = true;

      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = true;
      };
    };

    displayManager.ly.enable = true;

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
