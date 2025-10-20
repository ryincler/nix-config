{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
    ./system.nix
  ];

  modules = {
    security.acme.enable = true;
    services = {
      openssh.enable = true;
      nginx.enable = true;
      headscale.enable = true;
    };
    networking.tailscale.enable = true;
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
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBroVMo8P/KrE3i1P3pw23ehKZlasyFWGpG6naF4N5bl ry@terra"
    ];
  };
  environment.systemPackages = with pkgs; [
    git
    neovim
  ];

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [443];
  };
}
