# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{

    
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  #nix.optimise.automatic = true;

  system.autoUpgrade = {
    enable = true;
    flake = "/root/konix";
    flags = [
      "--no-write-lock-file"
      "-L" # print build logs
      "--impure"
    ];
    dates = "11:05";
    persistent = true;
    #randomizedDelaySec = "45min";
  };

  systemd.services.konix-flake-update = {
      serviceConfig.Type = "oneshot";
      path = with pkgs; [ git ];
      script = ''
        cd /root/konix
        git reset --hard
        git clean -dxf
        git pull
      '';
    };

  systemd.timers.konix-flake-update = {
    wantedBy = [ "timers.target" ];
    partOf = [ "konix-flake-update.service" ];
    timerConfig = {
      OnCalendar = [ "*-*-* *:00:00" ];
      persistent = true;
    };
  };

  systemd.services.konix-cleanup = {
      serviceConfig.Type = "oneshot";
      path = with pkgs; [ nix ];
      script = ''
        nix-collect-garbage --delete-older-than 7d
        nix-store --optimize
      '';
    };

  systemd.timers.konix-cleanup = {
    wantedBy = [ "timers.target" ];
    partOf = [ "konix-cleanup.service" ];
    timerConfig = {
      OnCalendar = [ "*-*-* 12:05:00" ];
      persistent = true;
    };
  };

  systemd.user.services.konix-reboot-check = {
    serviceConfig.Type = "oneshot";
    path = with pkgs; [ libnotify ];
    script = ''
      changes=$(diff <(readlink /run/booted-system/{initrd,kernel,kernel-modules}) <(readlink /nix/var/nix/profiles/system/{initrd,kernel,kernel-modules}) | wc -l)
      if [ $changes -gt 0 ]; then
        notify-send -i system -u critical "Update" "Bitte starten Sie den Rechner neu um das Update zu vervollständigen."
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

}

