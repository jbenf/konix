# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      /etc/nixos/configuration-hardware.nix
      ./locale.nix
      ./networking.nix
      ./nixos.nix
      ./boot.nix
      ./audio.nix
      ./input.nix
      ./printing.nix
      ./gnome.nix
      ./tools.nix
    ];

  

}
