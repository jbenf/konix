{ config, pkgs, ... }:

{
  imports =
    [
        ./nixos
        ./boot
        ./locale
        ./networking
    ];

}
