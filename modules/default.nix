{ config, pkgs, ... }:

{
  imports =
    [
        ./os
        ./desktop
        ./notebook
        ./tools
        ./flatpak
        ./printing
    ];

}
