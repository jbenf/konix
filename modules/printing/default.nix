{ config, pkgs, ... }:

{
  services.ipp-usb.enable = true;
  services.printing = {
    enable = true;
    extraFilesConf = ''
      SystemGroup root wheel lpadmin users
    '';
  };

  users.groups.lpadmin = {};
}
