{ config, pkgs, ... }:
{
  programs.chromium = {
    enable = true;
    package = pkgs.brave;
    extensions = [
      #{ id = "hifbblnjfcimjnlhibannjoclibgedmd"; } # MasterPassword
      #{ id = "eimadpbcbfnmbkopoojfekhnkhdbieeh"; } # Dark Reader
    ];
  
  };
}