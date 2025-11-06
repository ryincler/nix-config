{
  system.stateVersion = "25.05";

  networking.hostName = "yamada";

  nixpkgs.hostPlatform = {
    system = "x86_64-linux";
  };

  nix.settings.system-features = [
    "nixos-test"
    "benchmark"
    "big-parallel"
    "kvm"
    "gccarch-skylake"
  ];
}
