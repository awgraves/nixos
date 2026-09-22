# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  networking.hostName = "thinkpad"; # Define your hostname.

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
    settings = {
      Policy = {
        AutoEnable = false;
      };
    };
  };
}

