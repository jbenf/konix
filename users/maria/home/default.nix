{ config, pkgs, lib, cfg, ... }:
let
  
in {
  imports = [
    ../../home/brave.home.nix
  ];

  home.username = "maria";
  home.homeDirectory = "/home/maria";
}