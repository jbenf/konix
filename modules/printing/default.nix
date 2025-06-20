{ config, pkgs, ... }:

{
  services.ipp-usb.enable = true;
  services.printing = {
    enable = true;
    browsed.enable = false;
    browsing = false;
    extraFilesConf = ''
      SystemGroup root wheel lpadmin users
    '';
  };

  users.groups.lpadmin = {};
}
