# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  # boot.kernelModules = ["dell-smbios"];

  networking.hostName = "dell";

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      Policy = {
        AutoEnable = true;
      };
    };
  };

  # Fix for the loud fan on idle issue
  boot.kernelParams = [ "dell_smm_hwmon.ignore_dmi=1" ];
  # module seems to load fine already, but if needed:
  # boot.kernelModules = [ "dell_smm_hwmon" ];

  systemd.services.fan-control = {
    description = "Control fan based on CPU temp";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "simple";
      User = "root";
    };
    path = [ pkgs.coreutils pkgs.procps pkgs.gawk ];
    script = ''
      set -euo pipefail

      find_hwmon() {
        local want="$1"
        for dir in /sys/class/hwmon/hwmon*; do
          if [ -r "$dir/name" ] && [ "$(cat "$dir/name")" = "$want" ]; then
            echo "$dir"
            return 0
          fi
        done
        return 1
      }

      CPU_HWMON=$(find_hwmon "coretemp") || { echo "coretemp hwmon not found"; exit 1; }
      FAN_HWMON=$(find_hwmon "dell_smm") || { echo "dell_smm hwmon not found"; exit 1; }

      CPU_TEMP_FILE="$CPU_HWMON/temp1_input"
      PWM_FILE="$FAN_HWMON/pwm1"

      while true; do
        temp=$(( $(cat "$CPU_TEMP_FILE") / 1000 ))

        if (( temp < 50 )); then pwm=50
        elif (( temp < 65 )); then pwm=64
        elif (( temp < 75 )); then pwm=128
        else pwm=192
        fi

        echo $pwm > "$PWM_FILE"
        sleep 2
      done
    '';
  };
}  
