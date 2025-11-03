{
  hardware.bluetooth.powerOnBoot = false; # Power savings
  services.throttled = {
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
      Trip_Temp_C: 80
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
      CORE: -107
      CACHE: -107
      GPU: -100
      UNCORE: -112
      ANALOGIO: 0
    '';
  };
}
