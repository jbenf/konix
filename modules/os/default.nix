{ config, pkgs, ... }:

{
  imports =
    [
        ./nixos
        ./boot
        ./local
        ./networking
    ];

}
