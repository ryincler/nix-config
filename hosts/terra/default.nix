{ inputs, config, lib, pkgs, ... }:
let
  optimizeWithFlags = pkg: flags:
    pkg.overrideAttrs (old: {
      NIX_CFLAGS_COMPILE = [ (old.NIX_CFLAGS_COMPILE or "") ] ++ flags;
  });
in 
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./system.nix
    ../../modules
    
    inputs.aagl.nixosModules.default
  ];

  nvidia.enable = true;
  zerotierone.enable = true;
  steam.enable = true;
  hyprland.enable = true;
  nvf.enable = true;

  nixpkgs.overlays = [ ];

  nix = {
    settings = {
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
      system-features = [ "benchmark" "big-parallel" "kvm" "nixos-test" "gccarch-znver4" ];

      # Cachix for Hyprland setup
      substituters = [
        "https://hyprland.cachix.org" 
      ];
      trusted-public-keys = [
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      ];
  
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
    kernelPackages = pkgs.linuxPackages_zen;
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
    extraGroups = [ "video" "networkmanager" "wheel" "input" "libvirtd" ];
    packages = with pkgs; [
      ani-cli
      alacritty
      firefox
      rofi-wayland
      vesktop
      mpv
      lutris
      #librewolf
      ollama-cuda
      prismlauncher
    ];

    openssh.authorizedKeys.keys = [
    ];

  };

  # Allow unfree packages
  nixpkgs.config = {
    allowUnfree = true;
    cudaSupport = true; 
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = [
    pkgs.lf
    pkgs.git
    pkgs.ripgrep
    pkgs.ffmpeg
    pkgs.hyprpolkitagent
    #pkgs.catppuccin-cursors.mochaSky
    pkgs.bibata-cursors
  ];

  networking.firewall.enable = false; # TODO maybe enable lol

  virtualisation.libvirtd.enable = true;

  programs = {
    nh = {
      enable = true;
      flake = "/home/ry/nix-config/";
    };

    virt-manager.enable = true;

    # AAGL stuff
    anime-game-launcher.enable = true;
    honkers-railway-launcher.enable = true;

    # Nano is enabled by default, but yucky nano
    nano.enable = false;

    tmux.enable = true;
	
  };

  console.useXkbConfig = true;

  hardware = {

    graphics = { # Previously the OpenGL module
      enable = true;
      enable32Bit = true;
    };
  };

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

  	sunshine = {
      enable = true;
      autoStart = true;
      capSysAdmin = true;
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
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  qt.style = ["adwaita-dark"];
}
