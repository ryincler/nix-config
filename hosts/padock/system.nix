{
  system.stateVersion = "24.05";

  nixpkgs.hostPlatform = {
    #gcc.arch = "skylake";
    #gcc.tune = "skylake";
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
