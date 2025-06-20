# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{

  nix.optimise = {
    dates = [
      "10:55"
      "14:55"
    ];
    automatic = true;
  };

  nix.gc = {
    persistent = true;
    dates = "Wed *-*-* 10:45";
    automatic = true;
    options = "--delete-older-than 30d";
  };

  system.autoUpgrade = {
    enable = true;
    flake = ''"git+https://github.com/jbenf/konix.git"'';
    flags = [
      "--no-write-lock-file"
      "-L" # print build logs
      "--impure"
      "--option" "download-attempts" "10"
    ];
    dates = "Wed *-*-* 11:05";
    persistent = true;
    #randomizedDelaySec = "45min";
  };


  systemd.user.services.konix-reboot-check = {
    serviceConfig.Type = "oneshot";
    path = with pkgs; [ libnotify coreutils];
    script = ''
      set -eu
      booted=$(readlink /run/booted-system/{initrd,kernel,kernel-modules} | xargs)
      current=$(readlink /nix/var/nix/profiles/system/{initrd,kernel,kernel-modules} | xargs)
      if [  "$booted" = "$current" ]; then
        echo "No reboot needed"
      else
        echo "Reboot needed"
        notify-send -i system -u critical "Update" "Bitte starten Sie den Rechner neu um das Update zu abzuschließen."
      fi
      
    '';
  };

  systemd.user.timers.konix-reboot-check = {
    wantedBy = [ "timers.target" ];
    partOf = [ "konix-reboot-check.service" ];
    timerConfig = {
      OnCalendar = [ "*-*-* *:15:00" ];
      persistent = true;
    };
  };

  security.sudo.extraRules = [
    { groups = [ "users" ]; runAs = "root"; 
      commands = [ 
        { command = "/run/current-system/sw/bin/systemctl start nix-gc"; options = [ "NOPASSWD" ]; }
        { command = "/run/current-system/sw/bin/systemctl start nix-optimise"; options = [ "NOPASSWD" ]; }
        { command = "/run/current-system/sw/bin/systemctl start nixos-upgrade"; options = [ "NOPASSWD" ]; }
        { command = "/run/current-system/sw/bin/systemctl start konix-flake-update"; options = [ "NOPASSWD" ]; }
        { command = "/run/current-system/sw/bin/journalctl -u nixos-upgrade -f"; options = [ "NOPASSWD" ]; }
      ]; 
    }
  ];

  environment.shellAliases = {
    konix-update = "sudo systemctl start nix-gc && sleep 1 && sudo systemctl start nix-optimise && sleep 1 && sleep 1 && sudo systemctl start nixos-upgrade && sleep 1 && systemctl --user start konix-gnome-init && systemctl --user start konix-reboot-check && echo Update completed";
    konix-update-log = "sudo journalctl -u nixos-upgrade -f";
  };

}

