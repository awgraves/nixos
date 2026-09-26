# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "thinkpad";

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
    settings = {
      Policy = {
        AutoEnable = false;
      };
    };
  };

  environment.systemPackages = with pkgs; [
    steam
  ];
}
