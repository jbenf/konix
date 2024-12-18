# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      /etc/nixos/hardware-configuration.nix
      ./locale.nix
      ./networking.nix
      ./nixos.nix
      ./input.nix
      ./printing.nix
      ./gnome.nix
      ./tools.nix
      ./users.nix
      ./flatpak.nix
    ];

  

}
