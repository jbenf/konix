{ config, pkgs, ... }:

{
  services.printing = {
    enable = true;
    extraFilesConf = ''
      SystemGroup root wheel lpadmin
    '';
  };

  users.groups.lpadmin = {};
}
