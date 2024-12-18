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

  nix.optimise = {
    dates = [
      "10:55"
      "14:55"
    ];
    automatic = true;
  };

  nix.gc = {
    persistent = true;
    dates = "10:45";
    automatic = true;
    options = "--delete-older-than 7d";
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
    dates = "11:05";
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

}

