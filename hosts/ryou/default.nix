{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
    ./system.nix
  ];

  modules = {
    services = {
      openssh.enable = true;
      headscale.enable = true;
    };
  };

  nix.settings = {
    experimental-features = ["nix-command" "flakes"];
    auto-optimise-store = true;
  };

  networking.networkmanager.enable = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  users.users.ry = {
    isNormalUser = true;
    description = "ry";
    extraGroups = ["wheel"];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBSxUf9mWU31pwhiPrm6lbX0ap2RJH0sLEU9NuSP8Es3 ry@plaptop"
    ];
  };
  environment.systemPackages = with pkgs; [
    git
    neovim
  ];
}
