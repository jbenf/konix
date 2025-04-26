{ config, pkgs, ... }:

{
  imports =
    [
        ./autoupdate
        ./boot
        ./locale
        ./networking
    ];

}
